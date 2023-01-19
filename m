Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBB6672DFE
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 02:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjASBS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 20:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjASBQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 20:16:56 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DC26B9AE;
        Wed, 18 Jan 2023 17:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674090914; x=1705626914;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=F3j4WYUKtjwAusS3UzBuLRWoUhMz7lT7SpNon4azC+s=;
  b=BgVz6+x1RzUBD70VQWFRTnSPWpm4PzV3bq5LJmOu6qQnFdUiNoYErcDN
   02Wifxe5MFPq2Adk4yZ4ljoS6r3PK6jfO4OmOeHEbaBuZYNZ/3r19ELFf
   CAtFYq6Li6XMh2mUklt3O83+6JJAYcbcO6uUxorIbIvnIIpADh47wx31j
   Iceac8zYXnA9qrXyTYkEQho8I5xlwLeR501f/wOq6/zhuICXRRD2jJKDz
   ecxpGoFWrR7q8Q8b9uckeLmdgyfMwLHKAyH9yAf1Ja160mU5fWh5jVE3e
   ltWrgYpqREJ3xZhVo5wAuM/uvSn1UClwEbCR0LvYdYXaV5K9Wh0v3C9j9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="322845615"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="322845615"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 17:15:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="767992839"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="767992839"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 18 Jan 2023 17:15:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 17:15:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 17:15:10 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 17:15:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/ut/yAw0v4SdK2TNc7ycQd0YsceWpg4RKMKsjwq67isCB0ANA81yJOdbuBnYzfYRavXPwj2bvDIR8lddrqot78qwIC49hiT4DKEve9LZyNPVoYIs8MRuAarVcFZrunQnDx5DaAIpJcfKaLXnzrayzlb8YzJSwc2xFCPCZDfodRR6Q9RgJVDKxF4IQvkP96HWnO8N6QZndVcjklvA/Am0daEJPzWV7kHBj3gnHs4VRogzMwe6VpHDHaSYM9AJ/Z7SkmJQMy84BfDzlZ5lVXY2CyWyYYNUEtbFjjPi2E+w+f6pbL3cUpQLdmVn0qEPOHPWv/ckGd/z8ohiDT2uuMWWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHtAoOg2JOPjEm2Q+baBVSetLZrz/Vd8SDfZNy88ilA=;
 b=Vr32sHYO/Rvi97FO5OqeTSqHe0jTQBAZbLrMPpOQ9imwT6Qjfo0YMMrrTz3PbvIYPpuZHDTSHnsOcrXg3ASIXv8QsslmqRzA6y0O3bKipUDiKoM3KH1CKk636WPYBhehlXaDDtzYpyxXEDwvbl0aGCAaTVRpujt7KTItodkrqKQh4c53HWE80Us6QCqc61QPZ6zU3NAlkXkOFUOvX7d6LG9pdCEr8QHblTbOR1UAxQpZFWyHuMh1AV1Ynjd6VuuaZeLZhFm/m9vqFJUcvY5fzEVB3Yrvu2jGEIwe1PSsd5UHhpiV9XIM4Gio+FMBWOYPc5lQnaZd6LgAbJhEEWW7mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by BL1PR11MB6025.namprd11.prod.outlook.com (2603:10b6:208:390::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 01:15:08 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::593:877e:dd33:5b7a]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::593:877e:dd33:5b7a%5]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 01:15:07 +0000
Date:   Wed, 18 Jan 2023 17:15:04 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Petr Mladek <pmladek@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Petr Pavlu <petr.pavlu@suse.com>, <david@redhat.com>,
        <mwilck@suse.com>, <linux-modules@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <20230119011504.q23askbtbwzwmica@ldmartin-desk2.lan>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
X-ClientProxiedBy: BYAPR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:a03:100::37) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|BL1PR11MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a00358b-7543-4f39-3f44-08daf9ba99ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WSnBq3bMKIYlq0H8inbTGNZByBcOrQeDQ4Pp4fzeQ2cqTr+VhRvAhmcaRqi2u08koqVmyGnv9LFjUkpFWJsawkXRJBlxkOMQG/+SJZCPcbewosmiY5+R5OhYWECHtHnDA826Sjd0T/kbNRTNW3K+hNZiN9ivlOURclD/1GXdnQiIZ2fYeYpzculWjc2mUcOJ09yJ2iBNu3i6tdxeSmgTgQMU0vOTf9m3R10hXQ3EnJfy+8x0gCX/VtSxAiev4s84YArXfNKhG8s46q1YGgRcB9V33JKAYJ5gwtiR2eJvsD1PtA6gXaS4jbn2g4zqiqmrHBN6tqvxNpdhOfwokfHYyz9WNLJuPkDlrtkA2VHT1Kjp+fI0H9697Q6mi/o0Q8GHumoCba+Xp3YM2o3neOPaRxlwXylnIHQwbyk8d7cADn++rFTygajVw39KamKuVlpMwvJO0Q1T0zyG/3drqfkEf3Qaypf+GUTTAX/WMXMCnm2/kekKnH4vXtMUtiEjdYE6uDy7IYAnuGIcDqANbuUkhH704Wm5vyOf+uVE74n4MBZgp3jGmiMh3osDB31MnErV4z+YpF68V/zzbOvo9L0Af+KPkxdiu4pMmnIquDwjKrBxH52RuAXXVf3ysWriA5IjAVTN0YRF/Vo7GxcjYek8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(26005)(82960400001)(66556008)(6486002)(41300700001)(478600001)(6512007)(186003)(1076003)(86362001)(316002)(54906003)(38100700002)(66476007)(66946007)(66899015)(36756003)(6506007)(2906002)(4001150100001)(5660300002)(6666004)(7416002)(4326008)(9686003)(6916009)(83380400001)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cTjgFOULhw7Z8n1RDfLNFS/74ZPYAgctGqRkD9YYEFoNbeFyLhOhPHF48/gD?=
 =?us-ascii?Q?ZTp9La5UYwa2U+hWlmXwApA5Ue/NLB0+IApjD4XumYr5od3xzl7/Yksd7fyv?=
 =?us-ascii?Q?WrShtB9GooDKDOavMplUg+ihszW59vf0SS+uz/Y+vYhv+l5XIOkWizeFu2F4?=
 =?us-ascii?Q?yjM5mHGncLBBENMftU4zBEnyRIrs1dfAPTHzlKlNSjkgxf29c93lDiqlZIYZ?=
 =?us-ascii?Q?l6I/owHUbBMGFVOIrirdfCG+ibz7kiLNVdTpuvY1YyWC5SSpJxWNnvSYe+qC?=
 =?us-ascii?Q?9y/phzG8XL9C6vxEu95RjutuLnd2QKXCPdheCbeXXTpLLdTVCYTQilckZ0mB?=
 =?us-ascii?Q?bJzOwdZcU+qwyQNNPezPxmHlfnGMqbR+o7s7UG7K5C5EQFAM3U+og8hRSTIP?=
 =?us-ascii?Q?ptDNWG0E59Akr/2uJjbCtqvYe7LHHLx/ibmEoH9LDVLvdnbm9qGY84JR5W1o?=
 =?us-ascii?Q?1qsABZ+s5hDfdeR4kq+YxG3bhii48irF7ST6hLCSkrlt05q77X1fov0MTbDI?=
 =?us-ascii?Q?MWJrLK7cl2XevtptRfkhe+iRPT7qwHTBI50DVl9XkkIzzfdYfaAGSAepFaQ9?=
 =?us-ascii?Q?kfSkZ6iqSzUQbBQTj0gdD5aSyLcD2jhttXTmS8APcBrwNqK1Wz4QFONNzDzF?=
 =?us-ascii?Q?h8Hhd3CQAkeDwCF+vGv25rIRxabvtDv+k6LL8DKzH65WbCTOgt8AV/x+/+k/?=
 =?us-ascii?Q?43bUfXgvZU9+/9WtFqQ2ec3WEPv1pYFtVEgaa3I43uyexoOTiEfPBweoANNw?=
 =?us-ascii?Q?Vn34SvKAHyuwDvX/UVqIBndvO3M6lSH1MH+Vny0Cwsu7i9yZ3aAxP6zkHSxL?=
 =?us-ascii?Q?8dQDmMp9IfKtrL8JGvE9SePhSAxZRIP154MOP8ryVy5CbLx3qjNlGnPCaFXD?=
 =?us-ascii?Q?ofDAxQ7OI1HfjefkdHAwbSIUkBIfyWjwGn2/5Fy0pJ61EP1Mt8iXzydjIoHY?=
 =?us-ascii?Q?GHXuVoW6k6VuwRd5fh+xCcXPDQh+m0jCSy+jBWcICRwmuVn/R9C82NkURPqY?=
 =?us-ascii?Q?NUGJn6pniSjVi3e2lkGIdb2+u3EQSam/il39NK7imiJ4nyAYX3L5W1p/NLhe?=
 =?us-ascii?Q?sPxGhqALVSDB3E3nI/sRtD4ArXw6vu3iOQ3NxK6RNgFKc2by6yf1jq4r0/Bf?=
 =?us-ascii?Q?oSUeY6zmcKVTCFXr1+LVHJrMvkLQlVK6+wi0k7o6JggwLxJEOcaSANNThRix?=
 =?us-ascii?Q?xj7I2jnry5eHUXeG8i4VNExgk3Hi7RzrOgJ/AoW3Luum2KMNEsdReITgB0Oj?=
 =?us-ascii?Q?Y2oC7krydx69dIz/0ABi6UUo0lEdM3xu7e/lY8Q+csqL/akdX2jfCjJz5OSc?=
 =?us-ascii?Q?VLdyTcJWoaOT8/GGIJ53rlOxnxxcVTklk7wx2ijoFGbCxkB0PRcDjxeln20C?=
 =?us-ascii?Q?/3kl42HG4cWcqMD/r+4/FRMiYB6xUBCAytBE7BEeLjc6lAlV89bd6Y+neQvq?=
 =?us-ascii?Q?DmQX2dSwMxaWflUG3yZZtGnHsckEk1HOIPTjqlic7E6jqAiu5jaBu3M1T8k6?=
 =?us-ascii?Q?N6uPZgWQfF98aqBAoWuQLCNoho93lX1jWkvvHn25/7lH+GS9pe26WWqRa0Gf?=
 =?us-ascii?Q?v7GV01TGr+27vc/AzvpnjKfo5ExoCzN+IgpBnF1eOZFbpMgph5LHVrXWEZai?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a00358b-7543-4f39-3f44-08daf9ba99ed
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 01:15:07.4336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdKpcwpBks35TDa+lQ5lZ+ewTFsXC6ypS9k280CBr49Ov4USWX6d6FJf0tWFI0q3XOoQ3hkX9ZC0/TruOzB44CbDaviydJuN5T1CLlRqD5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6025
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 04:04:22PM -0800, Luis Chamberlain wrote:
>On Tue, Dec 13, 2022 at 11:17:42AM +0100, Petr Mladek wrote:
>> On Mon 2022-12-12 21:09:19, Luis Chamberlain wrote:
>> > On Mon, Dec 05, 2022 at 11:35:57AM +0100, Petr Pavlu wrote:
>> > > diff --git a/kernel/module/main.c b/kernel/module/main.c
>> > > index d02d39c7174e..7a627345d4fd 100644
>> > > --- a/kernel/module/main.c
>> > > +++ b/kernel/module/main.c
>> > > @@ -2386,7 +2386,8 @@ static bool finished_loading(const char *name)
>> > >  	sched_annotate_sleep();
>> > >  	mutex_lock(&module_mutex);
>> > >  	mod = find_module_all(name, strlen(name), true);
>> > > -	ret = !mod || mod->state == MODULE_STATE_LIVE;
>> > > +	ret = !mod || mod->state == MODULE_STATE_LIVE
>> > > +		|| mod->state == MODULE_STATE_GOING;
>> > >  	mutex_unlock(&module_mutex);
>> > >
>> > >  	return ret;
>> > > @@ -2562,20 +2563,35 @@ static int add_unformed_module(struct module *mod)
>> > >
>> > >  	mod->state = MODULE_STATE_UNFORMED;
>> > >
>> > > -again:
>> >
>> > So this is part of my biggest concern for regression, the removal of
>> > this tag and its use.
>> >
>> > Before this we always looped back to trying again and again.
>>
>> Just to be sure that we are on the same page.
>>
>> The loop was _not_ infinite. It serialized all attempts to load
>> the same module. In our case, it serialized all failures and
>> prolonged the pain.
>
>That's fair yes. The loop happens so long as an already existing module is
>present with the same name.
>
>> > >  	mutex_lock(&module_mutex);
>> > >  	old = find_module_all(mod->name, strlen(mod->name), true);
>> > >  	if (old != NULL) {
>> > > -		if (old->state != MODULE_STATE_LIVE) {
>> > > +		if (old->state == MODULE_STATE_COMING
>> > > +		    || old->state == MODULE_STATE_UNFORMED) {
>> > >  			/* Wait in case it fails to load. */
>> > >  			mutex_unlock(&module_mutex);
>> > >  			err = wait_event_interruptible(module_wq,
>> > >  					       finished_loading(mod->name));
>> > >  			if (err)
>> > >  				goto out_unlocked;
>> > > -			goto again;
>> >
>> > We essentially bound this now, and before we didn't.
>> >
>> > Yes we we wait for finished_loading() of the module -- but if udev is
>> > hammering tons of same requests, well, we *will* surely hit this, as
>> > many requests managed to get in before userspace saw the module present.
>> >
>> > While this typically can be useful, it means *quite a bit* of conditions which
>> > definitely *did* happen before will now *bail out* fast, to the extent
>> > that I'm not even sure why we just re-try once now.
>>
>> I do not understand this. We do _not_ re-try the load in the new
>> version. We just wait for the result of the parallel attempt to
>> load the module.
>>
>> Maybe, you are confused that we repeat find_module_all(). But it is
>> the way how to find the result of the parallel load.
>
>My point is that prior to the buggy commit 6e6de3dee51a ("kernel/module.c: Only
>return -EEXIST for modules that have finished loading") and even after that
>commit it we 'goto again' if an old request is found. We now simply bound this
>right away. Yes, the loop was not infinite, but in theory at least a few
>iterations were possible before whereas now immediately return -EBUSY
>and I don't think all use cases may be ready yet.
>
>> > If we're going to
>> > just re-check *once* why not do something graceful like *at least*
>> > cond_resched() to let the system breathe for a *tiny bit*.
>>
>> We must check the result under module_mutex. We have to take this
>> sleeping lock. There is actually a rescheduling. I do not think that
>> cond_resched() would do any difference.
>
>Makes sense.
>
>> > > +
>> > > +			/* The module might have gone in the meantime. */
>> > > +			mutex_lock(&module_mutex);
>> > > +			old = find_module_all(mod->name, strlen(mod->name),
>> > > +					      true);
>> > >  		}
>> > > -		err = -EEXIST;
>> > > +
>> > > +		/*
>> > > +		 * We are here only when the same module was being loaded. Do
>> > > +		 * not try to load it again right now. It prevents long delays
>> > > +		 * caused by serialized module load failures. It might happen
>> > > +		 * when more devices of the same type trigger load of
>> > > +		 * a particular module.
>> > > +		 */
>> > > +		if (old && old->state == MODULE_STATE_LIVE)
>> > > +			err = -EEXIST;
>> > > +		else
>> > > +			err = -EBUSY;
>> >
>> > And for all those use cases we end up here now, with -EBUSY. So udev
>> > before was not bounded, and kept busy-looping on the retry in-kernel,
>> > and we now immediately bound its condition to just 2 tries to see if the
>> > old module existed and now *return* a new value to userspace.
>> >
>> > My main concerns are:
>> >
>> > 0) Why not use cond_resched() if we're just going to check twice?
>>
>> We take module_mutex. It should cause even bigger delay than cond_resched().
>
>ACK.
>
>> > 1) How are we sure we are not regressing userspace by removing the boundless
>> > loop there? (even if the endless loop was stupid)
>>
>> We could not be sure. On the other hand, if more attempts help to load
>> the module then it is racy and not reliable. The new approach would
>> make it better reproducible and fix the race.
>
>Yes, but the short cut it is a userspace visible change.
>
>> > 2) How is it we expect that we won't resgress userspace now by bounding
>> > that check and pretty much returning -EBUSY right away? This last part
>> > seems dangerous, in that if userspace did not expect -EBUSY and if an
>> > error before caused a module to fail and fail boot, why wouldn't we fail
>> > boot now by bailing out faster??
>>
>> Same answer as for 1)
>>
>>
>> > 3) *Fixing* a kernel regression by adding new expected API for testing
>> > against -EBUSY seems not ideal.
>>
>> IMHO, the right solution is to fix the subsystems so that they send
>> only one uevent.
>
>Makes sense, but that can take time and some folks are stuck on old kernels
>and perhaps porting fixes for this on subsystems may take time to land
>to some enterprisy kernels. And then there is also systemd that issues
>the requests too, at least that was reflected in commit 6e6de3dee51a
>("kernel/module.c: Only return -EEXIST for modules that have finished loading")
>that commit claims it was systemd issueing the requests which I mean to
>interpret finit_module(), not calling modprobe.

just a comment on this, if it helps anything: commit 6e6de3dee51a says
systemd, but it would be more accurate to say udev or systemd-udev to
disambiguate with pid 1.

udev uses libkmod to load modules so it's pretty much the same logic as
modprobe.

Lucas De Marchi
