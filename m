Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399A74DB1CF
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 14:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346137AbiCPNrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356196AbiCPNrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:47:42 -0400
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A6D65426;
        Wed, 16 Mar 2022 06:46:27 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id y142so4453049ybe.11;
        Wed, 16 Mar 2022 06:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dK9PN09V9Q742d70+hhD+yY1CTbOnBjfr2AdE+7VVYQ=;
        b=AEtwcSD59vYPsHcDK2TX8/hizhJZ127seETMRULWOHFYFocoWivA2hnSNuXiJa8S1G
         yDfpS8U3Q9xAgLklj45JVwCkwlV/XqE47ZJH5HYjCo7z13Y5qZco3iTdaS2zcO/e/dfH
         2M1nHcu3nUsMNE3LodZH80R1OY0MjeoddatOdIHKV78GAjUY18qs6odalIYUEjbciQ/F
         LJas8HWWDX7IN8IZccYzgdTJfQO9iW5B6k4UYs+73veyT9etTSNms2JETivF/U1rluQu
         iOnmuppD1b583kjIDP8pHP9sjT3Ymnc3itHx1HscvNsXjVhJySXYGVG+fSLnxnG148yT
         9y6g==
X-Gm-Message-State: AOAM53278vgnpmznivzLH0nAaiL31UJXVpAoDT9EZFgw2OeBLaOiryxB
        wZZVH1q3OLuGktc/km5VBWaBt+A8TzpUYf3I/7U=
X-Google-Smtp-Source: ABdhPJxqHyZvQmwL5k8nkAoQ2zCg2jp7koJqTJOJ8YCdQYnsIXe+Gm4BSctmjZKLBE5r+ABtXuQVhdIPNN2MtkUWThY=
X-Received: by 2002:a25:9d8a:0:b0:633:9668:c48a with SMTP id
 v10-20020a259d8a000000b006339668c48amr1420684ybp.153.1647438386450; Wed, 16
 Mar 2022 06:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
 <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com> <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
 <CAJZ5v0imJfOp-Uw=tH2dimSQzb-EgHu_yEU_0LScmrQ43t3pbw@mail.gmail.com>
 <c9a1adb5-17b7-c7ed-d23f-6b6523a4771a@redhat.com> <CAJZ5v0gB2ZCWe3MeGnw6_CNu_Ds0QEPZ6X6jnA7dQbZe6gKZ8w@mail.gmail.com>
 <5fb0cbe8-5f9d-1c75-ae0a-5909624189d3@redhat.com> <ce781d92-f269-aaf5-1733-25de85f05b7b@amd.com>
 <CAJZ5v0irKgmSQ7YegP=US1ACUfqVMCNitu2azMbMAqm2f+cXTg@mail.gmail.com> <BL1PR12MB51572AA41E116C59FE0D5698E2119@BL1PR12MB5157.namprd12.prod.outlook.com>
In-Reply-To: <BL1PR12MB51572AA41E116C59FE0D5698E2119@BL1PR12MB5157.namprd12.prod.outlook.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 16 Mar 2022 14:46:15 +0100
Message-ID: <CAJZ5v0g5YcieFtPxPYgdPzEPKQU_V9g_e7qMYGsrLORE5qevqQ@mail.gmail.com>
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
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

On Wed, Mar 16, 2022 at 2:38 PM Limonciello, Mario
<Mario.Limonciello@amd.com> wrote:
>
> [Public]
>
> > > Just FWIW this fix that was backported to stable also fixed keyboard
> > > wakeup from s2idle on a number of HP laptops too.  I know for sure that
> > > it fixed it on the AMD versions of them, and Kai Heng Feng suspected it
> > > will also fix it for the Intel versions.  So if there is another commit
> > > that can be backported from 5.17 to make it safer for the other systems,
> > > I think we should consider doing that to solve it too.
> >
> > There is a series of ACPI EC driver commits that are present in
> > 5.17-rc, but have not been included in any "stable" series:
> >
> > befd9b5b0c62 ACPI: EC: Relocate acpi_ec_create_query() and drop
> > acpi_ec_delete_query()
> > c33676aa4824 ACPI: EC: Make the event work state machine visible
> > c793570d8725 ACPI: EC: Avoid queuing unnecessary work in
> > acpi_ec_submit_event()
> > eafe7509ab8c ACPI: EC: Rename three functions
> > a105acd7e384 ACPI: EC: Simplify locking in acpi_ec_event_handler()
> > 388fb77dcf97 ACPI: EC: Rearrange the loop in acpi_ec_event_handler()
> > 98d364509d77 ACPI: EC: Fold acpi_ec_check_event() into
> > acpi_ec_event_handler()
> > 1f2350443dd2 ACPI: EC: Pass one argument to acpi_ec_query()
> > ca8283dcd933 ACPI: EC: Call advance_transaction() from
> > acpi_ec_dispatch_gpe()
> >
> > It is likely that they prevent the problem exposed by the problematic
> > commit from occurring, but I'm not sure which ones do that.  Some of
> > them are clearly cosmetic, but the ordering matters.
>
> Hans,
>
> Do you think you could get one of the folks who reported this regression to do
> a bisect to see which one "fixed" it?  If we get lucky we can come down to
> some smaller hunks of code that can come back to stable instead of reverting.

It's been reverted already.

What we can do is to request adding it back along with other commits
needed for it to work as expected.

Also, I think we'll need all of the commits listed up to and including
c793570d8725 ("ACPI: EC: Avoid queuing unnecessary work in
acpi_ec_submit_event()") at least, but that's just a guess.
