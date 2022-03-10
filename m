Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD23C4D452A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 11:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiCJK50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 05:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiCJK5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 05:57:25 -0500
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CE01405FC;
        Thu, 10 Mar 2022 02:56:24 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id h126so10117597ybc.1;
        Thu, 10 Mar 2022 02:56:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9hRn5CDDGpweS0MoucbZPEewL2lB60a7c1YjeToAIiU=;
        b=lmfnJAidXYK+57ZHS0FsZLw3NK4Bcp4eME3pfKqAG7S88QpSH7LuNwimU0o3mdphoW
         BRxzV/PPzQUn4K2Q4HqlNxix1unWFgXE+QcejiFILJcnJrLizf5o4rGf0sfOk+h2y1s0
         wh0kR5klOf/AHBnn7I+poMJwocdewk4jZIgi6JVt0ZmitXGV1MclJilAf7j+mfz0lWX8
         nS/e99KYPE2Mxof7QKykUCE1CsYPLbNI5gjjEML9A+Cspb7k3J/krHoBOpWHJW5cUwlg
         4AwmnJGC3MngweXkfvgYwdrIojQD2SWLlcKAcsoGli2IWqqiqP9FqPSZcYQp9fuUkolO
         3TVg==
X-Gm-Message-State: AOAM531TyWcMy+OmcREd1wrAM6Mvskaa3Cjh/YGdnzPw2gKun7at6/9D
        jU0qxkirXQtZJgV2MMsc9C+Qk9DW+NBF3Ifj0ThedVipHyI=
X-Google-Smtp-Source: ABdhPJzrjwMkuTgFrhXZ4FlRjYyii5y/8U7PsKTCoY+ANf4ktCG8Bmy2ZQ1S3x0T426GRjIn+qz9Rk8XsPakralAz24=
X-Received: by 2002:a25:24d7:0:b0:628:79dc:1250 with SMTP id
 k206-20020a2524d7000000b0062879dc1250mr3301712ybk.153.1646909783576; Thu, 10
 Mar 2022 02:56:23 -0800 (PST)
MIME-Version: 1.0
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
 <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com> <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
 <CAJZ5v0imJfOp-Uw=tH2dimSQzb-EgHu_yEU_0LScmrQ43t3pbw@mail.gmail.com> <c9a1adb5-17b7-c7ed-d23f-6b6523a4771a@redhat.com>
In-Reply-To: <c9a1adb5-17b7-c7ed-d23f-6b6523a4771a@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Mar 2022 11:56:11 +0100
Message-ID: <CAJZ5v0gB2ZCWe3MeGnw6_CNu_Ds0QEPZ6X6jnA7dQbZe6gKZ8w@mail.gmail.com>
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 10:07 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 3/9/22 19:27, Rafael J. Wysocki wrote:
> > On Wed, Mar 9, 2022 at 5:34 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >>
> >> On Wed, Mar 9, 2022 at 5:33 PM Hans de Goede <hdegoede@redhat.com> wrote:
> >>>
> >>> Hi,
> >>>
> >>> On 3/9/22 14:57, Rafael J. Wysocki wrote:
> >>>> On Wed, Mar 9, 2022 at 2:44 PM Hans de Goede <hdegoede@redhat.com> wrote:
> >>>>>
> >>>>> Hi Rafael,
> >>>>>
> >>>>> We (Fedora) have been receiving a whole bunch of bug reports about
> >>>>> laptops getting hot/toasty while suspended with kernels >= 5.16.10
> >>>>> and this seems to still happen with 5.17-rc7 too.
> >>>>>
> >>>>> The following are all bugzilla.redhat.com bug numbers:
> >>>>>
> >>>>>    1750910 - Laptop failed to suspend and completely drained the battery
> >>>>>    2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
> >>>>>    2053957 - Package c-states never go below C2
> >>>>>    2056729 - No lid events when closing lid / laptop does not suspend
> >>>>>    2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
> >>>>>    2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
> >>>>>    2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> >>>>>
> >>>>> And one of the bugs has also been mirrored at bugzilla.kernel.org by
> >>>>> the reporter:
> >>>>>
> >>>>>  bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> >>>>>
> >>>>> The common denominator here (besides the kernel version) seems to
> >>>>> be that these are all Ice or Tiger Lake systems (I did not do
> >>>>> check this applies 100% to all bugs, but it does see, to be a pattern).
> >>>>>
> >>>>> A similar arch-linux report:
> >>>>>
> >>>>> https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
> >>>>>
> >>>>> Suggest that reverting
> >>>>> "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
> >>>>>
> >>>>> which was cherry-picked into 5.16.10 fixes things.
> >>>>
> >>>> Thanks for letting me know!
> >>>>
> >>>>> If you want I can create Fedora kernel test-rpms of a recent
> >>>>> 5.16.y with just that one commit reverted and ask users to
> >>>>> confirm if that helps. Please let me know if doing that woulkd
> >>>>> be useful ?
> >>>>
> >>>> Yes, it would.
> >>>>
> >>>> However, it follows from the arch-linux report linked above that
> >>>> 5.17-rc is fine, so it would be good to also check if reverting that
> >>>> commit from 5.17-rc helps.
> >>>
> >>> Ok, I've done Fedora kernel builds of both 5.16.13 and 5.17-rc7 with
> >>> the patch reverted and asked the bug-reporters to test both.
> >>
> >> Thanks!
> >
> > Also, in the cases where people have not tested 5.17-rc7 without any
> > reverts, it would be good to ask them to do so.
>
> Ok, done.
>
> > I have received another report related to this issue where the problem
> > is not present in 5.17-rc7 (see
> > https://lore.kernel.org/linux-pm/CAJZ5v0hKXyTtb1Jk=wqNV9_mZKdf3mmwF4bPOcmADyNnTkpMbQ@mail.gmail.com/).
>
> The first results from the Fedora test kernel builds are in:
>
> "HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case gets very hot and requires a power button hold to restart"
> https://bugzilla.redhat.com/show_bug.cgi?id=2059668
>
> 5.16.9: good
> 5.16.10+: bad
> 5.16.13 with "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE" reverted: good
> 5.17-rc7 with "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE" reverted: good
> 5.17-rc7 (plain): good
>
> So this seems to match the arch-linux report and the email report
> you linked. There is a problem with the backport in 5.16.10+,
> while 5.17-rc7 is fine.
>
> > It is likely that the commit in question actually depends on some
> > other commits that were not backported into 5.16.y.
> I was thinking the same thing, but I've no idea which commits
> that would be.

I do have an idea, but regardless of this, IMO the least risky way
forward would be to request "stable" to drop "ACPI: PM: s2idle: Cancel
wakeup before dispatching EC GPE" which has been backported, because
it carried a Fixes tag and not because it was marked for "stable".

Let me do that.
