Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F684C9153
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbiCARTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiCARTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:19:08 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465792DA96
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 09:18:26 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id o6so22770257ljp.3
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 09:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=telus.net; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOGmojwA30pg/gshCHQVR3nc13CD5CENWNrHNgWB7LQ=;
        b=Y3HPP7zy6Wdu6joJdXVJnjRHMexOCUgomZx2WMTBB3MkV5OpVazBJmVD3lb8JSHfYW
         vggaKe/i8uWZjhGkJSU1cJy4UtQmNN4P0WUQVLN+TnVZBIPcbaNBc7KD/LhsberKXCoA
         eUe9CbdkjXUguz0HaxgOIqVM8QFOoBq2fY2xSYeHFQSH1sXCN6fIEq8jCwOnGCEB2xGV
         etADwH6L5Zxh8usb3Dl9pUHHwHaNb9e7FF30/jcMmlQ1filTZcKARX0eMYvXzekF6L82
         6Hw8IJig2WvPpghYhbaaH7uluQJ7xQL9UeYrvTlDH2qnOke1brcJJ4MgOh2Vw0iNhLOU
         IX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOGmojwA30pg/gshCHQVR3nc13CD5CENWNrHNgWB7LQ=;
        b=vE5jfcRnx06wm2kSqtMZLNP/FqBRpBPlX/CDTl2W9AvTFeT/1/LAd2nizTtomy29A4
         DbTalSwL9Wfv8lDlhE2zdgmA9aQnbc6e6FvXy7TI15ljAdHxW+xj5GCQ5AymBwEDtarl
         XZ0J3J6LQ0sHT/6lg7IfkPfF8GZrPP06oFuUG3fyXM1U5cYaK5hdOnuarNt8LzlGnxvW
         Zv1Mvw4sY30yXe9PPsCWMMEgQoXExOYWXZk+keGm+3lAmru+CjhGzVJMTPqIefdajCEP
         w4p8T+a4azorJZd1EEgdHxVv9G1JUZY2/Xa+6SbaBYrqBUFnQ9efcjpT4AVRf/+0I7KU
         LMOw==
X-Gm-Message-State: AOAM532rZi50PRv3qBlUCFUef3on+wwHkgNRLVciIY3KG+MZZZ1bCH+o
        Ck5XYWQbKx76Xm4iOAVUVbVB60+sXlAXltNj66zn0w==
X-Google-Smtp-Source: ABdhPJxVpgzlZUjaEeDxXtwpjgMRDodY1U9aAK87DPuyBXcvVZmF6hFZhl3lFXcRrD3JfP7/Cnj/vIJttwvo8WPTQTo=
X-Received: by 2002:a05:651c:1542:b0:233:8ff5:eb80 with SMTP id
 y2-20020a05651c154200b002338ff5eb80mr17596891ljp.352.1646155103364; Tue, 01
 Mar 2022 09:18:23 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com> <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com> <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
In-Reply-To: <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
From:   Doug Smythies <dsmythies@telus.net>
Date:   Tue, 1 Mar 2022 09:18:12 -0800
Message-ID: <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Feng Tang <feng.tang@intel.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        dsmythies <dsmythies@telus.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 1, 2022 at 3:58 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> On Tue, Mar 1, 2022 at 6:53 AM Feng Tang <feng.tang@intel.com> wrote:
> > On Mon, Feb 28, 2022 at 08:36:03PM +0100, Rafael J. Wysocki wrote:
...
> > >
> > > However, it was a bit racy, so maybe it's good that it was not complete.
> > >
> > > Below is a new version.
> >
> > Thanks for the new version. I just gave it a try,  and the occasional
> > long delay of cpufreq auto-adjusting I have seen can not be reproduced
> > after applying it.
>
> OK, thanks!
>
> I'll wait for feedback from Dough, though.

Hi Rafael,

Thank you for your version 2 patch.
I screwed up an overnight test and will have to re-do it.
However, I do have some results.

From reading the patch code, one worry was the
potential to drive down the desired/required CPU
frequency for the main periodic workflow, causing
overruns, or inability of the task to complete its
work before the next period. I have always had overrun
information, but it has never been relevant before.

The other worry was if the threshold of
turbo/not turbo frequency is enough.

I do not know how to test any final solution
thoroughly, as so far I have simply found a
good enough problematic example.
We have so many years of experience with
the convenient multi second NMI forcing
lingering high pstate clean up. I'd keep it
deciding within it if the TSC stuff needs to be
executed or not.

Anyway...

Base Kernel 5.17-rc3.
"stock" : unmodified.
"revert" : with commit b50db7095fe reverted
"rjw-2" : with this version2 patch added.

Test 1 (as before. There is no test 2, yet.):
347 Hertz work/sleep frequency on one CPU while others do
virtually no load but enough to increase the requested pstate,
but at around 0.02 hertz aggregate.

It is important to note the main load is approximately
38.6% @ 2.422 GHz, or 100% at 0.935 GHz.
and almost exclusively uses idle state 2 (of
4 total idle states)

/sys/devices/system/cpu/cpu7/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu7/cpuidle/state1/name:C1_ACPI
/sys/devices/system/cpu/cpu7/cpuidle/state2/name:C2_ACPI
/sys/devices/system/cpu/cpu7/cpuidle/state3/name:C3_ACPI

Turbostat was used. ~10 samples at 300 seconds per.
Processor package power (Watts):

Workflow was run for 1 hour each time or 1249201 loops.

revert:
ave: 3.00
min: 2.89
max: 3.08
ave freq: 2.422 GHz.
overruns: 1.
max overrun time: 113 uSec.

stock:
ave: 3.63 (+21%)
min: 3.28
max: 3.99
ave freq: 2.791 GHz.
overruns: 2.
max overrun time: 677 uSec.

rjw-2:
ave: 3.14 (+5%)
min: 2.97
max: 3.28
ave freq: 2.635 GHz
overruns: 1042.
max overrun time: 9,769 uSec.

... Doug
