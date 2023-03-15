Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523896BAA8A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCOIQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjCOIQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:16:30 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2111.outbound.protection.outlook.com [40.107.21.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A494584B7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:16:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9NHJM10A+MRapZp2DD7icq0m3O97OFwHkYyLIUpuIXiRngDgc8SDcHzsXpBMZZRU8IcYgM8Lo73muLuc4Y06NgyHvF1ww2+UFC2ZbMn/f87JV5LOZdws3jhJOH0se3sQVuLnDx6tNSzaayzOQ6mFOjQcA5hg9oK2xbi4Fiao66wsrdPFNnBW1jJF8smN/mCbDDso7rlTVKU2HXRcqLOZ9T37DftEXFVkTZ9kr7hU4leEogRitAk1lz8HbBJjOi6fx3VA0kArOQlQYvV3GK8pfe02WMdogoepeYPo5/PF3UzaDjVUbQ0fuRTO8toSJm4KykohHrrACRkII7OmdaVTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1fWg7BYL/N4Cs++xC1AjdXLNG3xpRP/7brI6fdUE/g=;
 b=XXuh6sVDw2SaQMxVkfWojFUweQhNHJK6NVQf8ML9edA3wyOs2EQ3rK3I/9VFTWGBTsKoNFKTpwtwVfTGJVyOd5w+J0FodPS+3d9xaIiwaNIRvQ8wfKBT1e/GSl8/RsIBhI9RB5MS7zH/hLbUmxcxfHdMeTQS0Bk/b5J3i3mHL3meAOXvadgrqtL9oOHkqYx/pKWsBjkfSAEHGfAwgO7yy85iic3Z5T3K5zwIYiR2rSJzOrdhGPIOtg/jJJClXMccme51qZJvHZCfrSkeOifur7w3MzOEUny7obi6UU1ibjJkCoSTI+b5XL/bwInVkoJr1xzFqiQ2W4qjLF8hUagpCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=uipath.com; dmarc=pass action=none header.from=uipath.com;
 dkim=pass header.d=uipath.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uipath.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1fWg7BYL/N4Cs++xC1AjdXLNG3xpRP/7brI6fdUE/g=;
 b=FVhHT8qlZB1/NXUpZXcLioB1mhFPX54NFsaKA++6gzyrTUHSdvY19uxz+sO3lq4HZCSWg6E69VuACyjUNWW9xWY0mV0wsC+vIbMfu5AcKaiV9YZJ4VJ6m0+HjNpDOpmN9+9iCuxW/AfBOywZCile5Bde9YhNBPS2g6Xkz7x5rW1tkJKIVMAOCY6+fCLXJ3cAdGwW3EhaAEDDKtaC8WKTeBmEDGJTQti2HbwE39n7VJlSDVrWEZF5O8P/CIylxFeEXj7FTlZpLRRJlHSKvU0TmK0G9iNslXKA3eUleYoWnmr+d9/7eU1S8OWOUKMeEDH8wixltSRsVG12lYrGJr1gTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=uipath.com;
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com (2603:10a6:803:b1::28)
 by DB3PR0202MB9107.eurprd02.prod.outlook.com (2603:10a6:10:43d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 08:16:26 +0000
Received: from VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605]) by VI1PR02MB4527.eurprd02.prod.outlook.com
 ([fe80::224e:d6bd:a174:9605%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 08:16:26 +0000
Message-ID: <f244612b-3142-ccb5-65c9-67c1e4f67e69@uipath.com>
Date:   Wed, 15 Mar 2023 10:16:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15.y 1/3] KVM: nVMX: Don't use Enlightened MSR Bitmap
 for L3
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
References: <16781188891829@kroah.com>
 <20230314091953.3041-1-alexandru.matei@uipath.com>
 <20230314091953.3041-2-alexandru.matei@uipath.com>
 <ZBF7SQXlCXuxtkAa@kroah.com>
Content-Language: en-US
From:   Alexandru Matei <alexandru.matei@uipath.com>
In-Reply-To: <ZBF7SQXlCXuxtkAa@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR10CA0092.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::21) To VI1PR02MB4527.eurprd02.prod.outlook.com
 (2603:10a6:803:b1::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR02MB4527:EE_|DB3PR0202MB9107:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a013447-2ac4-4228-8b3d-08db252d9243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pneCcOr3Lb7hWPu+xAFUGzgaWruTQUmdG1E3goZpl9ilo/bTMzSoxgRlvmJPD+sYIQ4bI1i7WbjOxOzXLlbXb2Cg5Az8Xi2lRgyi/jrG6eJtS52OKpKtJ5dpnq7TkN0xRtyxuVYR1zR0QdkFPXskPH/IO6vD4zZMhLhImG+EU9vAPgOgUsgPzLKugnCc7Sa4ygN9oTIy6C3Rmr03O5WreXcPYbK6Hsu6BSfrjOPtr2Bx+wYnG2M9zrFpiRtTsgeyZJjLkKI51khVtCu8KLEyOX0NommppZ4iJlYVh5x6+VOnffiZ9RoybaJmNxwcn70+abTrR9NogNmR5W7bLNTKTQdg2UpJ+TSHwdCi8pr/9J0GtHl0QrIBgZU4bKVPnd507Er415QN4bHZof9NdqMZXc8IWtM+975GPV1rRmyDP/Z3w5a0kEXqqSa9lfV/QA/0li0JGlBuv3u1DbWN7FUkef+lnTBmpXLiw7M66t3Dewodi6Bob1oGi2fyfrdvv/QvJOizi0nqSAX0PzNyYY45TBJ72nUdBFk2oELg02APotu4vBBE+Z2fZMwti66WdqOuz7luJXMXdJDQP7WtFC5rA1lcx05opM2TFzg3KP4SPFiqE4Xt/n3hBO8jNCdztb7X2/Xo5ocLcAKsQk2jF95b9Ef/bEOYiGPS+LnPEQtoPKBubld8lUNTTMtbGQowPptL6aJ9uNPX5IDBqwFLmG1cAJIbPHmcFCOsbmM3FxNVEL0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4527.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199018)(2906002)(31686004)(41300700001)(83380400001)(186003)(36756003)(5660300002)(44832011)(66476007)(8936002)(66946007)(6916009)(86362001)(31696002)(316002)(38100700002)(4326008)(54906003)(6512007)(26005)(478600001)(8676002)(66556008)(53546011)(2616005)(6486002)(6666004)(107886003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTRQc1F6a25qVkdwQ281OGN1cm1pQWx2dkcwSnlJS09QeDNyMjRjUDBOZ3Ur?=
 =?utf-8?B?MmU4L1NBZWU1WHpPUHBFd0pCaEdkdlNVQ3gwY1JXWVZKQjFxdWdJMTE2L2Zj?=
 =?utf-8?B?TkFWak92RFpHVDB4MDQxMUNOUVF5U2xmY1ByN2p0VG8rZmVnNVJuRSszVytL?=
 =?utf-8?B?WE9udy9ySHZDQnBEMnM1aERCRGxFQ2NRRWJFS3NZTDlicWxyaUtiQ0duWUsr?=
 =?utf-8?B?TVVLeFk4dmRmbWVLVU5LZXZDdTU1cVJtVlhlU09LbHo1eFFFNC9GVnNRQy9J?=
 =?utf-8?B?Z21RYnF6L3hLbUFLSzdYa05vMTk0NkVnODd4RzhFTnpsY1ZOSy96SHF6U085?=
 =?utf-8?B?UFdBSEgreVZNTE9PaHpwaXExRW9WSGlXN3llWnlrTVlGUWNXZG5KZFlFTVVZ?=
 =?utf-8?B?aWQzN1JtS00rUDNRZEV4NHhHNVdxT05lSUJqbHN3dy8wdWxtSmdKL1UwSW90?=
 =?utf-8?B?OTJGVG41TmdCUVJwaFRLb2ZQa0dJM0djRlF5RndrU1JBemFSQ051Z292L1lo?=
 =?utf-8?B?NjRLbi9aNXZiZUh0QTg1TUJ1OER2SWRmQ1ZnLzlTQ3V1RkZpenJ1citHSlBM?=
 =?utf-8?B?bXpHZjhwUWcxbDVyT08zR2o2TitSQUFjdTdQOXhsbVNCODlpQmc4WFh6a0Fh?=
 =?utf-8?B?ei83WkJGeUZjaDBUWmphZjZVZ0RLNjJEQnRIV244NVZNUm1RMTFUbWVVWjdk?=
 =?utf-8?B?d0RzY2NQaFpWK2xCN1VTM2RNR2tYRHlsNTNSM29GM0FZa0szNnZCeDIyd2pL?=
 =?utf-8?B?N2ppSXhQQkkwcDk5N3RpZWg4QnV0MSt1SmMxc1ZoUGlPbWM2RDBrWE9VMnl3?=
 =?utf-8?B?YjRWVGwrWFBkYjl1a256Mm81blNneW52Lzd1di9ZMXlRbHZ2c0ZGRVVPNW9j?=
 =?utf-8?B?WEhwMTVKZG5MbmFXcVRNWmx3Tkt6bklpWDhGSXBKeDhqdUJpemRaQlJ1M0cx?=
 =?utf-8?B?a3BESnBvUlJaaENTUkppOHBQL3Z3bFNWNHFVSG9qUXZkYWJ6ZE1IQlpXV2Nn?=
 =?utf-8?B?bUY0K1BUbHlGbXl5RjRqTWRBOS9OVkd6b21HNzRrM0JjYTA2OTcxWUZlNmp2?=
 =?utf-8?B?S05zRXlMcjhXVFE4OHJjOWZwSXNaNlR1WGRlVDVlbTVtYkcxY1hYUG8rR0py?=
 =?utf-8?B?V2FqM1lLWFVab3RBeENkUDkvK2NpWjE1WHZYdVdxMHM2a0YxbFlpV3pvV3Ni?=
 =?utf-8?B?Slo1SWF4cFpRaGRNOWdmTEszVDh1T20rV0IrM3ZVdTJoRW1nbXE0RGZ5dm1O?=
 =?utf-8?B?bVhWQ1pKNlk5dU9aS3M3NktIL2FwL3dsTFc2VGZhMDVYVW9zQW53WTUvRHZV?=
 =?utf-8?B?RmY0clJ0blVIWmhzTGc3QTE2U0hZb0F6TFR6Wkl1TTdJVnEyUlY5Q2FjL0lr?=
 =?utf-8?B?OW5IdTZrcnBTM1RwZjZyelRPRVlSSGg3eTZaWXBGQ2pXSUVmWWtQVWlKcEVu?=
 =?utf-8?B?NHpEUnNkVUFJOXc5aXEvbWJFKzVqaFcrWitWWkc3NDQ3RUwyZzFqZFh3aHNV?=
 =?utf-8?B?aUdhVUpueWJjZDc1VEY3Z0liRTFOM21IcUZaZEtKWWpzcjRpa09Hclg1cjJT?=
 =?utf-8?B?bUsxS0xWcVlLK1c1YVF5bWcyeW9SSjV5aWRvdU44TEkxUmpSMFdPM3hpMHRk?=
 =?utf-8?B?bVh2ZjJyRzFvYWVwZVp2TXY5d3RxRlFacUcxNjFpSldGcm9qeHd4d2UzOVpU?=
 =?utf-8?B?NmFSSEI1Vy9JRzJCUkFadUJpaWo4ekMzQjZnMkNhQmVZUlNscEY4Y1lRMzk1?=
 =?utf-8?B?ZjRIenQ0eWx5ZzJsS0FZRmROM2pFRm9lNmx3Q2E3bHlzOEZpcjFUQVY4YUgy?=
 =?utf-8?B?U3pBNWNZMS9yVWNLdnpIMXlaeGFVNnVjcVhIRytrdXFBdzU5RmltRGp1QlRh?=
 =?utf-8?B?MW1KdDU1MnBqUW9WQUVmU0p5eXM2cTNIcTQxWGxrMzBSN3BMbTdSQzBCRi9Y?=
 =?utf-8?B?Y0V0VHRiYTBFOGJzMm9EYnRLVURBVWJvRkpQQjRpdzZFRHFpRDBBbWVybncy?=
 =?utf-8?B?M2tJeWkyR1R5QmJ2QUo5SDluaG1wSHR4L2psbTVBWkZ4L0dOMlhEemZ5bU53?=
 =?utf-8?B?VWNlL0ZxUTRUSy8rcld3Zy9zUjhlTE9vZ3FlZjFzZ1dYUmpZZkljKzBSNVZO?=
 =?utf-8?B?dnFNVCtBeWJydnRaM1ZXUnZ5eTduR3FlaWhMeEFpb3RzRXVyK05QU3NtdFRm?=
 =?utf-8?B?Snc9PQ==?=
X-OriginatorOrg: uipath.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a013447-2ac4-4228-8b3d-08db252d9243
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4527.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 08:16:26.2588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d8353d2a-b153-4d17-8827-902c51f72357
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7s01oRobUf/oPTYOAl9rA7TQKYHfb7kOiJeMltqXkyUwSavULoFqksxpCYRt5pTPG5Je9COQvdyqxuBqtBsSC148Dn35/tBStvY6QjgEfJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0202MB9107
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Thanks, sorry for that, I'll sign them and send a new version.

Alex

On 3/15/2023 10:01 AM, Greg Kroah-Hartman wrote:
> On Tue, Mar 14, 2023 at 11:19:51AM +0200, Alexandru Matei wrote:
>> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>>
>> commit 250552b925ce400c17d166422fde9bb215958481 upstream.
>>
>> When KVM runs as a nested hypervisor on top of Hyper-V it uses Enlightened
>> VMCS and enables Enlightened MSR Bitmap feature for its L1s and L2s (which
>> are actually L2s and L3s from Hyper-V's perspective). When MSR bitmap is
>> updated, KVM has to reset HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP from
>> clean fields to make Hyper-V aware of the change. For KVM's L1s, this is
>> done in vmx_disable_intercept_for_msr()/vmx_enable_intercept_for_msr().
>> MSR bitmap for L2 is build in nested_vmx_prepare_msr_bitmap() by blending
>> MSR bitmap for L1 and L1's idea of MSR bitmap for L2. KVM, however, doesn't
>> check if the resulting bitmap is different and never cleans
>> HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP in eVMCS02. This is incorrect and
>> may result in Hyper-V missing the update.
>>
>> The issue could've been solved by calling evmcs_touch_msr_bitmap() for
>> eVMCS02 from nested_vmx_prepare_msr_bitmap() unconditionally but doing so
>> would not give any performance benefits (compared to not using Enlightened
>> MSR Bitmap at all). 3-level nesting is also not a very common setup
>> nowadays.
>>
>> Don't enable 'Enlightened MSR Bitmap' feature for KVM's L2s (real L3s) for
>> now.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Message-Id: <20211129094704.326635-2-vkuznets@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> 
> You did not sign off on this backport (or any of the backports), so I
> can't take them sorry.
> 
> greg k-h
