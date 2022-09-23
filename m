Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9172E5E7AC9
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiIWMaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 08:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIWM3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 08:29:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AB313A3B1;
        Fri, 23 Sep 2022 05:26:31 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28N9c0w9000504;
        Fri, 23 Sep 2022 12:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=tRwGU9CQkuRkxlcRTOfcBwHunMblzwYUMZUGl9pFex4=;
 b=C6sqWFyP2CFfSSneyZlqUNclePJxkc0QZ8iYyElWJTuhrIlLqUTYD7Mwb31QmJGgHR9+
 uwS90bRzQn1+VxuIHxN+w+mkYUYA+RA3xVBXzzPMdB0OdnAYWWMSn4qVvj0fv2vrHY1I
 Td+WeZ7yAXhD4HFpFYF4IeF7Q6iP+C+Qf0MqhgU0mZZVrZsWDjGgLVbm0F+sX/HJDcPO
 hEr5/xHHquoRJFDK9Lu2VGXw6W87efCi9tclAnj/BNSmsAlljsW0L6nTZgszu9EZ26iA
 9n96YugsoDr9LAYqa0j/m13YzTwSkUy6oGQbBNllxArqPC7U7kUA98fGZ0FsbbtbGPPQ sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0qxsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 12:26:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28N9p4ru001911;
        Fri, 23 Sep 2022 12:26:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39tv2d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 12:26:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ki9K+LsX9MwNfVTlDTHvpQpd6ISNyQv85/CsTh5URaLy5lA9dxL5d79YwVzUCXwTG8p6uHIoU+91XVstnVY02hiLZV4qHTFq7t73/lPjPHsL9rfrTqKjXvlsVqX1+6d7wZnVspxNcfTmml7TQU/l38gBo0H0sNMAjcQAwhogYenIhGA5DlPJWqi8NOcEyrMSN7bhbwSjx3elF6v9cZXJiOGeYHnlVslCTw8Ty+2lW0AWmBA6zX0tteGoi9ePPZv1M+rydRnh0ZIHJvNBYLHH0TirzHRAw7eP4HgWJiB5yjb+J4D8kMBpgBrunbuuI1ExU2EjT9ifxgzJMrw8LkqhAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tRwGU9CQkuRkxlcRTOfcBwHunMblzwYUMZUGl9pFex4=;
 b=bozUrRYh2mx/KzCmFMWd2ZaZPG1DKQjuNjYMtBkM2uuHHXfNUrUv81TYdix5vdtZpDTbhLBFWCzFfSLkmI4T5jRda4eYwxKO9hhs7d51n/xnJy/jrOGjEBDMHMIrbdE416CqGKf73pQLA1NPdSpw/qCjXnQIpreKxEBK6K3NWoIGDwmDqtvIy45+BqC9e1wDvOqIGAbwhz6FGcxB1jzI07qBRH68HlirZSJFBa9Vym/G8ipwweR6Qdv+jIt1miKujssxBcYqTv0K/A4VYIxBwWAuXFjiQ985Z4sZ4F8OxA25DPQN/OxYv4oCTtXqcmJdOAvQ7/iijrElqf4+Q1PjIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRwGU9CQkuRkxlcRTOfcBwHunMblzwYUMZUGl9pFex4=;
 b=HGsMFYTn9Py9IgROynjuj41V0swRHm2gK3xfIXPhjXW0bPV25UnSDSgX5B/eW2wOnbjLxxiZoBAeHEqtaHG2og+aTodBpfw5GCZwisU7Gy+Je+uCSQCzTrmjrIAtRM9FkckdGHhcMgyUogz4JwDLNF6Ta7zgQWa1QvQr/hiapJg=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DS7PR10MB4879.namprd10.prod.outlook.com (2603:10b6:5:3b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 12:26:24 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::9034:820:1811:4ca0]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::9034:820:1811:4ca0%5]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 12:26:24 +0000
Message-ID: <4e99cb4a-b526-ae0f-e728-d4ddb13cf5de@oracle.com>
Date:   Fri, 23 Sep 2022 13:26:12 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
Subject: Re: [PATCH 5.10 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Content-Language: en-US
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Sean Christpherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20220922102236.810127-1-ovidiu.panait@windriver.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220922102236.810127-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:4:186::7) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|DS7PR10MB4879:EE_
X-MS-Office365-Filtering-Correlation-Id: 87297edd-876f-4d2a-7dae-08da9d5ed45e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o5FZqt3KoGjQoHtcToi0W7J79VnKOiYgkOzugx9UJsz/DNJpC9XLTs1aHDZWP/jvpkap2UW6SYgvsKvpADeAYzCstB/y/D0JIEXppnwn/+IoVWtjokTCjncl4KwYJrcJE1/WyuqEpEdXwj3mM4rrWDb9hb/N8RPKFogerGmz9hIOBMpfAIu3tBSyb0uD3YrWsVFkNpfAvnt4Wpiu9A7DBUIALwY6tSf5mioSBBM8RjeWwPu7lLdjVEnIWzg7uavGyFJbi5hRHiWaBnBym8Fz0d0yNPL0qbzfncVus4MRMqDHlEFUz7SE9IxMkJaTrEu4Ezn9H979kHEI4xQj82GqPMsaXv3DQrT4KuUeCuuMyQQR5f6JAg+Yc33ilKXw54ljZ1uBK6bhHNhzQGDygnOE6sSryRa74mQ+5am4QAMEPgTpTrwiyt/WE20SJbV94iWzbmrzOp5X4H7mxWc/M64BH2GBptX8YR4Yra+V6pj6KOdlV+zdcdkR/uvAA8mGLJJMqaSJ3gXEnTfixuw/WwN0dEH+E6EKdpUb72xJHlSJnKTfkiR/4QRYQscW9/iGCNJtFkdJR4arGLHu97YK8oheA056Bxt5lSAnhDwS2y+qVBkqQSyELtVttODwmsqL6WxT8BhOE+7wmPyLpe3vU4eA6Qg9kT+UsEkGSNXOPZvw2Od0h2mNxVK0SvlOQPVO0qj8Xl7SE3oEdkAdvA8lCAkar+AafTrXgtgBRLnyoMnNN2i8aHrVJcYz8S1tHSBegYnp5/7OHHAZY7G2DRpbUFeJNXZVPppcRa8JyVLNQawGMwM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199015)(6486002)(36756003)(6666004)(478600001)(66946007)(4326008)(66476007)(66556008)(8936002)(8676002)(54906003)(41300700001)(107886003)(316002)(2616005)(86362001)(31696002)(186003)(38100700002)(6512007)(6506007)(26005)(53546011)(83380400001)(2906002)(5660300002)(31686004)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlVEZEZXTTllcGZtLzl2SjBsT1k3MDdFTHhwSjFWUUwvK01tVlZlSEFpSFZD?=
 =?utf-8?B?am5ET1ZOREMzcDVGR3NNVnQwaGs2MUtxLzNoQ3B6cXpxUkNsV2taQUVmTHkw?=
 =?utf-8?B?OHQvQlY5RktlMkdhQVpIV25pbHlkdGNrcmVHbWliWGdZUWxjR0xldWE5RkdF?=
 =?utf-8?B?Z0x1Y3BRTTM5WERwUEVEaWVXbHZNRFAwc0tZSEFKRHlxbExaQlduTzhjckly?=
 =?utf-8?B?UkdrQktkU08wSUZ3TjA2b2txRllQN0NvWG41Mnc0eVhVdlArZXI0S2lHZC9F?=
 =?utf-8?B?L3hlajdkSSsrdGxJendkck5VMTlOdjBoREl2YmpvTHJURWJLdWduR3doVlVH?=
 =?utf-8?B?MUR6UDk3UlhKNkF0blpVb0piWmh2R2pEUzdBK2M4Mm9rUmMrdnZobXpXaFVl?=
 =?utf-8?B?SktuR3U3NWY2eVZjUVlSWXpKSndSN21POElDc1F2Tng0MEFOdkhRZHZlT3FG?=
 =?utf-8?B?TnovUVMvLzhxb2dWU1k5cjV6bWZDY0YvN1BBOTdZdHVFa1h0Z1hGWW9BMVBW?=
 =?utf-8?B?R24weFJPcFgyMzljeDh4UTVERDF4ZE9NemRjN2hURlhNb085WlNoWVJQMmFs?=
 =?utf-8?B?QjZvRVlWOWhFUWtoZ2Q5eVdDT1oxbHBQb1ltZkVqSjhKRC9TYWtRUkR5Nm1z?=
 =?utf-8?B?Z3FuenlsL2lkU3NoM3Z6T0VKT2NOWWUwL2c5M3ppbVBWOFkyd0JSWU1mTE96?=
 =?utf-8?B?NzUxbFlsT1g1cDBQSUFuQUVNaVVtOHcwSGFPRTR5M1lJWFRlWGtJWU5YNitB?=
 =?utf-8?B?cmxDR3VheFZDczh1T0JObEVMdEV3K2dkNlJrMWNrZ3JsMjRHMkZULy93SXRK?=
 =?utf-8?B?emVrRFNxUE1IaVg2ZEF3ZS9IakwydXVjUFZDRE1EczJ3Nkkxd3pBd0N2aWpJ?=
 =?utf-8?B?TURmY2lGRy9xZzRnTTdadE5IUlVkd01LUDNkN1d6M2pHUk1xTFExVjhSQ0J2?=
 =?utf-8?B?cm1URzdTRXBQNmFrS0l6ZWlEY1A2cUZSeXFZdzQxeFgreXFYSjl5UGxXSTdV?=
 =?utf-8?B?QVNsTFBkemx0dGlyS2QyUW9hMXBlb2ljSk5GYmFLR2RhN1lDTHVRMmZ4Yjhz?=
 =?utf-8?B?cmI0Tldyb3BvTTFFVEpmZEVoN0F6RzlJdlQzVlFiWHNxZXlueHJoMXFUOWpt?=
 =?utf-8?B?YWJ3V09ETXhjNTBPUit2dGsraHhMZ1l1cEdzZzAwSVdIQ0M2amw1cjFSbnhL?=
 =?utf-8?B?bk85UTdiVUFNUkdzalFZNy85VHdGQWxGa0hNeGpWZ3E0K2dXTHRuY1BmQkND?=
 =?utf-8?B?dnZBUDM4QU9wSmczR3hJNUhST2xNL2daZ1VFQnBhZGpSZFJUcHVlYUs3T05r?=
 =?utf-8?B?ZW5WTDkwM05mR3g3a2U1a2IrODFTeURBckpLUjdpT1FZU3dLUXY0bGwyd0s1?=
 =?utf-8?B?U0JZemxkSXcrRi9lWXVId3N4dThmZmhiekh0djRuVmJ1R2l1bnpJMU94dC9O?=
 =?utf-8?B?b2FZZko4NjZkakl3TE9PRVhUVW1qSnFYV1JrRWhSc2VpSFFLR0ZDaE1YM2dT?=
 =?utf-8?B?VmErZ3c3NlZramhZVzZBNmdGT01XUUhBWGF6T1JNNG5LT3p4SGZyalFiVUQw?=
 =?utf-8?B?V3lObDZqekJSazN4REhweDJzbyt2MWV0amFlQ2lsVWYvQytYWlBUSzRmVDFi?=
 =?utf-8?B?eUxwZUVtcGJjYU5TZlpXZFdzVE5OK0EzbW9sRjVVNXRJN0VPMzlpQWlPYnZl?=
 =?utf-8?B?alZqQ1l3b084WnFMZDdqbTdDcVB2NHQrMnNRTW8zQ1BaTG5aQ3daQkFmUFRn?=
 =?utf-8?B?Z3dBZWJZZEpSVmQrVjVVMWp0K3pHNVlhL1pOQks5TFZubVdQNUhQRHgveVVD?=
 =?utf-8?B?WG5GdHZLQmhpUUJ2Tk8xc0t1WWpVeHNnWTl6aVlSTzQzME4vTnNpL3RIaEtU?=
 =?utf-8?B?NDBKYkphdU8wNEdLTU41K1JZRGVxZGJRU1A2M3hJblNDblA3Rit0UzlxZG9r?=
 =?utf-8?B?YldXVkRGQWgxQnFKbmhoS2hwR1Zpak03M2NCZzd6OTRzbzN5Yjd0MWJ2dTBW?=
 =?utf-8?B?VERUcDZqMGkvVHVCWElGaW9QRXZpajYxTXl4ZHVhMHF5QXhUWFp3elFVL0VS?=
 =?utf-8?B?WmhRdVhrOVM4dUQvYlN3TThBaXUxZDhJVzhPRzVCeVdRSVdyajJ2U0lvK2s4?=
 =?utf-8?Q?OhqLtgVY7j3Ha7Ui2T4sMyoGt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87297edd-876f-4d2a-7dae-08da9d5ed45e
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 12:26:24.5559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2LY5A4KQA/ErBCMC/PBdyR33tWc3F2SM68U+kvk2MfTgGzG5wbNwwBdDEYfiCQWBmrE9kpR4oZjyG9poG2Ikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4879
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_04,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230080
X-Proofpoint-GUID: LIa5778aGvmJj9niBQqitAuFSvxH9DM9
X-Proofpoint-ORIG-GUID: LIa5778aGvmJj9niBQqitAuFSvxH9DM9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/09/2022 11:22, Ovidiu Panait wrote:
> From: Mingwei Zhang <mizhang@google.com>
> 
> commit 683412ccf61294d727ead4a73d97397396e69a6b upstream.
> 
> Flush the CPU caches when memory is reclaimed from an SEV guest (where
> reclaim also includes it being unmapped from KVM's memslots).  Due to lack
> of coherency for SEV encrypted memory, failure to flush results in silent
> data corruption if userspace is malicious/broken and doesn't ensure SEV
> guest memory is properly pinned and unpinned.
> 
> Cache coherency is not enforced across the VM boundary in SEV (AMD APM
> vol.2 Section 15.34.7). Confidential cachelines, generated by confidential
> VM guests have to be explicitly flushed on the host side. If a memory page
> containing dirty confidential cachelines was released by VM and reallocated
> to another user, the cachelines may corrupt the new user at a later time.
> 
> KVM takes a shortcut by assuming all confidential memory remain pinned
> until the end of VM lifetime. Therefore, KVM does not flush cache at
> mmu_notifier invalidation events. Because of this incorrect assumption and
> the lack of cache flushing, malicous userspace can crash the host kernel:
> creating a malicious VM and continuously allocates/releases unpinned
> confidential memory pages when the VM is running.
> 
> Add cache flush operations to mmu_notifier operations to ensure that any
> physical memory leaving the guest VM get flushed. In particular, hook
> mmu_notifier_invalidate_range_start and mmu_notifier_release events and
> flush cache accordingly. The hook after releasing the mmu lock to avoid
> contention with other vCPUs.
> 
> Cc: stable@vger.kernel.org
> Suggested-by: Sean Christpherson <seanjc@google.com>
> Reported-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Message-Id: <20220421031407.2516575-4-mizhang@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [OP: applied kvm_arch_guest_memory_reclaimed() calls in kvm_set_memslot() and
> kvm_mmu_notifier_invalidate_range_start();
> OP: adjusted kvm_arch_guest_memory_reclaimed() to not use static_call_cond()]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>


Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm/sev.c          |  8 ++++++++
>   arch/x86/kvm/svm/svm.c          |  1 +
>   arch/x86/kvm/svm/svm.h          |  2 ++
>   arch/x86/kvm/x86.c              |  6 ++++++
>   include/linux/kvm_host.h        |  2 ++
>   virt/kvm/kvm_main.c             | 16 ++++++++++++++--
>   7 files changed, 34 insertions(+), 2 deletions(-)
> 

