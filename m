Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 765321714F7
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 11:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgB0KaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 05:30:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40177 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728652AbgB0KaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 05:30:00 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so2734666wmi.5
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 02:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SLdHoR7RuaJu6mDZXSKmLzt7OC+B0gBW5TbVhcMC5L8=;
        b=RJBkr1uN1c65E+WDohEoOI6zeZ2V1OzAyfZ96xwNNo6gt7MXA2z6yYz8S0CjobaGfc
         D458GGvdMbdiOCYKgnnGvp53ReLs11Ty1Cx/9bMuHUnBuIBdCZprZOeNSqfj8sDqn3Xy
         ktfFd1novQHWe+NldSgzzE4icqOKRpRlKaNng3xbWW7lPZe8ybsaMKHCaz/jnJ5n95Yz
         mTImzycouXpudonAZVs5TO1WJBJqmRzojDae4PdYYNJ+6mmMXOdD+Pta3Nzy2fBlGg5f
         zj2Pa7mFpSPPtTFAi9FgYm3WEeZ8e+8Z0CUix1xhVG939YOskX5HHObr27kIzgemeo9l
         Om2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SLdHoR7RuaJu6mDZXSKmLzt7OC+B0gBW5TbVhcMC5L8=;
        b=s2vCzXFVXh9jxvhvdMjl88INKKKozsU6HNgLSYh0SUb1gExw9EjudOcAf4MQ5Ec4g/
         TkyMMQVlaRRNZ0TBpyDP+yx2Qqn4veY9pgOj/UaB5/7q3B5CWYuU4Fvcq+KYEDPPc4b8
         T1Ca5KQxGG85kVOYVoQc6cn3gqEm5MQdHIXugniDmmGeBmp6oJKnBzdrYx8VLzpYM/sr
         VDzmrZC6eB1HmqO9MD8Bo3vHToYLDSY7zGuqqTFC3dOud88EgAfr4eJeKfrDrzy973YK
         UaZkIODinaHojAmtpTmXiEDgPcyZMDTmIPw8D9aIxWLJECYz2fHRSjalazCIAbEgqvwV
         2Pjg==
X-Gm-Message-State: APjAAAWYet6RFh9Kv2fj2KD5jEidI05TIv3L4vqIT7CNv190J/B0EmYh
        4HZIJKM+2l1rRxRrz2Ga+5divRJ0YruMkwstso8dRQ==
X-Google-Smtp-Source: APXvYqxsJ4Hd1GnDMTyXYdsbnsRSx9BvI+LPHCveoRrLedtMmf7xRoEdMkB5bxi4P4sdFMAvo4LGcY/KXHXW8KLzM2I=
X-Received: by 2002:a1c:e0d6:: with SMTP id x205mr4210511wmg.29.1582799398148;
 Thu, 27 Feb 2020 02:29:58 -0800 (PST)
MIME-Version: 1.0
References: <1582714182242120@kroah.com> <20200227024735.GE22178@sasha-vm>
In-Reply-To: <20200227024735.GE22178@sasha-vm>
From:   Alexander Potapenko <glider@google.com>
Date:   Thu, 27 Feb 2020 11:29:46 +0100
Message-ID: <CAG_fn=Vt1fTEL+vTtt8xVjMVpJkAoRUhKDov-GJLQc3aD4q9Fw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] lib/stackdepot.c: fix global out-of-bounds
 in stack_slabs" failed to apply to 4.19-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Walter Wu <walter-zh.wu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 3:47 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Wed, Feb 26, 2020 at 11:49:42AM +0100, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 4.19-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From 305e519ce48e935702c32241f07d393c3c8fed3e Mon Sep 17 00:00:00 2001
> >From: Alexander Potapenko <glider@google.com>
> >Date: Thu, 20 Feb 2020 20:04:30 -0800
> >Subject: [PATCH] lib/stackdepot.c: fix global out-of-bounds in stack_slabs
> >
> >Walter Wu has reported a potential case in which init_stack_slab() is
> >called after stack_slabs[STACK_ALLOC_MAX_SLABS - 1] has already been
> >initialized.  In that case init_stack_slab() will overwrite
> >stack_slabs[STACK_ALLOC_MAX_SLABS], which may result in a memory
> >corruption.
> >
> >Link: http://lkml.kernel.org/r/20200218102950.260263-1-glider@google.com
> >Fixes: cd11016e5f521 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
> >Signed-off-by: Alexander Potapenko <glider@google.com>
> >Reported-by: Walter Wu <walter-zh.wu@mediatek.com>
> >Cc: Dmitry Vyukov <dvyukov@google.com>
> >Cc: Matthias Brugger <matthias.bgg@gmail.com>
> >Cc: Thomas Gleixner <tglx@linutronix.de>
> >Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> >Cc: Kate Stewart <kstewart@linuxfoundation.org>
> >Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >Cc: <stable@vger.kernel.org>
> >Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> I've grabbed ee050dc83bc3 ("lib/stackdepot: Fix outdated comments") as a
> dependency and queued for 4.19-4.9.

Thanks a lot!
