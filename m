Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDB6246E70
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389007AbgHQRa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:30:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37454 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388081AbgHQQ7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 12:59:09 -0400
Received: from mail-qt1-f197.google.com ([209.85.160.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <gpiccoli@canonical.com>)
        id 1k7iTS-00040T-Bh
        for stable@vger.kernel.org; Mon, 17 Aug 2020 16:59:06 +0000
Received: by mail-qt1-f197.google.com with SMTP id d2so12460616qtn.8
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 09:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=t1x9C5h8RE8Px4q89lymM+TedzlONkscXaarS6nSz68=;
        b=Vy3IK53Zr1J7YDJJljXtgqEdEEv5D0En7PYJm9v8q7MR0r/j9P4iOhika+RSEc4B/8
         kiloDQgg35wVyEUyVOBBoWM0Gcxf0RJkya1CYZ//hLKhSyegu6HKnnA/1uyUpWydF/eJ
         qqbmLzs9Uf6o1h2gna+zNCCxalC5eK/1MTISXdS+Madh06WCR4rQ/9mU+Ln4TpIZdaJD
         L+1X/T6uI7YUphrLldqcucTQLS73JofGZ/mJPhH+gDEKL6KZoLchA4b0dLCdO8Uf+6lq
         O0TQMn9K9FWc0hIWEgbSVKzikFIYF8Y4kS3e0mhgBOgVQxUXT7g26270yETH8avBozJ8
         9F1A==
X-Gm-Message-State: AOAM530fX4gzHZGZ7P0BXOV7tS2M6K+TQxIkIVqJJmxMlwTiCcsVdNa+
        yN2isdhO0GubmWjI2K4iYYH4D4opL1I/HIlGYP3L0Ke62hsuMhNe7xy8uAhDiB5G6ujxkLyWjyP
        dhTrv+XmLIlsx5z1aaYdafDXUH8UtSv212w==
X-Received: by 2002:ac8:1729:: with SMTP id w38mr14451115qtj.103.1597683545484;
        Mon, 17 Aug 2020 09:59:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxJJiv/Ri8rwm/wGpQwF0OCCWyOwaGCMllzvaEgPPwx8RdxAfTH9PUscUkBAtI5yJmc8VJeQ==
X-Received: by 2002:ac8:1729:: with SMTP id w38mr14451090qtj.103.1597683545208;
        Mon, 17 Aug 2020 09:59:05 -0700 (PDT)
Received: from [192.168.1.75] ([191.8.4.228])
        by smtp.gmail.com with ESMTPSA id y14sm20591273qtc.84.2020.08.17.09.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 09:59:04 -0700 (PDT)
Subject: Re: [PATCH 4.19 35/47] x86/irq: Seperate unused system vectors from
 spurious entry again
To:     Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     jan.kiszka@siemens.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        stable@vger.kernel.org,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        pedro.principeza@canonical.com
References: <c2b7a96a-122e-bdec-7368-d54700a55915@canonical.com>
 <20200817162156.GA715236@kroah.com>
 <a2788632-5690-932b-90de-14bd9cabedec@canonical.com>
 <20200817164924.GA721399@kroah.com>
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Autocrypt: addr=gpiccoli@canonical.com; prefer-encrypt=mutual; keydata=
 xsBNBFpVBxcBCADPNKmu2iNKLepiv8+Ssx7+fVR8lrL7cvakMNFPXsXk+f0Bgq9NazNKWJIn
 Qxpa1iEWTZcLS8ikjatHMECJJqWlt2YcjU5MGbH1mZh+bT3RxrJRhxONz5e5YILyNp7jX+Vh
 30rhj3J0vdrlIhPS8/bAt5tvTb3ceWEic9mWZMsosPavsKVcLIO6iZFlzXVu2WJ9cov8eQM/
 irIgzvmFEcRyiQ4K+XUhuA0ccGwgvoJv4/GWVPJFHfMX9+dat0Ev8HQEbN/mko/bUS4Wprdv
 7HR5tP9efSLucnsVzay0O6niZ61e5c97oUa9bdqHyApkCnGgKCpg7OZqLMM9Y3EcdMIJABEB
 AAHNLUd1aWxoZXJtZSBHLiBQaWNjb2xpIDxncGljY29saUBjYW5vbmljYWwuY29tPsLAdwQT
 AQgAIQUCWmClvQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRDOR5EF9K/7Gza3B/9d
 5yczvEwvlh6ksYq+juyuElLvNwMFuyMPsvMfP38UslU8S3lf+ETukN1S8XVdeq9yscwtsRW/
 4YoUwHinJGRovqy8gFlm3SAtjfdqysgJqUJwBmOtcsHkmvFXJmPPGVoH9rMCUr9s6VDPox8f
 q2W5M7XE9YpsfchS/0fMn+DenhQpV3W6pbLtuDvH/81GKrhxO8whSEkByZbbc+mqRhUSTdN3
 iMpRL0sULKPVYbVMbQEAnfJJ1LDkPqlTikAgt3peP7AaSpGs1e3pFzSEEW1VD2jIUmmDku0D
 LmTHRl4t9KpbU/H2/OPZkrm7809QovJGRAxjLLPcYOAP7DUeltvezsBNBFpVBxcBCADbxD6J
 aNw/KgiSsbx5Sv8nNqO1ObTjhDR1wJw+02Bar9DGuFvx5/qs3ArSZkl8qX0X9Vhptk8rYnkn
 pfcrtPBYLoux8zmrGPA5vRgK2ItvSc0WN31YR/6nqnMfeC4CumFa/yLl26uzHJa5RYYQ47jg
 kZPehpc7IqEQ5IKy6cCKjgAkuvM1rDP1kWQ9noVhTUFr2SYVTT/WBHqUWorjhu57/OREo+Tl
 nxI1KrnmW0DbF52tYoHLt85dK10HQrV35OEFXuz0QPSNrYJT0CZHpUprkUxrupDgkM+2F5LI
 bIcaIQ4uDMWRyHpDbczQtmTke0x41AeIND3GUc+PQ4hWGp9XABEBAAHCwF8EGAEIAAkFAlpV
 BxcCGwwACgkQzkeRBfSv+xv1wwgAj39/45O3eHN5pK0XMyiRF4ihH9p1+8JVfBoSQw7AJ6oU
 1Hoa+sZnlag/l2GTjC8dfEGNoZd3aRxqfkTrpu2TcfT6jIAsxGjnu+fUCoRNZzmjvRziw3T8
 egSPz+GbNXrTXB8g/nc9mqHPPprOiVHDSK8aGoBqkQAPZDjUtRwVx112wtaQwArT2+bDbb/Y
 Yh6gTrYoRYHo6FuQl5YsHop/fmTahpTx11IMjuh6IJQ+lvdpdfYJ6hmAZ9kiVszDF6pGFVkY
 kHWtnE2Aa5qkxnA2HoFpqFifNWn5TyvJFpyqwVhVI8XYtXyVHub/WbXLWQwSJA4OHmqU8gDl
 X18zwLgdiQ==
Message-ID: <14968c46-ad8f-fbdf-88d6-0ded954534c9@canonical.com>
Date:   Mon, 17 Aug 2020 13:59:00 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200817164924.GA721399@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/08/2020 13:49, Greg KH wrote:
> [...]
>> I'm sorry, I hoped the subject + thread would suffice heh
> 
> There is no thread here :(
> 

Wow, that's odd. I've sent with In-Reply-To, I'd expect it'd get
threaded with the original message. Looking in lore archive [1], it
seems my first message wasn't threaded but the others were...apologies
for that, not sure what happened...


>> So, the mainline commit is: f8a8fe61fec8 ("x86/irq: Seperate unused
>> system vectors from spurious entry again") [0]. The backport to 4.19
>> stable tree has the following id: fc6975ee932b .
> 
> Wow, over 1 1/2 years old, can you remember individual patches that long
> ago?
> 
> Anyway, did you try to backport the patch to older kernels to see if it
> was possible and could work?
> 
> If so, great, please feel free to submit it to the
> stable@vger.kernel.org list and I will be glad to pick it up.
> 

I'm working on it, it is feasible. But I'm seeking here, in this
message, what is the reason it wasn't backported for pre-4.19 - is there
anything on these patches that is known to break old kernels? I'll
certainly submit my backported patch to stable 4.14 once I'm sure it's
working and there's no specific reason to not have it done before.

Thanks again!


[1]
https://lore.kernel.org/stable/a2788632-5690-932b-90de-14bd9cabedec@canonical.com/T/#mf0b26d5a7ff880cfd63bcda80136296275d3682e
