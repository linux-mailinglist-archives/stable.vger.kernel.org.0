Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45041823EE
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 22:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgCKVew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 17:34:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40750 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgCKVew (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 17:34:52 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jC8zt-0000Wz-04; Wed, 11 Mar 2020 22:34:37 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 14D41100F5A; Wed, 11 Mar 2020 22:34:36 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Cc:     Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 1/3] x86/tsc_msr: Use named struct initializers
In-Reply-To: <9705677f-f52e-938f-a84a-8db8afc9fc8f@redhat.com>
References: <20200223140610.59612-1-hdegoede@redhat.com> <9705677f-f52e-938f-a84a-8db8afc9fc8f@redhat.com>
Date:   Wed, 11 Mar 2020 22:34:36 +0100
Message-ID: <87d09ik237.fsf@nanos.tec.linutronix.de>
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
> On 2/23/20 3:06 PM, Hans de Goede wrote:
>> Use named struct initializers for the freq_desc struct-s initialization
>> and change the "u8 msr_plat" to a "bool use_msr_plat" to make its meaning
>> more clear instead of relying on a comment to explain it.
>> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>
> I believe that this series is ready for merging now? Can we
> please get this merged?

I was hoping that Intel would give use some official information, but
unless I missed something this did not happen.

Screw it. That's definitely way better than what we have now.

Thanks,

        tglx
