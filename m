Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA60C1484C5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731972AbgAXL4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:56:09 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:42134 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgAXL4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 06:56:09 -0500
Received: from [5.158.153.53] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iuxZ5-0007IW-50; Fri, 24 Jan 2020 12:55:55 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id C06C3103089; Fri, 24 Jan 2020 12:55:54 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
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
In-Reply-To: <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com> <87eevs7lfd.fsf@nanos.tec.linutronix.de> <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com> <878slzeeim.fsf@nanos.tec.linutronix.de> <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com> <20200123144108.GU32742@smile.fi.intel.com> <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com> <87iml11ccf.fsf@nanos.tec.linutronix.de> <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
Date:   Fri, 24 Jan 2020 12:55:54 +0100
Message-ID: <87ftg5131x.fsf@nanos.tec.linutronix.de>
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
> On 1/24/20 9:35 AM, Thomas Gleixner wrote:
>> Where does that number come from? Just math?
>
> Yes just math, but perhaps the Intel folks can see if they can find some
> datasheet to back this up ?

Can you observe the issue on one of the machines in your zoo as well?

Thanks,

        tglx
