Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481CD638D92
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 16:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKYPj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 10:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKYPjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 10:39:55 -0500
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDE92CCBE;
        Fri, 25 Nov 2022 07:39:54 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id 83-20020a1c0256000000b003d03017c6efso5791852wmc.4;
        Fri, 25 Nov 2022 07:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CLfEu0Ol4ZgCIM6GMFZLdKNFioBS7Wn2cy33xc4Fgk=;
        b=fsTeudvekWBQDelGPR/HS2hagYcUfErYSLu65qns5/86uV9bvZlliWdS7fGlw+z43A
         Dq1KrIv0S4jnoObW3KtIUxR9kvXXGsD0vsLadTZ1BZgcrTdFKfiDbA61h0663UJ9lJ/d
         UXz05ESPGm8/KJySC7nxCPkK3ahpv1oRf9+YEp5RE5wE8ijiZ8EoJOONCNQqmEN975aQ
         KJFnP1slpB63GwwhFTjuQjT1HXwvdG0s3/Yh0IIjFFvKguAPqQEZg86WR4XSObz3c4X/
         AoX/Mq7MsM+gOv5bG24MsBwxX6cDsj+CeBLRPiVhj5vrGSEpN7NhtnWwSh3l7AZdz2Dq
         lTXg==
X-Gm-Message-State: ANoB5plNvvP4pzPfE9Y8wN5lQnY6h4sqQ9BeTiuAjy8TXoPrEUsTn2S+
        1OYb+Q/PKY5ydmAu7CWxXuI=
X-Google-Smtp-Source: AA0mqf5oTQD1Pkojn2mvb3FHJcD28lPaL2FsNVHWj3NUYllPAXUBdSn0nZJxW8R6VwYBEvIBNvH93A==
X-Received: by 2002:a05:600c:5552:b0:3cf:9a16:456d with SMTP id iz18-20020a05600c555200b003cf9a16456dmr30671380wmb.100.1669390793238;
        Fri, 25 Nov 2022 07:39:53 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id a12-20020adfe5cc000000b0022cc3e67fc5sm3868947wrn.65.2022.11.25.07.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 07:39:52 -0800 (PST)
Date:   Fri, 25 Nov 2022 15:39:50 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.0 13/44] clocksource/drivers/hyperv: add data
 structure for reference TSC MSR
Message-ID: <Y4DhxthMYGtYByX4@liuwe-devbox-debian-v2>
References: <20221119021124.1773699-1-sashal@kernel.org>
 <20221119021124.1773699-13-sashal@kernel.org>
 <SN6PR2101MB1693A83DF44A95B439532F9DD7089@SN6PR2101MB1693.namprd21.prod.outlook.com>
 <Y3+S6j4GW0RrHgB2@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3+S6j4GW0RrHgB2@sashalap>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 24, 2022 at 10:51:06AM -0500, Sasha Levin wrote:
> On Sat, Nov 19, 2022 at 05:37:16AM +0000, Michael Kelley (LINUX) wrote:
> > From: Sasha Levin <sashal@kernel.org> Sent: Friday, November 18, 2022 6:11 PM
> > > 
> > > From: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
> > > 
> > > [ Upstream commit 4ad1aa571214e8d6468a1806794d987b374b5a08 ]
> > > 
> > > Add a data structure to represent the reference TSC MSR similar to
> > > other MSRs. This simplifies the code for updating the MSR.
> > > 
> > > Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
> > > Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> > > Link: https://lore.kernel.org/all/20221027095729.1676394-2-anrayabh@linux.microsoft.com/
> > > Signed-off-by: Wei Liu <wei.liu@kernel.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Sasha -- I don't think this patch needs to be backported to any stable versions.  Anirudh
> > or Wei Liu, can you confirm?  The patch is more about enabling a new scenario than fixing a bug.
> 
> Ack, I'll drop both of the patches you've pointed out. Thanks!

Sorry for the late reply -- I think you should keep this patch and the
other one. The other patch fixes a real issue while kexec'ing in the
Linux root partition. This patch is a prerequisite for that.

Thanks,
Wei.

> 
> -- 
> Thanks,
> Sasha
