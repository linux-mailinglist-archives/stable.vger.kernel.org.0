Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD920595640
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiHPJ3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiHPJ2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:28:46 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2082.outbound.protection.outlook.com [40.107.20.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8FA39B94;
        Tue, 16 Aug 2022 00:48:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeaEjy7G5S6qYXqW1CWdpWySaZW2leshRGxAUKdPYZIWPIHrRtmMdAjU1kiwzRWu+yALSRHSo8R6J5r3FWLFWKLq2lcmzKDP9GjitVsoWC9X0jvC6Jt0xVxYM1qL/Ow9NCXYmRvRRpRBGI4oN7z4jWh53g8PGrhoYD1wgb/fQRAJ3S1GHR3OzAfS9B8Uma3OZ8o3/jyR+0L+5ExJH6RO10ls+XgXpX6pOaD1/UuHE+7NukRnCNggf/1gpFIecN78whwFBENbTChUkYc+T4sUhhG6cygqul/cjsNTDbctMOj44P3Glw/InQyErojNgMV2YKdtV9CUsvNkYbYLGXZDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJqymMDKp7KAlg5ez9bNluzviYjMIjegjNZ0iC38OBc=;
 b=msFF6F4NhQFaXI864rbZ/fqBEo1cv1VQsdZ8SDU+5A+J2YP5Wm8GAWNnB5O4hvmw5OXdwLakFf4+A4E78U4x4oo3AT3KSpk/JbdGZsOUBUCcKDXrhBGRODiBwWtqJDD7xw58Xecn+C7h6cfNRLcpiE03QQBcM4oQ/1zsSEVzoG1MtuH8nRIk15zHbSV10itkNYjJ/hrTywQI5QKKXMyp+exmcfPEHpwd1O7nUyUDmWE8R172eifBB1W4pG5geqoFxz+9p4cPyNsK5xVT6vDhPBzK7/injtc6WO5qP9ZKy56VNSygcjePJv7WqaTpDj3HZrYsFRsNrEhhLYJLP1IKDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJqymMDKp7KAlg5ez9bNluzviYjMIjegjNZ0iC38OBc=;
 b=C6FpRyKHfc09M1Ki9TuVjIAO8sQ78qtTZtGsx1KF1OyhY4+0FlAC/i2aWyApjc2HTiKCj7981ZltAOALtSTmMScSSGC2fous+SPek5wFNLaJGKL2ahCMyJ/iMGf9gzHZhjzOzXkXJ3arP8PAnj3P+301byEzsieBor1NMKTA0AwWeCHg6n5P1i0RqEvUfyR5T5BpnUF/d0PK9HHwDrzL6MNCsynX13zVWa/oIYRnjYyIizSeFlvqoltDqObm2KLyK1BErcqk/iADavkUOvyIqGDj0txJcnlWa+GNVpFdQbDU6lGlplNTNvkF3yl4dIdAzthq0h1zttJcgatWY+KTZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DB6PR0402MB2808.eurprd04.prod.outlook.com (2603:10a6:4:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 07:48:11 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad%4]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 07:48:11 +0000
Message-ID: <2987196d-a5fd-a756-03f4-e1ddc41b5249@suse.com>
Date:   Tue, 16 Aug 2022 09:48:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] x86/entry: fix entry_INT80_compat for Xen PV guests
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20220816071137.4893-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220816071137.4893-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::23) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f8d737e-c708-453a-deb1-08da7f5baad7
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2808:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8I9pPpwBpZ2jfrCgNQwsB420khp5roWKgWf696fhkN4SkM63eYtCdKAVJgMryQzs1+mDbPGkQ0CoZoWmfGVQhKhgCE1eM7c3Cp6//Z5XEDflSSO+Z6UeEKotVr32MxocMHQjcAiXyEtcm4eREiX/ZaFH81mqIAIldfGvxdzBqBnSkL7VLs+vhrPtHbTnAaCMppYSsQeXaK8g0NdqikDACu8a/h0MwRw+K+PtjPlfgjn/0At03z0cHiuY/idbd4XRm2cPHZixBySOCaQTIyDBcDuTPVLt3DOO4+2hcv3RhiFQIlO2NurydDhEN83/LDuxysKCfXZhxuu6k4Lzog5/bwEvVFbnLzNLyUec9t1gi3V066QqWIY4JfQ59wSxFvrpGNJevCzOdoUJahubjmyVBsCwwILcC87d9kJdPDmWldR71G578XmmJFsUUjJc+KLb4sMlAG+UemE7k3aSg/3a81/oc3DHyggM5Z9NmqIdyC0kxQHCpl4Kj8Uh+icVPsT+JpzuvqHRyoeYeSFiakH7Lo8vqF25xJtOymmmz7hJ++CoPLX44It69zL3cicIsbPFRpE4EqZ71RjOdaVqvTjJmbe9Q5NTmIps8XgWut93dHDz8B60VfDr8Aw/OyZWkd5PaEB0eyp5pJBxrBYzChe3r8nw+DnsOtJHkIpFlF8RDhvE2u9kZ3r9BkoZ+XvkdQITsyGBQMAprJRDX191mKA8NEnTHImEcsBfDdlN/3em1Xzii/UQ9aQeUtHqAOfRanwek2daxt8jk1F21U24sSFP4l212nZduIQHdQhMlv5jgFA6+8HuyOBObY5BLJCwI70YsyP2cuiKDeWGlF5ttcUjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(346002)(136003)(376002)(366004)(38100700002)(26005)(7416002)(5660300002)(66476007)(6512007)(6862004)(478600001)(6506007)(86362001)(8936002)(6486002)(53546011)(41300700001)(8676002)(4326008)(2906002)(37006003)(66946007)(6636002)(66556008)(31696002)(316002)(31686004)(54906003)(2616005)(186003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWl5c1FDYWVoTFRON3FZU1FaRWZWT2JjVWVDaXdWQUtMalRpL0IzckdmWTli?=
 =?utf-8?B?cy9YaEY3bll2T3lDbkI5VUtXbU44d05qaWJhNm1Zd0oyd3JCcmsveVhkelU4?=
 =?utf-8?B?VjR5KzVwQzUweE9WTE1WOUdPQ3RIbWRzbVpWOWxNTVpwdE5nek92eCt0SVdu?=
 =?utf-8?B?THdqam9mMFdVLzR2WjBsVXJSaTY0bjJDQk81M2V6Wm5NQTQrQUNOY0tFL0Zj?=
 =?utf-8?B?emlsUlBWMkgwRlB6cEhXRUFWZldjT1JydmpxK0x2MGtiVXZmQngrT2M1S3hj?=
 =?utf-8?B?T3ZYVWxnZTdBSXlONHhIVm5iM0YwN2dUZFprOVRTa2UvTUNZME1NWTByZDFW?=
 =?utf-8?B?YktJR1hpWHNsV21kSVIrZ2h3ckp4NUIydklCTDE4Z2hmUExQR3ZuaE5ZTGJ2?=
 =?utf-8?B?SWNsNk1jUUlNSFpqOUlqTEZ1WUZ3ZUtqa2E0SzhUVDhpdWdTMDJKZXRqQlNh?=
 =?utf-8?B?MVpVaFQ0T2xSUjI4eTVzV0RUa0M2UU0xandjYU5HV21uaFRUdnltQ2dZWXBE?=
 =?utf-8?B?VXNmOFk2QmszY25aU1l5VGpTV09IY0Q0eTY1MTlTTkJZWXlSeGhrSTZHemNK?=
 =?utf-8?B?d1Z6UHNHUWc1QnltVGgzLzRHR1JkYVB0VXdPZEx5V3ArSUtzdzR0bjZ4NWIr?=
 =?utf-8?B?a2NJb1VQbWRQbjV3ZFdTNzlWNlJEQ1pZbkZqYkh5TzEwNW1pZExZUnpqeXJy?=
 =?utf-8?B?RWU2VnYyT3JhTGtPeDhwaU5LTVdtakJpSnZWNi9LekV0aWdQSnJBOG5PSnVx?=
 =?utf-8?B?ZjB1UitZcllONkRNZjlwUHp4OEJmcE0xWUtlWlhjVkpSRGx0RTl2VnFpZDFu?=
 =?utf-8?B?bHVxa0VTMVJJdXFZb1FpQnVkV1k1YnZ6VHVpUlpyQmZLcVRSY1ByTVliWStQ?=
 =?utf-8?B?YVZrZS9MMVFhYm1vVjlSbmlxWmhQRjBPUEkyRXFGajdRM3NBd1lsS2tUalR2?=
 =?utf-8?B?NzNndzJGRmNPYzBQdGhEb3dwbkJxMkdyNkhZdXV6dkJJbWtmY0JKWmp2V2Uv?=
 =?utf-8?B?UGRqaEM1TWZ2aFJzSTlmNGdUOWp2NmtFNTV2RnBxaXNzTFh1VmxEKzN2K0JI?=
 =?utf-8?B?ZWxxUWRObkw2TzdQb1VKVUZHdHlNN2cxNHNvcWxmY1hkdVUyVW5TV2VLaHBE?=
 =?utf-8?B?TkRTWWFCb3c5ZXJNQ0FrbE9TNzk0L00xUTRTZUFsNEdJVlA0RmV3R09qL3Vt?=
 =?utf-8?B?aExYSnVLcGEwMk5TdGN3RVRhSW9KWWx2TlBZVnRhNjRVT2ZJenBHTE9xU1lC?=
 =?utf-8?B?ZUJ2QURkNTBVdUZBaFl3eU5YUGRHTDJ6WDRHdkx6azcrclRKVk8yL3RGanJV?=
 =?utf-8?B?dENXUkQzM29rOUk2Z0cyWUJ1bnl1U3NlbkZRMTFWZ04vbmt6UFp5bFFqV1Iv?=
 =?utf-8?B?UEtKM05Mc2ZYNTd3ZkFJSWh1dy9FWVNYdWFER0ZBUDFDUUE0L3RnRnRlUy9Z?=
 =?utf-8?B?TGhEY29JSFpRSHRZUm1Zbk9vbFVNblNTdDlCQVRYelNQWE83ZGNPNHVxaWQz?=
 =?utf-8?B?UGlWL05PUWZMZmtId01IMW5Cci8xUllVaUE4MzJaRDBZdDhuWnpxZXVOc2Jk?=
 =?utf-8?B?QUNPSWRReUlHYitUbUVod0U2ZHNaempSaGVjQnJlcU1QRGpoRlJoaEVzTUpD?=
 =?utf-8?B?N1k2UVZib05JdUVMY2NJSWNrN0FKV1ZXVytheU1yNmI1dFJyRDE1NUxEeVp2?=
 =?utf-8?B?Tko1N0pzekovYUY4K3hTYVZWTmxiZ09LODNqUUF5MmxuWTN4c1Y3cFJDcUtS?=
 =?utf-8?B?c1o1ZVhLaGd2WE9wYmd4V3pjcmxvUnJKY1VZcWticEtVWFY1UlgrNUFBcW4z?=
 =?utf-8?B?eE1SZXpXWUlFckNUU0dvK1N3WU0yOStBTG5BSXZkSC9WeDZjNUI1bm9VVXpJ?=
 =?utf-8?B?cWcwUU1uUTl1UUl3bDF4cGZqZzcvZ01yS2ZJS0Z6SzB6VGFtTmRwckdiMUND?=
 =?utf-8?B?WVNDYjNVYkhTak5sUDE3dlR5YjF5dnZ5bGlmbStCTFRSeVYxbmNYSzhrNnUv?=
 =?utf-8?B?NC8rV05VNjVvazJnOVdkNS81b0hoNUxQcXo4QmI4ZEZPb3dVdkxuTUl4SktS?=
 =?utf-8?B?c0VPalhWWVpkdTNDWkp0TlgzZWFyMDgwL0Q0MGFEVk9KT3hCY2x2NjFrM2hE?=
 =?utf-8?Q?3WG9zGFP5ds1/udKxgoMIQqxV?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8d737e-c708-453a-deb1-08da7f5baad7
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 07:48:11.2621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pCys0z/aBAMRL2EbX+ymQ7B0RZ63R4syZEWdOT7U8xy27sujV0Fj+GAYKRVXuW0x7le1NQ+UviZXl6O0kBchQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.08.2022 09:11, Juergen Gross wrote:
> Commit c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove
> the definition of SWAPGS") missed one use case of SWAPGS in
> entry_INT80_compat. Removing of the SWAPGS macro led to asm just
> using "swapgs", as it is accepting instructions in capital letters,
> too.
> 
> This in turn leads to splats in Xen PV guests like:
> 
> [   36.145223] general protection fault, maybe for address 0x2d: 0000 [#1] PREEMPT SMP NOPTI
> [   36.145794] CPU: 2 PID: 1847 Comm: ld-linux.so.2 Not tainted 5.19.1-1-default #1 openSUSE Tumbleweed f3b44bfb672cdb9f235aff53b57724eba8b9411b
> [   36.146608] Hardware name: HP ProLiant ML350p Gen8, BIOS P72 11/14/2013
> [   36.148126] RIP: e030:entry_INT80_compat+0x3/0xa3
> 
> Fix that by open coding this single instance of the SWAPGS macro.
> 
> Cc: <stable@vger.kernel.org> # 5.19
> Fixes: c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove the definition of SWAPGS")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>
