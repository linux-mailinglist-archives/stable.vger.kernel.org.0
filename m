Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB5B63297E
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 17:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiKUQcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 11:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiKUQbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 11:31:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE9CC72C5;
        Mon, 21 Nov 2022 08:31:50 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALGAO7g008497;
        Mon, 21 Nov 2022 16:31:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=I2jcbG4diNXHMQuzgwXVrsMSyvVyPJfUsXywr8iFVHM=;
 b=S0s1KNgkiH97WuqCHATC3eI2LLJYsHNdZPXyblcTxjVj6NTiiPjuBw7eae04u7Ccmq0U
 b8U/V7H71H9l+9p9K4KAuqabb1v5qZF0rhT9X7dTrhjYLQ7ooeMDfsYHp1Zjnt4dct0Z
 jGYiu3SDeWXXuDY5lr4Hs+abT923DQjJOc8zpENjZ7+uD+YLZWfkbfnLJyv5BvVS+ZP6
 WEiNJBu52zayCV8foKaHRcJBLhdzkuEv0kW/DBW8NRFAzN2ndNg0liM1JPP8ZrmjttVV
 yrjkDr19OLuXIrWFvXrQo9S0xvrgQEzrdJmhI+46I4oblU2WNh2SuLJ9L0Ig4opviRvO Wg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0cm1g2fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:31:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALFaaD8002229;
        Mon, 21 Nov 2022 16:31:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkaqp5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:31:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1GbTmNRQuxF+QEZofbZB5h9p0ImlIxXwTP4E0WPkESLWcLhtEqjlesY2lDvF1jQYVrzE23oS68aqZ+92OdU/Ig28nQHlWLZyrca72vgXRoWlJcbsuSm2iblLQxXcS2RDH5q4joNtfY7WYN04K04sxSNiU0G3IAVAn5RhWGYPBYvkkK0y5cwVatdmi+p+z93eZ0DdopNhnwI74Ab4cACUKApUpeEZzM5qbzN8hKgMuM/8lnlvZMieFQJ3uYvoDsn5OYorHWDHeOpTz0uRWkO9FAFGpxbfIjkcL3R78bknEdorOrFHih+jYDHRFPzxw3IKo2i6wSXIctZ5fNUzutitQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I2jcbG4diNXHMQuzgwXVrsMSyvVyPJfUsXywr8iFVHM=;
 b=DVWpQwuqPRBCHicopC7ErI7WhcrW+RnSobEQ1DCYNIMura6x1slEaHT/govyBqoskd++9+Wxo1dqlM2Ar3xuVZyrozAeybQ2kWbZiWErZGPACQF1R4rMO7f7BFY3XtabidwJQQudL7y+JI0LA5t8NLMlD9UvP4chWuPMmZW+6WHtDwVHWGLCZR4V1k322gQ7639jFoWaGdts0sjT11NphfRXzkwTjF3neu5QWnTZS42eHT8ThcUeGlgpxP7cnR6hGYnL7rKNxUNvHhCWPIX7+SGCT+zgfhAb1G+ZbKaQ1eQ2BpQC+TJfq2UD9eZtof+Wk30MacqAV2NSi9VkNoB4FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2jcbG4diNXHMQuzgwXVrsMSyvVyPJfUsXywr8iFVHM=;
 b=DzR6lZoYU3ki1V5bQD9i7ZQF74XjqXH5xB2L/JWM/Cf+lJuS+yh8AFK0adhtBOlVkB7X9TMHhjlpEQsfXSunZ1f7sKOJag5c9LNYLrZH01z2YVmnmbSMUR2ZN/qFO0c6XIku7FOI9MR5HENmM7mCHBT0ligm5DRUUJmmoud14mM=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SA2PR10MB4619.namprd10.prod.outlook.com (2603:10b6:806:11e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 16:31:13 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::c13d:dad:6a35:b25a%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 16:31:13 +0000
Message-ID: <d57ad4d4-db52-9e50-dd9d-667f9fc24625@oracle.com>
Date:   Mon, 21 Nov 2022 16:31:06 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
From:   Liam Merwick <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 3/9] KVM: x86: add kvm_leave_nested
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Colton Lewis <coltonlewis@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org,
        Liam Merwick <liam.merwick@oracle.com>
References: <20221103141351.50662-1-mlevitsk@redhat.com>
 <20221103141351.50662-4-mlevitsk@redhat.com>
Content-Language: en-US
In-Reply-To: <20221103141351.50662-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0025.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::18) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|SA2PR10MB4619:EE_
X-MS-Office365-Filtering-Correlation-Id: d55aa39c-6fb6-4cb5-ac33-08dacbddce31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3lfwjZY+qQt7xLiWby2HxLNk1r0gk6u8J4Kwju2eDG2jvho8TXxQkUC8rH9Krwrv892gJHvbGcksAC/xc+E+/iGjwefMPgOz3Y/shsKT2VC+bCx0HcBxEc5EmAQm+ISz9CI7GHrY5ByY7tVLqTQLCus1AWAqCjzA6eCQzyEHkPOYTrZ7GSuIiwqhJ796HCYVgVKgLTzqqOkM+cH82sHk0YJX+D02Ldjlzanqt3PoLyYZ5gQ4bSTceKGfowQP6aq+biy5ckPY9VQVa4EsOkysKNSs6znbcrFYSm4wy3cPCmV+DQlSrFrAqyrnjaa71fZRr+8qIZkSnLJXyqzPoVAK8bTe1IWJzHzuzRzPJHmfc2V0j/c3TBz/XBAomXYP1A+6FZgPPnGDTdjZ2zrisQLUVwPybzckbMOHuYXY+x/tOejAfUbaUbm1QdXfsePfVSOUmZbSs00Fztn5kgz/v9TOyvuFnZ2ipvhAu8RPlALLlduJMcxqi7bDgYTHBDban5kq3eFwHi72RDK2GO8NTDJ8FtjS2PnyfuDAJ47qW6Q+LEWxlOFgf+JvJC9ygPJ9HfQUujc0ZsJok5R+NQw/Lru2+ZdYblw/MnDc3lGuhOa316HYm6Att5uH6KHoMCexw8NSH3PnLnzX0sVx+KS8IY6mvvGjGy7ImhHHg9xqkfQeY6afzFcsS0NQvEHGXDqtIoU9mAeSZdexlt/Y9/DzA6TENZe/+IeTygPkW5y9PxcOoCo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(83380400001)(31686004)(6486002)(36756003)(8936002)(5660300002)(2616005)(7416002)(86362001)(31696002)(38100700002)(478600001)(6512007)(26005)(41300700001)(44832011)(2906002)(186003)(6506007)(66476007)(4326008)(66556008)(8676002)(66946007)(316002)(107886003)(6666004)(54906003)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUtZemxjQXhBZCtBVWdFQ0VCM1NRdzFUc1F2QzRROFh3N3U3RXdDWDdPS2V6?=
 =?utf-8?B?SXBFRWp4amtWM3BnQVFzTlduZjJ2MGdHSWpIZnhuVjUwR2dzbWxGWW5obytV?=
 =?utf-8?B?c29nYkJWZ256cHB1N25CRnVKeDJRZUM2L3hlajBtak5YRnlHRldmZ1hPNlYv?=
 =?utf-8?B?U0lGcmZoZEtsQS9lQnhMV0dyNkJsOEJ1OEhNb3lFS0hFRzYyZGJhMlFWd0pC?=
 =?utf-8?B?YjdnOWtMVXdja0pubjVmR01WbnYvS0lxVTdQVFB4enhZZnFGTUphUEJHWHp5?=
 =?utf-8?B?V05UcW5OQ2FwYThYQ3Z2cm5Zd2N0eUc2ZlEycmQyTDMxa0s5YU1KTXhWQ0Z3?=
 =?utf-8?B?Q3hSc3FSYVA2MSsrbnkxcGNhd0puVjdMckQySENuUExZTjRYMkhUL0toNDlW?=
 =?utf-8?B?NVhxOFRIa2lKKzRZMEJtellzRk9Rd0NCUVNwdW9QdFAzVDNWY3Arc3VReFRm?=
 =?utf-8?B?dTA4T05MN1ErdkIwQ1lKS1NkZ09xenNIcHpJNENEcDJPRTFmNHhscGpIdmx3?=
 =?utf-8?B?MlZQaWhnLzRqT3Nnbm5BUWZLWm0yL2FTLzBCS1FpUFZHSUlNdk04dUFiZE4w?=
 =?utf-8?B?L0thZ3VUK0o4ZzlWaklHb28rL0E4QkFGbzdoQk1TYThxY1BJaUNyN3BQd0h3?=
 =?utf-8?B?dVVTZC9PL2VUTnd1UkZxenczL1hEWGVMWWk0V2FRR0ttaHFMMEhTVWVHNVgr?=
 =?utf-8?B?TC85ZDdSak40WFVaN1JuUmhEbDhXanNGM0lNZFZGZStsNlN3OFZlbVlBcDh2?=
 =?utf-8?B?b3YyWCtwZ1l4Y3pNclN6b0tHVDNxRGtKcFNlenAzMDBVV1N6aGtuZmprN3Br?=
 =?utf-8?B?OXZHL3N6OXBqcTBxbE1LdlZZSEIwWnNRbFNXelgxalNna3JUKzVvU2E1dFd4?=
 =?utf-8?B?SGJLeFFiVVZweWhaK1dkaEpzT3VEV09VaW56SGg2N3djWVgzMG92eFc4VmR4?=
 =?utf-8?B?S3dzLys0L25BR0FpUmE3NWc3OVhqenU1SlIrR0dIRGtObnJWSmNKVHBvRlVU?=
 =?utf-8?B?RVpybS8xSm44NFgyVUNHa0JrbXlMODFCdkh6ZGhzUkd4VWlkbVNQQzBtMVls?=
 =?utf-8?B?Y21lOW5JcE84eXE4VUlSc2oraXJvOVVML3UydTI1VWJtbDNRZW5oQm9XSDZ4?=
 =?utf-8?B?TkFaT1J6aDIrVnJOckRCMzBBb0VzM1NXck5LV0lTUDcyU0E4UnhVUHBnTG5F?=
 =?utf-8?B?cG1lUEtwVVpMQjdoNmVCVmlIdmd2b3NnSExja3FzbjNZWHZSQUZYWnpIZFMw?=
 =?utf-8?B?UnQ1dWs4bHBmV1E5YWlYaTkrOTlQUDVKcEJVZDUwbkVBay9pUTU0cTV6azd2?=
 =?utf-8?B?YSttNFZnUGRwSnFhblNJc0hpd1pzWEZaT215M2txcm1ZMktsQVlEL3pMSW9q?=
 =?utf-8?B?c0xJQlhvcmRiRzJoWVVBTG54V3YrK29uanRyTHZRRVJOOG04bHNFS0RVd1pE?=
 =?utf-8?B?bFl5cHJ0NHZhZHpVRzBwSnUrL0o0ZDhYTkhCVWYwYWlncGZva0RDNUxTcnlI?=
 =?utf-8?B?Wi9rOTQ5cHFZa2Z3dkJQNEM0K3VaOVRoU2w0OWZSY09YZDU5ODJJMXkxNTRN?=
 =?utf-8?B?NVg1NVZFSnNtcitUanpFOTNkeW9pbmxmQ0JuTFREY1lXVVoveWFWUm9DaXpO?=
 =?utf-8?B?T0RxOHVwRWFZQ2NJamdBcU1KK2luME43WGUvTTNXQkxLOEFVenVOMGdVNGlM?=
 =?utf-8?B?REJRQ1hyK0V2cUw5M0F3Vjg4a0xDM3dtVU5ydmNydWNaWVBFaDRlSkc4Tnlr?=
 =?utf-8?B?bjA0NVA0ankrb21MUHovUVpFYlh1S1c2ZTI2U29KbVovR05UbkkzYXJMNEVM?=
 =?utf-8?B?cW9TOGJlWDNjcTduTGlXOWx6aExXdlJkRnlLclYraFE3M0NlbTZZQ09vMmNk?=
 =?utf-8?B?QU4wZXZRbHcyZzh6Umt0NVl0RUlXZVhzaElWQ0NHTjh2U0tZaUpqOHpRblVF?=
 =?utf-8?B?ZGtRZ2tDaVd6dnhCUHV1Vkw2eUE2WnN3SENmSXdFVWlLUFF3QUZFSDdBQ3ZM?=
 =?utf-8?B?aW9qdzNOK0F4bjNuajZIN0xrVmtvR2RKTDVETFFmejUvR3RndS84Tk8renFW?=
 =?utf-8?B?TXlFcWRhZkZacHlmc2xJZU03aUM0Qi9qZTU3eW9ILzdmWWZXTjlKeTBEb1l3?=
 =?utf-8?Q?1qiksCt2vJQfD/S+0bTQr1ayR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TDNIQ01nMXduOGFZRlZ2NkRYZmlVLzdNbHdyMEtQN1FzamtNWm1qbXovaXdB?=
 =?utf-8?B?SHIwVXFBb3JUZUYwRSs1WDE5VTJ3d2tvTDkrRVVpTVNkQTVNNzI1UnhwWjRk?=
 =?utf-8?B?c3QzYW8zd3UyQ0prWW1LWDBrTFFIeXhFaWNTUVI4TVFWRGtvbE9QMytvQy9y?=
 =?utf-8?B?aXNQVzlIVlg1ZUpPaXhVMkJtWmdHcUNLNHNnQXRqa0FkZk5zbjdzSVV6NTZP?=
 =?utf-8?B?eUpHVVBTMnNxZWRMZVFxNHIrbXZMelRWR3V1cW5CdS9aVjUyQUpJdHZYVTJn?=
 =?utf-8?B?NGNia3VWUk5MR29YYXdCQit2QWVnV3drbGdRNVZYSlpPeEtyN2NobjJNQXlM?=
 =?utf-8?B?aE9iL2ZDVTNvZHFQVmM4Q3l6UnVhME5KUW9WdHVXbGVQb2paSE5HY0sxS1dP?=
 =?utf-8?B?WGF3VGZldFdMMXRwZHdMVVRaUFNZcnVsT1h5UW9lUU5FL2JlNXFhMlBYWEJK?=
 =?utf-8?B?Z0tIOUR1K2ZkWDhPaEs3VlFYVWpxRkhPcUFkMkhnc1BuaFZuQzlsNC9iVk42?=
 =?utf-8?B?VHdIb04yUEpIQjdqNWxidE1pNmc5dnkrcmNZR2RBYzJWR0pDZ0JlZVlYLy8z?=
 =?utf-8?B?em5IdVBxT1hCc2NJM1hmUzBlTUk4U0pRZWM4SS95b0t1Y3NOZmxFb0R1TzJz?=
 =?utf-8?B?QUg0bmxsN1JVMnlLMXh2bTErYU43MjVleDhkYWhMVlpINTZ2ckZPTDFrdmhI?=
 =?utf-8?B?K3BPRkJwSkV2YUs2UjRRMHl0Z2RSTFFYMEV1NG1nYi9uN2x5SHJ6WkRKL0cy?=
 =?utf-8?B?SXB0MExRZ21JZ01GWjdDQkNDU01lcVlkS0pzUGtORy8ra0s1ZEtYcm5GWFMr?=
 =?utf-8?B?b1g3MmRzdGJtVHM4dGdraWVERjNRL25Uam5UQk5jYWdqU3JlLzJ1M1Izcmtl?=
 =?utf-8?B?MWc1bW9nUElNTllOdnhZRHgySXM3YlRyZjRITEZSRit1bzgwV0d0eFQzeFhl?=
 =?utf-8?B?WEJuQ2RTVFo3clNxN3dyUlpDclMwS1lwOUcrYVBwSHNzaGE2TTFRcmF3ZThj?=
 =?utf-8?B?K2J5bXlZa2UvMHZydEhHL1E4NG1iUHhwbDZzTENjVVhnM1JvNURKVFJCMk5K?=
 =?utf-8?B?a0ZHSXhVL0drL05KZVB6NmVjbXlQZW9KcHlZVHhnRm5pTmJLUDM2bUZXdWlR?=
 =?utf-8?B?VDRjZmNIemxhLytZTmVDejFVazFWaUNNdjNsL1ZrSEVHTXNsUitPNklFelEy?=
 =?utf-8?B?TWpHSDdFZW9KbU5pNVBQN0VTQk5lOFBVZlRKNzMvajhTMlNmZS9pdDg5cDkr?=
 =?utf-8?B?KzZQcjVrUEJ3WUhmSVExY2hGWGFXaWNCbURWZ1BaaGwwOU5tcGhPZHpGUDY4?=
 =?utf-8?B?RSt1Q0FKaVU2UnlhK2hPMncvVDA4YW1rbGFvSGpvZUw5ZkJib3M1NWx2eG02?=
 =?utf-8?B?OFRnd3dabmVYNm4yNUpYT2RqSXh0Y09udk81ak5ZandNaWxrRVdpbXljbjg1?=
 =?utf-8?B?d0lORmErdmlrWjhMVk9LUnVpb0UvZ09uaXNieTBQVzNVSGpEek5kZzV1V284?=
 =?utf-8?B?bzF0YU5ZR2hhZkRQRktzc3FGN1lVSmNLdTRTV2FycWxvQ0NxZ21KTDUzK2Nj?=
 =?utf-8?B?ZDdSYmxhTDFjZ3NkZmNPdWp0MnhZVk15S0cxcUVyR2tnTXRkbml3V0ozMUs3?=
 =?utf-8?B?WWIycmVQdmxpRnM5Q1dqZEZRUVRRSzhhZlVkcW5LQTEzSTFsblR0dDNJckNz?=
 =?utf-8?B?aGhiUzdoamFWNm02eXFNZUJ1Y2E2QUVxWUNBd0VHTzVNR3ZBVVU5cHZ2bklo?=
 =?utf-8?B?NUNSbFFyRGxHd0xyMWRaR1NUSVZUVlRjSURlL3Y4N0JmZzhxZ28wYlRkY1Fw?=
 =?utf-8?B?ZGJIbXFQVGRHSlI3Z2hNb0gvNjQ0WW5BMi9JMVlzV0xQNEpIWWxJN0pwZlhk?=
 =?utf-8?B?K1V6M2NVRUI5RnJYSG5pajFiWm1QUmNzR2xlVnppcVhaNUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55aa39c-6fb6-4cb5-ac33-08dacbddce31
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 16:31:13.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDXQp3S+XVvffy2P72LL2nEbZstSet4xvnHzBQ9cUtWJbNfVSfgjmkTHBB3G4NrtxBIrcXPOnu4YOunEckmzBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4619
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_14,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210127
X-Proofpoint-ORIG-GUID: noHbKcjHqiFgH5tOcX-qssKehZescJfv
X-Proofpoint-GUID: noHbKcjHqiFgH5tOcX-qssKehZescJfv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/11/2022 14:13, Maxim Levitsky wrote:
> add kvm_leave_nested which wraps a call to nested_ops->leave_nested
> into a function.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   arch/x86/kvm/svm/nested.c | 3 ---
>   arch/x86/kvm/vmx/nested.c | 3 ---
>   arch/x86/kvm/x86.c        | 8 +++++++-
>   3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index b74da40c1fc40c..bcc4f6620f8aec 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1147,9 +1147,6 @@ void svm_free_nested(struct vcpu_svm *svm)
>   	svm->nested.initialized = false;
>   }
>   
> -/*
> - * Forcibly leave nested mode in order to be able to reset the VCPU later on.
> - */
>   void svm_leave_nested(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 61a2e551640a08..1ebe141a0a015f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6441,9 +6441,6 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>   	return kvm_state.size;
>   }
>   
> -/*
> - * Forcibly leave nested mode in order to be able to reset the VCPU later on.
> - */
>   void vmx_leave_nested(struct kvm_vcpu *vcpu)
>   {
>   	if (is_guest_mode(vcpu)) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cd9eb13e2ed7fc..316ab1d5317f92 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -627,6 +627,12 @@ static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vecto
>   	ex->payload = payload;
>   }
>   
> +/* Forcibly leave the nested mode in cases like a vCPU reset */
> +static void kvm_leave_nested(struct kvm_vcpu *vcpu)
> +{
> +	kvm_x86_ops.nested_ops->leave_nested(vcpu);
> +}
> +
>   static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>   		unsigned nr, bool has_error, u32 error_code,
>   	        bool has_payload, unsigned long payload, bool reinject)
> @@ -5193,7 +5199,7 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>   	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
>   #ifdef CONFIG_KVM_SMM
>   		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
> -			kvm_x86_ops.nested_ops->leave_nested(vcpu);
> +			kvm_leave_nested(vcpu);
>   			kvm_smm_changed(vcpu, events->smi.smm);
>   		}
>   

