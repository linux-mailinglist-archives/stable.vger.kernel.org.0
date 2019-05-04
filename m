Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5AA1370F
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 04:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfEDCo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 22:44:57 -0400
Received: from webmail.newmedia-net.de ([185.84.6.166]:44751 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfEDCo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 22:44:57 -0400
X-Greylist: delayed 981 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2019 22:44:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=+3UaCGaRK+G9Btvnlqp56gFrq5JPRwLY7YIZojvybzE=;
        b=bdChA48c3okKbHHJi6e0yiUut34HQ1F8R4xapalMIIomowOmleYgJHWCIOBxPVRYYz1yYnEde4nPxRT7dGXVyn6MDR8U/urmKvv8n7Ag2mOxVCTWbzLIuO6Cum0Edm7Bk+I5GoOnoSrWITxqA2wMWqpm4MbNEhCbnK0NY+yO+u0=;
Subject: Re: [PATCH] x86/fpu: Remove the _GPL from the kernel_fpu_begin/end()
 export
To:     Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jikos@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        stable@vger.kernel.org, Jiri Kosina <jikos@jikos.cz>
References: <761345df6285930339aced868ebf8ec459091383.1556807897.git.luto@kernel.org>
 <20190502154043.gfv4iplcvzjz3mc6@linutronix.de>
 <nycvar.YFH.7.76.1905032044250.10635@cbobk.fhfr.pm>
 <20190504004747.GA107909@gmail.com>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <2238f6ed-9338-903c-760c-6200e73b1599@newmedia-net.de>
Date:   Sat, 4 May 2019 04:28:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504004747.GA107909@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:c9:3f07:6200:2ce0:fea8:6812:6f6a]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1hMkPo-0003Iw-Df; Sat, 04 May 2019 04:28:40 +0200
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Am 04.05.2019 um 02:47 schrieb Ingo Molnar:
> * Jiri Kosina <jikos@kernel.org> wrote:
>
>> On Thu, 2 May 2019, Sebastian Andrzej Siewior wrote:
>>
>>> Please don't start this. We have everything _GPL that is used for FPU
>>> related code and only a few functions are exported because KVM needs it.
>> That's not completely true. There are a lot of static inlines out there,
>> which basically made it possible for external modules to use FPU (in some
>> way) when they had kernel_fpu_[begin|end]() available.
>>
>> I personally don't care about ZFS a tiny little bit; but in general, the
>> current situation with _GPL and non-_GPL exports is simply not nice. It's
>> not really about licensing (despite the name), it's about 'internal vs
>> external', which noone is probably able to define properly.
> But that's exactly what licensing *IS* about: the argument is that
> 'internal' interfaces are clear proof that the binary module is actually
> a derived work of the kernel.
Using fpu code in kernel space in a kernel module is a derived work of 
the kernel itself?
dont get me wrong, but this is absurd. i mean you limit the use of cpu 
instructions. the use
of cpu instructions should be free of any licensing issue. i would even 
argument you are violating
the license of the cpu ower given to the kernel by executing it, by 
restricting its use for no reason


Sebastian


