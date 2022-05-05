Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2431C51C403
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242635AbiEEPjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 11:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242689AbiEEPit (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 11:38:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A0158E74;
        Thu,  5 May 2022 08:35:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245DZdE9018740;
        Thu, 5 May 2022 15:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hTsGKl5x1QrbsakYvssPdtFLooUSIbsNJfE9c7snd1s=;
 b=jEnqZrTsihysu/LB6IEvowPAH2v8BN7U2fQxEPrcMO0oB+w7WcUvyjtBBd+iIGQO0D0Y
 Cd6MZ4UJASmCProQefFJt9Lxzmk/j1lH9Z9drJdlfSIzwhIWoUvugDtHCWdwq9Hq5cZQ
 LkDIBnQoT2eAHVZkhFwOst4JsWrWzyGOVRnimWsiwnZgXX7Cv1b7439LK1pS+pdpo8t8
 CuCT2hNVled187qFIKE2WCUpOZH5j0VlHwVqPq48jOPr9gCXpzkQUuG0JcUHqogocir8
 ri4uUYvgaWLEx9uI39Y3l4Hesjab3P8RqnMNhUDTppTzjgqLyK+A8AIaq+vMQHN2Ee0P mg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwntbth8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 15:34:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245FAm0l018812;
        Thu, 5 May 2022 15:34:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fus8y797w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 15:34:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEJc3yvL40tTJFIaZ+hmvFC+oLPcbxPfj0tJjZJjJsL5Dm0XZlGgePC/SrbbUzM5am1Co8ze/wepb65kZYtQQhNBJKkLiPsGv2P3ah9CASuTIoSfOoVBV/eRsD5mUWjp1XjxFXB1CfoG4Svyj7DHqyL4qAWm7fJltJPL6UrGqZR3Zmd4MDR6D4yH03+MU1a2iBf+zoiSFljhxzCtC8JAJ1m+3uH8b1JFB8AsOXfPrp46AFbjnsXHqPpEOps2kTLm8WGY5lxGcjBXIbGMtEFbnCE6OqtWHCvCCcUdoneB1rq2HRLoiiqmE0LaoN2Esj1X7ZASibNWni6XPanrYRbPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTsGKl5x1QrbsakYvssPdtFLooUSIbsNJfE9c7snd1s=;
 b=NWjI0Qa6MkG87DV/05vUph2/TGC1FEI73uXByCy6Ru4r0lTo7BoRLQITI0zJa9DUQRjB93Grj5fC4Xr3huuVJVz8kMA43n4Oxpjou5OMdtbCT27IQ+U2bLPbEW896/fc8qciLEWG4VCmzy1vy2j8ZWfRsoMm8s4Wd6S/yl3uYylqpy2K6AzrmxbHDqRB9lfyfy9oCBgxiNyU9blJoMWXJ2NNpcNukrpqGP6nNKw+Uhb96EIpWnsnJFYn7IUN8W1xa5dTpzUrKLLOxXz9pK+PEDdUKvcJBp9RlyyDcZoSaUWJ24jDH5dHUNPrCTq48UuCvma2QM/LAR7W2ksiZLJRdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTsGKl5x1QrbsakYvssPdtFLooUSIbsNJfE9c7snd1s=;
 b=ZOagZ+809ZEXUXD4lgaJ9dpYWPSXdhxPc0crVXhEqLHnMR27gUkkC88nddGxuU1TBtKRBmgkpWLMJiMw4mQnj+BPF8FSXWxVzA6372C7zCUvIcWCw4GCHVEBDJDnlpN9PEuRBKslyuL0FnQC0COVbNVeQiOk0pe0Gopb1k/mnXQ=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SN4PR10MB5654.namprd10.prod.outlook.com (2603:10b6:806:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 15:34:55 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47:2730:1cb1:bd51]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47:2730:1cb1:bd51%4]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 15:34:55 +0000
Message-ID: <c20cc64b-d622-ebe7-2a54-9f5e291d988f@oracle.com>
Date:   Thu, 5 May 2022 17:34:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.4] ACPICA: Always create namespace nodes using
 acpi_ns_create_node()
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org, rafael@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <YnPmDlf3KD9ckpM1@zx2c4.com>
 <20220505150140.159449-1-Jason@zx2c4.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
In-Reply-To: <20220505150140.159449-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0191.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::35) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5432ae5-4507-4969-96ad-08da2eaccdc1
X-MS-TrafficTypeDiagnostic: SN4PR10MB5654:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB5654593EB950BF50472963DF97C29@SN4PR10MB5654.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dS/fba/wVI14KtuzqgnyX3T6d5Y7dLhy42heZOxfdY83hDAkKH9fEd+SXZuBlu6LANsvS4qv4XEZKD79HYXk41X69RFf/zjRKTNg5fPGR3rn9fYxc0HGj8c7c2UE8xbdioxDArB7QkQ4t1rwimX1ybFugfEYNZnmsiQDkq/0HK0dRVOseK9l4jXHrJdHhxp3h0wcN3fdyaxYYkL/VCj2xSgUWHhxVKiaNSwDnmPAVzo1iAzW6bbMaixxmWVPwZaJiNMgzjU4GMPuUXC0fBdaJnYzu2g1aB++rI9Zqp4lhDKZ5DxePzpebA+gpwqCvqOc9L44wQ7MLTA46owZbbu/9j7phYIiWnJ3smrotQwhCTaK8HGe9zIQeHNRfc/eYet5RHElvJ8APV4WknvID6oV6W/fMJtbu174OS/jlVZrqRDH/GAUwlwR41ffrO6PlalwdE/CQ7nZK2B1Sl85IgwHvHST48UMgx4oxxRlJK/g0urDTu7QBb+SyMdGNYJBkj0vJEfPADaIFzFAfpPXlOglIVGRgoLga2/nCjxZ6y5B2x7zF0pkfhwODFlIwJtIklnDn5uujF1/+f2E1Hnp0OiYQZbWw3N3JX0V0llADCMMgmPh5wBczrG7z7qVRusELQ/H0yWk3V1aJstkH/Q/mgPGrDNasXUUeLbeKEZ+vzGVYkyVdUlJrUeQ0318F+hyhCu/zq/YdrT5mv88N77ThkgrMYB01nxiukHJKhGEfsGBKK/UY+syYfNK3gGeIhamhGm+4gOwPcNxjIYgLy9MzEOai0mM9chgZIObJwS+V38ztpb64nEu31wlt6zBdPVNCgzWKzsFDGtD0rPmrF30lf2nQcovO4AjSJ9EN85es18R4FQDDETQqVJzUZ2rnbbrZdLeV9kd90GT5FWgqwwWpEALNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38350700002)(66476007)(6486002)(5660300002)(966005)(2616005)(66556008)(38100700002)(7416002)(508600001)(31696002)(8676002)(53546011)(4326008)(26005)(86362001)(6512007)(6506007)(316002)(54906003)(52116002)(6666004)(66946007)(186003)(31686004)(36756003)(2906002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OG92a1IyQTFQTGxQWGJCdkk4YkJPUDVoZzVDNmdJWm1NWkVTOUp4NFVza1lE?=
 =?utf-8?B?QXdXYnZ0TXkvQ1pZRG93cFJxVjhyUE5qYnpuRlpyb01xMjBvSENhTDcxRmpF?=
 =?utf-8?B?UkNkeE02bUVHcDZtUCt5cmNCblQ5MW1ReGhGYk5ud2VRNjlKeHBFT0dqNkNB?=
 =?utf-8?B?Zm4yWmRCL2ZMQlZhMThoT1A3UXJUTE94REl2WHNiV2FlNG1Sam9mcVYxWjJD?=
 =?utf-8?B?NE9NTFhHMi9tcVh5aWp1RXVhc3ZYMEFEZnBlQU03MWlqbVVnRG9nVjNhdmRu?=
 =?utf-8?B?eFdEUVlaUkpNYWdzemlGU252S3huMStOT1RCMUNVQWxrUDM5YXhzMHJnUnpj?=
 =?utf-8?B?R1A0UFI2ZEJWcnpSNm1NZjNXaXVRdHhUeXF6dVNqM1I5Y0NQby9sV3ZSc3Vz?=
 =?utf-8?B?ckpPOXJsVERTVHdXMWw1aHhEcEhYSElobVJYaG5wVE54dUNteFU4WDRpcm1P?=
 =?utf-8?B?WVo4YVVZczBOTDdnMC9yWFZlbnN6L1RVMWpqTTVoOEFsV3hKd253OWZKSy9B?=
 =?utf-8?B?b3lzU1hwbEw2Vmc3SFhxSkZnU2dvNmo0R21nYW51c1BPVlE4V0xFVW5TNDVI?=
 =?utf-8?B?d3NDZXpJeEtFU01ZUmtBQUthTTlaU2kzRTZnMWYrbm5iN2ZKMUhvYU9ZeFZS?=
 =?utf-8?B?ODZ0blkxUXo0Wk5tc0pQd3hDbDdmNy9yRFVsc0VlOENsYVNSOXM5VVh4RTZU?=
 =?utf-8?B?UDFTS2NpWmh3ZjFxWW92bVZUQVJVRkZ4aWpxdmhTemVXOWt6NVdnd1diaS80?=
 =?utf-8?B?M3R5MmpGRS8xRk5HZGF5UlpuUHZPVGRNMDV4WmRIK01NSzd2WU4ybFFhVkMw?=
 =?utf-8?B?QjFPSHhZTFZmNmR5eXJra3M4Z0N1aXlZVGdLVkUwdkcvckdUVkZHK1VBRFBI?=
 =?utf-8?B?U1RFZEwwOUtQZGxpdmZjeU1SYXp3UXZ1VFYydnhBZDIwOVpPclFsT3p2SExJ?=
 =?utf-8?B?T25XdGVMcERoTFZkMFF4eUIyMWtxODNsY2VBQ2duZ2FZSkxlZjh5NnJ4ZjhB?=
 =?utf-8?B?S1RYWnpPVlhuUDRpUW14WDgvKzZ4R1pKZHlraGVUelZucTk0YjhKVE9VajN1?=
 =?utf-8?B?WlN4MXdaL3RNZGlkNGdVVk1hQXE0eDJPcGdDRFNlWGk4NE1xeVA1MU91UXJ5?=
 =?utf-8?B?VE5ydGN1OFpvZmlYQnRrTXZuTmdsRVFwWkF0STZxeTR5b0duMVp5amtEMnA4?=
 =?utf-8?B?RlI1UGFjUGNLYlNibXpOb3BMU3pxR1AyTGV3WCttUXh4OGhjSHhWeWUxQkxP?=
 =?utf-8?B?N05PWXlnYm10UWdjYk1JVVo1SlJqa2lMTnlGY096c2VPQUhVMTF2WldLdTh2?=
 =?utf-8?B?dk9ZeVdhazNaMWxVdGJzUlRMaEZMdVNvVnk1NGxDeTZpanh1OWFEV3luQ090?=
 =?utf-8?B?QmJjaXpSS01GK1JoNVJDeXQrd2d1N3RMMS85eFhRZDg4aTdCSkN0bGxBTGE1?=
 =?utf-8?B?bWJzK09pQTl1YXVxUVVSOE5xRGtuQldqdzdzY1FGTDZjUzd1cUo2dnhWenh3?=
 =?utf-8?B?SkxPTXhDWUkyRUtKQ0tTMkdYbTk0S3loS0R1U3FSaDU4eHhIOGYwRGs1Qmcw?=
 =?utf-8?B?Z0pXWjRlenBDTnh0RDQxeS9jYVJVYUwvcjYzVHVhNHFJRDQxOThLZ0JTeTJ3?=
 =?utf-8?B?cDRZaGhrWUVoRkVXWXJHZXpxbkZaVWhjaEJkQi9JUTl6d3h6ODRCUDg1WjNS?=
 =?utf-8?B?bHM4Rjc1RmxwbzRMWGZsMjErWHRSSW5taEIvN01kdW40eU14VjF4WTJwMU5q?=
 =?utf-8?B?NlNZS1AxQk1XMXhxc2Z5WUIwYW1wZHpSWEt0ZTZqRlB0ZndBOVpTL3hyZXhZ?=
 =?utf-8?B?T3Jsby8xR2xQdGI3QjVJbUxXUDRXWVFEUTVNcUpMZ3RxK2xOR0VMQ1QxVldB?=
 =?utf-8?B?YzZMZkxrWnBzcmthd3VwanJ1OVNTWVRVMlB3Z01ZSHFGdW5qNVdqd2VQUGF5?=
 =?utf-8?B?dTl2TnZqc3RzS3dpeDFIL3Vyb0xFV3VoZFhpWjd6Nmx3ZExBckRWdWJBZHJ2?=
 =?utf-8?B?VXVyNTVBMjdEakpvMkVUbERUOHFrZ0lwbXRKN1VKOW1mK29OK1FyL3VYOWdy?=
 =?utf-8?B?UXFTeGtjSlQxWW5IMHVZVHBzYzhORW93UjQwMXAyRW9sanZDRWVYZzR0Uy9n?=
 =?utf-8?B?WkxUUnJZMldWT2FSZUF4TXlhZ00rMXRRY3JTa2hsbklGSVFFSkI3M0l6RWFm?=
 =?utf-8?B?K3pHWjlHN3NLdGJZVi9xcHRpYjd3RnFWRUlJYnJ6clN1Mm9DM0UrTEltWXZL?=
 =?utf-8?B?dzkybWRpSDBhUDNlRURWOWV4dCtkWGpyd1U1QmUrU3BzcUtEY1hzQzBqTzh1?=
 =?utf-8?B?OEE0RWhOYmtWYm1NaGdKeHhoWmE1dWQzR3hCTFNSMEYxRUZ5MHpvMk5IUlBG?=
 =?utf-8?Q?kbA3HuboKvEmSz0Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5432ae5-4507-4969-96ad-08da2eaccdc1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 15:34:55.1989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZnD5mJtN0Z3Z5VIvj5gRzP0aLN/HsjT/HMluZZ+dBqN4GeIm3s0PFMc7DWKQPajKVv4qQWhuhOVi7W0XZUbgUudw+lCB60EJmh6zR34vi/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5654
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_06:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050110
X-Proofpoint-ORIG-GUID: k4ppbnzaHnv7ehgyqEfkfkSjk1UWDsnu
X-Proofpoint-GUID: k4ppbnzaHnv7ehgyqEfkfkSjk1UWDsnu
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/5/22 17:01, Jason A. Donenfeld wrote:
> From: Vegard Nossum <vegard.nossum@oracle.com>
> 
> commit 25928deeb1e4e2cdae1dccff349320c6841eb5f8 upstream.
> 
> ACPICA commit 29da9a2a3f5b2c60420893e5c6309a0586d7a329
> 
> ACPI is allocating an object using kmalloc(), but then frees it
> using kmem_cache_free(<"Acpi-Namespace" kmem_cache>).
> 

[...]

> Link: https://lore.kernel.org/lkml/4dc93ff8-f86e-f4c9-ebeb-6d3153a78d03@oracle.com/
> Link: https://lore.kernel.org/r/a1461e21-c744-767d-6dfc-6641fd3e3ce2@siemens.com
> Link: https://github.com/acpica/acpica/commit/29da9a2a
> Fixes: f79c8e4136ea ("ACPICA: Namespace: simplify creation of the initial/default namespace")
> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> Diagnosed-by: Vlastimil Babka <vbabka@suse.cz>
> Diagnosed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Erik Kaneda <erik.kaneda@intel.com>
> Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> Greg/Rafael - tihs was marked as 5.10, but 5.4 crashes without it. So
> maybe it was mistagged? Will let you guys decide. -Jason

If I look up the Fixes: commit I get:

$ git name-rev f79c8e4136eac37255ead8875593ae33a2c16d20
f79c8e4136eac37255ead8875593ae33a2c16d20 tags/linus/v5.3-rc1~166^2~1^2~4

so it looks like the buggy commit actually went into v5.3.

I think maybe the bug was there since v5.3 but it was merely exposed by
some unrelated SLUB change that went in later, maybe that's where the
version number confusion came from, see
<https://lore.kernel.org/lkml/ce333dcb-2b2c-3e1f-2a7e-02a7819b1db4@suse.cz/>
as well. The commit I had bisected to it was:

$ git name-rev --refs='v5.*' 67a72420a326b45514deb3f212085fb2cd1595b5
67a72420a326b45514deb3f212085fb2cd1595b5 linus/v5.4-rc1~141^2~2^2~7

But as Vlastimil Babka pointed out, the bug is sensitive to slab merging.

Anyway, thanks for spotting that.


Vegard
