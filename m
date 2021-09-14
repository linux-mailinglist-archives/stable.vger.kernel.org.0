Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBDE40B346
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhINPm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234592AbhINPm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 11:42:26 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D093C061764
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 08:41:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id n30so9927018pfq.5
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 08:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qq1y+DofprhZDWMKXBLFIkDNGaMcVgTMv8sDqPM5COM=;
        b=s+2MY3/PnACAWKw8fTsVGCwqltqJN4+p9aTBDzyyYIHDF2fcGbRpmqzGFMH7zPXCPr
         3YnLO5CesNC064ugiPAAE7wOtbz5ISopSPr98YYh7UqeQ/M4EE//OXBrKPRRgg8bIwLQ
         PaoICJ9ZNuomwDpWU57RFK2PQmBF6RvOYCTpnXR1X/52+/yDILxbvXv3KiOJ4VwTP/5k
         xmP7c/LP+yAQzl2EymJEeGJr8lO6WxRAQz4F5RN/ZnBVBYl2WtwgfzRjxNOVYF0TlB0A
         mPS/s1YD7sPSfkwnWzMiiwvnDKtpaHB93qOjas+Zwbnka6xuPATYqudCepty13wsohqF
         MvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qq1y+DofprhZDWMKXBLFIkDNGaMcVgTMv8sDqPM5COM=;
        b=5Pfhj4V4ZRMhYy8pW+cqZBI6/eMUfOJ1PVd1FC5rKO/A9CopUvk5dfSVNTqvMqJcvI
         PLNtP/GVfBie9ureKuM0nygG6MnqJVI1VkqrgAcVDVs4m10ux8K/NNk3u94K5lxjlsch
         W/vAIpr2ZrJbiWJOjaECK1AbTT75DcVa86FVqFsQYi2yZ9I48d397Sn7dl33yt8TPntA
         Wd/CCJGYAgokg+AutMosFlQHTBbF4guOirMQ/8lEbGLNOZdHdbjR5uxJFDo9cKRa7dap
         5gKoNjvO5l9Wk0Mqlr8KwRZQlw6s5+lJld0YFeFR88/MrCOGre00TWdx8rUifBB/xMX5
         CXNQ==
X-Gm-Message-State: AOAM533/yhh+Pp6BaDS848Ge7L48lGGeHxEI4pyfNirMavJFFE9n5JIF
        zMXo2lKHHZgEfYlZVnzAdcL28s+2oeWdxE67YQBAH3AyTXg=
X-Google-Smtp-Source: ABdhPJxsd9tZKF5oCMVJOQcjWY9KKdZnQOdA4gLzlfeS7JEwihQdDQtmLTP0X8DgAzREIAJLz+3Tbe0T+aMRTtBM548=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr16045381pge.5.1631634068966;
 Tue, 14 Sep 2021 08:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210913223339.435347-1-sashal@kernel.org> <20210913223339.435347-3-sashal@kernel.org>
 <20210914095623.00005306@Huawei.com> <20210914095749.0000151f@Huawei.com> <20210914150558.n3lbmmt7h6o2uz6a@intel.com>
In-Reply-To: <20210914150558.n3lbmmt7h6o2uz6a@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 14 Sep 2021 08:40:58 -0700
Message-ID: <CAPcyv4gQhQvXJ7W_WuB_Gp73Xoiw1KLDi_zxWnO=zDCgm+3ihg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.14 03/25] cxl: Move cxl_core to new directory
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 8:06 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-09-14 09:57:49, Jonathan Cameron wrote:
> > On Tue, 14 Sep 2021 09:56:23 +0100
> > Jonathan Cameron <Jonathan.Cameron@Huawei.com> wrote:
> >
> > > On Mon, 13 Sep 2021 18:33:17 -0400
> > > Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > > From: Ben Widawsky <ben.widawsky@intel.com>
> > > >
> > > > [ Upstream commit 5161a55c069f53d88da49274cbef6e3c74eadea9 ]
> > > >
> > > > CXL core is growing, and it's already arguably unmanageable. To support
> > > > future growth, move core functionality to a new directory and rename the
> > > > file to represent just bus support. Future work will remove non-bus
> > > > functionality.
> > > >
> > > > Note that mem.h is renamed to cxlmem.h to avoid a namespace collision
> > > > with the global ARCH=um mem.h header.
> > >
> > > Not a fix...
> > >
> > > I'm guessing this got picked up on the basis of the Reported-by: tag?
> > > I think that was added for a minor tweak as this went through review rather
> > > than referring to the whole patch.
> > Or possibly because it was a precursor to the fix in the next patch.
> >
> > Hmm.  Ben, Dan, does it make sense for these two to go into stable?
> >
> > Jonathan
>
> As of now, no, but having this will make future fixes much easier to cherry
> pick.

Sasha, please drop this. The CXL subsystem is still in major feature
development. I would rather manually backport small fixes rather than
backport major code movement just to make small fix backport easier.

Let me know if there was a specific fix autosel was trying to resolve
and we'll take a look at whether it makes sense to do a custom
backport for -stable.
