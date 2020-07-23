Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E8322A6AC
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 06:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgGWEqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 00:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWEqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 00:46:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2FBC0619DC;
        Wed, 22 Jul 2020 21:46:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u185so2394460pfu.1;
        Wed, 22 Jul 2020 21:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x5OWXZ2oCswUaXjRk5/hllGRxClOI19n8grS+p6yEeY=;
        b=NCwYT/HglPC9BjF5hFoBQ8gvnq21EQlOOuf235wRoCXJW5tAroAUCRtrPFSG6KVxNo
         eNSeDxO7EPgAqep4yOvmr06UUjE+7ICHE5b/n+4MLrKuzWLa5PMj8j+noZV0tzYJIpEA
         R1EbXnq/QI7jt6V2NeUCymZlLrPVxsCaoAGCYSEdC8Habe+JYtdyHsA09lAC+0/gvwQU
         wXqM6bLbGz53jGLOqj+uxEc3f2JyGPmbDTVveBUdQimR/ABZqgpSo7ZoSHJTlpd4uDir
         I7nVC1vPDOBabOMjZv/cfGd0fPqW4e3jtc+5la+r0OhjjT4wESNBWR+YgQp/a3QUMt5j
         +02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x5OWXZ2oCswUaXjRk5/hllGRxClOI19n8grS+p6yEeY=;
        b=O11Sbp/V4DL6XMeGrmZkMlaNZN7ah3JefbcFHAtTXQ5WPA3jc3lXPCupsLnW7aMHs1
         5/8/fUQAhXog65B4nVRqHAp8lmMGX27EeJGp/GUMd1A58cZzYWW+MDkVbv/86d+ExOPk
         CEsBQzjz8ZhQd7D3jy+UVBcKmbeJm5YS9viG0ySJq4e5CEFMRy+/IJmjxaGPS9qPQBJA
         /1SuOf85kst32gVh+KblBk9VQJUg0NZ+AhTAB14XaUHzWNigcTDfNkWd5/Ai2ALrpAWH
         fdxppHEyeR/mncsdX07EnWC8Rs/VdwzV/QhGboc160S0xN/hsv/tOryjfVC38Lv0sv2I
         Rieg==
X-Gm-Message-State: AOAM532qJup7XBqTenE074CKKvkcfA2AglYa/JaNaZ5LI4WBmjmSHLif
        lZPE2HZO4Fju4CZgM4rpTmU=
X-Google-Smtp-Source: ABdhPJwVZwpILYxgUNEUu8nRecBvRcd/N1KnIwfW0B1zZEM5IiwDsOwwHwVNctCJr9xktB0OtJc8tQ==
X-Received: by 2002:a62:1407:: with SMTP id 7mr2433532pfu.88.1595479606028;
        Wed, 22 Jul 2020 21:46:46 -0700 (PDT)
Received: from localhost (g155.222-224-148.ppp.wakwak.ne.jp. [222.224.148.155])
        by smtp.gmail.com with ESMTPSA id 129sm1256303pfv.161.2020.07.22.21.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 21:46:45 -0700 (PDT)
Date:   Thu, 23 Jul 2020 13:46:42 +0900
From:   Stafford Horne <shorne@gmail.com>
To:     Atish Patra <Atish.Patra@wdc.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "palmerdabbelt@google.com" <palmerdabbelt@google.com>,
        "walken@google.com" <walken@google.com>,
        "naresh.kamboju@linaro.org" <naresh.kamboju@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zong.li@sifive.com" <zong.li@sifive.com>
Subject: Re: [PATCH 5.7 233/244] RISC-V: Acquire mmap lock before invoking
 walk_page_range
Message-ID: <20200723044642.GA80756@lianli.shorne-pla.net>
References: <20200720191403.GB1529125@kroah.com>
 <mhng-903745bf-c5df-4e70-ade8-c1e596265fc4@palmerdabbelt-glaptop1>
 <20200722124839.GB3155653@kroah.com>
 <0fcbb91ab6dc49807dcca953c5dca673ad403045.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fcbb91ab6dc49807dcca953c5dca673ad403045.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 22, 2020 at 03:11:35PM +0000, Atish Patra wrote:
> On Wed, 2020-07-22 at 14:48 +0200, Greg KH wrote:
> > On Tue, Jul 21, 2020 at 03:50:35PM -0700, Palmer Dabbelt wrote:
> > > On Mon, 20 Jul 2020 12:14:03 PDT (-0700), Greg KH wrote:
> > > > On Mon, Jul 20, 2020 at 06:50:10PM +0000, Atish Patra wrote:
> > > > > On Mon, 2020-07-20 at 23:11 +0530, Naresh Kamboju wrote:
> > > > > > RISC-V build breaks on stable-rc 5.7 branch.
> > > > > > build failed with gcc-8, gcc-9 and gcc-9.
> > > > > > 
> > > > > 
> > > > > Sorry for the compilation issue.
> > > > > 
> > > > > mmap_read_lock was intrdouced in the following commit.
> > > > > 
> > > > > commit 9740ca4e95b4
> > > > > Author: Michel Lespinasse <walken@google.com>
> > > > > Date:   Mon Jun 8 21:33:14 2020 -0700
> > > > > 
> > > > >     mmap locking API: initial implementation as rwsem wrappers
> > > > > 
> > > > > The following two commits replaced the usage of mmap_sem rwsem
> > > > > calls
> > > > > with mmap_lock.
> > > > > 
> > > > > d8ed45c5dcd4 (mmap locking API: use coccinelle to convert
> > > > > mmap_sem
> > > > > rwsem call sites)
> > > > > 89154dd5313f (mmap locking API: convert mmap_sem call sites
> > > > > missed by
> > > > > coccinelle)
> > > > > 
> > > > > The first commit is not present in stale 5.7-y for obvious
> > > > > reasons.
> > > > > 
> > > > > Do we need to send a separate patch only for stable branch with
> > > > > mmap_sem ? I am not sure if that will cause a conflict again in
> > > > > future.
> > > > 
> > > > I do not like taking odd backports, and would rather take the
> > > > real patch
> > > > that is upstream.
> > > 
> > > I guess I'm a bit new to stable backports so I'm not sure what's
> > > expected here.
> > > The failing patch fixes a bug by using a new interface.  The
> > > smallest diff fix
> > > for the stable kernels would be to construct a similar fix without
> > > the new
> > > interface, which in this case is very easy as the new interface
> > > just converted
> > > some generic locking calls to one-line functions.  It seems
> > > somewhat circuitous
> > > to land that in Linus' tree, though, as it would require breaking
> > > our port
> > > before fixing it to use the old interfaces and then cleaning it up
> > > to use the
> > > new interfaces.
> > > 
> > > Are we expected to pull the new interface onto stable in addition
> > > to this fix?
> > 
> > If it really does fix a big issue, yes, that is fine to do.
> > 
> 
> The original issue was manifests only for certain rootfs with
> CONFIG_DEBUG_VM enabled in kernel. I am not sure if that qualfies for a
> big issue :). But there was a similar fix for OpenRISC as well.
> 
> +stafford (who fixed the issue for OpenRISC)
> 
> @stafford Was there a request to backport the fix to stable ?

I have not requested  pulling my patch to stable.  Mine is this one:

  313a5257b84c2 ("openrisc: fix boot oops when DEBUG_VM is enabled")

If you cat request that would be great.

> I can combine all the git ids that needs to be pulled in.

Note, mine lists:

  Fixes: 42fc541404f2 ("mmap locking API: add mmap_assert_locked() and mmap_assert_write_locked()")

while your's lists:

  Fixes: 395a21ff859c(riscv: add ARCH_HAS_SET_DIRECT_MAP support)

That is when the code was introduced to the riscv port, but not the commit that
broke booting.

I think if you list the Fixes as I did when backporting to stable Greg, or his
tools, would also know that the patch depends on the the 42fc541404f2 commit.

Also, I guess there is no problem with listing 2 "Fixes" in the future.

Thanks Atish and Palmer.

-Stafford

> > > The new interface doesn't actually fix anything itself, but it
> > > would allow a
> > > functional kernel to be constructed that consisted of only
> > > backports from
> > > Linus' tree (which would also make further fixes easier).
> > 
> > That's fine.
> > 
> > > It seems safe to
> > > just pull in 9740ca4e95b4 ("mmap locking API: initial
> > > implementation as rwsem
> > > wrappers") before this failing patch, as in this case the new
> > > interface will
> > > function correctly with only a subset of callers having been
> > > converted.  Of
> > > course that's not a generally true statement so I don't know if
> > > future code
> > > will behave that way, but pulling in those conversion patches is
> > > definitely
> > > unnecessary diff right now.
> > 
> > If someone wants to send me a full set of the git ids that need to be
> > pulled in, I will be glad to do so.
> > 
> > thanks,
> > 
> > greg k-h
> 
> -- 
> Regards,
> Atish
