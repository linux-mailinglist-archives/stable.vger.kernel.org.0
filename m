Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6ED6831D3
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjAaPty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbjAaPtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:49:53 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5447B45C
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 07:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675180192; x=1706716192;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OvT0dtjQEgEa1GGGXen0t5DjrPP4McVNrMcCFULjkuI=;
  b=MnVTDlAkJeSzVlcxQ7H5szSITVi7adLiZNuqPHB1N5QnIB7A7smyCD7B
   R+tde1vNNJbPfIo8KZsLcHpaHlCYfQgyY0mDMtM9gvPUQjKLNoTNO3qX1
   VYFFZL9/5zM6cTzeGXqz2N80fqqB4PKGsusE9c6Hfrtk6mYLgPZg9VK8V
   h0v8WA5l8zirniD5RG8Abyv5MMYLtOT9lWS6lAfcST9ccTeWxuG2sUA61
   daRyrk8Z8+NUvqMBM+u7fsJ7Vy1rWbYRhqPVe5JrDu6PtgdmjThVU8CxX
   hPKzXkpdTg7lHtoll5reEn5vNc7m9AGD9xtstMl75cufDVDOl0a4grmFB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="325574722"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="325574722"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 07:48:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="753283227"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="753283227"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Jan 2023 07:48:41 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 07:48:41 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 07:48:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 07:48:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJBfgcowiO/xauLN8QLCO2d1jHVDv2uqEbNMs2chLTqk2ujGJ2mQ43IA/jLPG71K7S1qGH6zX68RpUVAhfueU5Srbvr+hTHE8V8gR3gcTZxKYwVjTAhFwX5v3YOWIg0Jpe0EWzEADMhNFTeBlEw/D7zTdAxBh9YTBXkc/zFxXTYIbyG2Gudb6rOkcqd89kuIoCgwh4uinEFvP9Xnh789Cw3P/3wWGwjcj0krzRNIdvPUvne3a9V5mgLe8SBTPQgUfOHucfWDyIC5Lc/4emDc5d4o314hYumaYvuYijYRy3/Ezq+eIThBZI/qSaLREuIutmmxFml1cnK6Y06gcF/MCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liIoMSqMDZO06/IRu5Wc3n/aPrZvAA1q7hMmlRB0H4o=;
 b=EzvMDCcVPXSjn3TwDDmZCvAvBgnRM3Qf1/bzUjRcFC44gAnkErIGc2CmFsMAL5lFVa66/fis42GEb2pdr5M2hQhxSKSwNgfIydAbPW3tKuYPOi6CcpYm1k4t1kI82FJtAlzKcVpw9JiFwr8PiBbaK1ThCs8EdtaBQE4fL3Dp+kIuDkA2aICPR6BDC5gV/G9zXtuDlrn+gpSpfDWPRJHkieHY66VXvszvHBre0kmQZ+i6XqRxpqX+Q3Pm/hAk3zYC8kx2nTZIYaT/17nkjBtS3fHI2DitWEvJmIpXdpTk3cRRxgZZ2lJJAOtxREm9KevQRE55jp9945BxmLwZ+0TXjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB6375.namprd11.prod.outlook.com (2603:10b6:8:c9::21) by
 IA1PR11MB6073.namprd11.prod.outlook.com (2603:10b6:208:3d7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Tue, 31 Jan 2023 15:48:38 +0000
Received: from DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8]) by DS0PR11MB6375.namprd11.prod.outlook.com
 ([fe80::8117:219e:33d2:4dd8%9]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 15:48:38 +0000
Message-ID: <8aff3653-0d10-77ef-1eb7-b1d1fdef183e@intel.com>
Date:   Tue, 31 Jan 2023 16:48:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
Content-Language: en-US
To:     Sasa Ostrouska <casaxa@gmail.com>
CC:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "Jason Montleon" <jmontleo@redhat.com>,
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
 <CALFERdwVzz5a7k7XjBkNyGKKd8+4Fez62Lq__6jOarqnBJQjJQ@mail.gmail.com>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
In-Reply-To: <CALFERdwVzz5a7k7XjBkNyGKKd8+4Fez62Lq__6jOarqnBJQjJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::8) To DS0PR11MB6375.namprd11.prod.outlook.com
 (2603:10b6:8:c9::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB6375:EE_|IA1PR11MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fc4acbe-0b06-4f8e-1314-08db03a29e9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 441SxEzXG5PpIsPgZvGjorJwlvkjvpVFwVon3ETsgI9517uSdGp+J/ZvHAW9+K+IG7rQJR9rBUyU4qESf2kR6QeatrnHHSnLFIe5tW3sF33bSgBtQ+oZXl6TvnP6XJWhvXeKAIFZIKBUqbpDGG9ZCW44Gf1H0YopeDK8xaz4JMdJz6upzyasZgvE1dzXJZyWFXTz6tWlxW/rvLBcomUQChSyf4DjIv4OSUzvo542LxMlCZTVHvytJHB9MkWT8PlstIjWROvHaVA5XMbzyxQFNzfCHIQjFhsFA+svmVH5lKGPC+yIV4yqMmsTFNQn5VWft30vganhw9yKutwdxGeo+jRvx1tvjmO5bTBJW38hNGd4A9vGkZ2BSfpcyqYT5cvmwShPf4hOaGxvIDpDsUoydNzXcOntBpCtsoQwi3Im9dcKxS1Wsrcsi7EdacWvWspg9zjwSi35hAur7kcQmbdHlNPlDfVqOkUsVAf8kQiMm1YWj5glZ0CBc3CK4EN2sKsQKMCrAIrsTmi80INIw0Kh7ZBfXkFJhcn/vbsGzDOGzW8U7J80sFRuk1occ7+v7TL7LNuXe3XBrFowzCJaQikB/JJKeBWSVAA706+IHtinR7rSbpcvxaRCIUIgILoxxDdDCaJYINrPFsGarcApLKbIzI0iHUrA9fRuwTE+dyVoQl4qE/Mrb6FhWCURlXBk170vR+8mVv1zaGqW0GFuYZSNeZVM4xYn6hxDLRQ/o/i9/rA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6375.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199018)(38100700002)(31696002)(2616005)(86362001)(82960400001)(2906002)(478600001)(6486002)(8676002)(66556008)(66476007)(6916009)(66946007)(316002)(54906003)(5660300002)(44832011)(4744005)(41300700001)(8936002)(6666004)(4326008)(186003)(53546011)(6506007)(36756003)(26005)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDlNa3UyUTh0SXVSWDVDWXRuSm9YUDIvSE9SMkg4NHBtbllGSVFTcEl1TEdq?=
 =?utf-8?B?MDJOMVpVTS9sSEJpN3RjY2d1aHhiVnppV2FYTjNOei92RjJyU3lqSU5OUFpn?=
 =?utf-8?B?SWI3cUhUbmZQcTJzbk5MenBDNzJCRnpZYS9IS1gvcGVHWWgvV1BTa0xxdFoy?=
 =?utf-8?B?ajhvRzBLWE1wU1l0MjY0OUFwdUFOTFBGeDJ0ZlJXd2c5T2dVSGZHcWZVOE5N?=
 =?utf-8?B?TDB6NDNnRTNHQWRjdisxanFDZkdZWi9ud3loU1QreFM1ejZXK21sNzhsZE1Z?=
 =?utf-8?B?OFlkcUxzS2RIalZzSFA4Nm1Ea3hNakNpYVlSMmM4Q2ROS2xHYmJrZkhCUi9q?=
 =?utf-8?B?dm5LVXNHUkl4UDB4aGdRTHg5Z1Uxa1hJSGZtaEpydHJmZVFqY251d2tlTXZh?=
 =?utf-8?B?UWlzNEYrTzJoMU9kUjV1WXBmRVJlZUQ2Um5nNDBtRE1BRjhoSm05V0ZLc2t5?=
 =?utf-8?B?LzUxdy9CQm1sL05VQXRSUVM1QmI1VjhjVndxQk5wbGcxZEJLWFVZQ3Fzc3l5?=
 =?utf-8?B?LzJxU09iZmxkck01ZVVpS1ZLN3VBSnByUUJ5SG15OTV4MmtvSlk4UnFQbEoz?=
 =?utf-8?B?S041M29EbXZNS2xLcit5aEZFTG5Yb1B2Sy9qMTM2OEdOdkh1WkR1bExRYlZo?=
 =?utf-8?B?clVTUHlBN1J0ZmhYdVgyYjRSaTN1V0tmbE92WlEvUi9FNTAzd09EL2xiNXBR?=
 =?utf-8?B?SXFPYVpSdE9VZW1CeG9OWlFnV2FEZG1vOFJ2VzhaYjNtb01oRktpUXpkQ1Zn?=
 =?utf-8?B?aXNUUkVxZjQ2ZkVNNWdpMVlOMXRFYk0ySlp3dWVSMU53clgvcTdoWGhQcTJ6?=
 =?utf-8?B?ZDEvMWxwNkFnR1FoemNJcitNcUlac1IwVElFbGptRG1Bdmd4cHBZR3BKMm85?=
 =?utf-8?B?TElFTE9wMUNqZXdqeEVLdDhnazNZRnlhaEU4WUlUU1hMdW4wWVYzVjQ1aFRp?=
 =?utf-8?B?ckZMc2xOY053MW42ZEhwQW42L1lhdmExQlZES1p5VEFxb20xZ1h0NC9RTXE5?=
 =?utf-8?B?RkdqdHJOdDF3YXN6NDExTFBUMW5kYy93eE85ZmFZTngxSEZWTURRZDNmVjJZ?=
 =?utf-8?B?K3pjK1l1b2xsaFhxbTNJSjRQb0FIdEJEeForVmsyL3pPL0NnbEZBY2RCSVBj?=
 =?utf-8?B?Und5bzQzbmlibW5qZnFSNHdIRzV0S2pwSXRESWZmQmZSNGxzNFduK1N6QnN3?=
 =?utf-8?B?cVZ4UnM5OFJVWWJPcGJJR21CVEdDWWdqTGl5eExJcFA4YjZBdnFrNVJqd2kw?=
 =?utf-8?B?eTBEU3czNWV2UmFqQzhuQ08xaWI3VFR5RkthOWZvZFZvMXRYRzdsTFM0cGEx?=
 =?utf-8?B?TE5uclEyNU9jZGxDSEQ5dDU0ZTNSWUMydDdmMHAzTVJ3QThwdzJQb2hucG43?=
 =?utf-8?B?d1lTbzdxU056a3FieVlFY2YwSEZPMkdadHBxbUNkamJOeS9hY0xaMXZYN2po?=
 =?utf-8?B?MEtYckZ4YUNWZWFjWGNhSmRsck1WOWUzNWRJa0pxNzVra2xHWkZSdWJUalZS?=
 =?utf-8?B?MGloSlI5NzNQZVB3UXFXQk1iZy8zeXBYVllkeDBFSE9kYVRsZlZ3NjJtQmF3?=
 =?utf-8?B?WUpMQzIrUFU4RXJkcW1kRGNsRklDSVdoaEF2UUJ5WEJ5T1lubElhTkR0OWxy?=
 =?utf-8?B?S1IvUFFNZU1RTXlGQU5ZZEtqYnloMDdzcHVwT0hpYTdRTXRiSDFYd0o5M0JC?=
 =?utf-8?B?YUpYTWM1bnVXL0VVQmdjRmM1R2U2dnE5cUcyNVpNVXlmZjFRK3AwTHdXNkdo?=
 =?utf-8?B?UThPeFZSVmpTME5Vc0xRbURJM3hQOHNlU2xSSnJxcTZmOUpWWUZmeWxoKy9Y?=
 =?utf-8?B?bGs3TTlFU3lvSFVaNVpxSldPeS9Bd1pQYmdFSWd2dTVtVXdCR1laOTZXa2U0?=
 =?utf-8?B?YzBtM2RKaTNpT1lvMkZTa1FJTTlicE5JRmo2NTRabW1leWh3TThQVXAvRldK?=
 =?utf-8?B?NUZWRnYySUFsM2dVL2oybnc5UjBiZXNNalI5RHlXZmlTUWxlSzhhUkhJZXEz?=
 =?utf-8?B?alRLNkhndTl3V2xvakFacTQ0ZCtobSt4ZnA2VzhuQTBBRE9HYW5BQ0ZnS0hY?=
 =?utf-8?B?SmJiY0txa0JhOXVKTENGOVBtcm1vZExRQUp5RHlTcGFUUDNaeTZzOHp5dUxJ?=
 =?utf-8?B?SWNmVXBFWFJZbEFoaEp1VU55M3BZV3p3Q2U0MGVzTDUyTlZvWWQwU2l4cmNl?=
 =?utf-8?B?VVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc4acbe-0b06-4f8e-1314-08db03a29e9c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6375.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 15:48:38.6339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BhibAwdNZnQHxqlqyqd1RCW7m5Gvsk8VA7nK+OqSC5v6g6e/96xE+daiZoAyNEO4f+ZpbHfhiutKdZKjWo1beW/b7gxKaJzIGZ13/wLBqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6073
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

On 2023-01-31 3:58 PM, Sasa Ostrouska wrote:
> On Tue, Jan 31, 2023 at 1:37 PM Cezary Rojewski
> <cezary.rojewski@intel.com> wrote:

...

> Hi Czarek,
>>
>> Could you provide us with the topology and firmware binary present on
>> your machine?
>>
> Sure, see below.
> 
>> Audio topology is located at /lib/firmware and named:
>>
>> 9d71-GOOGLE-EVEMAX-0-tplg.bin
> -rw-r--r--. 1 root root   37864 21 nov 20.18 9d71-GOOGLE-EVEMAX-0-tplg.bin
> 
> 
>> -or-
>> dfw_sst.bin
>>
>> Firmware on the other hand is found in /lib/firmware/intel/.
>> 'dsp_fw_kbl.bin' will lie there, it shall be a symlink pointing to an
>> actual AudioDSP firmware binary.
> 
> lrwxrwxrwx. 1 root root     23 23 gen 10.28 dsp_fw_kbl.bin.xz ->
> dsp_fw_kbl_v3402.bin.xz


I was hoping to receive the actual files. Names alone won't suffice. A 
bit of reverse engineering and I'll know exactly what topology I'm 
looking at.
