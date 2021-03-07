Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395A53302B9
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhCGPo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbhCGPn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 10:43:58 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A97FC06175F
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 07:43:58 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id r5so3443166qvv.9
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 07:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mS9UpdncXR9MHS9h0T1Gw/f6CT9PrQN5whsC1DFrt58=;
        b=JI4hpgQn2neHm+ucZNu7Sc0ssuhAAXw5z2xpe8MrP9/QGMCL8F2Jrmydi2lGClUwOc
         eaW564aDHdpZSV9xAm1s31EJ9PwQ1cDE42oKanEQMv5J+LdFOd3X/DxdhDr41JHbsQ9r
         jPjuPBI5IwhsAntBnIHdsB6M84CcIxT9dZ3a0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mS9UpdncXR9MHS9h0T1Gw/f6CT9PrQN5whsC1DFrt58=;
        b=epCn/K4LMxRMKkkzyfjQpqLJQxDTnCuRpxDp4BzjIBBmmFzND8RySJGefubU7JcU9R
         0s8xJIEC1k5LmmrEPTpvym9R/Zst+KyLAkQ8+oqK7d61x3lIQC6/8zJGDXL2cYRZztBC
         aSieFsEafTGOdWZHxxd/dxrvu9oB+NiEBUN15QgTAPe40z74JaLXPaIO6A8k+V5EYD5P
         XTLC+/a+OfK3YD4zldjoBgDQc7VVahkw7C9M1YT1VG7WzGqTeDRgE2/YWQkrSioeSu4e
         o7J7bJnb6aEFgPD/f7irzApPtB/1mYmHKkVi3bLKPRRZpTCkPTzP8UmUW9KOiw7QZG53
         4UHQ==
X-Gm-Message-State: AOAM530qei8r0i+NI2bAC0dy8n0m9U6GGT2SEQX6E3FgG3m3XmukGVH4
        I6KU2yvUQCGc+Mc13I3zrmYg8Q==
X-Google-Smtp-Source: ABdhPJyk/u0kCKWpXzQjHEBQuzPQEuAe09XUCapT+8tWJ8cJzeHmYbLVyt7Ra/WmF8Z+gQRtlLxAEQ==
X-Received: by 2002:a05:6214:1c45:: with SMTP id if5mr17365111qvb.9.1615131837280;
        Sun, 07 Mar 2021 07:43:57 -0800 (PST)
Received: from chatter.i7.local (bras-base-mtrlpq5031w-grc-32-216-209-220-18.dsl.bell.ca. [216.209.220.18])
        by smtp.gmail.com with ESMTPSA id d24sm5849982qko.54.2021.03.07.07.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 07:43:56 -0800 (PST)
Date:   Sun, 7 Mar 2021 10:43:54 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ronald Warsow <rwarsow@gmx.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: stable kernel checksumming fails
Message-ID: <20210307154354.qbbsy355d5zfubnf@chatter.i7.local>
References: <d58ab27a-78ad-1119-79ac-2a1fbcd3527a@gmx.de>
 <YETm+6sQqek6kY/A@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YETm+6sQqek6kY/A@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 03:45:15PM +0100, Greg KH wrote:
> > checksumming the downloaded kernel manually gives an "Okay" though.
> > 
> > 
> > is this just me (on Fedora 33) ?
> 
> Fails for me on Arch:
> 
> Verifying checksum on linux-5.11.4.tar.xz
> /usr/bin/sha256sum: /home/gregkh/Downloads/linux-tarball-verify.gZo313NCk.untrusted/sha256sums.txt: no properly formatted SHA256 checksum lines found
> FAILED to verify the downloaded tarball checksum
> 
> 
> Konstantin, anything change recently?

I think it's just cache invalidation problems. I've committed a tiny change to
the script that always grabs that file from the origin servers instead of
going via the CDN.

https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/commit/?id=71e570c5f090b5740e323f98504bf38592785b49

This should sidestep the problem.

-K
