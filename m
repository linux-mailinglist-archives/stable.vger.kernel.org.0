Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7442673185
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 07:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjASGKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 01:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjASGKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 01:10:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D08470A9
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 22:10:06 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILmm1K016508;
        Thu, 19 Jan 2023 06:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=KpmHd1OSdsQQ0QkPFsNGitkrqPtvQbjYjXxLlS+k2aY=;
 b=rneA//o3RadQVafpVWHmz7lLUaE0PRgGrH6MsVluvxHSetPucsdkkO3m20LiCJh/rTCW
 VP+6utsIwBkoqJmu0RBmLkbaoVylSYhyagDVt8TE2ONTAHKillC4JY872msovyaOBRds
 bXkUARTaF+nxgNX3fL9FKnbORyz7Ao/d1eFNJrv3Lm5rGgw/T1TyAV7IXBnUba8Dj2Ic
 jBWgMKmgDnr1jD4cvvx1mqYbEPisZEN8PrqezZAwABdk5JZP4zELJhK1jsP4BmB7+dPC
 v5Ery1fdK0F6NccUWxTEg0gf3s1OSF6hsF55Kn/JkH5t3tUfsytjkBBTUKeqZCbVBgBP 4w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3kaahc2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 06:09:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30J5Sea4009763;
        Thu, 19 Jan 2023 06:09:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n6qmd7r42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 06:09:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJXBoRHgDi/3/ou0Gs2hQ6lCIg1Gx2DAWwe1enEpqVn28KIH+EaNzkZh3yire2xa0vzD4HqUkpe171m7BiyyhiC6I+TDWDRfYjf6n2Qpkt6z1HESa4gJwwTgrWFcC7llCaCraf4Spjq09sS8SnFquZ+SS+KJ+pLz1gqpV9Ak8jQIh4DNHfh/0pWFOLeZewRIjEE+0DP/wOXS63CkDEZ+ED7LdUrdRefhQy7K+alRo5ZR95zdX5/jjRcnsYFYvYo+lXf7H2+lpliLOWUpxj5w8ezFq4KQITtM/oxxuYx+KfOnhcoaIwLdhvU+XIvqjGIy7aZSJGiI0nYtqbw+TQWwRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpmHd1OSdsQQ0QkPFsNGitkrqPtvQbjYjXxLlS+k2aY=;
 b=N9fDIuxNp36bINtUtVFh1ZxyxaoYIzgWqCFi/4vHKkDbd5n9sFOMhAME9yvv5bRTPTDtje5sldS188VllebcwJIXo0LobDrm9kGR66bVJds2kTzqLd5rov+hUpnVmxXb+b8migMqGAlcQ4tTHJsGFkh9oQIG8ieIWxS8RdgLGt35RGXWhZPrq9y4mL7UoKnvWZXWwmxcUeRGJ9qd+KvXCaGAwylrSiiUM7AaUiZW4OJ0lQTygQkyqhZa3ss6/Qid7WMPKwzCb6FWJq86MlHmYCiuyovwIC38LRy9RAGrvYYU14f7cONpg135N9rILmaIg1BQmrSCY+whJcwJR3SxLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpmHd1OSdsQQ0QkPFsNGitkrqPtvQbjYjXxLlS+k2aY=;
 b=foKgTWbfnYy3wW81veBUOLuhdz/Z1Z9Pp3CTdSjnX5LCdPTKAWZTFCr+CjMDz55SXBYwlLlrklOg3EjYWWORd0MRiQEsp8d9zGqon56kvwyCVbi0uS0loHASuEebJbOrdaUJrIeM2284H0Nv9rnN4SoemcFeQc2zK3ynZhCbN8Q=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DS0PR10MB7065.namprd10.prod.outlook.com (2603:10b6:8:143::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Thu, 19 Jan
 2023 06:09:44 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::475f:4f66:d927:ea15]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::475f:4f66:d927:ea15%9]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 06:09:44 +0000
Message-ID: <4d2928e1-c836-b817-3dc2-3fe9adcaf2d6@oracle.com>
Date:   Thu, 19 Jan 2023 11:39:35 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.4 185/658] xprtrdma: Fix regbuf data not freed in
 rpcrdma_req_create()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>,
        Dan Carpenter <error27@gmail.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20230116154909.645460653@linuxfoundation.org>
 <20230116154917.918263147@linuxfoundation.org>
Content-Language: en-US
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230116154917.918263147@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0199.apcprd06.prod.outlook.com (2603:1096:4:1::31)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DS0PR10MB7065:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f05eef1-45c2-40d3-ea0b-08daf9e3c2a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mBu7rSdF7HkPyRjaMFw7eG+j+U+wY6/JE0iYCGbSjV4LnPPx0nt04tNhRQZLVbBipThgGtNDiXTVvCC32MYFwH1s5QiYKuBQSBSHsI0zGqm/GMNFImDpsKoG50X+53ReaQqKSx9K26wF+HEoJGf33z0manj4NeMd9o6zoiu8CPCWfI7GIqP/pt6iUwgS8EtrepolYA3lS5KUb7mwwwpkAmnRZXYmuCtM1hCNzax808BFYmPJEqgANofa9pKeXREpd33feXqTzkVWJfDKhqUu45AUdorQ3R61vyTqR6eIMROxyr/o+ZKSPhUwBdE6SsXks8APh6Km2xcP7hWlQUwGY1JLm/M86seIRq/3w4fQr9euuF09a2P8dzu5Tf7rKH38NDzWGydplF+wX2l/6ccKOW/n8Rw4eUDXXHjQIrCpyAn9HBTwKKQsSFokJRHhuHwdtfA92bDax9LVVOR8LyZEXWePQY8OS470piKKo/GM1qTj/xEYe0e0gwZTogda0zVJqWjgjwR/oKmVC+APHxRuT9tRHe11BAotIQ3H48INePkZinb0a0i1n4EQ8O4KS1O6KDG9GBIamBqFCqa9R+DgOyCuWWoKJ6MSlEyNAI66TEdkVbZx0PReTobb1hyKHo2ZSGdS4jW1OM13OHYoFtWxOXvJEqUSeTqLTiExOuBiuise+fEBpQJlyREblLlBq6Eh4Jl0RAgjOehRv/DTeRVJNHAyM7nSfFORfzk2BhF1PgU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199015)(66476007)(38100700002)(31696002)(86362001)(8936002)(5660300002)(2906002)(66946007)(66556008)(4326008)(8676002)(41300700001)(26005)(2616005)(186003)(83380400001)(6512007)(53546011)(316002)(107886003)(54906003)(6666004)(478600001)(6486002)(6506007)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDBOUmpyTkNTa2pLcWRFZlQyYURoZzYzVEt2SjhMQ291eE45MVRDbUFua3RN?=
 =?utf-8?B?dERJZjVxZU1Ca0Z1T3dYcHUrM0NxRVNmRkFQbGRtbkRFZFR1bjU2dDRJS1ZH?=
 =?utf-8?B?RXBPajNCZGw2WjhzY1RMU0xiSVg3NTAyaHk3dnJCbVdtOFVvektFaGVwTVI4?=
 =?utf-8?B?V3pqV0t0VXdCSVBvYVNBSENSREViQVN6WDNMRGo0RnJtb1Y3R0NBUE5FL1dG?=
 =?utf-8?B?Rzc0TFgycU1rS1FTN1RzVXpPTXpHMTJFc2lzRUpwYXB5aE9iWEhKOGM5Tk9W?=
 =?utf-8?B?RlV6MFpJVmtqV3lrZTFHaHBTQjk3UkZZYTlQZmJXb3hISnduTXFWWFVPWVZO?=
 =?utf-8?B?VmVWQS9iWFZKYjZQYnhMZ0szQTREVk5FVlRpVUk4ZzZPZElwVTlLZzQ5VllZ?=
 =?utf-8?B?OGhRdVNyVzZqNmFlNzZqdWNRVm1EZklza3R3UVBPdmVaWDdyaHVjbmNiSkh6?=
 =?utf-8?B?NEgxUXcvejlBNUxsL3pHcEFmbGxsZnl0V2RocTBrc3d2TW91OWhqL0xEVThN?=
 =?utf-8?B?QWM5MzVEdUJSVUVabWNnT1c1Q3lVQkZabGg5UXl2bEhtNzJuMmo5UHRYR3Ay?=
 =?utf-8?B?YW8wWEhyeEo5b2prMnppa1VCUmlrV1NYVFdmZ043c3k0QlcwcnR4L0VZdGxB?=
 =?utf-8?B?SXZlSmc4Q1FSbnd3WGo1VEowQzJTOFZrRklZTitwZXRmZk5Dc0loK05wNktG?=
 =?utf-8?B?Ujg4ZmRYTVhuaEE1Z0ZhbDZWZDErODZQVWhZbG4yT1pqQzd0NW9sdkRHT0xz?=
 =?utf-8?B?OGZvb1J1dXdnUENBRjBUN01zNXdta0RRTDk0OGdQVmtjbXhJUDg1YnBYWXIz?=
 =?utf-8?B?bEZXVnZiaDd1bnluU3l3Tjk3RmxLR0dhL29VTkt1VHlTQ01FTzlxaUMvSFBD?=
 =?utf-8?B?SEtqS2M1LzJ6WTRGeFVsMEdNTzJXYzBmVUlqd2dIOXRJTHhpajNnRElpQlFN?=
 =?utf-8?B?NkpxdUxxdEM2OUZMbjZoZHdNVGI0WTVnYTVETW1kR29LMEZGL0dQTHp4anUy?=
 =?utf-8?B?TzYydHNCZGlqQ0ZxaTBvQ2RET0FNV1l5cFlNV2ltU3pCa3lvTzJhenZIS3Zu?=
 =?utf-8?B?NEVPeUkyYmMxU2puejlhMllNWWhmUHlKaC9kUEVINGdobnBMMW94alNtSDgy?=
 =?utf-8?B?L1pRaWUrL0kwNHc2RUNpQnl4R25xYzBqOTVUdWtzZkFZa2srR3d0ZmxzdmYz?=
 =?utf-8?B?NzZFS1FFVTV4QVoyUVFST1YyYXVIRjNwVy9IOTJac0tDQTBjY2Y2NlVsWmU1?=
 =?utf-8?B?WWh2V0trZ1hHSDI2SU1HNkJoaytaUDlpM2VEMktJYmxlUmltajJoNXdlUStD?=
 =?utf-8?B?cnFacG1vVnlnbVE1Mk91SU15NlNQNSszM3JEN2M1dTNVd0JtcHdBYmpEMis3?=
 =?utf-8?B?WDg3bmZNM2V4MzJmaXZyMjArQjk0YUp6WFMrTUg1dmIzdzdHS2k3ZEQ5VHVM?=
 =?utf-8?B?NkNzZWQwdk1aZjZKYmhORWlFV2JXaE1WeVhTbmU1dnh4cU5sbGU0ZUFCWFRP?=
 =?utf-8?B?Q2wyRG1EYjQzbzJXT0lWb3QzVXB1OU1ycjhsRUJGdE5SMUdHa0ZFMWtLM2Vt?=
 =?utf-8?B?aU1ZYXFhRWVERi9Ja2NhaG1yZVNwMWNCOXQ5Rmg1bzJPQ0ErR2wzd1pCQUhD?=
 =?utf-8?B?ckJJV0Q1Z2Q2V2NiZ09XejgwZWZNeHRGRzlsMkducFVMOFVSamVpYzN0S1Bo?=
 =?utf-8?B?SWpzQmMza3UrMVNhdDQzckhUc3ZFUWZ5K0l3SHVIZG1NL2Z0bVRaR0ExZTlF?=
 =?utf-8?B?RTBzUzQwWU00ekgyeUg2bGxVbS83LzE2OW9uSkhaOUFpcjZjUW1zdG9kbkpP?=
 =?utf-8?B?clNCOS81N3ZVOXVnZ1JnUmtMdU9kdzQySW0zZ2JmRnlpenF6a1RGSjEwTExO?=
 =?utf-8?B?UkJ6bmJqdWkwKy94ck90UHZQc0RLL08yV3RDaHliQ3M2T2pmTUh6QWR3VUlw?=
 =?utf-8?B?WmdFb0xPcmxEdTNXTkZoWldUZ1VXZHNUMG9MWHcvNTN3NHlzdWxyU0ZmN0Q4?=
 =?utf-8?B?UUdRN3dmZTdBSWFKRHRVY3BxU3UxWlduY1h3bXI1anNIcytvSCtnYU1JNnIy?=
 =?utf-8?B?dUppdzFkcEQ1L1BwOWg1ajBZTDVwZGFmQU9GZCsyMHhQa0xnamdBczNvSWNu?=
 =?utf-8?B?SzFpUTNmZjJjc2wvaG5sMlR2Si9rVlJXL2szYXpJd3ZHUFIweFlMOGZVYy9r?=
 =?utf-8?Q?o0xai68V2BgsTC+tRDEvB+s=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MXdCVHRmQmtHVlVYcTBCSFhrN3RwV00zNW80NnlCczBuaG05dDlyZGV1K09V?=
 =?utf-8?B?MmIvQ1N5OTJPRU5lZEJ1ODhRSWM0ZExCa3AyckVlcUJabHdLcE1seDRSSTBX?=
 =?utf-8?B?aTUzZkg0b2JFcjlxRkRPdUpXRzFyOTMyckh2QU5hdldRUGIrelRiMjdueUk1?=
 =?utf-8?B?cVFhQkMwR1BQN1FIY0VzYW1BdHpWcG9qUFRyK2JGVTY2MU5GcnlMbGgxa2pI?=
 =?utf-8?B?RzZtdDl3dmZYM09IbUxqN0JjclRXMHZiRStCL2ZKc1pxbUNrNU81bEJ1STdT?=
 =?utf-8?B?clRvaS9hbG4vM0VWWWdWVCszWjhMSTN0alVtK0o3TXNDWlpLSTNUWHg3R211?=
 =?utf-8?B?dy9Uak5wc2hOR2FFaG1LcEdNNnBUTnp3eUpSRm1ydDBQRE5ZeWRtTXhhYWtv?=
 =?utf-8?B?aFFCN0loRkp1R2ZoaHpNV3NHM2xIRWxRYXZ0cFp1eEh4RnJXcXFJSE9jWGU5?=
 =?utf-8?B?QzduVk9vbXN2eVl6SnExWkJCdGREblB5azhNTjJ1TTJ0Nk5nVnorcW02MWVu?=
 =?utf-8?B?WnIxRWUwVFg2MVhEWE9raGUxUFRLc0xtcS9Nck1sV2pxdFh1STJFa0JtY0p5?=
 =?utf-8?B?MlEvdld5dmQwbXdySUdSaGY4WTlGQ1dtNURCWmVZK2d1aVNTZFY3RjZ1c1ZC?=
 =?utf-8?B?TTlEelJHbUtGQTl4cXdpMjNzZ2RRYkZQcHJ3WUJEbVlaK3Y3TEdWK0RoMWJJ?=
 =?utf-8?B?SmpSWnhuNEVWejNQWGJqMFF5RmM0bWs3S2s4d1BhSjB2Q1NKdzIxZ0ZzRUN3?=
 =?utf-8?B?MDA1ZkltMm91bDVHY2VYNlhXNTNmV2FlTFhHZld1dzl0bEtlUFZ4WFJjRi9Y?=
 =?utf-8?B?a3QzQXExTUIyT3NPekh2YkpXYXJ5dTh6cmlNNTBBZ1hVVWxYVzJjUklidEVF?=
 =?utf-8?B?YnNiWFFQUzJhQ3YwNWtuTGl4b1JYTVNrdm9CMkRjbTZtQ1Z4VGdmT1VCcmVS?=
 =?utf-8?B?MXViQmU3cEpFMDF1QnZOOGplSFBBbjVLZUJmbXc2L1MxTEdQc0ZjeUFvb0JK?=
 =?utf-8?B?TjE5YXJxRFZ4OThhQ1hncS9VelVYTzRqbEFwcDVlTVd4cnVVZVNVY0VwRUxO?=
 =?utf-8?B?bWNtWktLUzAzWG43bUhkNlE4ZUlRZDhnTlpBcUFtSDNPMnpyeStISFZzZWFY?=
 =?utf-8?B?eDVxZjQ3ZVkzWkRYcjN1TjlYalJTaU9nUDYvYlhlSlpKNHRSejZLOVhSa05p?=
 =?utf-8?B?UUs4RS9qdWFWaU95bmF2akxJVk4vaVBnOU9LWVlsRGhFTEMwR3MrU0VPdjM2?=
 =?utf-8?B?NklyNFdLTVNidDIvMk1jczg4QkRCRk16TmYzUitZeUsra2ROUTdNdDcvREtP?=
 =?utf-8?Q?eaPg4NN2SVeZs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f05eef1-45c2-40d3-ea0b-08daf9e3c2a1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 06:09:44.7598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1BUUya8Ajv/59SU6kPIWyOB1QKutL+u1n4NtQau9KwPa5VXAaOXiNDUnyx2n90LISKl0Q7qyvK4xEAE1YznUTP++e7WSVVLOfFleqTiUMWGmctAh2n94cwiJ+36WTmCg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7065
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190048
X-Proofpoint-GUID: vr_lWUopdBFHVL1QXmCXbVib3Gu7sqFu
X-Proofpoint-ORIG-GUID: vr_lWUopdBFHVL1QXmCXbVib3Gu7sqFu
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 16/01/23 9:14 pm, Greg Kroah-Hartman wrote:
> From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> 
> [ Upstream commit 9181f40fb2952fd59ecb75e7158620c9c669eee3 ]
> 
> If rdma receive buffer allocate failed, should call rpcrdma_regbuf_free()
> to free the send buffer, otherwise, the buffer data will be leaked.
> 
> Fixes: bb93a1ae2bf4 ("xprtrdma: Allocate req's regbufs at xprt create time")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   net/sunrpc/xprtrdma/verbs.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 0f4d39fdb48f..e13115bbe719 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -1037,6 +1037,7 @@ struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, size_t size,
>   	kfree(req->rl_sendbuf);
>   out3:
>   	kfree(req->rl_rdmabuf);
> +	rpcrdma_regbuf_free(req->rl_sendbuf);

I think this introduces a double free in rpcrdma_req_create() [5.4.y]

Copying the function from 5.4.229 post the above patch here.

Comments added with //// marker.

struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, 
size_t size,
                                        gfp_t flags)
{
         struct rpcrdma_buffer *buffer = &r_xprt->rx_buf;
         struct rpcrdma_regbuf *rb;
         struct rpcrdma_req *req;
         size_t maxhdrsize;

         req = kzalloc(sizeof(*req), flags);
         if (req == NULL)
                 goto out1;

         /* Compute maximum header buffer size in bytes */
         maxhdrsize = rpcrdma_fixed_maxsz + 3 +
                      r_xprt->rx_ia.ri_max_segs * rpcrdma_readchunk_maxsz;
         maxhdrsize *= sizeof(__be32);
         rb = rpcrdma_regbuf_alloc(__roundup_pow_of_two(maxhdrsize),
                                   DMA_TO_DEVICE, flags);
         if (!rb)
                 goto out2;
         req->rl_rdmabuf = rb;
         xdr_buf_init(&req->rl_hdrbuf, rdmab_data(rb), rdmab_length(rb));

         req->rl_sendbuf = rpcrdma_regbuf_alloc(size, DMA_TO_DEVICE, flags);
         if (!req->rl_sendbuf)
                 goto out3;

         req->rl_recvbuf = rpcrdma_regbuf_alloc(size, DMA_NONE, flags);
         if (!req->rl_recvbuf)
                 goto out4; ///// let us say we hit this.

         INIT_LIST_HEAD(&req->rl_free_mrs);
         INIT_LIST_HEAD(&req->rl_registered);
         spin_lock(&buffer->rb_lock);
         list_add(&req->rl_all, &buffer->rb_allreqs);
         spin_unlock(&buffer->rb_lock);
         return req;

out4:
         kfree(req->rl_sendbuf);
//// free of (req->rl_sendbuf)
out3:
         kfree(req->rl_rdmabuf);
         rpcrdma_regbuf_free(req->rl_sendbuf);
//// double free of req->rl_sendbuf, we have a kfree in rpcrdma_regbuf_free.

out2:
         kfree(req);
out1:
         return NULL;
}

Found using smatch.

I looked at the history of the function, the reason is that we don't 
have commit b78de1dca00376aaba7a58bb5fe21c1606524abe in 5.4.y

This problem is only in 5.4.y not seen in newer LTS.

Please correct me if I am missing something here.

Thanks,
Harshit

>   out2:
>   	kfree(req);
>   out1:
