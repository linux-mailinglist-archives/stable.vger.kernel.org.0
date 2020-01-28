Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0FE14BA8C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgA1Ojp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:39:45 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46482 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgA1Ojo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 09:39:44 -0500
Received: by mail-pf1-f194.google.com with SMTP id k29so4208854pfp.13;
        Tue, 28 Jan 2020 06:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hEHN7LL9gmE7iQ0kTtqji+SU0gUig3r57BK5f0v4VrU=;
        b=GFJqYFw8bYMuCso8Uxc1c3MY2xZ5tPGIfN0z1daTxkvJ3lQLQCwmzsQQOcCICdwOpc
         dYKDQSeu6+UxwLmXX9GJScMV8RCT+R/PjJlFNXZKnoySCOlYTOqEcOvYYmMCG7haA9v8
         dONid4TVrQ7izHI3Xs3pVgGUh3tjx9uxC9i6/7KeQ0kukoTfQ/1LhSUVSisX8utxMzVQ
         jkUxKHeJ1Q47j7j57kkVpE88SGGewbWXb5kbx7P4DXzee0UN+MGsinwqyUrF7pEVNN0O
         t23xgMNQC1Ixr2/wFxwJ18W83shsKDqv+qpgbUHZiRU2xMhUCtoZWiiKv5wJ85GbA5lR
         hd4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hEHN7LL9gmE7iQ0kTtqji+SU0gUig3r57BK5f0v4VrU=;
        b=OxGQd4DsuHIPaOKyJfBnZXHTSFcwo2HCyVE4eXSCiMZfNh1tQugRilJsBrs3V6cj2q
         pTXXxYxuspPr8Rga/lbQK0j5pX/+6fKktvsumtsj8iKu9sOQvCtNE9jokvcEZRYf4JZF
         PcVBPoaZPGoLf0ctS9XnwJz4xBVpVwN4GkgR106ZEwVoJbYbtYgKfW5nh4QKUxdlFYo9
         CMKIZL/2oM3ijQfJzGRtkPWXgSWdWjsCva1eTf/Z9ORhc1YrluyJGs3REbYWC0/m+K2h
         +BSlgE3lqBet8EfjptdPzOwLzrwMhv3qUTAAjlhi0jxvxo0Th4M94h9GFbYZWzdmTcCs
         wMbQ==
X-Gm-Message-State: APjAAAX3BdEJoBdzypye2zsBbRM/NAVr4lZsIjxvXyKQBPar+YQ4Bm63
        4HKZi4aXo6BM7F6wXM2g3L/s8vn8BXDtSVA5iEo=
X-Google-Smtp-Source: APXvYqxW62S7Nm01nRZiBX0ysbOPqi08Kj32pIfKmsOjyIcltbZF3ntZS6AntkW1K2aXWsAw8QnLD0XuCqgnMshhuIM=
X-Received: by 2002:a62:17c1:: with SMTP id 184mr4354188pfx.207.1580222383991;
 Tue, 28 Jan 2020 06:39:43 -0800 (PST)
MIME-Version: 1.0
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
 <87eevs7lfd.fsf@nanos.tec.linutronix.de> <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
 <878slzeeim.fsf@nanos.tec.linutronix.de> <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com> <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de> <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de> <37321319-e110-81f5-2488-cedf000da04d@redhat.com>
 <CADdC98To8VKOUWnR+8zAJ04vgdc4vJoh2h96588+5XFer9YTJw@mail.gmail.com> <329a2f7d-c5ed-6376-ec78-f00fa1ba41cd@redhat.com>
In-Reply-To: <329a2f7d-c5ed-6376-ec78-f00fa1ba41cd@redhat.com>
From:   vipul kumar <vipulk0511@gmail.com>
Date:   Tue, 28 Jan 2020 20:09:32 +0530
Message-ID: <CADdC98S6cgYbvs-qt1YSJcicOq-z-sbpK-zejyBJ=kWxkUrxaA@mail.gmail.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,


On Tue, Jan 28, 2020 at 7:53 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 28-01-2020 12:47, vipul kumar wrote:
> > Hi Thomas,
> >
> > Please find attached logs with mainline kernel version 5.4.15 with patch.
>
> So the suggested change seems to not work, that is strange.

   Attached logs was with the patch that I had submitted as V3.

   I made changes in kernel as per your suggestion. Board is running
with your suggested changes. Will update you with the result.

  Regards,
  Vipul
>
> Can you double check you are running the correct kernel and
> add the following change and gather debug output ? :
>
> --- a/arch/x86/kernel/tsc_msr.c
> +++ b/arch/x86/kernel/tsc_msr.c
> @@ -102,6 +103,8 @@ unsigned long cpu_khz_from_msr(void)
>          /* Get FSB FREQ ID */
>
> + pr_err("tsc msr id match %ld lo 0x%02x\n", id - tsc_msr_cpu_ids, lo);
> +
>          /* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
>          freq = freq_desc->freqs[lo & 0x7];
>
> Regards,
>
> Hans
>
>
>
> > On Fri, Jan 24, 2020 at 9:24 PM Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>> wrote:
> >
> >     Hi,
> >
> >     On 1/24/20 12:55 PM, Thomas Gleixner wrote:
> >      > Hans,
> >      >
> >      > Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>> writes:
> >      >> On 1/24/20 9:35 AM, Thomas Gleixner wrote:
> >      >>> Where does that number come from? Just math?
> >      >>
> >      >> Yes just math, but perhaps the Intel folks can see if they can find some
> >      >> datasheet to back this up ?
> >      >
> >      > Can you observe the issue on one of the machines in your zoo as well?
> >
> >     I haven't tried yet. Looking at the thread sofar the problem was noticed on
> >     a system with a Celeron N2930, I don't have access to one of those, I
> >     do have access to a system with a closely related N2840 I will give that
> >     a try as well as see if I can reproduce this on one of the tablet
> >     oriented Z3735x SoCs.
> >
> >     I'll report back when I have had a chance to test this.
> >
> >     Regards,
> >
> >     Hans
> >
>
