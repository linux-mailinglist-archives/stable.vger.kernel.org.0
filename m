Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FFF146AEB
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 15:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAWOM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 09:12:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:40191 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgAWOM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 09:12:57 -0500
Received: from [5.158.153.53] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iudE0-0001Ni-7q; Thu, 23 Jan 2020 15:12:48 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 897AF1017FA; Thu, 23 Jan 2020 15:12:47 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     vipul kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Bin Gao <bin.gao@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
In-Reply-To: <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com> <87eevs7lfd.fsf@nanos.tec.linutronix.de> <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com> <878slzeeim.fsf@nanos.tec.linutronix.de> <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
Date:   Thu, 23 Jan 2020 15:12:47 +0100
Message-ID: <87muaep8gw.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vipul,

please disable HTML mixed mode completely in your mail client when
posting on LKML. Such mails are silently dropped on the list server and
never reach the public archives.

vipul kumar <vipulk0511@gmail.com> writes:
>> > On Tue, Jan 21, 2020 at 11:15 PM Thomas Gleixner <tglx@linutronix.de>
>> wrote:
>> What's the frequency which is determined from the MSR? Something like
>> ...
>
> tsc: Detected 1832.600 MHz processor

vs.

> tsc: Refined TSC clocksource calibration: 1833.333 MHz

So the MSR readout is off by 0.4%

>    Attached full logs with patch and without patch.

I can't find the debug output in them. Also:

> [    0.000000] Linux version 4.14.139-rt66 ....

Can you please run that patch on top of current mainline please? I
really want to see the debug output.

Thanks,

        tglx
