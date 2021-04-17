Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F363631DC
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 20:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbhDQSgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Apr 2021 14:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbhDQSga (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Apr 2021 14:36:30 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23BBC061574
        for <stable@vger.kernel.org>; Sat, 17 Apr 2021 11:36:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id f8so36038163edd.11
        for <stable@vger.kernel.org>; Sat, 17 Apr 2021 11:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RKcvDhpGybN7fjwMG9VRVxvuUfBZfScrE87bGadP8qc=;
        b=m7UJUgv9owx1j/Cuf7gTXDYo6/Zj1V82XETHU5PaWWJ+4dXCUphWPMuGL5pDIZeVlf
         MHh0P2NNybS55+m7euUk8RhZA4XFyne7BJpCeCBqNuYbRq+0ePRJ1rU8bcIzSWDenTDF
         tYCqrdzrwZkIkJZbhjPYkVDRfAV0OJv9AMrRjr9wc9ZrsQIEFXzji46hqGPv+xxqIodJ
         T7/AxfOIYAK8GlGI1M01xj0Rda9Va52bFAS0a7WDl6y5SCuP4hJzyjwyC8J429MygS+L
         YkaxN7bUzEJgR6PX0YKCuebFAr2XviEEtt2uhsM/NUwxjI8iOH1gxfEGD4YCUvWm/z5O
         iJqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=RKcvDhpGybN7fjwMG9VRVxvuUfBZfScrE87bGadP8qc=;
        b=CJcKhnb93q5PdVsZ3ggEyWUDW9Qb08adcMhb6/wIX9+B8OiH4KMp5KSwrPWtovAKyZ
         /YK/u21RnJV0vA7+Ap+H7qv7rHWb6pjmRIiYEwRvw5fIEzWNHrwCYnZBWxflUIGN0IxW
         FBWdMgsk5GmrVr72/9HZlwK/ZfwBgsBRqLY4tdk87Z5oq8tBzT0ZHCsPd7Ke3KvDatTt
         WF+mPELnhQRe5tfus//OWYI2OKHfMWzBR5gWzMn1AX1yFxlrsXvedsngkKfryrE0ffoJ
         A4Ry978B9pr/TbUMeEQl7wEsc/XPwCvSd48/I3JgfjoaMOC0R58HuNHob5HziJzXFey7
         6ONQ==
X-Gm-Message-State: AOAM531op9Ml9jA8aoGvBRIgK3mxhTyohEaPdvlnouHRdjW49O5+RYED
        OkfxS8+JpPum+jk34diRat8=
X-Google-Smtp-Source: ABdhPJxVJkZX21RJshuN2lVcqLzqRJd40V3PxZlAgvB/ab8eA4R4KLM/0T6p1Xwizjnz1QRAfYtb3g==
X-Received: by 2002:a05:6402:2054:: with SMTP id bc20mr16371266edb.334.1618684562417;
        Sat, 17 Apr 2021 11:36:02 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id z22sm5596492edm.57.2021.04.17.11.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 11:36:01 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Sat, 17 Apr 2021 20:36:00 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Steve Beattie <steve.beattie@canonical.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: Re: Please apply commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap()
 call into vfs_setxattr()") to stable series from 5.10.y back to 4.19.y
Message-ID: <YHsqkHk3zGQY+Y65@eldamar.lan>
References: <YHnr2D9UO+pQO6uq@eldamar.lan>
 <YHn7xAHwhcKDHdie@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHn7xAHwhcKDHdie@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Fri, Apr 16, 2021 at 05:04:04PM -0400, Sasha Levin wrote:
> On Fri, Apr 16, 2021 at 09:56:08PM +0200, Salvatore Bonaccorso wrote:
> > Hi Greg, hi Sasha
> > 
> > Please consider to apply commit 7c03e2cda4a5 ("vfs: move
> > cap_convert_nscap() call into vfs_setxattr()") to stable series at
> > least back to 4.19.y. It applies to there (but have not tested older
> > series) and could test a build on top of 5.10.y with the commit.
> > 
> > The commit was applied in 5.11-rc1 and from the commit message:
> > 
> >    vfs: move cap_convert_nscap() call into vfs_setxattr()
> > 
> >    cap_convert_nscap() does permission checking as well as conversion of the
> >    xattr value conditionally based on fs's user-ns.
> > 
> >    This is needed by overlayfs and probably other layered fs (ecryptfs) and is
> >    what vfs_foo() is supposed to do anyway.
> > 
> > Additionally, in fact additionally for distribtuions kernels which do
> > allow unprivileged overlayfs mounts this as as well broader
> > consequences, as explained in
> > https://www.openwall.com/lists/oss-security/2021/04/16/1 .
> 
> Is it needed without the rest of the patches in the series it was sent
> in
> (https://lore.kernel.org/linux-fsdevel/20201207163255.564116-1-mszeredi@redhat.com/)?

This is a very valid question. In fact from the series already
89bdfaf93d91 ("ovl: make ioctl() safe") was backported as well to
5.10.y (in 5.10.4). My thinking was it would make sense to pick as
well the mentioned commit as it fixes as well a specific issue.

If though you and Greg think my request is not valid, then so it will
be. I in any case have Miklos, Steve and Thadeu here which might
further comment.

Thanks for your work, which is not easy to sort out what to apply and
what not, much appreciated. My intention here is not to cause you more
hassle, but cover the initial mentioned aspect for downstream
distributions.

Regards,
Salvatore
