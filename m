Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC7C6831CB
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjAaPrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjAaPrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:47:22 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261A43802C
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 07:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675180041; x=1706716041;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5zObkkwxfXvjoK8k/dRhCekBh1TWGT/masUh/OFVGXs=;
  b=TTGvHtCNt3Li4sWRs+pZtD48FvD10aYRSmiIVcC30GCGwBPnSBKvvPh8
   eSSFy5oaxprqcaUyH7FanqntmUkd1omKR7DF8FYpWzZ5pdIV7LPqjqoGs
   cCELKiiigB2aFRg6SERqLFBD1v5kKYu5VWyyedoglv6R7DuR07zQ7+A76
   W73bilVEL65xZn12kBBzxWkHvxzYoleuqgPiuYge0auelxhxzkmurDzZ0
   2RIsvuuYPm71IyX34yYV3cswfrrrtBGeAV4HyFrJMEPXZZHAqC2M7Kphu
   sjsDtcR6Xh5YZRX385woSjY5/oJ6u73LtZXEFN403pmV1WcTcEhQspDEN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="308217066"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="308217066"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 07:46:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="807171568"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="807171568"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2023 07:46:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 07:46:16 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 07:46:16 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 07:46:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9Tx843YuwqSPFuxp/ewr89mCQIKFqip1anD8NicKE6jA14lquc4W3xP9sJOqYnm6LWrd2BDuN6/N1Bvhxu364BC/XHQPuJPDv9Lp8BKCF9kIUJoMGMJxkpturfRE/NINVrVb4cBdZlxhB+yfA0ekdboVzwYvUFXBC9KmDRXnD3rr4wjSmRexWt4zxDdF01hDbSnilYM2QhU5TvJAZLU5NM39HVCGNer1DNcKMyXKxOvn+ncYlQsir2ytUKKsyF00KTrd1efa3lYKpUluufUz5aE8bMHVHx8fmS9Fup41De38RNaoWnW09OW6Tc+43870rdYJSOU2wW/N1ZX7G9iLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIYKHVtMEDXB1RZ+KAPDJh9wToSgcj2yDDvZfFJ6Uws=;
 b=O9LE1prDHNNaGKoebmvHsNYyHNySyJETfQ13e/UNtmrdiLBTkc8Ze7KSksMa2eYQxmApyT+sWBw/5hkffgJcQTSuVT5swYRtzw3WTyR+dbqiPYwG84ZAlNlLno/n23OPSbTQ7tkmiBH9KgPKU39ztug+6Hluy4MBA3t+ArTMKGNeGq4OBFzoc6+D8nTNn4bZYZvTzU67WVCCsIcNwmFKvcU5kfg3vUg+YukdPwmmxNLGQA+8tpbeaihtXCTEeTeM950AmMjxXcv84tjqW0RbIMKMeXb//qlsaVAoKshnxsT4a40uk+XaeHP5wzk1Sq5tCmIHSNYmtMZ8fuqJ54KLpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB6375.namprd11.prod.outlook.com (2603:10b6:8:c9::21) by
 DM4PR11MB5486.namprd11.prod.outlook.com (2603:10b6:5:39e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Tue, 31 Jan 2023 15:46:14 +0000
Received: from DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8]) by DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8%9]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 15:46:14 +0000
Message-ID: <48c07209-0704-e134-cf7b-629ba34cbe7c@intel.com>
Date:   Tue, 31 Jan 2023 16:46:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Content-Language: en-US
To:     Jason Montleon <jmontleo@redhat.com>
CC:     Sasa Ostrouska <casaxa@gmail.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>, <lma@semihalf.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <stable@vger.kernel.org>, "Takashi Iwai" <tiwai@suse.de>,
        =?UTF-8?Q?amadeusz_S=c5=82awi=c5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>
References: <CAJD_bPJ1VYTSQvogui4S9xWn9jQzQq8JRXOzXmus+qoRyrybOA@mail.gmail.com>
 <Y9Vg26wjGfkCicYv@kroah.com>
 <CAJD_bPLkkgbk+GO66Ec9RmiW6MfYrG32WP75oLzXsz2+rpREWg@mail.gmail.com>
 <CAJD_bPK=m0mX8_Qq=6iwD8sL8AkR99PEzBbE3RcSaJmxuJmW6g@mail.gmail.com>
 <02834fa9-4fb0-08fb-4b5f-e9646c1501d6@leemhuis.info>
 <288d7ff4-75aa-7ad1-c49c-579373cab3ed@intel.com>
 <CALFERdw=GwNYafR3q=5=k=H_jrzTZMyDBQLouFGV0JGu8i9sCg@mail.gmail.com>
 <04a9f939-8a98-9a46-e165-8e9fb8801a83@intel.com>
 <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
In-Reply-To: <CAJD_bP+Te5a=OfjN9YrjGOG2PzudQ87=5FEKj6YLFxfKyFe5bw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0061.eurprd07.prod.outlook.com
 (2603:10a6:207:4::19) To DS0PR11MB6375.namprd11.prod.outlook.com
 (2603:10b6:8:c9::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB6375:EE_|DM4PR11MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: d8bf6e42-7461-47ee-bed9-08db03a248b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ONTm/UIfXglKYwHxMZHkMymmuY2orcMIAwEvK3/MZMOtarvnp4y140ETYYTZ6vPgkJdnyc4gqbwZN3K9la0m6ahm8XZ9F4ZCi4kOZt9wuMGTCK5aDPVrzvsMkCG7itD12tx5V/+cYJH4L9KMcWKJHmcbclnp1a86HAUfQU11OYAjkEim6NyxclbjGWQtsTGeCc8oay8t2zVddKw8uAcgLsx1njFGYSf2ob/L+e/wQxnNeaNtoY5nd5kHtIp+O4c6r3G6Veu1C2tPO0T8yED/Df8dnxcRB/Nm5EZq6Qh6ToLRb7GkBi5sK9iJJ6lmO8EIA6uHmpfNed0XvipBEdu5CrpjGWXnVqVWxkOdmVZ3XpZsufTFPolS2EFIAyHwX6PQzEzHLH/L+lc7d+MseETj7K90y7As3aLPVBZ1IgvH42t60/aYxXCX6iJjearMAuY2Od/m1cuGTB1jGx4/WcrWH13Uxt+4WFVZ4crSkIYlYNpJt0AisEXADEg0jjQgXd4kLt5Q9q60JraVM5rt4idRuwtk7vKb19QMyncoa7Ycw53kPV6osiicq/UUPaFrDyQ8vojux5k9mFo3GG+kcZliJYPqKL064a/1PM51njYw4WwZzpjP5Xgr7gUipSl9yRimULkSGpeUlZ4Xa6twOVGClFTSy2S2eZCJQeVFbZFBUbOCHTYRE2vwqBXEMI8zvklORwbalR9Moy24wCT4W2Y9UBpEteHi+Ti/afMhe7I4Q0uuDiVemFcy+jIpm66n43cY0xnaEMyxHz1qXMjse5IGOQhnA6pWm1E+bEPlDF+QgjbUYCcJB4VCMNwFjS248yEK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6375.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199018)(31686004)(66899018)(83380400001)(31696002)(86362001)(36756003)(6916009)(66946007)(82960400001)(8676002)(66476007)(66556008)(4326008)(44832011)(2906002)(41300700001)(6486002)(966005)(6506007)(54906003)(6666004)(478600001)(316002)(8936002)(5660300002)(38100700002)(26005)(6512007)(2616005)(53546011)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG5JRUtqV2JNbnVFRmdRa1RncUdJaDZjQm81N2MycWpkeEhNM21HMnJmOHRn?=
 =?utf-8?B?bW1HeURYZ053T0l5bElyYnFKckw3ZFZWWjBJNDJZbVRxSkk1V21PZ2wrTnV4?=
 =?utf-8?B?Um5iL2ZodGdGN0JxaHRRMVZ5M2QySFRaMm1MYjV0d0RmVGppemVNaVV6d3Uy?=
 =?utf-8?B?ZVVWT0ZKZGtsMjhySnhiUXpPRmVKRUZtYkVTSDNYU1BDUVViRnc2ZDBidGxw?=
 =?utf-8?B?Ri9Xbk5RMitrMHJaMG9OcEhSMDFMMmlyU2M4OEFWaVVJdGVTY0RWUlkxMlhV?=
 =?utf-8?B?VWNqaVE5WnVaa21yVE90UWRCbjBtcjJySlh3d0FmZDlaRzI4T0VTVk5XTmhU?=
 =?utf-8?B?UURRaGh3aEJ6Z2ZRNmZsdXhHYWNVOG5Td0ZjNnNtMXpQYzByaXc5U1ZJK29T?=
 =?utf-8?B?NXBXSzdZbHBsSHM2T0ZFa3lZSlNJSzFVUFNtNDJ5N3E3ZUdiUWNmU29XaW15?=
 =?utf-8?B?WWxuTXVyRklFVWJCMFc2bHdheWplYndlaHJGVy9seTl4ZE5XQkV6ODZNbEF2?=
 =?utf-8?B?ME16dnNYY3NGRmFHWUd6Wnk5cVhreUd4bjc5aGNpTzlncUlxVFFUd0hXNGJK?=
 =?utf-8?B?ckNZMWVURTlydHJjV0dnOWo1UzlYeVp2OUpqOHFJRnk5RVFDT3dVQUszYk9i?=
 =?utf-8?B?ZnJKTHhmZ3U2NDYwSEV5MnlGcTBxc2NqcnBCM041TmhaNmgvV044MUN6VU5M?=
 =?utf-8?B?bFhMSThWeTVjMDQxcXNxaXpuOFZzQzZuL1VUMTVlZXNtVjNjNjgvT0plbXh3?=
 =?utf-8?B?SUhNOUpMTUVYd1JuK2kraG4yM1VBWDlIQ0xhc2tTUmt3OWdKRC9pZ0ZKWklt?=
 =?utf-8?B?NHVhS29kSmJkS21KWmpjMmhrZHJLQ2pQdUY5YmpzTjRyZmdXSjZFYUxNQXR1?=
 =?utf-8?B?bEZvMnpGT0NRa0tWbDd2MzZZSC9xTjdjYVlXaGYvRElidEFDMVM3Q0VMQyty?=
 =?utf-8?B?UHh1WUpNVGZJVGFtYTZQRlo3U0lPa0ZuQ3NoUFErdG5odXdpM0d2SkRLUzNr?=
 =?utf-8?B?bDdLektPQ3B4Z01tMHRIUmt3K1NLOG5wcnU0U3F6V1FDWUhVLzJpY3N1ZDIr?=
 =?utf-8?B?OTdqU0VuT2x0Y0RXQzl4Ykk3Z0lMY0NZRyt0c2FiUW41YW0vbW9MTktBdnBm?=
 =?utf-8?B?R1BZR2tDT3AzOWg1SlZGaWZ0ZGk4ejYzM0pCbU0zL212czN5U1RQNis3cVNL?=
 =?utf-8?B?bzFUUXVuTjNZVHgzNitPRTBpZmxmNkFYU2F0cjdvNVRNZitlencxeFhzSzRJ?=
 =?utf-8?B?WU9rSi9NdklXUmt4WlBHNFBqd25vOGxCQ0tjbUJxK0oxeVBnK2JNWGUzQmd5?=
 =?utf-8?B?NnR1bnd3Um80cFJ5ekRsZHFwSzVCam94QjYzT1VCKzVOaENaRFZqMXJLd2dW?=
 =?utf-8?B?KzRReUFLaDVxcHBSQ3RidVoreTBCSFMyZGhtL0loTnduVDZ4dEEwTzJwWUJ1?=
 =?utf-8?B?QXBPa29mOXlNeGpmY2ZZc21nTlNSSlZOdVNzMnNuSlZ5K3dYVFh1L0lrTS9p?=
 =?utf-8?B?aENsREthZXMrUHdPYXB1NmNZVEl3Uld4MkVLMEd1U3AzNnJ2V29DSFl1QUdW?=
 =?utf-8?B?RHdFUCtuTlUvZVhEeXpXZlY3aFNDVjcwdWhJOFNoVkVrUElKelUwTEp4NkZO?=
 =?utf-8?B?ZEZhOEZGZk5UN1BCRG9vS2VheUNVUTRYcFc4Rlp5dTNHMEUxVkhkTGxWZWRP?=
 =?utf-8?B?NFZBSDVXWWJkTlUxMVNxa1pRN1RFelEzN0d3VkFHazBWY0d3TWR5aTBQYk1H?=
 =?utf-8?B?T2RCWXlSOXV0ZGd3MVBZWWZORXFPeHZtZXdwbmRaelk4dEszcVZabmtGK3B3?=
 =?utf-8?B?dFFKRHJHMEM0STQ3SkZ0bTJHVXExcW1ldXByU1p4YTBNdnBRVTd2ZHpsTmVw?=
 =?utf-8?B?NnFlRWE5dnNKYXd4RWxVUnFDdmpSUU5PSVl3RGVyZjB4ZERkMGdxY2trdUtG?=
 =?utf-8?B?bkMxcEVXeVR2VTlqcVk0dXRmQ3k1NDA3aDRqNklsdmh3dFJoLzVzZ0tkWUZq?=
 =?utf-8?B?eUd0VG5vVU1ncnBKL2wwYjVEU0NrVjNDZkFQNFF0djU4YWc1aFc0Y3JicHg2?=
 =?utf-8?B?OG1aUnJ6S2NlVC9QV24wQzZZeVEzRHpMTy82dENwa3J6R1JxNUJtSVpKYVdD?=
 =?utf-8?B?TVVTMW8ydnl5bmpzSHJtQmJsSVpDVXlzNzR3OVJuVEJDdVZSaXcwS0N0bjVF?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8bf6e42-7461-47ee-bed9-08db03a248b7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6375.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 15:46:14.4362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39zume61NDYhD5Su8zj9qui2TVmy9uYOMrLegkFN45hOB5rqOsJWFPvVvW2/MD9Ts0ms3KtJbAMmz0TnExZBeKN6HcnDtRmMSPEFVtHncgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5486
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-31 4:16 PM, Jason Montleon wrote:

> Maybe this is the problem.
> 
> I think most of us are pulling the topology and firmware from the
> chromeos recovery images for lack of any other known source, and it
> looks a little different than this. Those can be downloaded like so:
> https://gist.github.com/jmontleon/8899cb83138f2653f520fbbcc5b830a0
> 
> After placing the topology file you'll see these errors and audio will
> not work until they're also copied in place.
> snd_soc_skl 0000:00:1f.3: Direct firmware load for
> dsp_lib_dsm_core_spt_release.bin failed with error -2
> snd_soc_skl 0000:00:1f.3: Direct firmware load for
> intel/dsp_fw_C75061F3-F2B2-4DCC-8F9F-82ABB4131E66.bin failed with
> error -2
> 
> Once those were in place, up to 6.0.18 audio worked.
> 
> Is there a better source for the topology file?

There was no other source for the topology files for a very long time. 
This has been quite recently changed with the introduction of avsdk [1] 
and avs-topology-xml [2] repos. These hold 2 major branches each:

1) main - for the avs-driver which has already replaced the 
skylake-driver in client department and shall soon do the same in the 
remaining areas
2) for-skylake-driver - for the skylake-driver, help downstream in 
dealing with bugs and ease the transition to the avs-driver

Updated AudioDSP firmware binaries should be shared soon, completing 
last few remaining steps. Not every library can be shared though. And 
can't comment on usage of 3rd party loadable modules outside of 
supported set of configurations.


[1]: https://github.com/thesofproject/avsdk
[2]: https://github.com/thesofproject/avs-topology-xml


Kind regards,
Czarek
