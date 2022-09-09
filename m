Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC725B30CF
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 09:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiIIHrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Sep 2022 03:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiIIHq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Sep 2022 03:46:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056CC6B8F8
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 00:43:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtcBgA7/9tTtqs5+s9K78e8KAyQ7UlNWHhYOpvvXgqryJPM4AUgUaRO3xfoOx1fen7aVp4YabECRtJYykpF655I6f+9Zfv7aBdleaEOEt61DoheLlA9KaeEBa0X6xr14jLk3tcqb5SfQkjOwzm0/YD3vqhEwQRBRaRmK0j+pL4ywc8sqjFg061EwId7gDAAsS1ijTWFSvgMDOnJkZHC5LzmgyGj1hxRtrAeAAo0ZXNW5+vAAL34onJxb1I/lIywMGJi3F21uU+ugtBWjSXZpUSIV7CMnt5HOUGi8UNxET52IaPoYC7lhVUnZ0/YFyM/I0zNwOcGT5vH40HtN8cAlbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uc87nDdg5IMS9mR2dewUde4pCgB+AGUidAASZzHlNd8=;
 b=dyip6eR79Hx+WB9tsO3daYNjlMCJikYJ85VPIGVMdyaJB5LcTA1qzyBotimYEzFfVVubQh8yOY7ykMjJ3BH0vvC922dy9BX72KAgZDY3BYJJYuZd0s5GWnGijiR0PnXu9CCvfURp5OqF8FdIfd9GfkbpSmRwJ9F2EAgZl+wXf3HMeEEFy6pUAQakEUy99pVauxAVNtmlA7OVnG1JoHX1AUQMVUysaaexRmQknA4eL9/28gOgrrXDeUxRIeRQNoCpGkwIsRhSwAcTBrXY6jf4jfs8UxleAfezcf3YK3mS4rFHVftnfw/9x2gIt6/9jN0O31XpauvV54O1+G8r1E4DXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uc87nDdg5IMS9mR2dewUde4pCgB+AGUidAASZzHlNd8=;
 b=JmwYNNXZgmPcGuW0mMxS3/okhvkRdxRDsv7PfpbUns7Oun/DvpjBZYDRW4Vm0pDMivSkRiR50wXcJZrvA92knwUCSINlae6m61GZUnnBoWakW9teB+LWXvtlQD8ZhyRZsXTT3dXDYhf2XqLiZWHpfhBjyUWw+S1hN56SCcJkhvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB4614.namprd12.prod.outlook.com (2603:10b6:a03:a6::22)
 by PH7PR12MB5686.namprd12.prod.outlook.com (2603:10b6:510:13d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Fri, 9 Sep
 2022 07:42:04 +0000
Received: from BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8]) by BYAPR12MB4614.namprd12.prod.outlook.com
 ([fe80::2925:100a:f0b9:9ad8%3]) with mapi id 15.20.5612.014; Fri, 9 Sep 2022
 07:42:04 +0000
Message-ID: <a7b2f76a-772d-78d9-a1f8-68c32477f21f@amd.com>
Date:   Fri, 9 Sep 2022 13:11:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] drm/amdgpu: Don't enable LTR if not supported
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "wielkiegie@gmail.com" <wielkiegie@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Quan, Evan" <Evan.Quan@amd.com>,
        "Zhang, Hawking" <Hawking.Zhang@amd.com>
References: <20220908175713.GA206965@bhelgaas>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
In-Reply-To: <20220908175713.GA206965@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0013.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::9) To BYAPR12MB4614.namprd12.prod.outlook.com
 (2603:10b6:a03:a6::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB4614:EE_|PH7PR12MB5686:EE_
X-MS-Office365-Filtering-Correlation-Id: 80e0f8c7-2d78-4b9f-68d9-08da9236ca18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1aAQz3ozQvT5YNmf9wqZX0WSF7TmFXkop2bvprFElJjy9manwHB/X7f7PsTMXmU2lJP8oipR7f72qfzv0cF+VjQ+gspnuB2MTdN2kLmzR9EGobwaufNDObxYxV+XwVe0xoR/pjUxDn2WWAEXOcQv0gPwJwGmlhU3lbWpqrhT8lDqnpdF8Jh0g42AmXKtiYyYfmtlrwO6feAdsfwV9L4pK1AxqHhC7md1OBY7mWPYQWaUedKwm+4znDaOpQETQ6bsHaciRguFtoLnimPLxK8lqyn4RPciaqVWxc06ZQhqRPDzDmm1oMSfiUHjF/X3c3Yl9rMjsxQBESEfbeAQhQTfTyXRWPIagCR98TpCP6/ejGLmnnyotOpawd0REFiBhrm9Jo2yiSwobaZF4JjR07uWXntI3WTmZ+Fq1hXdalGOikyhMhN/N31KgIop0SJxNNDbba+T9aEVjXLYZ3lrCH32Eol4Lee26l8zZY4uIKk7qmbGCxH4bpoP8mgoPilKIlJ2LH9eUsJIlHCJvYHxew0WcG5vlBhf9uv0L81wkiZwlq2J+qEMKArY9eMhVwMNng4pk+SqrdOeWwS2ZqBzxFN8UdrnAsNFzPQ/5JoEb+xTa6Gt5K7iz6wmiE54TWJA1tdWKj8KBSS/xUP9/Gju6gLDunejez447X8Aogi+SDlGLVegly99hMbYeUpS9OsOEIqN3qryuEApIfkuYOtO7cgwkjpQV7Xq7xPvCoLc5bzXGRyNR9iGTAzLI+1neQYRbP8pCzI8riDjLE4ST0zdXwj7vIQsxuK0gZm+gmWKJDL8ks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(6512007)(26005)(54906003)(86362001)(31696002)(6666004)(53546011)(6916009)(41300700001)(6506007)(478600001)(6486002)(2616005)(186003)(38100700002)(83380400001)(66476007)(66556008)(8676002)(4326008)(8936002)(36756003)(31686004)(66946007)(5660300002)(2906002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QllzbmVwN3RsVldEZ0hVY0pZbVI0T0M2d0hFTW5SQzRmUFdYZ0kwSTJ3dnQ1?=
 =?utf-8?B?azRUeVVoSE9zMElZMktXMHRuUWtYcXRCbzRsM1ZLY1JNWG80MjJmR2JnQ2s2?=
 =?utf-8?B?NFZPeGRmVDlUeTN1bnh6U2llRE1wVlJTUlFBUmRLeGVrUzlGdGJQZ3l2NlAv?=
 =?utf-8?B?dG1Nd0FiMEcvdkU2a3F4M2pmaHhNd1YvMmROaDNvMVpsWFZHbEczUW5NZ3JS?=
 =?utf-8?B?cnNOdnA2SVd6Q1A0N0dGQjNkNVJESEdROVFTL09VY0VZVnVzL2xoZVYxdDJr?=
 =?utf-8?B?L0MvWWp2bkdScHY3bk5TV09JdEVwY0xxeGhUUEkrR01NUHNwTjJQUHdtekMy?=
 =?utf-8?B?aGc3Ykd5V3A2YkEzRnNOTTJkdWozSGNIdzZrajV0cFMzL2phenNoTlhrZDU4?=
 =?utf-8?B?a2loaWxxZ0NLWXk4ODJLSmRoZk5zZDgzbHRoaVlsQUExYUxsSmEzMFBOMGc5?=
 =?utf-8?B?bjY1cEZHcjFzRFZ3a3dRWDNBRGpLMkkzTURTWktuOVlTZy9wZnNYOWZ3TzVK?=
 =?utf-8?B?cHZvRVkyUUpCNUYrVy9sL1MwQ2FidGlMbEljeHVTWkRZK0NGcktYMFYrR0NX?=
 =?utf-8?B?ejZRRWpoWHEwaUpiU0tjQnJOZDdoV2dhdG1pdWlUai9PalZBb0NjQzczendV?=
 =?utf-8?B?dDF3TXAxMEN2Kzh6d01EZmd0TnY3c0JyZXRBTFdmdlBlMDM2OEh4dDZrSEJX?=
 =?utf-8?B?dmZET1NOY3J5U1Y4V0RDNXdGWTAvMkFkQ2ZBT21ucUR6RzVwRzVTTnBNUjA3?=
 =?utf-8?B?cC9uUTk1SzJ4U3FoMzF5YW9rV1JZTFBaTjhEdVYxM0krMERFMTlMSURqUW1C?=
 =?utf-8?B?MXNDYWMrRjNFbFhxallsaFZLTklBZ3BFRzQ1WWZvSzF3d2FveWthSXFySmVa?=
 =?utf-8?B?Wnk0NmFZZHg4V2N4cExaaG9DajFrbTJoSDNnRGJHQUtnV3pHUDFGZUUrMENN?=
 =?utf-8?B?U2FuN0x2V1o4bkg4azB6VHJMWk84a3ZuQ1hDTmdJZFhsOWVncjNZVjc2R1Nr?=
 =?utf-8?B?TGk4UHZLa2xKR01LTllHQVZBOVdabEFLb0cxU0srem1FOWlmM29oYzljR2dG?=
 =?utf-8?B?ZURDUm0ySEVrcytJQVRzMVpPYnlaOENBVlhmNkNPUzlTakVtc2NMUDVsZ0F2?=
 =?utf-8?B?TktWbitUUHlTN1oyOWhVMnJvTTNNMS9EeGdXY210SVJTeGVpWjJWUTBpTDlH?=
 =?utf-8?B?OURkNG5LOURMZENjUWZ3TkxQOXVYNm1xd2taeDU1QTd0dGM3TGxlbmdpU05w?=
 =?utf-8?B?aGNvejhaNDUrMUZWTk1kMUp3MlZkcVdXMVd4NWNMZ3l0SExzVmVKTTZaUEg5?=
 =?utf-8?B?UzU3N3c2dThxT0laTndHdStSb01vVDhkWk9rTlBqcFd4K0lkdkI5WVBPM1ZS?=
 =?utf-8?B?TUZWMXFlNDN3ZU5hODNhSHAvQ1Vzc0VpTFVtV01QY3Z1U3VZeWsxVXZxRG1u?=
 =?utf-8?B?enVoRnF3aks4RnRkSGJPS1BHYklSQzBqQXdidGY5ZWsyUmxISk5DeFBJelJI?=
 =?utf-8?B?b0ZJWVUzdzBJYkZhSXE5NlAxbnJ3ZDd5V1B5bmp0MnlKWmdUZ3F2ZGVDZFZ1?=
 =?utf-8?B?Nzl2NDlZWTR3SEpMRnhDVUpzV3VMUHRxMkZsd2NSSmJxNDRyRXozdkgyNWx5?=
 =?utf-8?B?cGhJaUtaNlBjWGNtRmtRcDRGMTRDVHlteDNKMThTMzZTQ2JldnI4cWtTQ1Bq?=
 =?utf-8?B?Z3JObXJqdmJlL08xYlFpMTlUY2xBdlJIYUxtRXE3VEw5alZzR0FCZmlzN1hI?=
 =?utf-8?B?Tmp5c1R4MzZCOExFQ3o2N0krOEcwY3hQam5NV3lNUDJxczV1SHdQc05JNjNn?=
 =?utf-8?B?b2NCS2RGMCs2ZWpzUlN4QWZhbXlhTDZON3U1elZxdUVEb1l2WWR5V3QzRVda?=
 =?utf-8?B?d21PQ2xOTjdKeTZ6VmF5eFhXZDY3ZUJ6RVdJWUw4MmVnRllTTm1XcjBDUEdQ?=
 =?utf-8?B?RldHK0c2ajZUTEZ0cGhEa28zUVlKZGROQW5ZeE9qaFpldzIzLzIxRzRWSDRQ?=
 =?utf-8?B?MmhGRDl2VDViWTZCRnRJQUFQNGd6N0oySEhCTXdSaXE5eHhzWDZUaDMwOE5r?=
 =?utf-8?B?aC9IWFpLd3BpU2pvSmRvS2JWZ256Nmh2SGhXT0pzYjB0SmJKNW9KNFdjWGlh?=
 =?utf-8?Q?fDIxU0ZyPe33qWpXRT+XN/q1p?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e0f8c7-2d78-4b9f-68d9-08da9236ca18
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 07:42:04.6270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTG6KjYiZlMd3UyLJcK29QcZk6nYEdtXasfFPTtoGywocI03CH3aI34+BgbsNxXe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5686
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/8/2022 11:27 PM, Bjorn Helgaas wrote:
> On Thu, Sep 08, 2022 at 04:42:38PM +0000, Lazar, Lijo wrote:
>> I am not sure if ASPM settings can be generalized by PCIE core.
>> Performance vs Power savings when ASPM is enabled will require some
>> additional tuning and that will be device specific.
> 
> Can you elaborate on this?  In the universe of drivers, very few do
> their own ASPM configuration, and it's usually to work around hardware
> defects, e.g., L1 doesn't work on some e1000e devices, L0s doesn't
> work on some iwlwifi devices, etc.
> 
> The core does know how to configure all the ASPM features defined in
> the PCIe spec, e.g., L0s, L1, L1.1, L1.2, and LTR.
> 
>> In some of the other ASICs, this programming is done in VBIOS/SBIOS
>> firmware. Having it in driver provides the advantage of additional
>> tuning without forcing a VBIOS upgrade.
> 
> I think it's clearly the intent of the PCIe spec that ASPM
> configuration be done by generic code.  Here are some things that
> require a system-level view, not just an individual device view:
> 
>    - L0s, L1, and L1 Substates cannot be enabled unless both ends
>      support it (PCIe r6.0, secs 5.4.1.4, 7.5.3.7, 5.5.4).
> 
>    - Devices advertise the "Acceptable Latency" they can accept for
>      transitions from L0s or L1 to L0, and the actual latency depends
>      on the "Exit Latencies" of all the devices in the path to the Root
>      Port (sec 5.4.1.3.2).
> 
>    - LTR (required by L1.2) cannot be enabled unless it is already
>      enabled in all upstream devices (sec 6.18).  This patch relies on
>      "ltr_path", which works now but relies on the PCI core never
>      reconfiguring the upstream path.
> 
> There might be amdgpu-specific features the driver needs to set up,
> but if drivers fiddle with architected features like LTR behind the
> PCI core's back, things are likely to break.
> 

The programming is mostly related to entry conditions and spec leaves it 
to implementation.

 From r4.0 spec -
"
This specification does not dictate when a component with an Upstream 
Port must initiate a transition to the L1 state. The interoperable 
mechanisms for transitioning into and out of L1 are defined within this 
specification; however, the specific ASPM policy governing when to 
transition into L1 is left to the implementer.
...
Another approach would be for the Downstream device to initiate a 
transition to the L1 state once the Link has been idle in L0 for a set 
amount of time.
"

Some of the programming like below relates to timings for entry.

         def = data = RREG32_SOC15(NBIO, 0, regRCC_STRAP0_RCC_BIF_STRAP3);
         data |= 0x5DE0 << 
RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
         data |= 0x0010 << 
RCC_BIF_STRAP3__STRAP_VLINK_PM_L1_ENTRY_TIMER__SHIFT;
         if (def != data)
                 WREG32_SOC15(NBIO, 0, regRCC_STRAP0_RCC_BIF_STRAP3, data);

Similarly for LTR, as it provides a dynamic mechanism to report 
tolerance while in L1 substates, the tolerance timings can be tuned 
through registers though there is a threshold.

Regardless, Alex is already checking with hardware design team on 
possible improvements.

Thanks,
Lijo

>> From: Alex Deucher <alexdeucher@gmail.com>
>> On Thu, Sep 8, 2022 at 12:12 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> 
>>> Do you know why the driver configures ASPM itself?  If the PCI core is
>>> doing something wrong (and I'm sure it is, ASPM support is kind of a
>>> mess), I'd much prefer to fix up the core where *all* drivers can
>>> benefit from it.
>>
>> This is the programming sequence we get from our hardware team and it
>> is used on both windows and Linux.  As far as I understand it windows
>> doesn't handle this in the core, it's up to the individual drivers to
>> enable it.  I'm not familiar with how this should be enabled
>> generically, but at least for our hardware, it seems to have some
>> variation compared to what is done in the PCI core due to stability,
>> etc. It seems to me that this may need asic specific implementations
>> for a lot of hardware depending on the required programming sequences.
>> E.g., various asics may need hardware workaround for bugs or platform
>> issues, etc.  I can ask for more details from our hardware team.
> 
> If the PCI core has stability issues, I want to fix them.  This
> hardware may have its own stability issues, and I would ideally like
> to have drivers use interfaces like pci_disable_link_state() to avoid
> broken things.  Maybe we need new interfaces for more subtle kinds of
> breakage.
> 
> Bjorn
> 
