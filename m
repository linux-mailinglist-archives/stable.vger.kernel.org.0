Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FC2246D11
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbgHQQnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:43:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37064 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388955AbgHQQnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 12:43:24 -0400
Received: from mail-qk1-f198.google.com ([209.85.222.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <gpiccoli@canonical.com>)
        id 1k7iED-0002wP-6C
        for stable@vger.kernel.org; Mon, 17 Aug 2020 16:43:21 +0000
Received: by mail-qk1-f198.google.com with SMTP id a186so11253810qke.1
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 09:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0xqp6xB0x/F0bhAYGhsldeK+3c9wtI19yZmF/fn1Ktk=;
        b=aMd14eG5OMF0+cKnT5lyltzH5oJRI2X/D55ZthBW6w3PLP16pOvnqJbVWapROlxIPs
         w6sjQi7Q0P2l0JzXxzMGMCAiRECIs2kTDk7BVnnNJ+p+R+GiVIo6ERR0qWh71tdB6mC4
         5tI/BhL/P64YWcQ8JpP/Om0Op6cJK8pW/4hs0pU1Ypg8JPKaXVIAT7lhpKOK3cUYcuBA
         HAOi91AbOAyFex5brkxQJ0ks+s21lYchfiGsBwCIEkGjaUB2TVJdVGSlJ/mjlVSRp4e7
         jnn3laXuZjNA9fBrKtVOz4wj+TGZ+OiMaOP1jmRb0vtgL2hUG7BG+v056wlxXmY2hnBK
         ppqA==
X-Gm-Message-State: AOAM532gbxHxRPVIIeV4vknVxpC07mESRuidtbj7aH1sWOQWp4Xt/NlJ
        Ixx5EHorY642c5xcQjOZRcGQ5uwVUZ2EbNgxzj//emQcxhciRfkcKPXlG+FcbKMJdq9CVX2cw8/
        DWnUaZZBJaXUBRc7SRwQQio/+lZU+H61azw==
X-Received: by 2002:aed:3689:: with SMTP id f9mr14186363qtb.238.1597682600001;
        Mon, 17 Aug 2020 09:43:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyV+pqTxdDjsPAf45jTQsDme4iPUwb15CUTVTopNSxei2R4A1jDkAKkX2pvDfXB8lwqkS5Fmg==
X-Received: by 2002:aed:3689:: with SMTP id f9mr14186338qtb.238.1597682599694;
        Mon, 17 Aug 2020 09:43:19 -0700 (PDT)
Received: from [192.168.1.75] ([191.8.4.228])
        by smtp.gmail.com with ESMTPSA id k5sm19858067qtu.2.2020.08.17.09.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 09:43:18 -0700 (PDT)
Subject: Re: [PATCH 4.19 35/47] x86/irq: Seperate unused system vectors from
 spurious entry again
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     jan.kiszka@siemens.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        pedro.principeza@canonical.com
References: <c2b7a96a-122e-bdec-7368-d54700a55915@canonical.com>
 <20200817162156.GA715236@kroah.com>
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
Message-ID: <a2788632-5690-932b-90de-14bd9cabedec@canonical.com>
Date:   Mon, 17 Aug 2020 13:43:14 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200817162156.GA715236@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/08/2020 13:21, Greg KH wrote:
> On Mon, Aug 17, 2020 at 12:36:25PM -0300, Guilherme G. Piccoli wrote:
>> Hi Greg / Thomas and all involved here. First, apologies for
>> necro-bumping this thread, but I'm working a backport of this patch to
>> kernel 4.15 (Ubuntu) and then I noticed we have it on stable, but only
>> in 4.19+.
>>
>> Since the fixes tag presents an old commit (since ~3.19), I'm curious if
>> we have a special reason to not have it on long-term stables, like 4.9
>> or 4.14. It's a subtle portion of arch code, so I'm afraid I didn't see
>> something that prevents its backport for previous versions.
> 
> What is the git commit id of this patch you are referring to, you didn't
> provide any context here :(
> 
> thanks,
> 
> greg k-h
> 

I'm sorry, I hoped the subject + thread would suffice heh

So, the mainline commit is: f8a8fe61fec8 ("x86/irq: Seperate unused
system vectors from spurious entry again") [0]. The backport to 4.19
stable tree has the following id: fc6975ee932b .

Thanks,


Guilherme


[0] http://git.kernel.org/linus/f8a8fe61fec8
