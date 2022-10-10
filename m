Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C2B5FA71D
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 23:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiJJVkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 17:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJJVkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 17:40:49 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8C57D7A3;
        Mon, 10 Oct 2022 14:40:43 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y100so17597054ede.6;
        Mon, 10 Oct 2022 14:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YMm42EDaG2xyenP4cqz7LgZCKvvRWqD9+usRBzVHGfc=;
        b=fFJbmdOl/YV8OjteSQwffjfxHeWRPRJ30eoFYJyNj1kJRMsmeXSaq8EnsbOtkkvhFW
         HRLAuVvz4SispDPW6uITgsAXqKr3QdyKEYG08RbNc6/BAWtS73Vwg4CWwcWxSpXAyfVN
         mmtlZU9cX2nZSs9qZV6Qsfh2guswB8vDvAHDuWgR5LxdozJotrMEG5DawcCKYORDp2K2
         0XAk40eNjAoHZ/lhOtUaJmScHR8SSTVBU2lGjyJK9sp/z9H/fRnZmrzymumkLGeg13Tl
         YiZ4t4BorJNi1C5eV3yjQrmQ0vdygo3cjUjWvWHBaHINprmO0HGiUdd0hB2W4ZElRb0P
         UQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YMm42EDaG2xyenP4cqz7LgZCKvvRWqD9+usRBzVHGfc=;
        b=2qrZSXqWqW8iZsLLoQpb9mpmFCLPYW+r+A9CkmN7a1PM7xpOoUjL+C5v6I0S0e3i8p
         cGbULh236kys3zfQW8syxw6L9MRbvOjpOsqPGzCBFw0uY9YrpwOSxj9mFvzLMqmWjShW
         m2oiA2UgXDhdQTUqXYB5i5WrlJ6cyvt8YCDd7y9smIY1IAq79fYuS+l9yEZ/lbFvCoOL
         xp5QNZ8sfdvGbkhMz275ARzyUtfUNqpWCQ2FMFbowsWGuhVIq2C+xIweWGrGm0eY8hIv
         gXQ6gCu6sR99nG3cZP3zPXJN+C1PHrqTaht0JULj4dtZ92IUGx0C1g8hVIZd/bTppsmH
         VJhA==
X-Gm-Message-State: ACrzQf1qcjCNnwwcFNFthpHBGWaCU7wNZO/0eO6Vn40e9BnnlxLeYcvS
        7sdkMbIiCdJ47Qxdvw+WyWVf0YLNHlllisYo/zA=
X-Google-Smtp-Source: AMsMyM5C7u2F0QtafFz7eTH6G0n466XMMI5XD7JZp8CrNqA63PgghDU4nBrmjb/SeSw9qslHcEfa9zDzf4RoYBtKVP0=
X-Received: by 2002:a05:6402:909:b0:435:a8b:5232 with SMTP id
 g9-20020a056402090900b004350a8b5232mr19660325edz.240.1665438041735; Mon, 10
 Oct 2022 14:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221003215734.7l3cnb2zy57nrxkk@synopsys.com> <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com> <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com> <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com> <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com> <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <Y0PFZGLaREQUazVP@smile.fi.intel.com>
In-Reply-To: <Y0PFZGLaREQUazVP@smile.fi.intel.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 10 Oct 2022 14:40:30 -0700
Message-ID: <CAHQ1cqG73UAoU=ag9qSuKdp+MzT9gYJcwGv8k8BOa=e8gWwzSg@mail.gmail.com>
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

On Mon, Oct 10, 2022 at 12:13 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Sun, Oct 09, 2022 at 10:02:26PM -0700, Andrey Smirnov wrote:
> > On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth <fntoth@gmail.com> wrote:
>
> Thank you for the testing on your side!
>
> ...
>
> > OK, Ferry, I think I'm going to need clarification on specifics on
> > your test setup. Can you share your kernel config, maybe your
> > "/proc/config.gz", somewhere? When you say you are running vanilla
> > Linux, do you mean it or do you mean vanilla tree + some patch delta?
> >
> > The reason I'm asking is because I'm having a hard time reproducing
> > the problem on my end. In fact, when I build v6.0
> > (4fe89d07dcc2804c8b562f6c7896a45643d34b2f) and then do a
> >
> > git revert 8bd6b8c4b100 0f0101719138 (original revert proposed by Andy)
> >
> > I get an infinite loop of reprobing that looks something like (some
> > debug tracing, function name + line number, included):
>
> Yes, this is (one of) known drawback(s) of deferred probe hack. I think
> the kernel that Ferry runs has a patch that basically reverts one from
> 2014 [1] and allows to have extcon as a module. (1)
>
> [1]: 58b116bce136 ("drivercore: deferral race condition fix")
>
> > which renders the system completely unusable, but USB host is
> > definitely going to be broken too. Now, ironically, with my patch
> > in-place, an attempt to probe extcon that ends up deferring the probe
> > happens before the ULPI driver failure (which wasn't failing driver
> > probe prior to https://lore.kernel.org/all/20220213130524.18748-7-hdegoede@redhat.com/),
> > there no "driver binding" event that re-triggers deferred probe
> > causing the loop, so the system progresses to a point where extcon is
> > available and dwc3 driver eventually loads.
> >
> > After that, and I don't know if I'm doing the same test, USB host
> > seems to work as expected. lsusb works, my USB stick enumerates as
> > expected. Switching the USB mux to micro-USB and back shuts the host
> > functionality down and brings it up as expected. Now I didn't try to
> > load any gadgets to make sure USB gadget works 100%, but since you
> > were saying it was USB host that was broken, I wasn't concerned with
> > that. Am I doing the right test?
>
> Hmm... What you described above sounds more like a yet another attempt to
> workaround (1). _If_ this is the case, we probably can discuss how to fix
> it in generic way (somewhere in dd.c, rather than in the certain driver).
>

No, I'm not describing an attempt to fix anything. Just how vanilla
v6.0 (where my patch is not reverted) works and where my patch, fixing
a logical problem in which extcon was requested too late causing a
forced OTG -> "gadget only" switch, also changed the ordering enough
to accidentally avoid the loop.

> That said, the real test case should be performed on top of clean kernel
> before judging if it's good or bad.
>

Given your level of involvemnt with this particular platform and you
being the author of
https://github.com/edison-fw/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/files/0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch
I assumed/expected you to double check this before sending this revert
out. Please do so next time.
