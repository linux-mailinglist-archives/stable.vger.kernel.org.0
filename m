Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D893E1DE82D
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbgEVNiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 09:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729890AbgEVNiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 09:38:18 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C077C061A0E
        for <stable@vger.kernel.org>; Fri, 22 May 2020 06:38:18 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g185so10661452qke.7
        for <stable@vger.kernel.org>; Fri, 22 May 2020 06:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YBx0QmgBlhkPaubO0vtt6QDHFJk7HKYLiMKXWU9gGLs=;
        b=PrjvHlWoGx0tOv0xWyqyUec5LfWVpFdXT95xXV2W7uO6uczntwzYivL0XfeTSyxKOJ
         rbS28lT8ArAQ3vl6VS9se8TLJFiS/+VqDagHUXwvaY6okiRqnr4r7mqZYeA6/3rhZrMG
         f9jVGK3EDVQgrJYwc+PXdgKKGw7FOdxNKC/pg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YBx0QmgBlhkPaubO0vtt6QDHFJk7HKYLiMKXWU9gGLs=;
        b=UI/nfl012IKrgIceOdupg13w1V/rGXgkGUJmluOCS833gG3FqQHTq+O1sGel+0FtFO
         NqxW82w0FEGvAwMqFtPKNvehNSyrbf7M8Mb4HJ/RhXaGUJ4Ex+zBid7e+QJKneAJ+Vmg
         3f0RS7x4I7Tt2jjHrnalhwbCC/bIa8qoSnrDu/zzYLzL8fBEKXawRBYp6pd7wVgbg7Vr
         nzy80BXPV56e0712rt0noR8BYIwWDD4Ha0HHmeloJEz1kX1q79wnb/IIYMBXXcCD1jUS
         TDRXuhcELkc6m8xHOYM/vJSaomgaw6opYZ2NN/i3FKhTBve6EM1U2BGOxsY52UBMwbpW
         jTWA==
X-Gm-Message-State: AOAM533fRu9soIFH9aqfmCh0/Hsyar0NdU22CNu/TvyjhQPVZLH52sXl
        IduRk/RrLVlK1ky6+FHcxsRJ4w==
X-Google-Smtp-Source: ABdhPJwIySgd5FjYEb2seaX5kyI0Ej2bREBDLCoGNYAWJMUC5WkeYKNtC90051dOURxepwzIcfAp0Q==
X-Received: by 2002:a05:620a:6b7:: with SMTP id i23mr14461310qkh.156.1590154697354;
        Fri, 22 May 2020 06:38:17 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id m33sm7675398qte.17.2020.05.22.06.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 06:38:16 -0700 (PDT)
Date:   Fri, 22 May 2020 09:38:16 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Matthew Blecker <matthewb@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Mike Frysinger <vapier@google.com>,
        Christian Brauner <christian@brauner.io>,
        Vineeth Remanan Pillai <vpillai@digitalocean.com>,
        vineethrp@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RFC] sched/headers: Fix sched_setattr userspace
 compilation issues
Message-ID: <20200522133816.GB210175@google.com>
References: <20200521155346.168413-1-joel@joelfernandes.org>
 <CAEXW_YTj83gO0STovrOuL9zgDwEYWRJusUZ3ebVw_jOG6yJxTg@mail.gmail.com>
 <20200522131355.f4bdc2f4h2zyqbku@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200522131355.f4bdc2f4h2zyqbku@wittgenstein>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 03:13:55PM +0200, Christian Brauner wrote:
> On Thu, May 21, 2020 at 11:55:21AM -0400, Joel Fernandes wrote:
> > On Thu, May 21, 2020 at 11:53 AM Joel Fernandes (Google)
> > <joel@joelfernandes.org> wrote:
> > >
> > > On a modern Linux distro, compiling the following program fails:
> > >  #include<stdlib.h>
> > >  #include<stdint.h>
> > >  #include<pthread.h>
> > >  #include<linux/sched/types.h>
> > >
> > >  void main() {
> > >          struct sched_attr sa;
> > >
> > >          return;
> > >  }
> > >
> > > with:
> > > /usr/include/linux/sched/types.h:8:8: \
> > >                         error: redefinition of ‘struct sched_param’
> > >     8 | struct sched_param {
> > >       |        ^~~~~~~~~~~
> > > In file included from /usr/include/x86_64-linux-gnu/bits/sched.h:74,
> > >                  from /usr/include/sched.h:43,
> > >                  from /usr/include/pthread.h:23,
> > >                  from /tmp/s.c:4:
> > > /usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:23:8:
> > > note: originally defined here
> > >    23 | struct sched_param
> > >       |        ^~~~~~~~~~~
> > >
> > > This is also causing a problem on using sched_attr Chrome. The issue is
> > > sched_param is already provided by glibc.
> > >
> > > Guard the kernel's UAPI definition of sched_param with __KERNEL__ so
> > > that userspace can compile.
> > >
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > 
> > If it is more preferable, another option is to move sched_param to
> > include/linux/sched/types.h
> 
> Might it be worth Ccing libc-alpha here? Seems like one of those classic
> header conflicts.

sched_param is defined by POSIX from my reading of the manpage. Is the kernel
supposed to define it in the UAPI at all? I guarded it with __KERNEL__ as you
can see.

Resent with libc-alpha CC'd per your suggestion.

thanks,

 - Joel


