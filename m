Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A5132CA39
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhCDByX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 20:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbhCDByW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 20:54:22 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CCEC061756;
        Wed,  3 Mar 2021 17:53:42 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id q20so17710324pfu.8;
        Wed, 03 Mar 2021 17:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SgfOqxpUwOnzFw5cQY/+DTc1b5iVCkKKMyH86csg75U=;
        b=fTGsxZ9Jlg9U/OaQ70X0GtIcD/WQjCXrENWYlvtzp4DLhWKmngnxgt2QWjFnhsn948
         UNXLQk/I3KAVN95aNKiit8SKtYgcPQWXVwEAK0RSlRnhqfY1UEpmdz+oa6OY15DElgOm
         EZN63u5CgGSsPEd5ZjrbyFws+ESnIJuSSx6vwP3dYN8y+kTAp09uS8gLZ2szF9IZwcVn
         kDEWfsYyd4ZVscxDNyp7iCBLciAWNnfWqZKVFDCYKKSW9ClclVG5HohgAbiAc8xaSdWz
         awkn6ZC3PRQ4JMW8gif4N2DYh1HKzpzTWIB8v0hwcjAlCuLhUK1tQjBMgB9Y4KtYVvTf
         IXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SgfOqxpUwOnzFw5cQY/+DTc1b5iVCkKKMyH86csg75U=;
        b=G83+EsqvvOPO4a1n3lBQmmkH4aPF2NlHfB8IDQvScgKX6xewsTFsGvWe7xprODvOOh
         Coz2Yb7wack/kqpk3tTrdupWFYEhBE4kQZPhUITD10UyxlWVDvZcABzVZXAcpg/+lnsm
         OrLOMWGtyKzC08qQwDcwRFtqG4ZRPpqhVn/2sLAHLzr5+t2AZbIg0kSFjfkjBa1Qdkt/
         3bHzdiw3YrC0cBBifRq2PNve1SI9GeWBFbdikjdIogkNSHWwAJW2/iiXJ2NXUh6sorNM
         FxNOtaSlBMoNxyyuV5yBiKvyZCTnx6MSmesKewjTXWUZ2sAlou5EY8GIK1GzJI5Ow89O
         gGMQ==
X-Gm-Message-State: AOAM533ZNpZhyEKwXmlms94Da1zMELi7eYridu5UZ3q1VOPy/NcipDf5
        OhSAJ1FBXB0GWqdaS+MZEgU=
X-Google-Smtp-Source: ABdhPJyfFmVgqvCZi+SBxwsNy2m1AKDMVzOW+rKKHpAqlqQbgo8oA6VYZmLieeCmyFBiUyc9j5rc0g==
X-Received: by 2002:a63:1119:: with SMTP id g25mr1591917pgl.162.1614822822012;
        Wed, 03 Mar 2021 17:53:42 -0800 (PST)
Received: from google.com ([2620:15c:202:201:2074:dba8:1918:3417])
        by smtp.gmail.com with ESMTPSA id b3sm7919270pjg.41.2021.03.03.17.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 17:53:40 -0800 (PST)
Date:   Wed, 3 Mar 2021 17:53:37 -0800
From:   'Dmitry Torokhov' <dmitry.torokhov@gmail.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     jingle <jingle.wu@emc.com.tw>, kernel@pengutronix.de,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: elan_i2c: failed to read report data: -71
Message-ID: <YEA9oajb7qj6LGPD@google.com>
References: <20210302210934.iro3a6chigx72r4n@pengutronix.de>
 <016d01d70fdb$2aa48b00$7feda100$@emc.com.tw>
 <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
 <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Uwe,

On Wed, Mar 03, 2021 at 09:03:30PM +0100, Uwe Kleine-König wrote:
> Hello Dmitry,
> 
> On Wed, Mar 03, 2021 at 07:32:23PM +0100, Uwe Kleine-König wrote:
> > Hello,
> > 
> > On Wed, Mar 03, 2021 at 11:13:21AM +0800, jingle wrote:
> > > HI uwe:
> > > 
> > > Please updates this patchs.
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=056115daede8d01f71732bc7d778fb85acee8eb6
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=e4c9062717feda88900b566463228d1c4910af6d
> > 
> > The first was one of the two patches I already tried, but the latter
> > indeed fixes my problem \o/.
> > 
> > @Dmitry: If you don't consider your tree stable, feel free to add a
> > 
> > 	Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > to e4c9062717feda88900b566463228d1c4910af6d.
> 
> Do you consider this patch for stable? I'd like to see it in Debian's
> 5.10 kernel and I guess I'm not the only one who would benefit from such
> a backport.

When I was applying the patches I did not realize that there was already
hardware in the wild that needed it. The patches are now in mainline, so
I can no longer adjust the tags, but I will not object if you propose
them for stable.

Thanks.

-- 
Dmitry
