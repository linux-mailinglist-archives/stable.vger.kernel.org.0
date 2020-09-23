Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11726274DCD
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 02:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgIWA04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 20:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgIWA0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 20:26:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67707C061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 17:26:55 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z23so25272757ejr.13
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 17:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mVimv4F4pEyqaeD0LO4zdEDOLVsHvqmHuDl7JJ50ulQ=;
        b=egeCKs17gt8CwPK7u6srOHG8/XtUaR57acvx0TxFQN4OgfTewTTwNVhJ3xelSuchN5
         dH/v0TdAhVjm1OyK8YI/T1+nqHAvQGirk70/PXrjkrdJstF0zEVxO5EnN1TxNqfCZaIs
         sVFUFHg41vJCFF8sHTLjyTKmBQc6j+DXLyARf1yKv3ipC/84wjQsbZkM+FPiwArDH8cJ
         bKSG7LvIosF6KjiHPL5OTU7DIEfS5cCFKMjLfJ3X4RvlJz61N2TQQVaxEsdJ9C8UZ2Ss
         6EcJmIO8EzYqFXjqs1VH/T6FFOBJAM/zJ/HxZwB4JnNx4mM4AmtxRYYLWa/cjUZee6+T
         Cwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mVimv4F4pEyqaeD0LO4zdEDOLVsHvqmHuDl7JJ50ulQ=;
        b=S6oiJcukZ8yxjdWDfAoARWeIa3bDgYI/rlWzNXoncxIvF1/tauStoao/S/lJZjLXaG
         ABCLZ2uWbgzZhgFDvtMpAdid1IcPbpc2x32K26iLZ4Qm/Hlgi54yU2cgorxU5KvXLnQG
         MjMA8w+6m/4J6feIXZugHKI23gXh7okICWrbJcL2KNYg08cuYZByRdBXU73CstQ15Uur
         YLQh6xvOflJtlZ4cSYDY9+0oed2vKsmlTxorp0oZWBOmeRHrwlaN2DLQf7RBgdQApOty
         7wiBpqzRSAeI6KYYQPL8eBY7vP+Bt/zTnyRhBxA9SsKueXQ0OpTfgb9hQ00bzbtu4oCH
         A9ow==
X-Gm-Message-State: AOAM530FW1/EUBp4Ak+kdxSWoLh1XhYnt8tauvGXMy0Wj6Ne0ZhLyCD0
        9eHczFyXqku81ecj2W9lH9RIjS8Ukt9huFzfR5h67Q==
X-Google-Smtp-Source: ABdhPJzMI1hBpS5IYBJf0bWw0qKhmM688XSDWbxykQZ6wRaR8yLKTmjvfdk/TFFeszIL860KBJljCLyAkyMM+SAS30U=
X-Received: by 2002:a17:906:2354:: with SMTP id m20mr7460553eja.341.1600820812915;
 Tue, 22 Sep 2020 17:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <159630256804.3143511.8894023468833792004.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200803094257.GA23458@shao2-debian> <20200806133452.GA2077191@gmail.com>
 <CAPcyv4hS7K0Arrd+C0LhjrFH=yGJf3g55_WkHOET4z58AcWrJw@mail.gmail.com> <20200806153500.GC2131635@gmail.com>
In-Reply-To: <20200806153500.GC2131635@gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 22 Sep 2020 17:26:41 -0700
Message-ID: <CAPcyv4jk8TRDSJVmN_sAbqkHAQa4gvE2_k4Vrg1aUOikX44yMA@mail.gmail.com>
Subject: Re: [x86/copy_mc] a0ac629ebe: fio.read_iops -43.3% regression
To:     Ingo Molnar <mingo@kernel.org>
Cc:     kernel test robot <rong.a.chen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        X86 ML <x86@kernel.org>, stable <stable@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        0day robot <lkp@intel.com>, lkp@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 6, 2020 at 8:35 AM Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Thu, Aug 6, 2020 at 6:35 AM Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > >
> > > * kernel test robot <rong.a.chen@intel.com> wrote:
> > >
> > > > Greeting,
> > > >
> > > > FYI, we noticed a -43.3% regression of fio.read_iops due to commit:
> > > >
> > > >
> > > > commit: a0ac629ebe7b3d248cb93807782a00d9142fdb98 ("x86/copy_mc: Introduce copy_mc_generic()")
> > > > url: https://github.com/0day-ci/linux/commits/Dan-Williams/Renovate-memcpy_mcsafe-with-copy_mc_to_-user-kernel/20200802-014046
> > > >
> > > >
> > > > in testcase: fio-basic
> > > > on test machine: 96 threads Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 256G memory
> > > > with following parameters:
> > >
> > > So this performance regression, if it isn't a spurious result, looks
> > > concerning. Is this expected?
> >
> > This is not expected and I think delays these patches until I'm back
> > from leave in a few weeks. I know that we might lose some inlining
> > effect due to replacing native memcpy, but I did not expect it would
> > have an impact like this. In my testing I was seeing a performance
> > improvement from replacing the careful / open-coded copy with rep;
> > mov;, which increases the surprise of this result.
>
> It would be nice to double check this on the kernel-test-robot side as
> well, to make sure it's not a false positive.

Circling back to this, I found the bug. This incremental patch nearly
doubles the iops in the case when copy_mc_fragile() is enabled because
it was turning around and redoing the copy with copy_mc_generic(). So
this would have been a regression for existing systems that indicate
that "carefu/fragilel" copying can avoid some PCC=1 machine checks. My
performance checkout was comparing copy_mc_fragile() and
copy_mc_generic() in isolation. Refreshed patches inbound.

diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
index 9e6fac1ab72e..afac844c8f45 100644
--- a/arch/x86/lib/copy_mc.c
+++ b/arch/x86/lib/copy_mc.c
@@ -58,7 +58,8 @@ copy_mc_to_user(void *to, const void *from, unsigned len)
        __uaccess_begin();
        if (static_branch_unlikely(&copy_mc_fragile_key))
                ret = copy_mc_fragile(to, from, len);
-       ret = copy_mc_generic(to, from, len);
+       else
+               ret = copy_mc_generic(to, from, len);
        __uaccess_end();
        return ret;
 }
