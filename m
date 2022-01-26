Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208EC49C7D0
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 11:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiAZKqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 05:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiAZKqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 05:46:01 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47E9C06161C;
        Wed, 26 Jan 2022 02:46:00 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id c192so2041955wma.4;
        Wed, 26 Jan 2022 02:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yRqdOKllno2WTAMKVZS14yrHhw5Xe+r37FBeeO98mgQ=;
        b=F0BmIlv/Au9mK3wEWC6nrbIc7SzbHgrzGwoIPl5txafX0sGFIqScJvdF5CIU3Kj7VW
         qF5+HW0iSMKGBPmfFwzMOxa2Isn+mmE0lBQxIOgMdUmXgWcDuGF9OSvC7N61QMUEYAhh
         c97kjgaaZaaoXexoSsCnJZgFsiHb8iqzGsiLbFep89jZdoa0+GzFOSnxE13abWd9FGt5
         SpdkCcWb1gF6jYBjwsjneYcY4nakrOprmYF7SSCeUKOdEGfMxOYUoMvN/0p7ZF/mq56T
         0XAVt+UyttcHfqgLG7NQWq56pHifKtHqvt2dSVG6rNl1/Yz0NcI7cT9TGuOYA1BquIe8
         UQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yRqdOKllno2WTAMKVZS14yrHhw5Xe+r37FBeeO98mgQ=;
        b=xFGNUWAQjCCK7l+SqZIUeFYGqsHAQpU+eyablMw+q4bncEfJUAAhg66dM9kP2O6HcF
         CDyxpWTFSsGhYs7z3BsvJoDzRI6/1UmgC3QlMkT4dy7CiDxyd2LiGkxfzSnxC3zO0MwQ
         UXYWcwfuB21/5JRMOxXRcav6ZmohIDOt0Rri594I4bI9mbNt+VUTrePhVtEC/g1ybRMQ
         jTYsNgQkcmG42xchKxZh2N/Q9GMkYlc+jqQz6OTL1YtLQuLO06OvMbk73A/e6RE+CHmw
         ifCuuPHW3+mhh2q0BX7AXTNDaoQRv/CZ2YyRxJV3LUmvn5GamGp+Twjl5XageCVmjchJ
         Gvkg==
X-Gm-Message-State: AOAM530rJSJdEyAucARkdjIWWSUTm0AidUiX9nvIGugkzIS3ER8zUo6q
        PNflGmOBJVwtQfwNyyOJEs2uqLO4xxq1fA==
X-Google-Smtp-Source: ABdhPJxtjBHMbtcCtEI1vey0tvuiH8R5Oty/VyEI84awcw8AODNabeOkHG7+8IJ3GNOCZjxqqG1Erg==
X-Received: by 2002:a1c:6a14:: with SMTP id f20mr6629539wmc.123.1643193959406;
        Wed, 26 Jan 2022 02:45:59 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id m14sm12800014wrp.4.2022.01.26.02.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 02:45:58 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 26 Jan 2022 11:45:58 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: review for 5.16.3-rc2
Message-ID: <YfEmZiwkdZlQ3DVb@eldamar.lan>
References: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
 <YfAKYWOMdGJ0NxjE@kroah.com>
 <CAG=yYwksvQmEsfRyFiQTbSxUL39WGf7ryHaywtAxgdL1Nt67OQ@mail.gmail.com>
 <YfAk90OPjlpjruV5@kroah.com>
 <CAG=yYw=BK1gU0UV8g5_ZT5gOe5P2W2rKHWdFyPi4ZHSy4CGMFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG=yYw=BK1gU0UV8g5_ZT5gOe5P2W2rKHWdFyPi4ZHSy4CGMFw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Jan 25, 2022 at 10:32:26PM +0530, Jeffrin Thalakkottoor wrote:
> On Tue, Jan 25, 2022 at 9:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jan 25, 2022 at 09:49:00PM +0530, Jeffrin Thalakkottoor wrote:
> > > On Tue, Jan 25, 2022 at 8:04 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Jan 25, 2022 at 06:15:46PM +0530, Jeffrin Jose T wrote:
> > > > > hello greg,
> > > > >
> > > > > compile failed for  5.16.3-rc2 related.
> > > > > a relevent file attached.
> > > > >
> > > > > Tested-by : Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> > > >
> > > > But it failed for you, how did you test it?
> > >
> > > i compiled  5.16.3-rc2  related to "make localmodconfig" and  "make  -j4"
> >
> > So it somehow failed?
> 
> Yes i think so
> 
> >
> > > >
> > > > >
> > > > >
> > > >
> > > > >       char *                     typetab;              /*    24     8 */
> > > > >
> > > > >       /* size: 32, cachelines: 1, members: 4 */
> > > > >       /* sum members: 28, holes: 1, sum holes: 4 */
> > > > >       /* last cacheline: 32 bytes */
> > > > > };
> > > > > struct klp_modinfo {
> > > > >       Elf64_Ehdr                 hdr;                  /*     0    64 */
> > > > >       /* --- cacheline 1 boundary (64 bytes) --- */
> > > > >       Elf64_Shdr *               sechdrs;              /*    64     8 */
> > > > >       char *                     secstrings;           /*    72     8 */
> > > > >       unsigned int               symndx;               /*    80     4 */
> > > > >
> > > > >       /* size: 88, cachelines: 2, members: 4 */
> > > > >       /* padding: 4 */
> > > > >       /* last cacheline: 24 bytes */
> > > > > };
> > > > > Segmentation fault
> > > >
> > > > What "faulted"?  Look higher up in the log please.
> > >
> > > a top view...
> > >
> > >   CALL    scripts/atomic/check-atomics.sh
> > >   CALL    scripts/checksyscalls.sh
> > >   CHK     include/generated/compile.h
> > >   GEN     .version
> > >   CHK     include/generated/compile.h
> > >   UPD     include/generated/compile.h
> > >   CC      init/version.o
> > >   AR      init/built-in.a
> > >   LD      vmlinux.o
> > >   MODPOST vmlinux.symvers
> > >   MODINFO modules.builtin.modinfo
> > >   GEN     modules.builtin
> > >   LD      .tmp_vmlinux.btf
> > >   BTF     .btf.vmlinux.bin.o
> > > struct list_head {
> > >     struct list_head *         next;                 /*     0     8 */
> > >     struct list_head *         prev;                 /*     8     8 */
> > >
> > >     /* size: 16, cachelines: 1, members: 2 */
> > >     /* last cacheline: 16 bytes */
> > > };
> > > struct hlist_head {
> > >     struct hlist_node *        first;                /*     0     8 */
> > >
> > >     /* size: 8, cachelines: 1, members: 1 */
> > >     /* last cacheline: 8 bytes */
> > > };
> > > struct hlist_node {
> > >     struct hlist_node *        next;                 /*     0     8 */
> > >     struct hlist_node * *      pprev;                /*     8     8 */
> > >
> > >     /* size: 16, cachelines: 1, members: 2 */
> > >     /* last cacheline: 16 bytes */
> > > };
> > > struct callback_head {
> > >     struct callback_head *     next;                 /*     0     8 */
> > >     void                       (*func)(struct callback_head *); /*
> > > 8     8 */
> > > .
> > > .
> > > .
> > > .
> > > .
> > > .
> >
> > I do not know what is failing, there is no error message here.  Does
> > 5.16.2 build properly for you?
> 
> stderr has  captured  the  following...
> 
> 
> -------------x-----------------x--------------x---
> FAILED: load BTF from vmlinux: No such file or directory
> make: *** [Makefile:1161: vmlinux] Error 255
> make: *** Deleting file 'vmlinux'
> ------------x----------------x------------x--
> 5.16.2-rc1 builds for me.
> 
> Will the following link help...
> 
> https://unix.stackexchange.com/questions/616392/failed-load-btf-from-vmlinux-unknown-error-2make-makefile1162-vmlinu

What version of pahole are you using? Are you using Debian
downstream's 1.22-2? If so please check if it's just the same issue as
reported in https://bugs.debian.org/1004311

Regards,
Salvatore
