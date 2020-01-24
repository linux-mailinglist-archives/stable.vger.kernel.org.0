Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BE3147975
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 09:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgAXIfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 03:35:33 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41770 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAXIfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 03:35:33 -0500
Received: from [5.158.153.53] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iuuQq-0006yO-Sc; Fri, 24 Jan 2020 09:35:13 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 680F0103089; Fri, 24 Jan 2020 09:35:12 +0100 (CET)
To:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vipul kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
In-Reply-To: <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com> <87eevs7lfd.fsf@nanos.tec.linutronix.de> <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com> <878slzeeim.fsf@nanos.tec.linutronix.de> <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com> <20200123144108.GU32742@smile.fi.intel.com> <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
From:   Thomas Gleixner <tglx@linutronix.de>
Date:   Fri, 24 Jan 2020 09:35:12 +0100
Message-ID: <87iml11ccf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hans,

Hans de Goede <hdegoede@redhat.com> writes:

> Hi,
>
> Sorry for top posting, but this is a long and almost unreadable thread ...
>
> So it seems to me that a better fix would be to change the freq_desc_byt struct from:
>
> static const struct freq_desc freq_desc_byt = {
>          1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
> };
>
> to:
>
> static const struct freq_desc freq_desc_byt = {
>          1, { 83333, 100000, 133300, 116700, 80000, 0, 0, 0 }
> };
>
> That should give us the right TSC frequency without needing to mess with
> the TSC_KNOWN_FREQ and TSC_RELIABLE flags.

Where does that number come from? Just math?

Thanks,

        tglx


