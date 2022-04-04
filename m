Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A134F21D1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 06:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiDEDKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 23:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiDEDJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 23:09:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5834755D;
        Mon,  4 Apr 2022 19:54:22 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234JIs8o012575;
        Mon, 4 Apr 2022 23:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eFU89ZSlyTSv0WOP9BHEZELJQz6ttCmN9y+37h1f3Ks=;
 b=0Am9GJOiM+d06KiVEy6Jth4cYGyovuV86pR76QaGs727zw1aiAHoROz8k/YdqWGtRJgD
 bJrIStganPOGHkm/MOSK4W2BDDV3cI0mvB6UUIXjtbQPsXO3fUiPXKen8mh5i1nlKJrv
 G89pWpGyuQStC41kCQpY5Ie8Venr8DsPmmC7PnWjUpCZrq5QJ9zRLNMINrJqrXxx6Ucl
 lwxKqjDrrKDQCBDDLM50Xn8+roSI4VPLno6VzNGIuPU/njy6JjNzHrMj2b5+WGvuA8xH
 ZcIVlHP83I9EYppHhdikIpwpcrKR8RZvhNdbhEKBI56M6qSq+Z6Olss5dGOGO3h42qov cQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcckm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Apr 2022 23:48:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 234NgKmE014150;
        Mon, 4 Apr 2022 23:48:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx2ya5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Apr 2022 23:48:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDv5/oi/x0GGjz98Rbry6355KBj+YrS1xjMo7GnjdXgn6B17RwfE7mrbqbKPSXTTtIROp592WkjHCAzli/ZGhGhJf0ibHjmW34cDjQRYiE9D+9TCdswUJDJPbKUbypOsvQ5vD1efwiB2Xy8b25WkfG19KKpP3sdGBn8jEpVufebz5/TfgMXHTYDAqOsK68v2zi/ak6nsw6R02r1JYWM0G9D26yV3FxKGJoKlgmZeiAsRzK6SeizUsU9pD0pDPR0ZKCYn2DWVgpKrNsQgLVwTwyJAAQBzseaObRPGSfVgq1jkcTsrKNMLlQZVmjJXJRNiR4rgI7AhIPGXOyhTOrUdjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFU89ZSlyTSv0WOP9BHEZELJQz6ttCmN9y+37h1f3Ks=;
 b=aRNf7SOVtnDtQXcU8sef4smBj6ouPFRlO1rEUygO9ceNQ47R/Uje8DrGMyLEaUAx25cxxTmO2+4yY2on8ssS45hT+O0ydRhz/PZIPJh8IqoMCfloCoLV5Ov+SwXwR0apTOsRNzy9L2WvOH43k3jR+RK0jRLKblvfS1l7KJNHkPY1mGnzXU0icCxF6JvrtA3QL7w3gBCVMHJUXz9QuYODeKH4nAY+o1ZzMratuxUTIM+1ERZP7/Vp6Feqfce8s/JoWcXHiCIhryHxdbqD2w6JnrN4LK/buwjs2xMonsIc1vFkqlA+8geIIsjy5vURBD1WHVN1+IOSj+71ie0NbSETIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFU89ZSlyTSv0WOP9BHEZELJQz6ttCmN9y+37h1f3Ks=;
 b=PeEOoRaERNtzWaJwC5Hd1wSgZvYszZE0SR+B1Zmz2h+MOue2UT+3zSLYaNuKRAhOAOtdMdnmyocvnpMbd3WjGIn5FtgGCSxkv9OYo7E9FVEEZvW24R5af16CSaYXI4q8b3UpFjgDoox53eycmV68mUnYAJSVgtQzq6U9bo/q518=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CY4PR10MB1253.namprd10.prod.outlook.com (2603:10b6:910:7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Mon, 4 Apr
 2022 23:48:39 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::245f:e3b1:35fd:43c5]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::245f:e3b1:35fd:43c5%9]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 23:48:39 +0000
Message-ID: <d3b98e2b-2148-172a-358c-e7ab1e444c3b@oracle.com>
Date:   Mon, 4 Apr 2022 16:48:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] hugetlb: Fix hugepages_setup when deal with
 pernode
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Peng Liu <liupeng256@huawei.com>, akpm@linux-foundation.org,
        yaozhenguo1@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220401101232.2790280-1-liupeng256@huawei.com>
 <20220401101232.2790280-2-liupeng256@huawei.com>
 <0aefbc18-4232-0bae-b37a-d4c6995e3d00@redhat.com>
 <508fd247-b809-27d7-6bc8-a08c4c73cbb5@oracle.com>
 <e3889061-4681-0618-5291-05b9559e0e10@redhat.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <e3889061-4681-0618-5291-05b9559e0e10@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0362.namprd04.prod.outlook.com
 (2603:10b6:303:81::7) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8be609d5-b36f-457d-e8c5-08da1695a414
X-MS-TrafficTypeDiagnostic: CY4PR10MB1253:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1253862089C0BB29D52ED7C8E2E59@CY4PR10MB1253.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbJuwFiKr1GbXkKELdMhDoeAkEP2sISI9SkdVYLxU9r7q8+xhbC5A6tiUOfpTq61psNTRkyViu5ECC/5OWjgsWlBCjpzbMuY6zT4tGoLDS03eUziuCmcr3I9/Hb3dbH5t5QVNG7FdlltVusGSaJYLfAVqWlpGr3hHedw1Q1JyJWDEJaE07XzH6QHFSjgqwrb54gvH8xIZEhvSii/6rPKtsbBzdGZ4jyBOqRyTqr0j+UkeAZottiir08b0IrvznW+VzyQE5shUKhRPZO3jlnArHETa+ahaq0EYHrtLT3aXhpJO7sdW7JIZpBPdCDSHMqtm9/yW01LIiOiQ3VVxJ/kyJfNepbREDWP9mYSk/r6VT6LtMaGPHvdiuUiALlVvagcHdffG8OZMaXTjfjTym90gyforQp97vXYSnEHx6VOxBRC0xA/qgwWRyoBAabDGywD0ab5Jjxtmeeg3kIfP0i2dDfG4NbNCDmD4R0e4ZcHHRPVRSb4EFHjPaF1+re9Cfv0/miKDlA496HvyAKuyXtQK35+YFY4t7EV0vE/fEbFN3oJAgz9IERUz2cAfV1ucuucuyuzfV3lVRuoW2ZP1VDCR3FtCeHLhkI6EL7/EBRgwOPA+OJ8bF3t32V5ZeWchAXOiloBX4zB1Ws9mDo3m+H2FRKQa22EQvNrlHQ/T6VbirIB8XU4F26KUfRNUW8fforVgKrbMPfVXFZYYWbnWU4bxaqUTDsgtL5CFeO4HEnF2cXUFpZlEsWcEiyBrYpowxIh5yalAaB9uLWEHqSOYAW21OY2jI612/5dmLt7HQGYh0DFtYRmfCR8FI8NPXf5o726FgsZI3lOS/Pt3XeoNwDjh78sZwOMCObGwOIzlqexVF0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(31686004)(508600001)(86362001)(36756003)(83380400001)(2616005)(6506007)(53546011)(52116002)(6512007)(26005)(186003)(44832011)(2906002)(66556008)(38350700002)(8676002)(6666004)(38100700002)(966005)(6486002)(5660300002)(31696002)(110136005)(66476007)(316002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0QzT3lWUm9OMVFyWFJxT0V4SGE5Um5mdGZPRGZHZ2MxdFFoVXptQXIrSWZl?=
 =?utf-8?B?cndTTmwwWmRQKzdZS2h4SUNxa2JyUkQ0TW1YV2ZIZ2dvR2t1ZHJCU09McGhV?=
 =?utf-8?B?RVRENENGU1NLMWN4RXFaSjFwN2FNaWVhNXM5Ums3YVRqbFY5dFpkdHRzSXJH?=
 =?utf-8?B?NTFJR2FLMDNGZnlJY3NjL2pXYk9wdG1OU3hWSUY1S0pxWXZ0M0pLSDZmbTlB?=
 =?utf-8?B?bm1MZkVQaURQT0s5dk0ybkZodTFqekN4akQ0bkcxM01wZTlGSHlSdE9CQ0ds?=
 =?utf-8?B?VXgxZHZ3V1o3N1V0bm44Sy9vYmJMVFQvOFlkdFk2cmo5ditIaGl0M2tXb214?=
 =?utf-8?B?MGpteit5S1dSaXRvVm9qaDl6eU1mOGZkR2pSeC9Nb2tsRmkzQTRGRGU2cGFs?=
 =?utf-8?B?Y1QwaHNtZXVHNWlhZDJjTHdIOW1ZSVFKY2hsLzNvanZ1QWRIdDVIamhnUU10?=
 =?utf-8?B?dnpxNkhSMWl2K0p4dXZHbWJlWHFhMXpuNVZlandPbjRTcWRhWWpPMDRzNTR1?=
 =?utf-8?B?Z0dsWUtpaklZbjVBSkNIb3FybEVCSU40M05WUHZnY1ZaeWs4SFdmdjRJWStl?=
 =?utf-8?B?MzFlSkhOWVYrbHFXeUNFSDVsb0d4MDN2VlhJSVBPUnd1LzFtKzg5cjJ2azcz?=
 =?utf-8?B?SnJyaXFKZ3BNdUhNeTZmU0VxemptTU5Qdkg2K1gxaThIV1dXVldacG1Gblcr?=
 =?utf-8?B?ckdOWEw2UHVWTmxHQlhieGZVYkFMQ0lzbyt0RWJKS1kyaHd2MUFxYWdjUmM4?=
 =?utf-8?B?dm85V21vNWZRSndySWdDS3BQVjhtNkFqeHFYN3JEdWY0N1laWFRpZG41ZkhB?=
 =?utf-8?B?d1N3MFVvTnZETW41UGZSdWlCOW1RUTZjK1M0YXlVMGVrVHh4YVl0OTA4a2pR?=
 =?utf-8?B?aGg1Z1h0OXhITmh0cXpObXhGMjhudHNwcW5yYXNZNjlXaUd4Wkk3VVdrUCtY?=
 =?utf-8?B?bE11VlJZbWJzV2NUUUJ0UkgxdnlPcmZFTWR6RWwzYko1OEJrWVBJSGxUNVZi?=
 =?utf-8?B?NzhnclhpSCtkcnBFNlF6eHl1SUJ6bEtoMjM0b2R1YmlKbUFiY0Zrc1I1ekVQ?=
 =?utf-8?B?Y0h6cklPYjR0TlZSU3NCLzNCS1d0VE1URmoxRDB6WkgvZmdnT1NVN1RWbWVu?=
 =?utf-8?B?SjVVUkhNQ3RPd0FCWnB2MTFaT3h0WWQwUTU2Q3F4ZUFDTHR3RzVicXpDZ25x?=
 =?utf-8?B?eFN4Smw1RFpLOWNRR0NuZXBaR2RiSUxCRXJBdEFBUUhRRVBVZXZsSXQyVWFV?=
 =?utf-8?B?MXdZYlFXQTJiTGx4dkxPRVhzaXJUblBucXhEdWJ2N3Ewd3VWR3Q0SFBJeVVS?=
 =?utf-8?B?dHZUUEZYMGo3TFpHc0tQcG1lNjNwSjZhd0FzeXZjQ29FbzFNWXVpSWpJUDBl?=
 =?utf-8?B?Q2ZYQy95LzNyR3ZWbnpMV1liVzhTbUVIcFhlVCtZQ2VVMS9wQXBEMzBEbmRq?=
 =?utf-8?B?OExxZ09QUzk3eWZYS1NEUWgzWVZVMVp2bFdRd3Y1Z0lFbkRucnNGam9IT254?=
 =?utf-8?B?ZFZvR2V3N1d3eUNXY2dWUC9WYnR5SFBUMGJyR3hYQytuZkYweXNoMGJYMm1R?=
 =?utf-8?B?L2M0ZVhmdG9lSEo5TWUvbEJEMGFySWFha1VzMmFPUlFDTkNGVGtHMURRWU5r?=
 =?utf-8?B?UUpmQU1FYnRXZHAzamJGWFo3Y1k3NHhEaS9SZ3I1eTA5K3ZkaGx3VEY5NldS?=
 =?utf-8?B?SUpjcktqK2srVlNPMXBvRkZDdmh1L29Sc1BUaTFzSWZPUjk5Ty9aZFIrSzRy?=
 =?utf-8?B?VGg1bzh6TWpjYk1xTENzOHEvUkdRRXVHOGxoQi9rbS9kYnpFSkZVbTJDUWFz?=
 =?utf-8?B?cnY0b1RpQkN3eWJEdEhWOCtuUEtiSUFPdUlvK01UUmxCN3RwVkZBQ0gzMUdi?=
 =?utf-8?B?cGdtRjdPQnlMWERWaFhDTEhITmtIbHM0VGducXB0RTdMV2ovWlU2QXRTcUhz?=
 =?utf-8?B?Nks2QVR0QStKVW1HckpzR0dWZGNuOEwrQkd6NFAzSklYMUZTVUluYkh0S3ll?=
 =?utf-8?B?bzk3bzNBTjFaemFGRkJtcHNDN2pWNWNVNCtvQy9CbzVBaUlIMm1GaEFCczlG?=
 =?utf-8?B?K2dzOGZTODBWZ1FDYUJsSVNxTm90WjRSMVY3dUthY1UzajFUKzR2cWo2YVUw?=
 =?utf-8?B?OEUzc3ZKeDhTSkMvTEdYK3VyUFRyWGtENkZBQ1oyclo4bFhRR1FIaDdGUElE?=
 =?utf-8?B?YWQzNXRFY0Zmejdpa1RxbzdGeU52SXdlTGg4VURCcWM0TXM3Ukh4eDhvNGds?=
 =?utf-8?B?S3hrTWZHUm5HS3p6OFd1Z2hJclVPQ3FlQmtRMGo5TnY0OU5hWmpsWEFtNVVo?=
 =?utf-8?B?cE9xWThqRDVXb05RbEExZXI0YzFFUzBEM2hybW5reTM3VHJlRTJycEU4dVFL?=
 =?utf-8?Q?y6RWmJfSbS0UqQzw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be609d5-b36f-457d-e8c5-08da1695a414
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 23:48:39.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kiVq0tk442ku+E/f+YGhbFrJvjmCSB0biqZ9iIBRYxDHE2DUMy3S4aOBf3MdZGAR+qHy/glJe0bUM9Z1xIaqYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1253
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-04_09:2022-03-30,2022-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204040131
X-Proofpoint-ORIG-GUID: a4FxPHORTJYFIdIXt07_Rcek9Q8HkT6o
X-Proofpoint-GUID: a4FxPHORTJYFIdIXt07_Rcek9Q8HkT6o
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/4/22 03:41, David Hildenbrand wrote:
> On 01.04.22 19:23, Mike Kravetz wrote:
>> On 4/1/22 03:43, David Hildenbrand wrote:
>>> On 01.04.22 12:12, Peng Liu wrote:
>>>> Hugepages can be specified to pernode since "hugetlbfs: extend
>>>> the definition of hugepages parameter to support node allocation",
>>>> but the following problem is observed.
>>>>
>>>> Confusing behavior is observed when both 1G and 2M hugepage is set
>>>> after "numa=off".
>>>>  cmdline hugepage settings:
>>>>   hugepagesz=1G hugepages=0:3,1:3
>>>>   hugepagesz=2M hugepages=0:1024,1:1024
>>>>  results:
>>>>   HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
>>>>   HugeTLB registered 2.00 MiB page size, pre-allocated 1024 pages
>>>>
>>>> Furthermore, confusing behavior can be also observed when invalid
>>>> node behind valid node.
>>>>
>>>> To fix this, hugetlb_hstate_alloc_pages should be called even when
>>>> hugepages_setup going to invalid.
>>>
>>> Shouldn't we bail out if someone requests node-specific allocations but
>>> we are not running with NUMA?
>>
>> I thought about this as well, and could not come up with a good answer.
>> Certainly, nobody SHOULD specify both 'numa=off' and ask for node specific
>> allocations on the same command line.  I would have no problem bailing out
>> in such situations.  But, I think that would also require the hugetlb command
>> line processing to look for such situations.
> 
> Yes. Right now I see
> 
> if (tmp >= nr_online_nodes)
> 	goto invalid;
> 
> Which seems a little strange, because IIUC, it's the number of online
> nodes, which is completely wrong with a sparse online bitmap. Just
> imagine node 0 and node 2 are online, and node 1 is offline. Assuming
> that "node < 2" is valid is wrong.
> 
> Why don't we check for node_online() and bail out if that is not the
> case? Is it too early for that check? But why does comparing against
> nr_online_nodes() work, then?
> 
> 
> Having that said, I'm not sure if all usage of nr_online_nodes in
> mm/hugetlb.c is wrong, with a sparse online bitmap. Outside of that,
> it's really just used for "nr_online_nodes > 1". I might be wrong, though.

I think you are correct.  My bad for not being more thorough in reviewing
the original patch that added this code.  My incorrect assumption was that
a sparse node map was only possible via offline operations which could not
happen this early in boot.  I now see that a sparse map can be presented
by fw/bios/etc.  So, yes I do believe we need to check for online nodes.

-- 
Mike Kravetz

> 
>>
>> One could also argue that if there is only a single node (not numa=off on
>> command line) and someone specifies node local allocations we should bail.
> 
> I assume "numa=off" is always parsed before hugepages_setup() is called,
> right? So we can just rely on the actual numa information.
> 
> 
>>
>> I was 'thinking' about a situation where we had multiple nodes and node
>> local allocations were 'hard coded' via grub or something.  Then, for some
>> reason one node fails to come up on a reboot.  Should we bail on all the
>> hugetlb allocations, or should we try to allocate on the still available
>> nodes?
> 
> Depends on what "bail" means. Printing a warning and stopping to
> allocate further is certainly good enough for my taste :)
> 
>>
>> When I went back and reread the reason for this change, I see that it is
>> primarily for 'some debugging and test cases'.
>>
>>>
>>> What's the result after your change?
>>>
>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>
>>> I am not sure if this is really stable material.
>>
>> Right now, we partially and inconsistently process node specific allocations
>> if there are missing nodes.  We allocate 'regular' hugetlb pages on existing
>> nodes.  But, we do not allocate gigantic hugetlb pages on existing nodes.
>>
>> I believe this is worth fixing in stable.
> 
> I am skeptical.
> 
> https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rst
> 
> " - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing)."
> 
> While the current behavior is suboptimal, it's certainly not an urgent
> bug (?) and the kernel will boot and work just fine. As you mentioned
> "nobody SHOULD specify both 'numa=off' and ask for node specific
> allocations on the same command line.", this is just a corner case.
> 
> Adjusting it upstream -- okay. Backporting to stable? I don't think so.
> 
