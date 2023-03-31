Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7053F6D288F
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 21:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCaTPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 15:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjCaTO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 15:14:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAFD24413
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 12:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680290093; x=1711826093;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OLV1Hjm0t/pIH3hAYbxSZuOv+HypCS6RDa8vT39pX90=;
  b=dM0Z1shdnF8eN9Kg9fSNcqAIyC5ORiecN5B8dvkSJlDEN00aVbH8sSRo
   gl5tEXx0oQJXOU/uAtOvIKhxbgWcGTYQVRDgKZWXHnCXRnHJE6S5Wf2HV
   LWJpwMpO4rGyPk7XxjwqUzA1296O9rii6MZu5tERox1sJ79h4sxfKyl9r
   U0OnOVPDnrWO4452KDDATa1wugwTxDECVp5WuWr9swjYU5KqJ/xSlHhC2
   KETEOS38wZqysvazMFjVXzQYHquqqKvwBdcOZDVBD9BTUeOCVNEuqWfWn
   pPJvZBtbfL4QYWLns8iShw3hpZnd6keCXYWA0l3lecZlVA8mm+70aARJl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="339036792"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="339036792"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 12:14:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="749734034"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="749734034"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 31 Mar 2023 12:14:52 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 12:14:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 31 Mar 2023 12:14:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 31 Mar 2023 12:14:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnfT5laPwkrENKgPh3GCIN7e1514vw24vSePh78lBLbL3GnpsW39LZAK0T5BIIhlNVl2P2KK4gTIu3EzZTtJfioHtNz9umfsNjH6u19QzMp7wFw/m6dx0dN8n5oJ7pyx2WqerAh/jzIUvbArDgax1S8GfgCYe/L9ckv+VVSZfmtAdNmcXKFxiAlnbZXANCdaEtAVOA7gDypumqyQmhqWDQtr6ppjk2UtZ8Nxql54gEtuJwRWDJn23kfLt7NMKluGmUcjx4zeItwrtYixo0DtQi/4py4SG9YraEX22Y/8LboEokzNyfEDKgDDOxKAHhIm+NhdOOdCA/WM68ZDQzWIJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flm4jKX0ldkSLWOdK3u3h1gw4oziIRQO7zmMWxJhP+E=;
 b=NP0HC0X+BQ8Jo8Bs3lZQ8rVQsFI7lzt6co7klLORFHxQTJMGYPAqiP624Hp67yxBbxIlG6EaVC7lRKsL74gwujFzARyGp28kIu4zWJ5r7SRJMWCjNgRabGkAPJNs6yKrXiKORgOGxY65/ZhqR6DX6d1La5nCw7iWVJ7aug1/xLf09hUQasQRvj6QHJjDroZZnO4G2/yJU7GigIQNWAl96lE0F1B4C+0aRT3ooySaNKN1+T+q4VhCjij9scANDrzn+do/Zy1D6IE1LUsbNIURTd9iXzF34/Z4KVS14xJ9GtRtS27B7zU3HOPPoqQn6KVbhPOBoIbQrh8zihCB8URvrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB3911.namprd11.prod.outlook.com (2603:10b6:a03:18d::29)
 by DM4PR11MB6309.namprd11.prod.outlook.com (2603:10b6:8:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 19:14:50 +0000
Received: from BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::1510:9541:e6ac:fede]) by BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::1510:9541:e6ac:fede%4]) with mapi id 15.20.6222.033; Fri, 31 Mar 2023
 19:14:49 +0000
Message-ID: <ba2e49ea-d1a4-bf77-dde5-f92c6600cb4f@intel.com>
Date:   Fri, 31 Mar 2023 12:14:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH] [i915] avoid infinite retries in GuC/HuC
 loading
To:     Alexandre Oliva <oliva@gnu.org>
CC:     <intel-gfx@lists.freedesktop.org>, <stable@vger.kernel.org>
References: <orjzzlhhg8.fsf@lxoliva.fsfla.org>
 <b9a2746f-bace-3a1e-eb82-8e8eecddb6ae@intel.com>
 <or1qlbvo9b.fsf@lxoliva.fsfla.org>
Content-Language: en-GB
From:   John Harrison <john.c.harrison@intel.com>
In-Reply-To: <or1qlbvo9b.fsf@lxoliva.fsfla.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:a03:254::15) To BY5PR11MB3911.namprd11.prod.outlook.com
 (2603:10b6:a03:18d::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB3911:EE_|DM4PR11MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: 61c0e082-c28a-436e-bc29-08db321c32b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xoAihfrPt8Wrz9K2DWxVRmHNWi1AWtylsaiH4X8cdRDxXdMEXFQLQMDDQyemU9ECyeTF0toV94MfHWToX3bNbTEsdr/EeBOJv9aI9+V1z0sdNWygLyaFfYIrJFjcfrk8XZu6v1FzG+RXMfqWibY6s2mOG7BBsSqU06aKqvu9HDdyx3GNRl/nISZQ2bsjG8NoUIfc99svIwEA0JKy5DT57eW5y/gdS3T186vg7RpNBfPG4gvLNSE1N8M+uQEp3yHsgVk5kdnEm3RAFEkmKwir/uKbdFu0s1MH6CIIhSMI4CzY6K7duN1MLoXC1d3IeTtUK+ITP91wKlu6F50aoVKxumJfB0qrRp3kg6CSBgmkGBsL/VBZIQVRs4pUeFJMirTQSvin+RO1ee2vlfTq9BuLFmY0BjboUKHqvewMbg+O8X8Zm/Cj1k73i97f8loVgpUyHM+UsNTl88mTAZOxpbwY9PQcvsb0XtasmR/z1CfhqmlIkVG833PbcZNxg+XRSU3z3ujux78PZEnqsYeiea8M1iijI/03petv1KVbNnFVMconVc7TD4BtQE48jzbB/hPd32flCP6EADhIXJxICU4I1DOlsfwrRUw8EuZVKUqzz2TYM0qHppg9EwZiGmkBYJYIxup4ekSuyIlOCZFUUiBRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199021)(2906002)(186003)(53546011)(26005)(6506007)(6512007)(36756003)(478600001)(316002)(6486002)(5660300002)(66556008)(31696002)(82960400001)(41300700001)(66476007)(66946007)(86362001)(8676002)(4326008)(6916009)(8936002)(38100700002)(2616005)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnVhUGxON3ZET29peVhCcTBOUVAyc3Q3dlhxbEpzNzVYWWVjRUZKTlhnMVVk?=
 =?utf-8?B?TkdtbkxBNGVtN1plcDNBZmFPZ1FpL0tlWHVaZVRVV09pWUJ2VnVWWURJbmJk?=
 =?utf-8?B?VTVKQll4dlN2cmlTOUQxdk1hQXdqM3FuRU5ObEIwQ0RGY29WTXB6S1dKRmhx?=
 =?utf-8?B?amRYZlF3UTJSMkZQT2hzeDNNR09SSVVTZnlLclZwcW9QZHlZWDdhZkY5bnJG?=
 =?utf-8?B?RTUxdi9rUXAvUyt2aUdWMEVFUExQeFFyOGlnQUhOdHk0S2hoZXRJZ2xsK2lN?=
 =?utf-8?B?V1lMWjFicTR2M1BwZzhicy8zcHlET01uRWt1ejdBYVlOUHQycTFISFFpL3RR?=
 =?utf-8?B?dEM4WDIwNXpjVFdCeXFMYk01VlM5bldkZXB6eCtad1BMbnZuRlF4N2VTdmtO?=
 =?utf-8?B?cG1tclJETVNrMWRKamhLK2hwUCtuZnpqWFFmakUyZWFNUmZTb3F1S0c4cUli?=
 =?utf-8?B?L1NaVE5pN0pQQjU1ellEcDZBd0R2L0p6bG5pZCtGRnU1c3dTOFJjSGh4TEdy?=
 =?utf-8?B?RkNqSDJuais4RmlhYjVkZGpxWGtEa01TT2ZqNmdwTVhMSzRLUnkyK2lyRkVU?=
 =?utf-8?B?KzdaM01COGFGVzVOSXlYZmFuUHZ6VkNROGpRZEU0WnVSbmR1RkQ2UGg4Y0Fq?=
 =?utf-8?B?WDdiSXB3dVUzMzcyQW9ZSjJhWHpqM2poaUdLMWJyTlp5OU9oSmZmb1RUY0Rt?=
 =?utf-8?B?ZzVjRjNkT2ZyblZIV1V6T2Q3eGNGRGNoQ0IwTVF3WnN6YVh4Y3VDb05BaE1U?=
 =?utf-8?B?ek03cWxadEhvZzhqempJbHBCSmtBVjd3cjYwVFlFWWNiaHQ5aEZuNFFSVjdn?=
 =?utf-8?B?ZXFIMFJvazBDQ1hIQjZRRERzdTZNZklyd3RIZnhHdmZUTWUxNWMxblhwb2pJ?=
 =?utf-8?B?TkhibjkweUI2RVVubTM2WnU0U3BDd3A4T1VGeGo0Z0NBVHgrYlQyOGNVaXZ0?=
 =?utf-8?B?TXBXajcyeisybTIxcmpMVGpOcE16cXNxQml6eUorRGV2cklRSDJnYlJpNjUz?=
 =?utf-8?B?T2dwQXcvbWlaZGVHbmpkQkFNZmd0REZEN3N2VDIrdU5yREZWNC9qTGVwMTd1?=
 =?utf-8?B?cEVOQnF4TDAwL3FsTVpFNUNtUGhkd3pOY296WWhhUjZuSTBVNnRnYnBvaytL?=
 =?utf-8?B?RWdZbWhvSS93YXNPRkxJVU5TUFVnb0J4STluYW1MMU95QTA5S3h4UDlVeVVv?=
 =?utf-8?B?cXRGTklVOXFhVlJYYjNRWlhBZXZvL0w1NlU3RzRpNHkrb2FsUXZFeVlxKzVx?=
 =?utf-8?B?aStLRDQwVlYyUjJLSmxybXM3K0g4OTMyd1dMT0lFdWFKd2FFSzhTNk9KeERI?=
 =?utf-8?B?VldidXJTRXpQQzlJdGt6QjkrVlFEUnVVSjl5bDMwZTBOTTNrbHdoV0xoM3Vi?=
 =?utf-8?B?dzg0ZjdWT2FaQzZxL3JuNThMVlZueHF4QkhTVGJDaHYvVFZPaHkvM1hpbUZa?=
 =?utf-8?B?bTdpcWRBeFRyTDVwMzNQeENvMWIwa0dKWnUwQ0ltYk42R1lJd2gxMXVyY0lj?=
 =?utf-8?B?VFIyWWQ2VndhYTNGMkhKc0N1TDVGR3lDOGdlNnY4aXBWYzNZeWp6L3pUZVBV?=
 =?utf-8?B?U2QrSGNPbU1YTm1XdWVBQURnNDRiYXVQUG93ajJsUktpeHBNd1M1emhQbGN0?=
 =?utf-8?B?UEZpRzNWSmd1T3JOdFc2NnpMdGNSeXc4SGNxamE5UFpOb0tUSzFKRFpRektI?=
 =?utf-8?B?ZzZIcUl1aGVrcm4wY2RDbXVLK1hSN1loendHZkl5ZCs0bmpSbmVsekQ2RzNY?=
 =?utf-8?B?VzVIK0tNcFlXUmFtMlBCdHdnV3NtR1pYRWFyNjB0MjdvWkRLcHUybmh5SmVZ?=
 =?utf-8?B?K2xwaUxQNU0vN3N0RUlVMnhiMlVPL1dNbWVKSDBKR2E2dFYyZ0d0UnRYZXhV?=
 =?utf-8?B?VkJzRWNmS3JmRjhuUlp0WUpiNDVna1o0L2Fhdnhqbm9rZHVyU3VucFV4a2xG?=
 =?utf-8?B?Y0pTZUp1a29KaHFqNC9wYzkrdUw1TC96RnIyVUxYQ2lJVHBDNmQ2V1VGWXFM?=
 =?utf-8?B?a25sbWRFKzhscFBqK3poSU40eVp0U2pQbWExVWZNZTFRNENnUVAwcHNLTW1o?=
 =?utf-8?B?bFVKbExVdGQ1SFVId0JCRlBYQWxjdVFaTE50bnRrUXdpZUhSeUFDenh2UFpn?=
 =?utf-8?B?bWJ0OUNlSlFVY2JvYWxLZzdBdUlraXQ4RTlHaWxUbURqbzF4UUw0eXFucjBo?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c0e082-c28a-436e-bc29-08db321c32b7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 19:14:49.6192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bGSF+C9n8OCnEqGIjRlwsVrqTrvqdeqLFkstsR74J6fg5z47xnO/0iMTPDR2VD5WJa3rIDWYR/amHETP1BgduyFofDeH9mkyQDUVui9ovAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6309
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/26/2023 02:46, Alexandre Oliva wrote:
> Hello, John,
>
> On Mar 24, 2023, John Harrison <john.c.harrison@intel.com> wrote:
>
>> On 3/12/2023 12:56, Alexandre Oliva wrote:
>>> If two or more suitable entries with the same filename are found in
>>> __uc_fw_auto_select's fw_blobs, and that filename fails to load in the
>>> first attempt and in the retry, when __uc_fw_auto_select is called for
>>> the third time, the coincidence of strings will cause it to clear
>>> file_selected.path at the first hit, so it will return the second hit
>>> over and over again, indefinitely.
>>>
>>> Of course this doesn't occur with the pristine blob lists, but a
>>> modified version could run into this, e.g., patching in a duplicate
>>> entry, or (as in our case) disarming blob loading by remapping their
>>> names to "/*(DEBLOBBED)*/", given a toolchain that unifies identical
>>> string literals.
>> Not sure what you mean by disarming?
> Our users find loading nonfree firmware harmful.
>
>> I think what you are saying is that you made a change similar to this?
>>      #define __MAKE_UC_FW_PATH_MMP(prefix_, name_, major_, minor_,
>> patch_) "i915/invalid_file_name.bin"
> Yeah, that's the jist of it.  The name we use is "/*(DEBLOBBED)*/", so
> that it can't possibly be satisfied.
>
>> So all entries in the table have the exact same filename.
> *nod*
>
>> And with the toolchain unification comment, that means not just a
>> matching string but the same string pointer. Thus, the search code is
>> getting confused.
> Exactly
>
>> I'm not sure that is really a valid use case that the driver code
>> should be expected to support.
> It's most certainly not.  As I wrote, I'd be happy to keep on carrying
> the patch that adjusts the code to cope with our changes.  I just
> thought the same issue could come up by, say, mistakenly applying a
> patch twice to add support for a new card, a circumstance in which one
> might not have the card readily available to try it out.
Not following this argument. You can't add support for a card that you 
don't have access to. GuC firmware is produced internally by Intel so it 
isn't going to be added by some third party person. And internally, we 
have CI systems up and running for each platform before the patches to 
support that platform land in the upstream tree. So any such error most 
certainly should be caught by pre-merge CI.

>> Even without the infinite loop, the driver is not
>> going to load because you have removed the firmware files?
> Oh, no, the driver loads just fine even without those blobs, and that's
> much nicer of you than other drivers for hardware that doesn't really
> require blobs, but that insist on bailing out if the firmware can't be
> loaded.  i915 hasn't been hostile like that.
That situation won't last...

> When you override the firmware filenames, and it fails to load, the
> driver makes it a (reasonable IMHO) hard fail, but when it just fails to
> find the regular firmware files, it's nice that it proceeds that does
> the best it can.
>
>> However, I think you are saying that the problem would also exist if
>> there was some kind of genuine duplication in the table?
> Yes.  Not the kind you mention, for different platforms, but an actual
> duplicate entry, such as what you might get if you applied a patch that
> added an entry for a new card, and then applied it again, resolving the
> conflicts in a way that retained the duplicate entries.
I would consider that a bug that should never make it past either 
pre-merge CI or code review.

Also, that is what we have the table verification code for - ensuring 
that bugs don't creep in to the table. So if you have spotted a hole in 
that verification then I do think it needs plugging.

Unfortunately for you, I think that is the best way forward for 
i915/Intel. Enhancing the verification step to ensure that such bugs 
can't happen before it gets to do the search. However, I think there are 
easier ways for you to modify the driver to prevent firmware loading. 
E.g. rather than modifying the table, just force an early exit from the 
loading code itself. And if you really do need to remove the firmware 
files from the compiled binary completely, then replacing them with 
unique names would also work - '/*(DEBLOBBED_1)*/', '/*(DEBLOBBED_2)*/', 
etc.


>
>> So there can only be a problem if a single platform specifies the same
>> filename multiple times? Which would be a bug in the table because
>> why? It would be redundant entries that have no purpose.
> Agreed.
>
>> Note that I'm not saying we don't want to take your change. But I
>> would like to understand if there is a genuine issue that maybe needs
>> a better fix. E.g. should the table verification code be enhanced to
>> just reject the table entirely if there are such errors present.
> Table verification might wish to detect and report duplicate filenames
> for the same platform, to catch even alternating duplicates (e.g. "a",
> then "b", then "a" again), but it would be kind if you didn't make that
> a hard error, otherwise we'd have to tweak it to cope with our own
> "/*(DEBLOBBED)*/" duplicates.
>
> Another approach, that would probably be more efficient as the table
> grows, is to store in uc_fw a pointer to or index of the current or next
> entry to be searched, so that the code doesn't have to iterate over the
> table at every try (O(n^2)), and instead takes it from exactly where it
> left off, running overall a single time over the whole table (O(n)), at
> the cost of a pointer or index in uc_fw.  Then, duplicates in the table
> wouldn't matter at all.
>
>> Also, is this string unification thing a part of the current gcc
>> toolchain?
> Yeah, compilers and linkers have been unifying (read-only) string
> literals for a very long time.
That's what I would have assumed. Which is why I was confused that you 
were saying 'if you use a toolchain that does this'. It seemed that you 
were implying that most don't and this was a special situation.

John.

>
> Thanks,
>

