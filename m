Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F202A2F64
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 17:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgKBQMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 11:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgKBQMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 11:12:15 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AD3C0617A6;
        Mon,  2 Nov 2020 08:12:15 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id b19so7051421pld.0;
        Mon, 02 Nov 2020 08:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rmFpankWLJheBPHzQ8xk4lfNURwOLXv70XaVIKZdiwQ=;
        b=PixVJiQveY36P8J7rMawey5rmPa9eaEgULEO6TUxwJFITNeIuTFCWNDFPAqR68Hv0A
         CKlf7b+vfM/4YiksEHZqi+ai+c5QIeR3GsvNY3pmFpjV6ApUdeh8y8m8lPe7ZC7qfrQM
         Gd6HLqKQoRrz/UwtZXOyYuxLs1TmGmFTDrV9JV9fua2hN7IsPx4rtXxKeIOqw7xBxtYa
         86YcV8Q+PEn25+UprntpeFHhyK9LEwrWKoOOQrt6fdIhoBUGzit/TJoNLUS2iv55KY/s
         NqceMtCSEQAGMa2tVnl1FkomlDEft1Yy4G9FMo1QxCrVWF6CKvMBg4ZyBMkLd+T02UXb
         L+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rmFpankWLJheBPHzQ8xk4lfNURwOLXv70XaVIKZdiwQ=;
        b=ZAJLjM0TGJ6GBOkLu8/Gn8Zk8HkkLXNkq53XRu6S5xFwWshSoxbvXckrmAGEHStPj2
         UnECsyiGAzdqhosluTYpdMMWuJyUD74L/ovg7DUohVYf1lzqbrj29PWL2dJ1CX1hBaHJ
         zfJxyQ5sriwe7wGMlG5U/ivfExAg22UexwoRiXYWszhfED0C+54jpf0YS720vX/CxZA/
         MD7ntUPs59ZnO9iBabCuKlZEUMzcM2fw867OfhCrbw8MlrGw7L+f5pgW38GX9iiBw3dV
         Af1BWTxecYbRPVE6+lb3azDzWRIlrc6VVNy4V2/G1R7p5yyxmhyuu7uyJuTGcOgD22Ga
         fKMg==
X-Gm-Message-State: AOAM5314aPJ/BMTehTLoJ4KjvmNx66oLX5O0JF2Ymovksi0XTX7v2KnK
        2uqRY6+9tVQ3rDzmYjghLQ==
X-Google-Smtp-Source: ABdhPJwOe7sZoHnAXjluowvFrA5C+q7qIO9nN9eYgaojlB/SsctUFflBl6Y/wkyBgtLlEnq9QD0t+g==
X-Received: by 2002:a17:902:eacd:b029:d6:cc2f:a18 with SMTP id p13-20020a170902eacdb02900d6cc2f0a18mr5588685pld.36.1604333534512;
        Mon, 02 Nov 2020 08:12:14 -0800 (PST)
Received: from PWN (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id hg15sm12318541pjb.39.2020.11.02.08.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:12:13 -0800 (PST)
Date:   Mon, 2 Nov 2020 11:12:03 -0500
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Lee Jones <lee.jones@linaro.org>, daniel.vetter@ffwll.ch,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201102161203.GA1561792@PWN>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201031102709.GH1551@shell.armlinux.org.uk>
 <20201101131122.GD4127@dell>
 <20201102102343.GK1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102102343.GK1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Russell,

On Mon, Nov 02, 2020 at 10:23:43AM +0000, Russell King - ARM Linux admin wrote:
> On Sun, Nov 01, 2020 at 01:11:22PM +0000, Lee Jones wrote:
> > On Sat, 31 Oct 2020, Russell King - ARM Linux admin wrote:
> > 
> > > On Fri, Oct 30, 2020 at 06:18:22PM +0000, Lee Jones wrote:
> > > > Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
> > > 
> > > Your commit ID does not exist in mainline kernels, which makes this
> > > confusing. The commit ID you should be using is 6735b4632def.
> > 
> > Ah yes, quite right.  That is the ID from android-3.18 where this
> > issue was first seen and fixed against.  I will fix it up for
> > Mainline.
> > 
> > Does the fix look okay to you though Russell?
> 
> Frankly, I don't know. Looking at the commit itself, it looks safe,
> but it depends what this "extra" data is being used for. From what
> I can see, the commit in question just adds the additional opaque
> data as a member named "extra", and one is left to guess what it's
> use as.

Thank you very much for looking into this. I apologize for the trouble
and confusion it has caused.

The motivation behind this commit, and commit 5af08640795b ("fbcon: Fix
global-out-of-bounds read in fbcon_get_font()") was to fix a decades-old
out-of-bounds access bug in the framebuffer layer.

However the framebuffer layer is doing bounds checking in a very strange
way, by hiding the buffer length before the buffer, then access it using
a negative-indexing macro:

	#define FNTSIZE(fd)	(((int *)(fd))[-2])

Other "extra" (so-called by the framebuffer layer) fields include:

	#define REFCOUNT(fd)	(((int *)(fd))[-1])

	#define FNTCHARCNT(fd)	(((int *)(fd))[-3])
	#define FNTSUM(fd)	(((int *)(fd))[-4])

...representing reference count, character count and checksum,
respectively.

The commit in question (6735b4632def) prepends the buffer length to each
of the built-in font buffers, so other functions in the framebuffer
layer can use FNTSIZE() on them. 5af08640795b uses it to fix that
out-of-bounds bug.

> I'd have thought a small structure with named members would have
> been the minimum given our standards for in-kernel code.

Yes, this is a temporary bug fix, and is far from satisfactory. We are
trying to replace these magic macros using a structure with properly
named members. It is taking more time than I imagined, but one day this
temporary fix will disappear from the kernel, I hope.

> Why was the "const" dropped in the first place? Does this "extra"
> member get written to somewhere?

No, I will try to come up with a solution without these fields being
writable.

> So, sorry, no idea. This looks to me like a very unsatisfactory
> commit, and probably something that got a very poor review.

I hope this helps explain it.

Again, I apologize for all the troubles. I will do more thorough testing
and practice writing a commit message. Thank you!

Sincerely,
Peilin Ye

