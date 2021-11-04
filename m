Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DA0445AA7
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 20:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhKDTn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 15:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhKDTnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 15:43:24 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6E3C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 12:40:46 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id o83so10998125oif.4
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 12:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OeYD9of2/3dPVEhJLIAiLwllwbIYNwjaT6dfja+DDds=;
        b=h1kOiY3v3eEcU1Q+tA7T62giuxHqf6sgRCiXptZzu+ae2E5rVTFew0WF7QC/V55QRu
         kFBlPRjLKGF/5XNwOMu/MqNFKFkJooDtDiBadgfM163zJpLlbuQ/z+IX9tm2MgN4pmdi
         OdjWS1f5vdd36xQT6+UHvEDy/g4mWjnysure4au7nrFDEOvIrffCs4pM+JS5Va9PP5SO
         XMwT10gwW8OcvXjG1LKKcdW/9nHmJTXQSNF5hqMTIdEyBmkRRpopsAbDUk7r4+ZM8xi3
         iY8OoVJVBRxGuPjG74PuI1TpEP54NU6P1NbahF8jCwxBtV0sOBHOFRTDy7tuwskvUkfo
         KPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OeYD9of2/3dPVEhJLIAiLwllwbIYNwjaT6dfja+DDds=;
        b=Ww1BZLZVfn0Q1LtCraQTSPLPX2cU3r+b3sPurpguLoBCERP+3uvoGV6o1s3vflnJwy
         oFKIhsvVwD4Ystf/XTC7cxOkiuu5XlkzDm4MtR5adlI1JPiACIXKqL+KLoMVxILfeKt9
         cbNMGXyV9RyrPb+8S4ClpfTKGgKsaQoB6cCRxRPLOLINtzlFeeYkgzXhe6ZlZPCkVGxz
         R0TF7qAwzxFvNjohAKej0mxaBv3WcAt9hhikEQEJ8TLPr024Ljc1gV/LYeMyUBuwpsR2
         R/ClF+1mZMtXIoMw1vuxeaYLI2dYWH5K/FlYQis/NslggimIHP97hFBD6cuP/4X7+E4+
         KCvA==
X-Gm-Message-State: AOAM533QmN2y5265B7Z45ieSyskgbuNeJYql+9p+YSKHH+SswF3aJB38
        NW5x/PAWgiaJB74nbuYoWsUD8G4xIj+vg8osUg0fpg==
X-Google-Smtp-Source: ABdhPJw96DjvBV/xD2nTUvXPqzxuRqxRq7G+hqCRevj3A1oI36jHyAoppqVx90i9DAD28fEDHYAWm0j7GotmTRgmOBo=
X-Received: by 2002:a05:6808:6ce:: with SMTP id m14mr17597120oih.134.1636054845305;
 Thu, 04 Nov 2021 12:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <CA+DW03VfQpOJUWAM9CZMCM4Vkw8KVbNWAxgsq-g615QPz_3=YQ@mail.gmail.com>
 <CA+DW03WPM1b_01eNB3cE7kVsp+tRbzv-O-=TvX627ATOUSywBQ@mail.gmail.com> <YYQsw+GBLr1WXidM@kroah.com>
In-Reply-To: <YYQsw+GBLr1WXidM@kroah.com>
From:   Yi Fan <yfa@google.com>
Date:   Thu, 4 Nov 2021 12:40:32 -0700
Message-ID: <CA+DW03WkHiq1tpfVJ33onMytp-0AmqTYGcvtNwdkzwxm+7qpQA@mail.gmail.com>
Subject: Re: null console related kerne performance issue
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        shreyas.joshi@biamp.com, Joshua Levasseur <jlevasseur@google.com>,
        pmladek@suse.com, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reply inline.

On Thu, Nov 4, 2021 at 11:56 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 04, 2021 at 11:14:55AM -0700, Yi Fan wrote:
> > Resend the email using plain text.
> >
> > I found some kernel performance regression issues that might be
> > related w/ 4.14.y LTS commit.
> >
> > 4.14.y commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.253&id=27d185697322f9547bfd381c71252ce0bc1c0ee4
> >
> > The issue is observed when "console=" is used as a kernel parameter to
> > disable the kernel console.
>
> What exact "performance issue" are you seeing?
>
[YF] one kernel thread was randomly blocked for more than ~40
milliseconds, causing a certain task to fail to process in time.
[YF] the issue is highly random on a single device. But it might
happen a few times per 24 hours on a certain percentage of devices.
The overall percentage of devices that show the issue seems quite
stable over a long period of time (somehow the magic number is ~40%.).
[YF] local test on a pool of devices does not show any correlation w/
any particular devices.
[YF] local test after reverting the above single commit passes, no
issue is observed.

> And what kernel version are you seeing it on?
>
[YF] it was first found on some products w/ kernel version 4.14.210.
through bisection, we located the commit on 4.14.200.

> > I browsed android common kernel logs and the upstream stable kernel
> > tree, found some related changes.
> >
> > printk: handle blank console arguments passed in. (link:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=3cffa06aeef7ece30f6b5ac0ea51f264e8fea4d0)
> > Revert "init/console: Use ttynull as a fallback when there is no
> > console" (link:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.14.15&id=a91bd6223ecd46addc71ee6fcd432206d39365d2)
> >
> > It looks like upstream also noticed the regression introduced by the
> > commit, and the workaround is to use "ttynull" to handle "console="
> > case. But the "ttynull" was reverted due to some other reasons
> > mentioned in the commit message.
> >
> > Any insight or recommendation will be appreciated.
>
> What problem exactly are you now seeing?  And does it also happen on
> 5.15?
>
[YF] we do not perform any tests on 5.15 yet. so no idea about whether
the issue happens on 5.15.

> thanks,
>
> greg k-h
