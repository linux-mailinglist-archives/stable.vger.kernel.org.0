Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EE05FBBF3
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 22:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJKURe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 16:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJKUR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 16:17:29 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75E89C7F8;
        Tue, 11 Oct 2022 13:17:27 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z97so21744069ede.8;
        Tue, 11 Oct 2022 13:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/dVWmSEpPkjHTh+w4m1dqtY30GxJiF4wnPh/0dTOSI8=;
        b=CcWVueIiWsiL0nvXq9hB6HFgq+6S2DciP2Q07yMmF3g65kqHaEyf0TPST2Yk1NOeHe
         KFUP9UA5lCaqXmF+YYbvaemwVKqEeSIb3/NmmPvcUHgb5uaK080W3UWZqzqJrulm7Ps6
         ctuUDCwKIm6qNn598scLuCId7ZuqTqzSHI1Eyw1XWTMSN4CISKhEVoRRLKfmhaKpK1sT
         g6qHuiIWzJG8ZNmT0Xt7swGES4Gf4KPFrHTqQzqLJ12As4fUCqJotKEcYxDBbJf6sH4G
         YmXsa9ahXMx8JKJ3NiS44yTqBOcikg7dEBVecopRdOswsmqe8mojVuyniOUG+5zQFU5N
         Dm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/dVWmSEpPkjHTh+w4m1dqtY30GxJiF4wnPh/0dTOSI8=;
        b=zTLx774PYgrMU8j+3pz1c/5Qh2EZG4w+9RLDmwRQ3rPKHtdJX6SGhbW2W5JGtvUaYH
         Pihz//iCwYqw9ijPD8QDMWM3BLCDykhIuvbQuqIVNMbnd617Kis2PI1jSw5sj5YkzGKa
         QiPEflQWZiZEoxMjsTLXTsNxFL0nP/82TQZEqNimUHaHnJtMZlnkfJfRqJDF5Bq49anJ
         udthT8iv5P4eRyznvdrgJJY2vpTCUuio6DZpom/AzeCbCTS9/xd6SDhxtzz5cKQZLsVj
         L5sReJJDBhticbcEbEEd+p8OK0Wnrd45vDzaNWOVWZE3N+27pSqvmeQvjVZFNIYrLhFB
         qRIw==
X-Gm-Message-State: ACrzQf1ju4gx5gpNQKDk6N9kPfby/phsYvPb3lTbNtGqv85D35MX65MI
        5/NcazN6OIlBm1x83wpMxJ9RbDm7HKyQPZ4ZDco=
X-Google-Smtp-Source: AMsMyM7dGtOnFAokHqWsD18wriuFb8mrEQbssNxJ8Xd0gQnNQYXjRVeBfWQIkEz+mDeNl9mfvdnZjClH/ODrHSp/7Kc=
X-Received: by 2002:a05:6402:909:b0:435:a8b:5232 with SMTP id
 g9-20020a056402090900b004350a8b5232mr24380112edz.240.1665519446051; Tue, 11
 Oct 2022 13:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com> <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com> <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
 <20221007021122.nnwmqc6sq43e5xbn@synopsys.com> <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com>
 <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <Y0PFZGLaREQUazVP@smile.fi.intel.com> <CAHQ1cqG73UAoU=ag9qSuKdp+MzT9gYJcwGv8k8BOa=e8gWwzSg@mail.gmail.com>
 <Y0U1j2LXmGLBYLAV@smile.fi.intel.com>
In-Reply-To: <Y0U1j2LXmGLBYLAV@smile.fi.intel.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 11 Oct 2022 13:17:13 -0700
Message-ID: <CAHQ1cqHOZr1fBzz=jXTudhw11K-uu4NK9acmeY_URwVxO7MJ7Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Ferry Toth <fntoth@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 2:21 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Mon, Oct 10, 2022 at 02:40:30PM -0700, Andrey Smirnov wrote:
> > On Mon, Oct 10, 2022 at 12:13 AM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > On Sun, Oct 09, 2022 at 10:02:26PM -0700, Andrey Smirnov wrote:
> > > > On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth <fntoth@gmail.com> wrote:
>
> ...
>
> > > > OK, Ferry, I think I'm going to need clarification on specifics on
> > > > your test setup. Can you share your kernel config, maybe your
> > > > "/proc/config.gz", somewhere? When you say you are running vanilla
> > > > Linux, do you mean it or do you mean vanilla tree + some patch delta?
> > > >
> > > > The reason I'm asking is because I'm having a hard time reproducing
> > > > the problem on my end. In fact, when I build v6.0
> > > > (4fe89d07dcc2804c8b562f6c7896a45643d34b2f) and then do a
> > > >
> > > > git revert 8bd6b8c4b100 0f0101719138 (original revert proposed by Andy)
> > > >
> > > > I get an infinite loop of reprobing that looks something like (some
> > > > debug tracing, function name + line number, included):
> > >
> > > Yes, this is (one of) known drawback(s) of deferred probe hack. I think
> > > the kernel that Ferry runs has a patch that basically reverts one from
> > > 2014 [1] and allows to have extcon as a module. (1)
> > >
> > > [1]: 58b116bce136 ("drivercore: deferral race condition fix")
> > >
> > > > which renders the system completely unusable, but USB host is
> > > > definitely going to be broken too. Now, ironically, with my patch
> > > > in-place, an attempt to probe extcon that ends up deferring the probe
> > > > happens before the ULPI driver failure (which wasn't failing driver
> > > > probe prior to https://lore.kernel.org/all/20220213130524.18748-7-hdegoede@redhat.com/),
> > > > there no "driver binding" event that re-triggers deferred probe
> > > > causing the loop, so the system progresses to a point where extcon is
> > > > available and dwc3 driver eventually loads.
> > > >
> > > > After that, and I don't know if I'm doing the same test, USB host
> > > > seems to work as expected. lsusb works, my USB stick enumerates as
> > > > expected. Switching the USB mux to micro-USB and back shuts the host
> > > > functionality down and brings it up as expected. Now I didn't try to
> > > > load any gadgets to make sure USB gadget works 100%, but since you
> > > > were saying it was USB host that was broken, I wasn't concerned with
> > > > that. Am I doing the right test?
> > >
> > > Hmm... What you described above sounds more like a yet another attempt to
> > > workaround (1). _If_ this is the case, we probably can discuss how to fix
> > > it in generic way (somewhere in dd.c, rather than in the certain driver).
> >
> > No, I'm not describing an attempt to fix anything. Just how vanilla
> > v6.0 (where my patch is not reverted) works and where my patch, fixing
> > a logical problem in which extcon was requested too late causing a
> > forced OTG -> "gadget only" switch, also changed the ordering enough
> > to accidentally avoid the loop.
>
> You still refer to a fix, but my question was if it's the same problem or not.
>

No, it's not the same problem.

> > > That said, the real test case should be performed on top of clean kernel
> > > before judging if it's good or bad.
> >
> > Given your level of involvemnt with this particular platform and you
> > being the author of
> > https://github.com/edison-fw/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/files/0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch
> > I assumed/expected you to double check this before sending this revert
> > out. Please do so next time.
>
> As I said I have not yet restored my testing environment for that platform and
> I relied on the Ferry's report. Taking into account the history of breakages
> that done for Intel Merrifield, in particular by not wide tested patches
> against DWC3 driver, I immediately react with a revert.

That's what I'm asking you not to do next time. If you don't have time
to restore your testing env or double check Ferry's work, please live
with a revert in your local tree until you do. My time is as valuable
as yours and this revert required much more investigation before it
was submitted. You lived with
https://github.com/edison-fw/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/files/0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch
since 5.10, which apparently was needed to either boot or have dwc3,
so I don't think there is any real urgency.
