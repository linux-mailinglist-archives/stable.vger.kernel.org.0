Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE9F5FCE3C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 00:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiJLWOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 18:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiJLWOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 18:14:14 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB66E124;
        Wed, 12 Oct 2022 15:14:12 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id x18so227802ljm.1;
        Wed, 12 Oct 2022 15:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aK4BhJufIcl423HeoNB4VLvw9adw2JaRkVkLBj+d2C4=;
        b=AYj/1yqvrQgRPumulzE3dGXIr8voDz+UZOMRhSYvehrkFud1rxULN/tyzcrmBVQSnJ
         ebZxijMrCrNHiPTyTQfJG35Ha9VI+Y5IPrjoipMqdnC9Qti4mmN3drC64LZKZv+sGWj0
         SD2qujioEhEM3U6Ouxhsp0ihFN6xdkvdOjzeagyj1B6OaVZdik2K4rYqKmBXmRElrb+y
         Kl5Eb7o3dFVn5h+vV5kiJL/T6N8YjWzTQA6Rton5jl8lItnQgCrEV/BS2FLGsozt3uvk
         HTqKbZxWS07vG5UK5hyd9RGdF43fScuLp2pA24vgquD9vIJ1GkqbGaQdHYyuetHj8pt/
         RBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aK4BhJufIcl423HeoNB4VLvw9adw2JaRkVkLBj+d2C4=;
        b=Tk87s2rAfbp7xxHRJEMSJYyDi6oqHsG7wE059Y4EOPQROWYOtzGIbeXW7MX3KmQL5t
         jsxpZYBlvRLl8981L9uSFO0GY05adO5HAcQooNbiwOUJ5nbXKM6H1sjIBvH/2KruH1dM
         WUTIWwoowIhVo0sD4MVZr52QUBr7YAVbszTrv2R5mvhNk8Xktry7w2oYrQaoQ97vA/Xd
         oogTc/DfuHSRKY3xv9bKp55k3Ig5jYSz6LMsSeMx+/5HELOW/VQQm4OcIMKcgwfqG5kC
         wNfAKGQ7k7+M8yQI9QAeUT9jkTJMqGw8SyCibgyzldJSIESLTP2KsrtalaMH3KglYc0M
         YOCg==
X-Gm-Message-State: ACrzQf1Y6woiqrKtvbBcyOhCnVVr878CQ8ktgzEyrAc+WkGntxNyvVNm
        2MVe+opXDRpulR4+VfvP/KGxYF+6/iOiVkdYfgo=
X-Google-Smtp-Source: AMsMyM6pOYEkJC1EEW1vxn/yg7LVH4JNi21glC1C+HGyG1/NV4u3jH4ObB+1OtD5ZrZ+gIQCvpwTjcUx7fv+cXrjdhk=
X-Received: by 2002:a2e:5d1:0:b0:26e:1d6:eb2f with SMTP id 200-20020a2e05d1000000b0026e01d6eb2fmr12030057ljf.194.1665612850930;
 Wed, 12 Oct 2022 15:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com> <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
 <20221007021122.nnwmqc6sq43e5xbn@synopsys.com> <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com>
 <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <Y0PFZGLaREQUazVP@smile.fi.intel.com> <CAHQ1cqG73UAoU=ag9qSuKdp+MzT9gYJcwGv8k8BOa=e8gWwzSg@mail.gmail.com>
 <Y0U1j2LXmGLBYLAV@smile.fi.intel.com> <CAHQ1cqHOZr1fBzz=jXTudhw11K-uu4NK9acmeY_URwVxO7MJ7Q@mail.gmail.com>
 <Y0aXtWnlvpkJlxEP@smile.fi.intel.com>
In-Reply-To: <Y0aXtWnlvpkJlxEP@smile.fi.intel.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 12 Oct 2022 15:13:58 -0700
Message-ID: <CAHQ1cqETufvnUWCACHNjGcPYd8tUKs36qnNQzypJwf4v05XYgA@mail.gmail.com>
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

On Wed, Oct 12, 2022 at 3:32 AM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Tue, Oct 11, 2022 at 01:17:13PM -0700, Andrey Smirnov wrote:
> > On Tue, Oct 11, 2022 at 2:21 AM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > On Mon, Oct 10, 2022 at 02:40:30PM -0700, Andrey Smirnov wrote:
> > > > On Mon, Oct 10, 2022 at 12:13 AM Andy Shevchenko
> > > > <andriy.shevchenko@linux.intel.com> wrote:
> > > > > On Sun, Oct 09, 2022 at 10:02:26PM -0700, Andrey Smirnov wrote:
> > > > > > On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth <fntoth@gmail.com> wrote:
>
> ...
>
> > > > > > OK, Ferry, I think I'm going to need clarification on specifics on
> > > > > > your test setup. Can you share your kernel config, maybe your
> > > > > > "/proc/config.gz", somewhere? When you say you are running vanilla
> > > > > > Linux, do you mean it or do you mean vanilla tree + some patch delta?
> > > > > >
> > > > > > The reason I'm asking is because I'm having a hard time reproducing
> > > > > > the problem on my end. In fact, when I build v6.0
> > > > > > (4fe89d07dcc2804c8b562f6c7896a45643d34b2f) and then do a
> > > > > >
> > > > > > git revert 8bd6b8c4b100 0f0101719138 (original revert proposed by Andy)
> > > > > >
> > > > > > I get an infinite loop of reprobing that looks something like (some
> > > > > > debug tracing, function name + line number, included):
> > > > >
> > > > > Yes, this is (one of) known drawback(s) of deferred probe hack. I think
> > > > > the kernel that Ferry runs has a patch that basically reverts one from
> > > > > 2014 [1] and allows to have extcon as a module. (1)
> > > > >
> > > > > [1]: 58b116bce136 ("drivercore: deferral race condition fix")
> > > > >
> > > > > > which renders the system completely unusable, but USB host is
> > > > > > definitely going to be broken too. Now, ironically, with my patch
> > > > > > in-place, an attempt to probe extcon that ends up deferring the probe
> > > > > > happens before the ULPI driver failure (which wasn't failing driver
> > > > > > probe prior to https://lore.kernel.org/all/20220213130524.18748-7-hdegoede@redhat.com/),
> > > > > > there no "driver binding" event that re-triggers deferred probe
> > > > > > causing the loop, so the system progresses to a point where extcon is
> > > > > > available and dwc3 driver eventually loads.
> > > > > >
> > > > > > After that, and I don't know if I'm doing the same test, USB host
> > > > > > seems to work as expected. lsusb works, my USB stick enumerates as
> > > > > > expected. Switching the USB mux to micro-USB and back shuts the host
> > > > > > functionality down and brings it up as expected. Now I didn't try to
> > > > > > load any gadgets to make sure USB gadget works 100%, but since you
> > > > > > were saying it was USB host that was broken, I wasn't concerned with
> > > > > > that. Am I doing the right test?
> > > > >
> > > > > Hmm... What you described above sounds more like a yet another attempt to
> > > > > workaround (1). _If_ this is the case, we probably can discuss how to fix
> > > > > it in generic way (somewhere in dd.c, rather than in the certain driver).
> > > >
> > > > No, I'm not describing an attempt to fix anything. Just how vanilla
> > > > v6.0 (where my patch is not reverted) works and where my patch, fixing
> > > > a logical problem in which extcon was requested too late causing a
> > > > forced OTG -> "gadget only" switch, also changed the ordering enough
> > > > to accidentally avoid the loop.
> > >
> > > You still refer to a fix, but my question was if it's the same problem or not.
> > >
> >
> > No, it's not the same problem.
> >
> > > > > That said, the real test case should be performed on top of clean kernel
> > > > > before judging if it's good or bad.
> > > >
> > > > Given your level of involvemnt with this particular platform and you
> > > > being the author of
> > > > https://github.com/edison-fw/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/files/0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch
> > > > I assumed/expected you to double check this before sending this revert
> > > > out. Please do so next time.
> > >
> > > As I said I have not yet restored my testing environment for that platform and
> > > I relied on the Ferry's report. Taking into account the history of breakages
> > > that done for Intel Merrifield, in particular by not wide tested patches
> > > against DWC3 driver, I immediately react with a revert.
> >
> > That's what I'm asking you not to do next time. If you don't have time
> > to restore your testing env or double check Ferry's work, please live
> > with a revert in your local tree until you do.
>
> I trust Ferry's tests as mine and repeating again, we have a bad history
> when people so value their time that breaks our platform,

This is not a good excuse to jump the gun and send a revert without
double checking. Some regressions will always be unavoidable.

> so please test
> your changes in the future that it makes no regressions.
>

This is, in a nutshell, asking me to prove a negative. That's not a
feasible request. To add insult to injury, you are talking about a
platform way past EOL that's out of stock in every major store and
it's by sheer luck that I was able to get the last kit on eBay.
Downstream will always be the ultimate test for regressions given the
sheer number of permutations. A CI/CD rig that would allow developers
to make a regression test run, would make this a much more reasonable
request, without it, end-user(s) is the only "test bed" there is.

> If you want to have a proof that your patches are broken, then I will
> prioritize this. We now have a full release cycle time for that.
>

You prioritizing this now saves me nothing, whereas you prioritizing
this before submitting reverts would've saved me time. That's the
point I'm trying to convey.

> > My time is as valuable
> > as yours and this revert required much more investigation before it
> > was submitted. You lived with
> > https://github.com/edison-fw/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/files/0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch
> > since 5.10, which apparently was needed to either boot or have dwc3,
> > so I don't think there is any real urgency.
>
> It is in my tree only for the purpose of "don't forget that issue".
> I think you can work around it by built-in extcon driver.
>
