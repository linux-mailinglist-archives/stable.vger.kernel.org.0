Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916495EAE81
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiIZRtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiIZRtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:49:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8371598CA1;
        Mon, 26 Sep 2022 10:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664212872; x=1695748872;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zspz2i0z+Z0imrLNWG4sSFVlLZv+LKuS0uB03RLTKYA=;
  b=c8Ua2eiflTTaA2aK3JRp7Rc4Mgdig45f5kS1A6AIJKxgpz77AczBTk4c
   L4Vljn0EThIBSzIb46MnTOFa4KRoS5qmmTuVSIgFHCBu2whT895hu1nLI
   yQrnKGRvVN01cEhvmIJZQUQrO3IuiXA8pXqTwDsFZoUYdQ1hJQM6Pk7ED
   BkleGbajbbycgfrq5auTiGS7hQse9Vei9El2cJtGWEWDQo+Nqkx0i4Thx
   OsBQ77pZkuye11rJn5ADhZCHrITzluCCshZm3yi7gyu5CpJPGEYVDr2KU
   +w2imPh+JuRZZYFl/im2IQAXOJdqHiCfq39HDYgsM/bO39PiQHjzg/Ye/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="299812096"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="299812096"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 10:21:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="796418075"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="796418075"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2022 10:21:07 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id AE113F7; Mon, 26 Sep 2022 20:21:25 +0300 (EEST)
Date:   Mon, 26 Sep 2022 20:21:25 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "Mehta, Sanju" <Sanju.Mehta@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] thunderbolt: Explicitly enable lane adapter hotplug
 events at startup
Message-ID: <YzHflTAaNaeeDEkU@black.fi.intel.com>
References: <20220926143351.11483-1-mario.limonciello@amd.com>
 <YzG84WEuVdXxclJB@black.fi.intel.com>
 <MN0PR12MB61015D287945A57D82910CE4E2529@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB61015D287945A57D82910CE4E2529@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 02:54:22PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> 
> 
> > -----Original Message-----
> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Sent: Monday, September 26, 2022 09:53
> > To: Limonciello, Mario <Mario.Limonciello@amd.com>
> > Cc: Andreas Noever <andreas.noever@gmail.com>; Michael Jamet
> > <michael.jamet@intel.com>; Yehezkel Bernat <YehezkelShB@gmail.com>;
> > Mehta, Sanju <Sanju.Mehta@amd.com>; stable@vger.kernel.org; linux-
> > usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v4] thunderbolt: Explicitly enable lane adapter hotplug
> > events at startup
> > 
> > Hi Mario,
> > 
> > On Mon, Sep 26, 2022 at 09:33:50AM -0500, Mario Limonciello wrote:
> > > Software that has run before the USB4 CM in Linux runs may have disabled
> > > hotplug events for a given lane adapter.
> > >
> > > Other CMs such as that one distributed with Windows 11 will enable
> > hotplug
> > > events. Do the same thing in the Linux CM which fixes hotplug events on
> > > "AMD Pink Sardine".
> > >
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > 
> > Looks good to me now. Since we are pretty late in the rc and this is not
> > trivial fix anymore, would it be OK for you if I apply this to my next
> > branch with stable tag? Then it gets slightly more exposure before it
> > ends up in any of the stable trees.
> 
> Yeah that's fine by me, thanks!

Applied to thunderbolt.git/next, thanks!
