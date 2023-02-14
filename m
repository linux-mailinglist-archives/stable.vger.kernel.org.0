Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7754E696D1F
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjBNSkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjBNSkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:40:19 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0311F2B284;
        Tue, 14 Feb 2023 10:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676400016; x=1707936016;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=WeSdV4dZI0ERUVzIeAGv6AAhwRE7teARy1THgX7BWMM=;
  b=NoH215Y9qYlALV/Pr9k2HJnOixC4Gb1EvVfG50OpbUgsKhD8T2Lu9ekg
   vrEO1dzffIix51LfOjlTnuCKmGCB6hjs/q6RjXINUavQTerWuhgtw0oh/
   IAylUG8fW6D2TsuPdUgqpDyf4WpG7ri6UjmvMKTXrHTzE2wFiptZielaq
   k2DWbQfD3MYGcCMaQ+C00bOek4MKUeKkX3V5AdUPOgo9bsXs1FzFhrAa/
   zx19kZA2oCpusPrCPWPb3/hCr1CHn+MlwvU1dSgFYP9R2vuB/dYBXiB3D
   96PwgtCYskS681K+GTD/2mq6lbvvcNwYTahYnnoXhyXrCvuszT3snLX7M
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="395851479"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="395851479"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 10:40:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="778462191"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="778462191"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 14 Feb 2023 10:40:07 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 10:39:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 10:39:59 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 10:39:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kE2s+kRGvtuYDrI+gxSb6xsS2VglDNSveZVaxy5DSzsr5u+xY1Waq1GGuFvQSmr4zBibvReoPFxlOd8+QEXLKewcqj4H+zxzowgrzix6XhGqIg7VmM6/3cYEyIQb48Ld0Nw5cHw7KspmMHwAZ2x2P9fEdJk9oIW2QEloTznvMxtavp74lnOzyV8rckGP9J1jnJeLwCJLCrN2pVox2l6OB+inh2X8q4oymVKyjLiIYW/D2AjVAgfa5Gfn7Mn3WeMnvmkIssHr8n60jmRSCAph519pug4hb+MNxQ/KM0eywCsvyGb18seid/137NiYnyVhavzw6o6+4sz5RMzGiFVJMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JZ3FTogNtcSQr3llQoi4OZNBxyfacmWuVjz930Zuew=;
 b=LuxqrYRX83DM04+LUbU7lBbFEzCGVeD1y1/39o3ctt3/t46H/3J7Qf7d9uhvgdZvXITJ1ySr4+eFpXgjTBTaDBeCNcEPT2YEzH+jDoopSJTAYVz+OuT3rRdC6ZUlvSFItDKz4aoe208g5csQAJ6WnKO/6S/wkswTPqNO8vay2n3aD2eUy8+eE/LcvH4KASe6vj/YQbsHK8HiJOrWhiXipzh5o0q3IRyqYj5Q1xgeDpc4xJH6EtDjRfoim11RMnNAmVOCMpNARB2eYafXuMl83+LE+676pe9ZpnasozrosoyFcEKdA/a5Cme+vi4XPBmjfI8nZgNt+AcrJ44b87hSIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB6516.namprd11.prod.outlook.com (2603:10b6:208:3a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 18:39:50 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::421b:865b:f356:7dfc%5]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 18:39:50 +0000
Date:   Tue, 14 Feb 2023 10:39:42 -0800
From:   Dan Williams <dan.j.williams@intel.com>
To:     Gregory Price <gregory.price@memverge.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        "Kees Cook" <keescook@chromium.org>, <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <63ebd56e639e9_32d61294f4@dwillia2-xfh.jf.intel.com.notmuch>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <Y+vSj8FD6ZaHhfoN@memverge.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y+vSj8FD6ZaHhfoN@memverge.com>
X-ClientProxiedBy: BY3PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:217::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB6516:EE_
X-MS-Office365-Filtering-Correlation-Id: ceb09a29-0b96-4d21-e2e1-08db0ebadaf1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cA+x92kOC97le489cKFKiXZ1nhwBpFRCvr4uG7BQVi/XDgKHKdEQwsD5dE4lXuQ53ar7AqaeZyFJmg9a2pgdRJasX/jS411wUXTX3UHlgtmsSAFwIJDOP2X/sKdCgHwW414W0pkUxmWCHHcuKif3DbSLKUZj0kVpAz03dn3XvgmCpy1ahpfAmpbdG4ITxJRVkGoOQ8Rq/uk9VitOHTMv0fU+uI7m2lnUyrXJWfm7sJaj2zfj6YwpgsKQIN3k+hHe6a9M7wATx2SiPJ95oEOizNXty9F55LKMKStB41zIZg3uT5+01vmZNaKylCP/LdGHYO3n9xlTBHuf9XS8dDCSHAcCeMinG6Ry7usBArMRDGyWzgKTNEca4Q4vwX7V83ZgRzt4468jcQVYQtwgl3+80jcsqfUp34bnSXPwn4mq95hsMYKjXR9ONP8pmXao3DLkQcnHfr/qwMKTkNM2WTQ54ZBYQC+GP6YDvM8ulRj0ZRQRq7/fc8tuj/nK3ITKlipQpGdlGTawo17EHfY0JBGR97tuqHS6PRmYAAB+EuMLiryv5JXVzm+QPuGTTsUyrWG5uYgsv38Rv771Cu6lOo4qFPzDyiOcWgfp4YyzBLyPDM+F3ar7U1kGsc6GT6KIWzLnq5Wi1vleK4bfplKZIwyMve/eNrW8SJqEpc+1SPnEkf4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199018)(86362001)(5660300002)(2906002)(41300700001)(4326008)(8936002)(38100700002)(82960400001)(83380400001)(8676002)(966005)(478600001)(6486002)(26005)(9686003)(6512007)(186003)(6666004)(66556008)(54906003)(316002)(66946007)(66476007)(110136005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ry9FeWErTlVXU2FSRngvdkNlSXloaWdSWmk2Y29laVpVVklSdEJVcDI0dUtT?=
 =?utf-8?B?TkhrdUpBSElzSzk0Rnh3MUg1WW1qRFdSNE0xR1ROUTF4VU9ZblVUWFB2Zzhl?=
 =?utf-8?B?bElGM2FnMU81N2V3THNlSEdYa3NLQ3FTZlVSYXcvT0J3dkZaLzJwNkt4NFJI?=
 =?utf-8?B?SDNuQXg2L2FWRVJ4SE9xWnd2U051b25EaE1kRjZCbms0ZTdNRERlaUxHbERU?=
 =?utf-8?B?Ri9hcUpaWFE1VGd6OVh5MTA5WEQvNCtnM2orT2JWKzhsYkFHSkYrcmQ3Rkpy?=
 =?utf-8?B?Y2kzdERNMU1jR0YwNWtrUHJ0Z3NsYVczajNCSGRvZG1xS3VzOHdmbVNtdnRP?=
 =?utf-8?B?dERlbjBIY0pLazlrSk1TaDdheS8wNGUvUWRzNmFjMmZLNkdVb0ZkRVhjakg2?=
 =?utf-8?B?RkluODZIcEpXYlZMUnVjK3JqeFQ3SFJSNmxnNUdLQVZRUFBHeCtwL2l6U2Vi?=
 =?utf-8?B?ZExiUE1tK0xLMlArNXoxeEViaEJ0Mm9tNGVidXRKaXQ4Mk53a3Q2aDdDUGJs?=
 =?utf-8?B?dDlETk1SMENCTmNJaHVQQllYM1JxYk52N3V2QUhhbzRIN0hpcnNmQXJXUkx5?=
 =?utf-8?B?VkZjNnM0Nk9nZkZmZUg1clJlZUJETVNmV3RreUo2THM0b05kOG5mU0pET25q?=
 =?utf-8?B?eFI1RXVXbEU0MlpFOE5icHdqZW9jU3JNSEM1bTkrb2x6ZnQ1azJGbyt2Mzdz?=
 =?utf-8?B?VFVab1EvVjVSWnZ1WUp2dStiWGRkb2FzUFE4WlVjRjNCSmFFWCtkdjRDVWcw?=
 =?utf-8?B?RklWQXNMUTFuOGE1cnNnNkw4SkgrT0ROQk9mMFBwMkp2aXpBb2V4OCtXQWxF?=
 =?utf-8?B?WVQ5a2JaY3pTQWRJc01oTVl3N3lkY2ZlODRuOWloL1dHdDB4a2Z4R2RsTktO?=
 =?utf-8?B?U0hEV3RvNWErNURBbW11WmtRZjZlU1RObno0MUc1Z1ZrdnVXZGRpNk8zZ1dw?=
 =?utf-8?B?WlFGNjUzLzhINWtMQzV3S0Fmc3NDU1djQVpTaGY4WEhQa2ZoVGJidEZvYnlr?=
 =?utf-8?B?NFF2d1RGSUFWT3lxaWVnM0RpOTNkQWU1QlU1ZmhZT3RhRU1lOTZ3RDVWdk5W?=
 =?utf-8?B?MXNUeFJBOG9vL0RYb2VOeWR0SFVIeDQxMDF3Y2IzMHlWOGNGSjJ3OTF5aUEz?=
 =?utf-8?B?Rzhvd3Z0NlAxN1ZsSVFOUS9WMktleDZJZzdhbHZybE9OSlBOR3ZDam1PLzVH?=
 =?utf-8?B?TUlmNUg0ZWJKR3h0bFJ4U21CTkNTdEUvOWFCWCt6SjlyeFdGTzNEYUQwaHRN?=
 =?utf-8?B?dlJNdDJuVGZlU09WTW5FT2lEQVkzVlZWMkJXTXh0RDdzZEUyNStNeERsdm5V?=
 =?utf-8?B?VnZaSUlEY2NRbzQ1MmFCR1IyOFNoUGZhRVkwQXdaMHc2clYwUThCdTFMWUZk?=
 =?utf-8?B?V0JmdXY0eU5ZWjYyS0xWSFRrL0RMZm9SQWZHeGNtMjVEbUk0Vm9vbnlLclRH?=
 =?utf-8?B?RmM3d2k1cjV3Qmg4K2pTRUJkakxnOFkyM2NZTzJvMWd1dTV5WFVUa3NrbjRM?=
 =?utf-8?B?ZEVtK3U2NUl4cFgySW1mdVVRZWRDRGZFT1pSazJhQ1lRYnZmTEV3YzR2Vm56?=
 =?utf-8?B?TWlKd2JneXpyS2U0blFUNEFjWkdvZ2VTTlRaYXpGUUNLZklOVGxCZnQvazRY?=
 =?utf-8?B?WHQrTnF0MlRXUnkyWUVpL0xjM1hGODcvSnVVVkFDakR4eXlMQUNWbGFzWnU5?=
 =?utf-8?B?WU83TmdEZ0JUWGFvbS84cGxtL2NQVlJUT05tb0VNZ0xSd2NTL0Z1cC9RcHJk?=
 =?utf-8?B?ajdkUmFxRHArZURPS1JKaDRCM3kxcXk4eDZkTEFyNkY5R1h0ZEFkOVJnNjVt?=
 =?utf-8?B?cWcvQW1rby8wZ0JrbWx6SkJXZ3JwWlF5TDVGSU5wS1BRVmJMMElmaTFhNERz?=
 =?utf-8?B?d3AwL2lsZ21GbVdIY3oyZEx3cEtqVE40ekZrOXJHWGt4L2lnSEdwZzhKWFcw?=
 =?utf-8?B?b3RpZU5wbWw0NlRqMXBHb205YUN5cEs0TlVsaHBTV205VEhrckdUaEZ0elUw?=
 =?utf-8?B?TlVkNkcrQUhXZEJzVU9mRU4xZEliWHZCYWtSNVBOblcrdDhFMTBxbTJpaEg1?=
 =?utf-8?B?NllpK3NFY2dKTDhFRWk3eGJiT2hzV3RFeGJlTDhLRUxBeU1OQmh4b25RMmpl?=
 =?utf-8?B?a1MvQndRSFg3cGFMdVp4ZjZ5dW1xVEtGZGNlWHdoaFYzaVZ5YVpYTUc0Yi9u?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb09a29-0b96-4d21-e2e1-08db0ebadaf1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 18:39:50.4455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HV0E0H/SWp9RDRywezAC6J8935ZXnOaKaQUpR8vw+gH1EDxrNXCzxErX9FbOAQKetSMpgkHGzDin0LPVwxMram0ysaNzCJXRuHL8pofqyfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6516
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gregory Price wrote:
> On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:
> > Summary:
> > --------
> > 
> > CXL RAM support allows for the dynamic provisioning of new CXL RAM
> > regions, and more routinely, assembling a region from an existing
> > configuration established by platform-firmware. The latter is motivated
> > by CXL memory RAS (Reliability, Availability and Serviceability)
> > support, that requires associating device events with System Physical
> > Address ranges and vice versa.
> > 
> 
> Ok, I simplified down my tests and reverted a bunch of stuff, figured i
> should report this before I dive further in.
> 
> Earlier i was carrying the DOE patches and others, I've dropped most of
> that to make sure i could replicate on the base kernel and qemu images
> 
> QEMU branch: 
> https://gitlab.com/jic23/qemu/-/tree/cxl-2023-01-26
> this is a little out of date at this point i think? but it shouldn't
> matter, the results are the same regardless of what else i pull in.
> 
> Kernel branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-6.3/cxl-ram-region

Note that I acted on this feedback from Greg to break out a fix and
merge it for v6.2-final

http://lore.kernel.org/r/Y+CSOeHVLKudN0A6@kroah.com

...i.e. you are missing at least the passthrough decoder fix, but that
would show up as a region creation failure not a QEMU crash.

So I would move to testing cxl/next.

[..]
> Lets attempt to use the memory
> [root@fedora ~]# numactl --membind=1 python
> KVM internal error. Suberror: 3
> extra data[0]: 0x0000000080000b0e
> extra data[1]: 0x0000000000000031
> extra data[2]: 0x0000000000000d81
> extra data[3]: 0x0000000390074ac0
> extra data[4]: 0x0000000000000010
> RAX=0000000080000000 RBX=0000000000000000 RCX=0000000000000000 RDX=0000000000000001
> RSI=0000000000000000 RDI=0000000390074000 RBP=ffffac1c4067bca0 RSP=ffffac1c4067bc88
> R8 =0000000000000000 R9 =0000000000000001 R10=0000000000000000 R11=0000000000000000
> R12=0000000000000000 R13=ffff99eed0074000 R14=0000000000000000 R15=0000000000000000
> RIP=ffffffff812b3d62 RFL=00010006 [-----P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 0000000000000000 ffffffff 00c00000
> CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
> SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> DS =0000 0000000000000000 ffffffff 00c00000
> FS =0000 0000000000000000 ffffffff 00c00000
> GS =0000 ffff99ec3bc00000 ffffffff 00c00000
> LDT=0000 0000000000000000 ffffffff 00c00000
> TR =0040 fffffe1d13135000 00004087 00008b00 DPL=0 TSS64-busy
> GDT=     fffffe1d13133000 0000007f
> IDT=     fffffe0000000000 00000fff
> CR0=80050033 CR2=ffffffff812b3d62 CR3=0000000390074000 CR4=000006f0
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
> DR6=00000000fffe0ff0 DR7=0000000000000400
> EFER=0000000000000d01
> Code=5d 9c 01 0f b7 db 48 09 df 48 0f ba ef 3f 0f 22 df 0f 1f 00 <5b> 41 5c 41 5d 5d c3 cc cc cc cc 48 c7 c0 00 00 00 80 48 2b 05 cd 0d 76 01
> 

At first glance that looks like a QEMU issue, but I would capture a cxl
list -vvv before attempting to use the memory just to verify the decoder
setup looks sane.

> 
> 
> I also tested lowering the ram sizes (2GB ram, 1GB "CXL") to see if
> there's something going on with the PCI hole or something, but no, same
> results.
> 
> Double checked if there was an issue using a single root port so i
> registered a second one - same results.
> 
> 
> In prior tests i accessed the memory directly via devmem2
> 
> This still works when mapping the memory manually
> 
> [root@fedora map] ./map_memory.sh
> echo ram > /sys/bus/cxl/devices/decoder2.0/mode
> echo 0x40000000 > /sys/bus/cxl/devices/decoder2.0/dpa_size
> echo region0 > /sys/bus/cxl/devices/decoder0.0/create_ram_region
> echo 4096 > /sys/bus/cxl/devices/region0/interleave_granularity
> echo 1 > /sys/bus/cxl/devices/region0/interleave_ways
> echo 0x40000000 > /sys/bus/cxl/devices/region0/size
> echo decoder2.0 > /sys/bus/cxl/devices/region0/target0
> echo 1 > /sys/bus/cxl/devices/region0/commit
> 
> 
> [root@fedora devmem]# ./devmem2 0x290000000 w 0x12345678
> /dev/mem opened.
> Memory mapped at address 0x7fb4d4ed3000.
> Value at address 0x290000000 (0x7fb4d4ed3000): 0x0
> Written 0x12345678; readback 0x12345678

Likely it is sensitive to crossing an interleave threshold.

> This kind of implies there's a disagreement about the state of memory
> between linux and qemu.
> 
> 
> but even just onlining a region produces memory usage:
> 
> [root@fedora ~]# cat /sys/bus/node/devices/node1/meminfo
> Node 1 MemTotal:        1048576 kB
> Node 1 MemFree:         1048112 kB
> Node 1 MemUsed:             464 kB
> 
> 
> Which I would expect to set off some fireworks.
> 
> Maybe an issue at the NUMA level? I just... i have no idea.
> 
> 
> I will need to dig through the email chains to figure out what others
> have been doing that i'm missing.  Everything *looks* nominal, but the
> reactors are exploding so... ¯\_(ツ)_/¯
> 
> I'm not sure where to start here, but i'll bash my face on the keyboard
> for a bit until i have some ideas.

Not ruling out the driver yet, but Fan's tests with hardware has me
leaning more towards QEMU.
