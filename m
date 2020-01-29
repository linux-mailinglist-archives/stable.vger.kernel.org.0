Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED2014CD05
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 16:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgA2POD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 10:14:03 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51538 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgA2POD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 10:14:03 -0500
Received: from 80-254-69-18.dynamic.monzoon.net ([80.254.69.18] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iwp2H-0002On-8y; Wed, 29 Jan 2020 16:13:45 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id DBEFC105CFD; Wed, 29 Jan 2020 16:13:39 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     vipul kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC
In-Reply-To: <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com>
References: <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com> <20200123144108.GU32742@smile.fi.intel.com> <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com> <87iml11ccf.fsf@nanos.tec.linutronix.de> <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com> <87ftg5131x.fsf@nanos.tec.linutronix.de> <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com> <87sgjz434v.fsf@nanos.tec.linutronix.de> <20200129130350.GD32742@smile.fi.intel.com> <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com> <20200129141444.GE32742@smile.fi.intel.com> <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com>
Date:   Wed, 29 Jan 2020 16:13:39 +0100
Message-ID: <87imku2t3w.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:
> On 29-01-2020 15:14, Andy Shevchenko wrote:
>>> The only one which is possibly suspicious here is this line:
>>>
>>>   * 0111:   25 * 32 /  9  =  88.8889 MHz
>>>
>>> The SDM says 88.9 MHz for this one.

I trust math more than the SDM :)

>> Anyway it seems need to be fixed as well.
>> 
>> Btw, why we are mentioning 20 / 6 and 28 / 6 when arithmetically
>> it's the same as 10 / 3 and 14 / 3?
>
> I copied the BYT values from Thomas' email and I guess he did not
> get around to simplifying them, I'll use the simplified versions
> for my patch.

Too tired, too lazy :)

Andy, can you please make sure that people inside Intel who can look
into the secrit documentation confirm what we are aiming for?

Ideally they should provide the X-tal frequency and the mult/div pair
themself :)

Thanks,

        tglx
