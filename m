Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257231E604
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 02:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfEOAZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 20:25:37 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40337 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfEOAZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 20:25:36 -0400
Received: by mail-ed1-f68.google.com with SMTP id j12so1464261eds.7
        for <stable@vger.kernel.org>; Tue, 14 May 2019 17:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h2wbbn+50G92UFcNx+QSq8qpoP65Z/vv5qYbllDR5Ck=;
        b=hyfPiTJWmJAGpYFESdcTFQGUPSNerIfzomB0VLHaskLki1GvQNf72HX91KqN6a3PyO
         noBbTyEmWtNZf2MBRjL431v2s4zD7LvvNjoTv3+Xy4HNz7L3JaAEFFbi0elMTPOIGxgx
         F8yCQUBJ197IbEgqb+ktN7UfrErSmh3TPQanyR7HhVAu/dpsaA+vyZRgOTVDqwq8rraG
         eMu+gmZurufPCmlRzx2K/EOH46POjPOpVf3BsI33pUmEt77GXRb8ORc+Tj9RuAlAzJHD
         WZTUbCuqcUjOp8bXKjXEAnoZvQn7gZ6ial21dUaFjB1UAUoYfvXPA+ccvrxAgPq4MG1T
         Yn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h2wbbn+50G92UFcNx+QSq8qpoP65Z/vv5qYbllDR5Ck=;
        b=UJTH2jg7fG8XrWSQ3eMsOkTM9LZw+spppa4MhdG1ROgBNuvSIz8pYXEibYB7xj63AF
         8dJ+mJRL6qO/tosjXmq9cqnX7LT5MPTOKnGcjGn7X0n9afuhRG67JJDa4N3Iifrrfaai
         +LSDANmaEfkfn+2vImYK7CMgfyL5PB1QzyO6MvBi48q8zBXIm8oqOK+XcQecUGgvM4BH
         aKTmd32EnlYkegMvu8LTdYb6SF/yNkJY9IGFF//r0aQh99QMJnjQZaqKgQAeXP/iCtcf
         ygDHr9zcbmtkYk5vCOqc/M+l1a1GA0mKvYcWPvJS//Kmhx/iB5C16c5S5twobPm9QYkn
         j3GA==
X-Gm-Message-State: APjAAAX3QZRX88QSM8G3y126Y7MALEuGR+zud2e0bwtA9ePwZn/hcHMq
        9xu2NiIzx6MfXyGD4cT7PsA=
X-Google-Smtp-Source: APXvYqyyGI1b0COx6hEo5DBLBDaIXHgsZJAWOS+gufbUGFm6Q0Fu528oemstoouAYXEhS9OcizlWJg==
X-Received: by 2002:a50:b6b2:: with SMTP id d47mr40524369ede.169.1557879934915;
        Tue, 14 May 2019 17:25:34 -0700 (PDT)
Received: from archlinux-i9 ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id y46sm187540edd.29.2019.05.14.17.25.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 14 May 2019 17:25:33 -0700 (PDT)
Date:   Tue, 14 May 2019 17:25:31 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Sasha Levin <sashal@kernel.org>, stable@kernel.org,
        Alistair Strachan <astrachan@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        Carlos O'Donell <carlos@redhat.com>,
        "H. J. Lu" <hjl.tools@gmail.com>, Borislav Petkov <bp@suse.de>,
        Laura Abbott <labbott@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH for 4.4, 4.9 and 4.14] x86/vdso: Pass --eh-frame-hdr to
 the linker
Message-ID: <20190515002531.GA12671@archlinux-i9>
References: <20190514073429.17537-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20190514075004.GD27017@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514075004.GD27017@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 09:50:04AM +0200, Greg Kroah-Hartman wrote:
> On Tue, May 14, 2019 at 04:34:29PM +0900, Nobuhiro Iwamatsu wrote:
> > From: Alistair Strachan <astrachan@google.com>
> > 
> > commit cd01544a268ad8ee5b1dfe42c4393f1095f86879 upstream.
> > 
> > Commit
> > 
> >   379d98ddf413 ("x86: vdso: Use $LD instead of $CC to link")
> > 
> > accidentally broke unwinding from userspace, because ld would strip the
> > .eh_frame sections when linking.
> > 
> > Originally, the compiler would implicitly add --eh-frame-hdr when
> > invoking the linker, but when this Makefile was converted from invoking
> > ld via the compiler, to invoking it directly (like vmlinux does),
> > the flag was missed. (The EH_FRAME section is important for the VDSO
> > shared libraries, but not for vmlinux.)
> > 
> > Fix the problem by explicitly specifying --eh-frame-hdr, which restores
> > parity with the old method.
> > 
> > See relevant bug reports for additional info:
> > 
> >   https://bugzilla.kernel.org/show_bug.cgi?id=201741
> >   https://bugzilla.redhat.com/show_bug.cgi?id=1659295
> > 
> > Fixes: 379d98ddf413 ("x86: vdso: Use $LD instead of $CC to link")
> > Reported-by: Florian Weimer <fweimer@redhat.com>
> > Reported-by: Carlos O'Donell <carlos@redhat.com>
> > Reported-by: "H. J. Lu" <hjl.tools@gmail.com>
> > Signed-off-by: Alistair Strachan <astrachan@google.com>
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Tested-by: Laura Abbott <labbott@redhat.com>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Carlos O'Donell <carlos@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Joel Fernandes <joel@joelfernandes.org>
> > Cc: kernel-team@android.com
> > Cc: Laura Abbott <labbott@redhat.com>
> > Cc: stable <stable@vger.kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: X86 ML <x86@kernel.org>
> > Link: https://lkml.kernel.org/r/20181214223637.35954-1-astrachan@google.com
> > Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> > ---
> >  arch/x86/entry/vdso/Makefile | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> This is already in the 4.14 stable queue.
> 
> Sasha, how did you tools miss it for 4.4 and 4.9?

Not Sasha's fault but mine, I forgot to git grep for the short hash like
I usually do to ensure I catch all fixes (or I didn't do it properly, I
forget which) when I added this to all of the trees.

I currently see it queued up for 4.9 and 4.14, don't forget 4.4.

Sorry for the breakage,
Nathan

> 
> thanks,
> 
> greg k-h
