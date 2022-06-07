Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8ABB53FDA4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbiFGLie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbiFGLid (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:38:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0076928E33;
        Tue,  7 Jun 2022 04:38:29 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2579YKw1001822;
        Tue, 7 Jun 2022 11:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gPd7/KqY2HDEwxgs4yebUWk3WNhqRYkOpikLXYW4EyI=;
 b=n8rB2LVjagYRcRVnT/Di5Nv8i22VUYQ4D5EOyWfKoPUv3my2v1sLKMpzTe+urx/IiDP3
 ij46KTUzZxgtcKCHCg2CIZzNULzqk793FHxm37qQgh4S4R+7fC5eioIIGnchwHmDMObn
 qmVBJoVMocef41MlXtzE/ANF5/ju+AkvyJwYKuwbFEjGhCJkOy0uzL5mfJnPYONbbctN
 ihX+GYWUMWSxJDH4cvicy7loN5B5+MIXBFc79BAzbWdocCaUGHFtOPPu9Et0G5oplFAx
 RIkvsPE4fF45QH0f7FrDTTA4V18W1dJriCZ3y1qt2Sa0mGK0T3fJzEVa4vwL6V2K3DtV mA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyxsdncp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 11:38:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 257BaQFQ018999;
        Tue, 7 Jun 2022 11:38:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu2ee91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 11:38:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrGWMrUjBxP7RqynG3avawYYqVZewBWfwylMXxzfNZgFwULeNfYtrCGJWuaR1krhHGuRzDeDbllVDBDL2QpxdFRdegPK6JpH/AGEQWWAGMv8C3gu1bAmcH3WOPFHwNS1FMXQeO9rPMjNAU9dkx9GReq45b+d24YtQO3JTGZGY/qRI3m7D6iIU818HX9vFO39gc2VF/JjQflVAJ3hwXib62GvRSZtHlIr+qmvsUJzPuGJ/QWHR0aecQOgvLKGqxo5+alM+Drmm8hd3AJrT71R8C+fkaFtaaBXnjNKXkDWKqnquXKWZv9nrXElhtoIgZ2aSb50THmcUcs7ftTskc9U7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPd7/KqY2HDEwxgs4yebUWk3WNhqRYkOpikLXYW4EyI=;
 b=NQn5oIvtKw6fEL85hXoRv7WzCtQIw9gfC/yuWHPpM1Xi5xwyaZger2FQ+NGJhf/RAxFdzWZT49V3IPBHJ5Kq9ZIe1zIsKiTKFGUTRjzp+PKPKsL0rgQJLl8L/KMSEdpYVn2OYxnGEgIMBJ9/+KMskK4ycFVTZqcLeZ0ZHLaxbdOZMFPxG+byBwcIQHpk8tT4S/07WZfDmPeINzv1l1TX9Usj6W7Cs86ISJpsui1g3co6D5ji63Woeopy5wfIUM4SoaMNhynFf74Tuf5ST3sfBN3p6seIrMSZtfLMJ+4T3LNw+cfMkM2ql/smlCFqEMi4sOzxVEdojmQ36F8fge6ToA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPd7/KqY2HDEwxgs4yebUWk3WNhqRYkOpikLXYW4EyI=;
 b=VJzO9Mior3lEoOnPOAn0xLI7L1llUEgrjihQ7aLUKkkwhsx2KG0nsEeu9AiqssXrGjB7RcPxP4pzOzs+zDx3Bqpetcnr1tf6axCS6iQEmUzskYNr1MgKm1robeteLiavEm3Bxv3vNc/41/B6arluZTWKnUQkx4Ht8c6FEgICh0g=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM5PR10MB1402.namprd10.prod.outlook.com (2603:10b6:3:c::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Tue, 7 Jun 2022 11:38:24 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::138:2847:c75d:b5cf]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::138:2847:c75d:b5cf%3]) with mapi id 15.20.5314.013; Tue, 7 Jun 2022
 11:38:24 +0000
Message-ID: <80a1469f-e5ce-11e1-b637-dba40706ce80@oracle.com>
Date:   Tue, 7 Jun 2022 17:07:55 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] btrfs: add error messages to all unrecognized mount
 options
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220606110819.3943-1-dsterba@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <20220606110819.3943-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::15) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b975094-db7d-4536-72ea-08da487a3b12
X-MS-TrafficTypeDiagnostic: DM5PR10MB1402:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB140200027B3231C12FEC1B09E5A59@DM5PR10MB1402.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m0L/gi4FXeig6uaUBAUlYG7uL7A+kGtlmVwQ2AgYONrJmB5QsI5wP37cx1M2YOrSuzq8eGahEBsTShXVibXNEIsSEejXqrEX9aJ3y0QdSDocNt7zo8RmNXegeITcFkxI6nCK5wj7hc35fcVAD52AJM0B53cJpjLGKJpLJEGdgjiHapsrneI4cqw57PurWSVoCyfxUeBuxVqHC1vYDXYGezR2+T9JWCWOXDU1LdjCBMPRSEYcMkwtpfIgBBjh3vFkwQvpMJd4f3FlBOy4+bF+BnFrOW3BpPARogJpmf1IqSSWSk733WnGj3cSNTgR3EwhSXMEhchTm1Lm0Bs7/XdcfS6T2ih8k9r+7kVbCyTe89StojOPaKROany61PFzzs3FOLgi2Qu4+NvdO9ErmH+oy8oQagtQYsjjF+F9GXb02UFl+A3AsOZ1pEGaDZb+TRZsVavb7MiT+sKdiwD6lrYgPqY3immlhFIFML7vGkuat5EQmRe6pOFlF/FwJeT9sp9/mDjekv4WGfyLbTqb71KKZIV31yNn6uXh1Tkdk9daoV868jdzo2zRbnLqiTsgrL6fbEqDAhxBayD1ps1QX4p+k/874y0SV1v3fhX2tx45GUmXI37mrBDL/lW6bug/rDcrHF4naRwffvFdQyEfsu88+ezPyRx8FFNV04BuIac66RmsAbOkXeCCcLab77b1aB6gbLb69HmV+W8yt6jsOKGx8Rbjm5RbQIZTHWCL12B6cLQ4n/CkVDRNERe4PzBaQxnHIvm7y2JJARRcOfDaY5IHjCsVC522t0J32lS5kehWtZ4jgGEURqYsKDcxFKtbRGA4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(2906002)(6666004)(15650500001)(38100700002)(6512007)(44832011)(316002)(36756003)(86362001)(83380400001)(6506007)(31696002)(66476007)(8676002)(2616005)(4326008)(31686004)(6486002)(66946007)(966005)(5660300002)(66556008)(508600001)(186003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VE1wQlZaRUNpbitMMXB4TmRRK0twQ2l5MTRQOHRqN3lra1Erb011cTFYcUwx?=
 =?utf-8?B?cy9LOTFmTlFwUmw3NTUzdFNpb2daS1ZQT3ovWUFNVjd4TXV6OHRhS1Y0WW9R?=
 =?utf-8?B?akxsM09rTlNsUzM4WVg4N3F1WDBmd2V0cUtDR255cVhFVlpYVi9jbGFEb2Z3?=
 =?utf-8?B?WlVwOXhSMS8yYlV3cDFXSllDL2krWTViNmxBNmtDSjBBVnd2MnBPWHArc2hR?=
 =?utf-8?B?bmdMVWd2R1NoMlIxWWs3TXc4Z1BXeHpabEdJbWxUQjFkSVJXeGI4MEo1dUJt?=
 =?utf-8?B?eHdsaVluSDBGK3RBQi80SklJTThSejM4K2lUUUNzYmJMTVZFQXFORHc1YVZE?=
 =?utf-8?B?QlBldHZSR2pncnFiZ1RpTG5wWi91Z0Ira0ZTRWhzTXVnNVkyKytrd1l4eGtr?=
 =?utf-8?B?MHBSV3pHczNWeDZZV0xqQlFNSWdkbVkrRkFIU3Boa0ZJMmJKWjRXcFpoalZM?=
 =?utf-8?B?MUk5a1VUSXFjTDF6Ny9YZHNvSDZIZGRsUTVONVlycTdPRHFQZjhmSVk0QjNM?=
 =?utf-8?B?d3pZWmFiVVloZmhGNnRrWHBPZ1Y2RzVaOUJQTUgrMVB2eVUxNTJSQ0hxRmpP?=
 =?utf-8?B?T0M5aVdsVEkxYTdWWUQwTnRaaDB0NU1yNEloRnJpZnVFa1pWTzRLanQ4OHJ2?=
 =?utf-8?B?anRqd2tMSzI4Y29BVmlMTmFIWjgxTXlZUXJ3M00wNGVJbGRsK25FMEhrRXlv?=
 =?utf-8?B?amhnSWtndkFGZVN2R0lYblNPSnc2VFQ2QnpSZTgyQmNUbC82VkNHY0dCS01q?=
 =?utf-8?B?WmhWblRoc2tNRzN4Sk1UQzJjV0VPRDhsalpuSWdJY3cvWDdPaVZKVDlsZDlK?=
 =?utf-8?B?QnkrN2lDN0lISlJabzRZd1dDRmVYRGRVKzlML0c3NHJpNWE3aUZkZEk4TUl5?=
 =?utf-8?B?WStmVWFqV29jVlMvVVNJL0xPMG1uSktBdkVJS2w5Sm54dGU0ZVV0T2VtTHda?=
 =?utf-8?B?NFBFdi9sK0tnS044V0lMQllvR09xRGZvMmY2b1dJSFFUanREV21MaEliU2ZE?=
 =?utf-8?B?a1ZiQ0Y2K2tRZXZQZUxTWnRiVGhCay9KK0ZDc3Vxa1lNRXNtamtnZnRKNEtX?=
 =?utf-8?B?aG1kMGdMMkEzcVo5SlFxdS9FdjdxVXo4dU9wUEZlWTZicEh1Tm1pNFkvVlZz?=
 =?utf-8?B?b01QVjloMXRza0RlWkZ4VFh2a0kydkFGZjRqZzhVdzJaVW1qMnliSEdkdkhD?=
 =?utf-8?B?WXhhQkxDVmlDdnVqSzNEc1pwWUJFN0pSZ2hyZVUyNVVGR1VFWUtqVTd1M0N4?=
 =?utf-8?B?Y0ttUVp6MEQzM3doQ1pkR1kwS0R1ZHMxemRXNkl3ZnNGWWt1RWIzb3FwWHNy?=
 =?utf-8?B?Yi9BbHNaZ212NCtjdkt4MWJjNTNIbkZMWDhocE1uSXZmeXg2b05sWXZ1cW9l?=
 =?utf-8?B?VmFubjhURVV4OCtZNFB3SzlpZnRZTzhsSW5FSDhsODZobi9nN0tuaGlrMk41?=
 =?utf-8?B?TUZaQmVJWDlCU2YrWVNwajB2M2xhVURuQmwxZUsrc0NUbVNCT3p6QWdZRkJR?=
 =?utf-8?B?b0hQbEZQaWFIS3MxcFhVQzN3bkRPRUVHN0tBaHU3WjN0cVRzU1lvQm1GTS8x?=
 =?utf-8?B?VmxpeThUT2tnWmlpSXh0QS9PUjZ6a1NnYjVkVFQwR0s2TjhQaGNUNzZoK2JZ?=
 =?utf-8?B?b1p3dnN6VjBUSnI1WWFFMFhrSUZmQ2lBMlVPQmNmNldhazZwMWlLSlZtRDZK?=
 =?utf-8?B?ZHpnL3RsRkl3bG5YTzZXWTA0Uis5azlqVCtyODJaMnROdk9vUmppeXpvTXI0?=
 =?utf-8?B?U2Vibng2Y0cxMHg0QjhCYWZJaEFQTUxBQVQ4Z2xUeXJlVkxvTEt2SElRSVV1?=
 =?utf-8?B?bDluMDkrV3RRSnhhOE85bUJpU3lXSXIvUTBINkRKcW02L21SdTZvQlBTZUhB?=
 =?utf-8?B?TFBiQmJ2ZDdRT0RtSGlhVGJucUZTNldKTEhlMWNWOEpOeVRjeEt3NWd3YTJ6?=
 =?utf-8?B?L2dSaDQ2Nlg4TkZjbkRSV1BOQll4RUxNMi9tZkkzdFI4YzUzYzdieWx2eGor?=
 =?utf-8?B?UXQvK2EvY21tTkNUTkwzYitjaGd2NGhiY0tCQWNvR0RseVVWdnBBUzY1TXlt?=
 =?utf-8?B?bGlxaG1zSUxTQ2R4WiswZDhuUDNwTHppZ05rK0tPYzRpeUVlSVhBWGw4MERo?=
 =?utf-8?B?bXpXNENKeHd1RDdKcys1QnpPUC9mcFBNb2Vxc2V4ZWhybE8xQ0tsaDJheUJU?=
 =?utf-8?B?c1lPa1hHV0wxQURJSlhjMGVnTS90V2l0a3lIT3pxekwwQUZKNEhGQVJwUU83?=
 =?utf-8?B?eE9acFJOY2NaY2xiak12MjBmY1NBYmFpaXVOSzBvemRVZnpBZUd1bWZiaVlG?=
 =?utf-8?B?dEdmVlk0S1IrYlZsMmJGS1l5ZXM3M0VzeGVKVjRhVERoSEhRV05pWGlmL1dh?=
 =?utf-8?Q?Tigs7MY2khnfrzTbAw6QAzt4Sf4oUg4yH699Akuqrh89v?=
X-MS-Exchange-AntiSpam-MessageData-1: Birv7DJM3mQ1Eoi8Y1m4Vu/jnVSTqNP7obY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b975094-db7d-4536-72ea-08da487a3b12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:38:24.1558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GeL33nOcHdZUyhV0VW2QQF8r+9zXCJqb5I+f/8/wZfCpEfgWedAFj6AIC2OWPZE3zoBgpSnXpDFLPZZclxsHKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1402
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-07_04:2022-06-07,2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206070049
X-Proofpoint-ORIG-GUID: KsXF-vYbDL6prZXkfWGJcuGlz33y36x8
X-Proofpoint-GUID: KsXF-vYbDL6prZXkfWGJcuGlz33y36x8
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


LGTM.
Reviewed-by: Anand Jain <anand.jain@oracle.com>

While we are on this topic-
Not all valid mount options get printed either. I sent a patch a long 
time back [1] to fix it. If there is enough interest, I could revive it.

[1]
[PATCH v2] btrfs: add mount umount logs



On 6/6/22 16:38, David Sterba wrote:
> Almost none of the errors stemming from a valid mount option but wrong
> value prints a descriptive message which would help to identify why
> mount failed. Like in the linked report:
> 
>    $ uname -r
>    v4.19
>    $ mount -o compress=zstd /dev/sdb /mnt
>    mount: /mnt: wrong fs type, bad option, bad superblock on
>    /dev/sdb, missing codepage or helper program, or other error.
>    $ dmesg
>    ...
>    BTRFS error (device sdb): open_ctree failed
> 
> Errors caused by memory allocation failures are left out as it's not a
> user error so reporting that would be confusing.
> 
> Link: https://lore.kernel.org/linux-btrfs/9c3fec36-fc61-3a33-4977-a7e207c3fa4e@gmx.de/
> CC: stable@vger.kernel.org # 4.9+
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/super.c | 39 ++++++++++++++++++++++++++++++++-------
>   1 file changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index d8e2eac0417e..719dda57dc7a 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -764,6 +764,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   				compress_force = false;
>   				no_compress++;
>   			} else {
> +				btrfs_err(info, "unrecognized compression value %s",
> +					  args[0].from);
>   				ret = -EINVAL;
>   				goto out;
>   			}
> @@ -822,8 +824,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   		case Opt_thread_pool:
>   			ret = match_int(&args[0], &intarg);
>   			if (ret) {
> +				btrfs_err(info, "unrecognized thread_pool value %s",
> +					  args[0].from);
>   				goto out;
>   			} else if (intarg == 0) {
> +				btrfs_err(info, "invalid value 0 for thread_pool");
>   				ret = -EINVAL;
>   				goto out;
>   			}
> @@ -884,8 +889,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   			break;
>   		case Opt_ratio:
>   			ret = match_int(&args[0], &intarg);
> -			if (ret)
> +			if (ret) {
> +				btrfs_err(info, "unrecognized metadata_ratio value %s",
> +					  args[0].from);
>   				goto out;
> +			}
>   			info->metadata_ratio = intarg;
>   			btrfs_info(info, "metadata ratio %u",
>   				   info->metadata_ratio);
> @@ -902,6 +910,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   				btrfs_set_and_info(info, DISCARD_ASYNC,
>   						   "turning on async discard");
>   			} else {
> +				btrfs_err(info, "unrecognized discard mode value %s",
> +					  args[0].from);
>   				ret = -EINVAL;
>   				goto out;
>   			}
> @@ -934,6 +944,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   				btrfs_set_and_info(info, FREE_SPACE_TREE,
>   						   "enabling free space tree");
>   			} else {
> +				btrfs_err(info, "unrecognized space_cache value %s",
> +					  args[0].from);
>   				ret = -EINVAL;
>   				goto out;
>   			}
> @@ -1015,8 +1027,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   			break;
>   		case Opt_check_integrity_print_mask:
>   			ret = match_int(&args[0], &intarg);
> -			if (ret)
> +			if (ret) {
> +				btrfs_err(info,
> +				"unrecognized check_integrity_print_mask value %s",
> +					args[0].from);
>   				goto out;
> +			}
>   			info->check_integrity_print_mask = intarg;
>   			btrfs_info(info, "check_integrity_print_mask 0x%x",
>   				   info->check_integrity_print_mask);
> @@ -1031,13 +1047,15 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   			goto out;
>   #endif
>   		case Opt_fatal_errors:
> -			if (strcmp(args[0].from, "panic") == 0)
> +			if (strcmp(args[0].from, "panic") == 0) {
>   				btrfs_set_opt(info->mount_opt,
>   					      PANIC_ON_FATAL_ERROR);
> -			else if (strcmp(args[0].from, "bug") == 0)
> +			} else if (strcmp(args[0].from, "bug") == 0) {
>   				btrfs_clear_opt(info->mount_opt,
>   					      PANIC_ON_FATAL_ERROR);
> -			else {
> +			} else {
> +				btrfs_err(info, "unrecognized fatal_errors value %s",
> +					  args[0].from);
>   				ret = -EINVAL;
>   				goto out;
>   			}
> @@ -1045,8 +1063,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   		case Opt_commit_interval:
>   			intarg = 0;
>   			ret = match_int(&args[0], &intarg);
> -			if (ret)
> +			if (ret) {
> +				btrfs_err(info, "unrecognized commit_interval value %s",
> +					  args[0].from);
> +				ret = -EINVAL;
>   				goto out;
> +			}
>   			if (intarg == 0) {
>   				btrfs_info(info,
>   					   "using default commit interval %us",
> @@ -1060,8 +1082,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>   			break;
>   		case Opt_rescue:
>   			ret = parse_rescue_options(info, args[0].from);
> -			if (ret < 0)
> +			if (ret < 0) {
> +				btrfs_err(info, "unrecognized rescue value %s",
> +					  args[0].from);
>   				goto out;
> +			}
>   			break;
>   #ifdef CONFIG_BTRFS_DEBUG
>   		case Opt_fragment_all:

