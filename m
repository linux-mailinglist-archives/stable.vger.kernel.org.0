Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDED23DF02
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgHFRgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbgHFRf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 13:35:27 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F41C0086A8
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 08:20:03 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id m19so10217571ejd.8
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 08:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=27KOdDBMR58YvRnK7H5/nd9yUqjH+UuYcfpnQiwOOLU=;
        b=tGrB7Z7WS0HHtWrS+RAu0IAYwU8Nad8rwMZdG73SY5x2ARE0d1FqXwWCLzD3UMrdlR
         6Kn0kjJyU3Zbj6OubM+TRf7kg41JZspNfLxofrrUzUQMRrYpHgt6yi61+Rzw0TSxyySG
         ZrV978lfm55ZcESwNGZp975asvMxzL4xk01lDpBkj9kuUKt1y4ZnLs/xyWsATvELhJk1
         kFLFuZbHju979DVXXQ3lQhqftMpDMvL9oc++9T2qcgkhq/HPw08XX+JQDNIRTow6uAXN
         WiVbdduH+x+EmynnvVmeE/Jlm8OcHRV5jln6i5lJFo17YjLsUFxNhJ1YjoX3Mjouet1b
         4MZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=27KOdDBMR58YvRnK7H5/nd9yUqjH+UuYcfpnQiwOOLU=;
        b=XhTi3f3UNN+v281vIQzabGKzWOFaaqWQxWHyInKrU1Kw6Bqhl3zD3nUx4R7dKcYKEQ
         ga7W0jDT8t52qUwKshOH6zVWeEAt1Wxhz2RcKUcXpUMCofkjX58mqZnm6njbY63YBJH9
         rhxis5ok6d8kJo1WCrwrEt407l8UY8axs1kyXAT2dLnF5mh3xFml2ogGsyNdmzZVlebo
         VqXdlc8Dac2qsxraDZeH76nGvJxA5hyoY+lBkCN/j73q4tEp4qLg0avsKex7vfHvXRnG
         AFi0XJwyTZoKEFOioDCdkSZZmCAMRzzLXtkoLDMHRrFa5tACfVT/AwLDpR9wzUPTVZbb
         KfmQ==
X-Gm-Message-State: AOAM533iUmJ6BaDwlSXDfvuDezvBZJxP9uDPEOFsumBcG+E6MnbtP7mp
        3zGToAn6IQp6nfa6J3xc3KFwk6Iex05FisrwIIPmKA==
X-Google-Smtp-Source: ABdhPJzrlkvHWWpq4WM0aG15rib8qGzmbNy1T+8TCAaz/ASsMen1gmJIqTYuiQwAEJfL8+D0y5EKRfUDgIokuAOiI0I=
X-Received: by 2002:a17:906:38d8:: with SMTP id r24mr4667542ejd.341.1596727202027;
 Thu, 06 Aug 2020 08:20:02 -0700 (PDT)
MIME-Version: 1.0
References: <159630256804.3143511.8894023468833792004.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200803094257.GA23458@shao2-debian> <20200806133452.GA2077191@gmail.com>
In-Reply-To: <20200806133452.GA2077191@gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 6 Aug 2020 08:19:52 -0700
Message-ID: <CAPcyv4hS7K0Arrd+C0LhjrFH=yGJf3g55_WkHOET4z58AcWrJw@mail.gmail.com>
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
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 6, 2020 at 6:35 AM Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * kernel test robot <rong.a.chen@intel.com> wrote:
>
> > Greeting,
> >
> > FYI, we noticed a -43.3% regression of fio.read_iops due to commit:
> >
> >
> > commit: a0ac629ebe7b3d248cb93807782a00d9142fdb98 ("x86/copy_mc: Introduce copy_mc_generic()")
> > url: https://github.com/0day-ci/linux/commits/Dan-Williams/Renovate-memcpy_mcsafe-with-copy_mc_to_-user-kernel/20200802-014046
> >
> >
> > in testcase: fio-basic
> > on test machine: 96 threads Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 256G memory
> > with following parameters:
>
> So this performance regression, if it isn't a spurious result, looks
> concerning. Is this expected?

This is not expected and I think delays these patches until I'm back
from leave in a few weeks. I know that we might lose some inlining
effect due to replacing native memcpy, but I did not expect it would
have an impact like this. In my testing I was seeing a performance
improvement from replacing the careful / open-coded copy with rep;
mov;, which increases the surprise of this result.
