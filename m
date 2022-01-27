Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E471D49E6BE
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243252AbiA0PyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237754AbiA0PyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:54:20 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46B2C061714;
        Thu, 27 Jan 2022 07:54:19 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b9so6212116lfq.6;
        Thu, 27 Jan 2022 07:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tEdIw9wvH2zzikieh/eX5e+Rn+l7enMUtCDEVtvQdrk=;
        b=RFckaGUnFbqIPS+Q3iHJdF5OVea6d/84A+JBwxVoCixniwESqyDafZ3gFBKPIzaPrO
         8TSOKZ8Jp4DbbQkgIq0OIxwnbnNzUcMY2U5VBYn3mxflXD9WRG+qxFBn3BVNEIPYLLIA
         FyTGNk8T2sB2CWrxUGumY2eAgbTTOY3HW3lrIuou4T+wPPAdnH1NiwFcCfVM4DcI2ZTN
         PvLMjVheIkU+hB3Rm1WXGRR0wAD7dd6/Is6eiIW6AfgrgkyTkx45Yo0e6JlB/+rgI3A9
         Ye+wgETRfXf5dDOEv7DHF3JcXiOqlv+iuMiTp058SHGz2cAAWKl5Y2Huco9lXwSBdVKA
         +azA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tEdIw9wvH2zzikieh/eX5e+Rn+l7enMUtCDEVtvQdrk=;
        b=b8TZh8zad6ij1UQ8xCDrUZNKGrvsVxxDJ0rJgkzbbVyU9MVOcrtvFQGcCOIuG0LrYI
         jaOCfQsGHKVW3CkEbO6ApKvdq/lS7F6ectyl1kKkjHBQEQhtZX3NRC4QpyCVqQwkMk3L
         lUzCdLuK4fnM0CGdSnTAWCOslglH4AKCXUL+265DH7SaayUVJSPqovPEHrNEpwxcl1td
         vK2+jgTSfKum/OA4N5Uoa7fMUHFmwl6zUBnvpOqJqVjXBUP0lpxwjaQ2RZsxhTCPgmV4
         LY2O1vUW4JP6le7LfJyruR5cLsgPC5mP9O2NLuFXZwgeOvWRvEJRUSyGUojmq+SNUr2q
         9sDg==
X-Gm-Message-State: AOAM533vT7VhTG1KqirJhknhkb6THnp+VmzqX9vnOMjtiaaiCLZG8fJT
        CFpLZGG70d0TIkWzGg0w94A=
X-Google-Smtp-Source: ABdhPJw2RbNlH1CI/XMN31AVt5cBqVHbtguMFCuLTIRR3y0VtDDhtWko0pU27pPdEeTzVhMuLYIUcQ==
X-Received: by 2002:a05:6512:1054:: with SMTP id c20mr3147735lfb.654.1643298857761;
        Thu, 27 Jan 2022 07:54:17 -0800 (PST)
Received: from pc638.lan ([155.137.26.201])
        by smtp.gmail.com with ESMTPSA id m22sm1689600lfq.192.2022.01.27.07.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:54:17 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 27 Jan 2022 16:54:15 +0100
To:     Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Message-ID: <YfLAJyKVGNOTUCSc@pc638.lan>
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <20220126185340.58f88e8e1b153b6650c83270@linux-foundation.org>
 <c658f8c5-a808-f2f1-2e1e-cfb68dd19d6a@colorfullife.com>
 <YfJXDDeDwZuBxs13@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfJXDDeDwZuBxs13@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 09:25:48AM +0100, Michal Hocko wrote:
> On Thu 27-01-22 06:59:50, Manfred Spraul wrote:
> > Hi Andrew,
> > 
> > On 1/27/22 03:53, Andrew Morton wrote:
> > > On Wed, 22 Dec 2021 20:48:28 +0100 Manfred Spraul <manfred@colorfullife.com> wrote:
> > > 
> > > > One codepath in find_alloc_undo() calls kvfree() while holding a spinlock.
> > > > Since vfree() can sleep this is a bug.
> > > > 
> > > > Previously, the code path used kfree(), and kfree() is safe to be called
> > > > while holding a spinlock.
> > > > 
> > > > Minghao proposed to fix this by updating find_alloc_undo().
> > > > 
> > > > Alternate proposal to fix this: Instead of changing find_alloc_undo(),
> > > > change kvfree() so that the same rules as for kfree() apply:
> > > > Having different rules for kfree() and kvfree() just asks for bugs.
> > > > 
> > > > Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.
> > > I know we've been around this loop a bunch of times and deferring was
> > > considered.   But I forget the conclusion.  IIRC, mhocko was involved?
> > 
> > I do not remember a mail from mhocko.
> 
> I do not remember either.
> 
> > 
> > Shakeel proposed to use the approach from Chi.
> > 
> > Decision: https://marc.info/?l=linux-kernel&m=164132032717757&w=2
> 
> And I would agree with Shakeel and go with the original change to the
> ipc code. That is trivial and without any other side effects like this
> one. I bet nobody has evaluated what the undconditional deferred freeing
> has. At least changelog doesn't really dive into that more than a very
> vague statement that this will happen.
>
Absolutely agree here. Especially that changing the kvfree() will not
look stable.

After applying the https://www.spinics.net/lists/linux-mm/msg282264.html
we will be able to use vfree() from atomic anyway.

--
Vlad Rezki
