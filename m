Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DD74DB045
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 14:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352150AbiCPNEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiCPND7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:03:59 -0400
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B698B6662E;
        Wed, 16 Mar 2022 06:02:42 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2e5ad7166f1so9611047b3.12;
        Wed, 16 Mar 2022 06:02:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2kXsqPiYOqsHAhBrFjuq2lGWRyJ/hN9PzrRuRIITwfo=;
        b=S6IBYbt42fPeeftUhK1dJrU4YS2T5k8r9ZNjEQXwr34ctZpxbYICUbpmhgNIjOEma3
         EolQAqlMTvHfU2H6Ad/5cSqA7csuNyNeS/CbbwZJZ1ejt9/3kOSvOR3EJnbDSQdELy6b
         sHrUD6ftaP3Ewk1knGoxeyria+fTpJvAa4rnpU/o6HmFO+3bXBXdo35XscpDbxbIAyFA
         2dDaIvmVCfhNEvfvkR9wU+iYLBsBrGFXeSgJ8NhkLEYjaIV4M28AeiHGdVqlBouVfVWw
         7tvhjr10yCAWnSF6XXFoMiKvDehq4aNSuN2R0xOziGKOAfAkz17/e8ZG1zWc9hzi0igv
         vkaA==
X-Gm-Message-State: AOAM530bsqDBjE3+caWmGiO8lqprBF6sNk5hzMFTqjxo19pHngSr7hyV
        OZ4uU4QKOmmSbemR7GneDvWHxSO4tvC2OUFEERE=
X-Google-Smtp-Source: ABdhPJwcIUZ8ZwyAWC6O7Ni3CtnZ75zb54xMJej9WfYL/MKnZXUU6l2cA0i5SBQWNwwSrcKG9YnVbz/WPPTlUpan/90=
X-Received: by 2002:a81:508b:0:b0:2e5:9904:8655 with SMTP id
 e133-20020a81508b000000b002e599048655mr6655175ywb.196.1647435761506; Wed, 16
 Mar 2022 06:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
 <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com> <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
 <CAJZ5v0imJfOp-Uw=tH2dimSQzb-EgHu_yEU_0LScmrQ43t3pbw@mail.gmail.com>
 <c9a1adb5-17b7-c7ed-d23f-6b6523a4771a@redhat.com> <CAJZ5v0gB2ZCWe3MeGnw6_CNu_Ds0QEPZ6X6jnA7dQbZe6gKZ8w@mail.gmail.com>
 <5fb0cbe8-5f9d-1c75-ae0a-5909624189d3@redhat.com> <ce781d92-f269-aaf5-1733-25de85f05b7b@amd.com>
In-Reply-To: <ce781d92-f269-aaf5-1733-25de85f05b7b@amd.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 16 Mar 2022 14:02:30 +0100
Message-ID: <CAJZ5v0irKgmSQ7YegP=US1ACUfqVMCNitu2azMbMAqm2f+cXTg@mail.gmail.com>
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 3:37 PM Limonciello, Mario
<mario.limonciello@amd.com> wrote:
>
> + KH
>
> On 3/10/2022 06:22, Hans de Goede wrote:
> > Hi,
> >
> > On 3/10/22 11:56, Rafael J. Wysocki wrote:
> >> On Thu, Mar 10, 2022 at 10:07 AM Hans de Goede <hdegoede@redhat.com> wrote:
> >>>
> >>> Hi,
> >>>
> >>> On 3/9/22 19:27, Rafael J. Wysocki wrote:
> >>>> On Wed, Mar 9, 2022 at 5:34 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >>>>>
> >>>>> On Wed, Mar 9, 2022 at 5:33 PM Hans de Goede <hdegoede@redhat.com> wrote:
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>> On 3/9/22 14:57, Rafael J. Wysocki wrote:
> >>>>>>> On Wed, Mar 9, 2022 at 2:44 PM Hans de Goede <hdegoede@redhat.com> wrote:
> >>>>>>>>
> >>>>>>>> Hi Rafael,
> >>>>>>>>
> >>>>>>>> We (Fedora) have been receiving a whole bunch of bug reports about
> >>>>>>>> laptops getting hot/toasty while suspended with kernels >= 5.16.10
> >>>>>>>> and this seems to still happen with 5.17-rc7 too.
> >>>>>>>>
> >>>>>>>> The following are all bugzilla.redhat.com bug numbers:
> >>>>>>>>
> >>>>>>>>     1750910 - Laptop failed to suspend and completely drained the battery
> >>>>>>>>     2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
> >>>>>>>>     2053957 - Package c-states never go below C2
> >>>>>>>>     2056729 - No lid events when closing lid / laptop does not suspend
> >>>>>>>>     2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
> >>>>>>>>     2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
> >>>>>>>>     2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> >>>>>>>>
> >>>>>>>> And one of the bugs has also been mirrored at bugzilla.kernel.org by
> >>>>>>>> the reporter:
> >>>>>>>>
> >>>>>>>>   bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> >>>>>>>>
> >>>>>>>> The common denominator here (besides the kernel version) seems to
> >>>>>>>> be that these are all Ice or Tiger Lake systems (I did not do
> >>>>>>>> check this applies 100% to all bugs, but it does see, to be a pattern).
> >>>>>>>>
> >>>>>>>> A similar arch-linux report:
> >>>>>>>>
> >>>>>>>> https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
> >>>>>>>>
> >>>>>>>> Suggest that reverting
> >>>>>>>> "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
> >>>>>>>>
> >>>>>>>> which was cherry-picked into 5.16.10 fixes things.
> >>>>>>>
> >>>>>>> Thanks for letting me know!
> >>>>>>>
> >>>>>>>> If you want I can create Fedora kernel test-rpms of a recent
> >>>>>>>> 5.16.y with just that one commit reverted and ask users to
> >>>>>>>> confirm if that helps. Please let me know if doing that woulkd
> >>>>>>>> be useful ?
> >>>>>>>
> >>>>>>> Yes, it would.
> >>>>>>>
> >>>>>>> However, it follows from the arch-linux report linked above that
> >>>>>>> 5.17-rc is fine, so it would be good to also check if reverting that
> >>>>>>> commit from 5.17-rc helps.
> >>>>>>
> >>>>>> Ok, I've done Fedora kernel builds of both 5.16.13 and 5.17-rc7 with
> >>>>>> the patch reverted and asked the bug-reporters to test both.
> >>>>>
> >>>>> Thanks!
> >>>>
> >>>> Also, in the cases where people have not tested 5.17-rc7 without any
> >>>> reverts, it would be good to ask them to do so.
> >>>
> >>> Ok, done.
> >>>
> >>>> I have received another report related to this issue where the problem
> >>>> is not present in 5.17-rc7 (see
> >>>> https://lore.kernel.org/linux-pm/CAJZ5v0hKXyTtb1Jk=wqNV9_mZKdf3mmwF4bPOcmADyNnTkpMbQ@mail.gmail.com/).
> >>>
> >>> The first results from the Fedora test kernel builds are in:
> >>>
> >>> "HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case gets very hot and requires a power button hold to restart"
> >>> https://bugzilla.redhat.com/show_bug.cgi?id=2059668
> >>>
> >>> 5.16.9: good
> >>> 5.16.10+: bad
> >>> 5.16.13 with "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE" reverted: good
> >>> 5.17-rc7 with "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE" reverted: good
> >>> 5.17-rc7 (plain): good
> >>>
> >>> So this seems to match the arch-linux report and the email report
> >>> you linked. There is a problem with the backport in 5.16.10+,
> >>> while 5.17-rc7 is fine.
> >>>
> >>>> It is likely that the commit in question actually depends on some
> >>>> other commits that were not backported into 5.16.y.
> >>> I was thinking the same thing, but I've no idea which commits
> >>> that would be.
> >>
> >> I do have an idea, but regardless of this, IMO the least risky way
> >> forward would be to request "stable" to drop "ACPI: PM: s2idle: Cancel
> >> wakeup before dispatching EC GPE" which has been backported, because
> >> it carried a Fixes tag and not because it was marked for "stable".
> >>
> >> Let me do that.
> >
> > Ok, that sounds good, thank you.
> >
>
> Just FWIW this fix that was backported to stable also fixed keyboard
> wakeup from s2idle on a number of HP laptops too.  I know for sure that
> it fixed it on the AMD versions of them, and Kai Heng Feng suspected it
> will also fix it for the Intel versions.  So if there is another commit
> that can be backported from 5.17 to make it safer for the other systems,
> I think we should consider doing that to solve it too.

There is a series of ACPI EC driver commits that are present in
5.17-rc, but have not been included in any "stable" series:

befd9b5b0c62 ACPI: EC: Relocate acpi_ec_create_query() and drop
acpi_ec_delete_query()
c33676aa4824 ACPI: EC: Make the event work state machine visible
c793570d8725 ACPI: EC: Avoid queuing unnecessary work in acpi_ec_submit_event()
eafe7509ab8c ACPI: EC: Rename three functions
a105acd7e384 ACPI: EC: Simplify locking in acpi_ec_event_handler()
388fb77dcf97 ACPI: EC: Rearrange the loop in acpi_ec_event_handler()
98d364509d77 ACPI: EC: Fold acpi_ec_check_event() into acpi_ec_event_handler()
1f2350443dd2 ACPI: EC: Pass one argument to acpi_ec_query()
ca8283dcd933 ACPI: EC: Call advance_transaction() from acpi_ec_dispatch_gpe()

It is likely that they prevent the problem exposed by the problematic
commit from occurring, but I'm not sure which ones do that.  Some of
them are clearly cosmetic, but the ordering matters.
