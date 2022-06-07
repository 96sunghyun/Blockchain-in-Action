const bin =
  "608060405260008060006101000a81548160ff02191690836003811115610029576100286100b0565b5b0217905550600060035534801561003f57600080fd5b5033600060016101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060016000806101000a81548160ff021916908360038111156100a6576100a56100b0565b5b02179055506100df565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b610aaa806100ee6000396000f3fe60806040526004361061007b5760003560e01c806391f901571161004e57806391f9015714610100578063957bb1e01461012b578063c19d93fb14610147578063d57bde79146101725761007b565b8063268f1153146100805780633ccfd60b146100a95780634036778f146100c05780636a0c3050146100e9575b600080fd5b34801561008c57600080fd5b506100a760048036038101906100a2919061072f565b61019d565b005b3480156100b557600080fd5b506100be610214565b005b3480156100cc57600080fd5b506100e760048036038101906100e291906107c8565b6102f4565b005b3480156100f557600080fd5b506100fe610435565b005b34801561010c57600080fd5b506101156104e2565b6040516101229190610849565b60405180910390f35b61014560048036038101906101409190610864565b610508565b005b34801561015357600080fd5b5061015c6105b6565b6040516101699190610908565b60405180910390f35b34801561017e57600080fd5b506101876105c7565b6040516101949190610932565b60405180910390f35b600060019054906101000a90505060008054906101000a900460ff1660038111156101cb576101ca610891565b5b8160038111156101de576101dd610891565b5b116101e857600080fd5b806000806101000a81548160ff0219169083600381111561020c5761020b610891565b5b021790555050565b6000600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205490506000811161026557600080fd5b6000600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055503373ffffffffffffffffffffffffffffffffffffffff166108fc829081150290604051600060405180830381858888f193505050501580156102f0573d6000803e3d6000fd5b5050565b600280600381111561030957610308610891565b5b60008054906101000a900460ff16600381111561032957610328610891565b5b1461033357600080fd5b600080600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000209050848460405160200161038a92919061098f565b604051602081830303815290604052805190602001208160000154036103e7578060010154826103ba91906109ea565b9150848160010154106103e6576103d133866105cd565b156103e55784826103e29190610a40565b91505b5b5b3373ffffffffffffffffffffffffffffffffffffffff166108fc839081150290604051600060405180830381858888f1935050505015801561042d573d6000803e3d6000fd5b505050505050565b600380600381111561044a57610449610891565b5b60008054906101000a900460ff16600381111561046a57610469610891565b5b1461047457600080fd5b600060019054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc6003549081150290604051600060405180830381858888f193505050501580156104de573d6000803e3d6000fd5b5050565b600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600180600381111561051d5761051c610891565b5b60008054906101000a900460ff16600381111561053d5761053c610891565b5b1461054757600080fd5b604051806040016040528083815260200134815250600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008201518160000155602082015181600101559050505050565b60008054906101000a900460ff1681565b60035481565b600060035482116105e157600090506106ff565b600073ffffffffffffffffffffffffffffffffffffffff16600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16146106b25760035460046000600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008282546106aa91906109ea565b925050819055505b8160038190555082600260006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600190505b92915050565b600080fd5b6004811061071757600080fd5b50565b6000813590506107298161070a565b92915050565b60006020828403121561074557610744610705565b5b60006107538482850161071a565b91505092915050565b6000819050919050565b61076f8161075c565b811461077a57600080fd5b50565b60008135905061078c81610766565b92915050565b6000819050919050565b6107a581610792565b81146107b057600080fd5b50565b6000813590506107c28161079c565b92915050565b600080604083850312156107df576107de610705565b5b60006107ed8582860161077d565b92505060206107fe858286016107b3565b9150509250929050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061083382610808565b9050919050565b61084381610828565b82525050565b600060208201905061085e600083018461083a565b92915050565b60006020828403121561087a57610879610705565b5b6000610888848285016107b3565b91505092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b600481106108d1576108d0610891565b5b50565b60008190506108e2826108c0565b919050565b60006108f2826108d4565b9050919050565b610902816108e7565b82525050565b600060208201905061091d60008301846108f9565b92915050565b61092c8161075c565b82525050565b60006020820190506109476000830184610923565b92915050565b6000819050919050565b6109686109638261075c565b61094d565b82525050565b6000819050919050565b61098961098482610792565b61096e565b82525050565b600061099b8285610957565b6020820191506109ab8284610978565b6020820191508190509392505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60006109f58261075c565b9150610a008361075c565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff03821115610a3557610a346109bb565b5b828201905092915050565b6000610a4b8261075c565b9150610a568361075c565b925082821015610a6957610a686109bb565b5b82820390509291505056fea264697066735822122018c596d9bc56282b54b30ddce33764d1203f04b46c7bcf86bd74c966b7f9d5aa64736f6c634300080e0033";

module.exports = { bin };