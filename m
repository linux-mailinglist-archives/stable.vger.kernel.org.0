Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D9A52F1A0
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 19:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbiETR2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 13:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352213AbiETR2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 13:28:46 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D1C186299;
        Fri, 20 May 2022 10:28:45 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id i66so10685673oia.11;
        Fri, 20 May 2022 10:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PJV//q4C+9A8+JynDsrPULdS+3PNMfOCw/IssIKP16o=;
        b=lqjsrr+pfYAGghM/3IYxhgJS8jGQ+XlKdPGeBOVSMF01xv7MVSJBIWIgmKQ6u5H7EC
         CdSU2X+8spRMfr/k2ncLLnRgJOynr4Rbfbfxf0uOpUB/GKnWC/piU6pn55pjzSHHqkno
         LBPTO1Wk9FjWIRVEDx07/rh27z0ICXZH3kNsk5YojYTf7oQ19p2FgBYBPN5McGtLJK1o
         un4x0Lujsrq45IXG9A07ApSb3+7xPX4vOixg5sAF96aaAPT9mIRrgKCrblDQezb8NTIW
         N+64rUiOYTKY1Fy2mvV484io7ygZF8Sp9G7z8OrX7FoVzpJLTUEz9xBrNME/ng24Hz02
         Jx8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PJV//q4C+9A8+JynDsrPULdS+3PNMfOCw/IssIKP16o=;
        b=LMdeXwcxhlJF+sqRZjMEdDJqalnxGW8oZu9uZgZq8O7KpgnkUCE+9IiG1iImNfFPgN
         6z7vaSQ4n+o6nJsFLKEla7LJ7ivh5EEucF0lkhUiomWb6F9WOfm9D/C1zarqeJWvFhvy
         Axs1E9eZ0APfBVi8AIZC0t5Yn6KE3dy/d7SjBLKq1bnoeba3Pp5l/sBsjFudc5A3B9hm
         u3rRVMfBbvr32L3NCp23FdE0qcz2/AZa85d6c3pP64/RUiupw3/AD6lLLcOenQfN6pBO
         eRRPJqGPkBMfNnUnAYb45zzTK63IXIhHAeMfBLbhG1yq6NJvvkJaBUuKlGY/JYhiDmv5
         Nxiw==
X-Gm-Message-State: AOAM533O7YCkr28QEeMo7p/21/LDRIYN4i9LIuZpimAt1+jSc1xhZTog
        ZUFByvIBs7SPsgmxpcuBWM0JfuLH8Tut2j9kTL8=
X-Google-Smtp-Source: ABdhPJzve0DTjiYQrp8wbZsMGhQApnnSSk2ujTqRgV6cbl0vEP2x0jeqLmCnKUADThYGL+hlxOE+qrXR/HQzdowXe3o=
X-Received: by 2002:a05:6808:302b:b0:2f9:eeef:f03 with SMTP id
 ay43-20020a056808302b00b002f9eeef0f03mr6312601oib.128.1653067725056; Fri, 20
 May 2022 10:28:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com>
 <CACjc_5q247Yb8t8PfJcudVAPFYQcioREAE3zj8OtPR-Ug_x=tA@mail.gmail.com>
 <CACRpkda=0=Hcyyote+AfwoLKPGak7RV6VFt6b0fMVWBe8veTwA@mail.gmail.com>
 <CACjc_5r7i3HJ466MtwR0iZD6jdVXEqq4km0Tn7XwRijGnsDz=Q@mail.gmail.com>
 <CACRpkdZGVq19GZuOP1BwLB2-qxj1_=O9tHMVRvphvy3m6KbNig@mail.gmail.com>
 <CAMRc=McPSFQFPP1nSTXj3snKWqQyzNgz0j_J5ooyUrhRFRMqJQ@mail.gmail.com> <a0ce4372-df94-a19c-063d-274e65da7c38@leemhuis.info>
In-Reply-To: <a0ce4372-df94-a19c-063d-274e65da7c38@leemhuis.info>
From:   Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Date:   Fri, 20 May 2022 14:28:19 -0300
Message-ID: <CACjc_5oRRHdCjbSEeMMY2DeJRyFDcbQ2Vk7vaFC9h+kas8zC9g@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thorsten,

On Fri, May 20, 2022 at 6:12 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> On 16.02.22 15:40, Bartosz Golaszewski wrote:
> > On Tue, Feb 15, 2022 at 10:56 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> >>
> >> On Mon, Feb 14, 2022 at 12:24 AM Marcelo Roberto Jimenez
> >> <marcelo.jimenez@gmail.com> wrote:
> >>> On Sat, Feb 12, 2022 at 1:55 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> >>
> >>>> I am curious about the usecases and how deeply you have built
> >>>> yourselves into this.
> >>>
> >>> I don't know if I understand what you mean, sorry.
> >>
> >> Why does the user need the sysfs ABI? What is it used for?
> >>
> >> I.e what is the actual use case?
> >>
> >>>>> In any case, the upstream file should be enough to test the issue reported here.
> >>>>
> >>>> The thing is that upstream isn't super happy that you have been
> >>>> making yourselves dependent on features that we are actively
> >>>> discouraging and then demanding that we support these features.
> >>>
> >>> Hum, demanding seems to be a strong word for what I am doing here.
> >>>
> >>> Deprecated should not mean broken. My point is: the API seems to be
> >>> currently broken. User space apps got broken, that's a fact. I even
> >>> took the time to bisect the kernel and show you which commit broke it.
> >>> So, no, I am not demanding. More like reporting and providing a
> >>> temporary solution to those with a similar problem.
> >>>
> >>> Maybe it is time to remove the API, but this is up to "upstream".
> >>> Leaving the API broken seems pointless and unproductive.
> >>>
> >>> Sorry for the "not super happiness of upstream", but maybe upstream
> >>> got me wrong.
> >>>
> >>> We are not "making ourselves dependent on features ...". The API was
> >>> there. We used it. Now it is deprecated, ok, we should move on. I got
> >>> the message.
> >>
> >> Ouch I deserved some slamming for this.
> >>
> >> I'm sorry if I came across as harsh :(
> >>
> >> I just don't know how to properly push for this.
> >>
> >> I have even pushed the option of the deprecated sysfs ABI
> >> behind the CONFIG_EXPERT option, which should mean that
> >> the kernel config has been made by someone who has checked
> >> the option "yes I am an expert I know what I am doing"
> >> yet failed to observe that this ABI is obsoleted since 5 years
> >> and hence failed to be an expert.
> >>
> >> Of course the ABI (not API really) needs to be fixed if we can find the
> >> problem. It's frustrating that fixing it seems to fix broken other
> >> features which are not deprecated, hence the annoyance on my
> >> part.
> >>
> >
> > I'm afraid we'll earn ourselves a good old LinusRant if we keep
> > pushing the character device as a solution to the problem here.
> > Marcelo is right after all: he used an existing user interface, the
> > interface broke, it must be fixed.
> >
> > I would prefer to find a solution that fixes Marcelo's issue while
> > keeping the offending patches in tree but it seems like the issue is
> > more complicated and will require some rework of the sysfs interface.
> >
> > In which case unless there are objections I lean towards reverting the
> > relevant commits.
>
> Reviving and old thread, hence a quick reminder: The patch at the start
> of this thread was applied and then reverted in 56e337f2cf13 with this text:
>
> ```
> This commit - while attempting to fix a regression - has caused a number
> of other problems. As the fallout from it is more significant than the
> initial problem itself, revert it for now before we find a correct
> solution.
> ```
>
> I still have this on my list of open regressions and that made me
> wonder: is anyone working on a "correct solution" (or was one even
> applied and I missed it)? Or is the situation so tricky that we better
> leave everything as it is? Marcelo, do you still care?

The purpose of my patch was to revert the patch that was causing the
hardware I work with to fail. But reverting that patch had bad
consequences in other hardware, so I really do not think that my patch
should go in.

Following Linus Walleij's advice, we are stopping using sysfs for
gpio, so in the near future that patch will be irrelevant for me. On
the other hand, a few people using recent kernels have tried my patch
successfully, so it can be used as a temporary transition hack.

Also, the patch exposes a serious problem with the sysfs gpio, which
is currently broken. Maybe we should consider removing the interface
in a near future release, as it has been advocated several times
before, since it has long been deprecated, has a much better
substitute API and, the worse part, it is broken and no one seems to
have a high priority in fixing it.

IIRC, the last time I read, the kernel documentation said that the API
would be removed in 2020, so we are a bit late :). I know that
removing an API has lots of implications, so the consequences must be
carefully balanced.

> Ciao, Thorsten

Best regards,
Marcelo.
