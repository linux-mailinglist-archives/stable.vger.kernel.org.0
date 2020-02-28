Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA161173199
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 08:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgB1HNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 02:13:46 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:54117 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgB1HNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 02:13:46 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 6198A344;
        Fri, 28 Feb 2020 02:13:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 28 Feb 2020 02:13:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=aEzvlAUGJRwKhFXpv2aQYkGgja6
        XIr8r4NKk3nIB2bU=; b=XLbCFfWEUtZE6JHRaV3nCb4G2eaaMiJO8O8cF9EO33N
        rcypElKGTX5N1hMRulJW19yjZxZkCEipkBVepPLBCIMahWi3/VDpA+rjttMh4mmp
        UFTfw4rERTNEnhhifF2qFTpw+OnnYGKBWabe88qo0Bnm2QqZH+4u2um3j/LRa0Cl
        9xqBHQJ34m2bZyQYUBWNRiErnWWfjHJdbv1lLv3hCff5lRFItKNQlqafaKufe2Bw
        bENMoSWqyP5K8hO1gcgHtun99/dAlcjEfgOnd6xFt59NUcKCRE0WkwyQGyvMjTZh
        cQp14dXPlUGxWzeeLpE34LMWoAMq3NP5XjD+HECUSfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aEzvlA
        UGJRwKhFXpv2aQYkGgja6XIr8r4NKk3nIB2bU=; b=w8JH/UTzp3K7LO1SF5vAs9
        584t2NOMcfyizOnGmN+ieN/F/BWtB/hzVKMwdh9Nrnn6SYRbJylMPgehXC7nxrtT
        93/GPb6p6MnSFNJ3xULA2dMve6f/H9zc6hfiXyVsSTBLza/hjb/rR/isOfVEZfZ0
        u+hNkg5pmLiycgEiCuGrI7paV6rHtt1LU03p+mf1JBnCABiBtDbu86x98HZuFVue
        EHrWgZXv6zSf8wH74JWfp9ieJFP6cann0h0GXCaXL6Hsq8nce88wwTubA6zARD87
        12xSy5xGhQBp3j7e0/KRtVGYY9nPpfOpLZns8wYtM9KPwF9Ak3s+jHBiEEnseDNA
        ==
X-ME-Sender: <xms:p71YXq6RGA8MFbhoGbGGu3kaiJP7L9pv8b2GLgR3Xu439HWDr0LwGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleejgddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinheprhgvughhrghtrd
    gtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrh
    horghhrdgtohhm
X-ME-Proxy: <xmx:p71YXibjKtDlAI2rgaYhyaOMUxEOkTwtapD1NRBGGnFgRRkOUWeLVg>
    <xmx:p71YXk8afSNwRKCdkFq1rAhTClwcn9bAOVTDuaotlRjs3lFdRKJbxA>
    <xmx:p71YXhTBNidMoCr_3120X-M8uDwzbTakxwVRLW0LdKgdaD4r-ZeAOA>
    <xmx:qL1YXu5GH_RVrF0ZB7Lgg5w_RsG8FFM9HUKHHSVaMISvOW_6NgawCQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED9EC3280067;
        Fri, 28 Feb 2020 02:13:42 -0500 (EST)
Date:   Fri, 28 Feb 2020 08:10:24 +0100
From:   Greg KH <greg@kroah.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: 5.5.6 regression (stuck at boot) on devices using the sof_hda
 audio driver + fix
Message-ID: <20200228071024.GB2895159@kroah.com>
References: <e15641c3-2cf8-db66-3eeb-019af4b482db@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e15641c3-2cf8-db66-3eeb-019af4b482db@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 08:39:04PM +0100, Hans de Goede wrote:
> Hi All,
> 
> I and various other Fedora users have noticed that Fedora's 5.5.6 build gets stuck
> at boot on a Lenovo X1 7th gen, see:
> https://bugzilla.redhat.com/show_bug.cgi?id=1772498
> 
> This is caused by the addition of this commit to 5.5.6:
> 
> 24c259557c45 ("ASoC: SOF: Intel: hda: Fix SKL dai count")
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.5.y&id=24c259557c45e817941d3843f82331a477c86a7e
> 
> ###
> ASoC: SOF: Intel: hda: Fix SKL dai count
> [ Upstream commit a6947c9d86bcfd61b758b5693eba58defe7fd2ae ]
> 
> With fourth pin added for iDisp for skl_dai, update SOF_SKL_DAI_NUM to
> account for the change. Without this, dais from the bottom of the list
> are skipped. In current state that's the case for 'Alt Analog CPU DAI'.
> 
> Fixes: ac42b142cd76 ("ASoC: SOF: Intel: hda: Add iDisp4 DAI")
> Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Link: https://lore.kernel.org/r/20200113114054.9716-1-cezary.rojewski@intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ###
> 
> Notice the "Fixes: ac42b142cd76 (...)", that commit-id actually
> does not exist, the correct commit-id which this fixes is:
> 
> e68d6696575e ("ASoC: SOF: Intel: hda: Add iDisp4 DAI")
> and that commit is not in 5.5.6, which is causing the problem,
> the missing commit makes an array one larger and the fix for the
> missing fix which did end up in 5.5.6 and bumps a define which is
> used to walk over the array in some places by one so now the
> walking is going over the array boundary.
> 
> For the Fedora kernels I've fixed this by adding the
> "ASoC: SOF: Intel: hda: Add iDisp4 DAI" commit as a downstream
> patch for our kernels. I believe that this is probably the best
> fix for 5.5.z too.

I've done that now too, thanks for catching this.

> p.s.
> 
> I know that the stable series are partly based on automatically
> picking patches now. I wonder if the scripts doing that could be
> made smarter wrt rejecting patches with a Fixes tag where the
> fixed patch is not present, so where in essence a pre-requisite
> of the patch being added is missing ?

Looks like Sasaha's scripts has a bug in it :(
