Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BA92B9592
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 15:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgKSO4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 09:56:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43441 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgKSO4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 09:56:12 -0500
Received: from mail-qk1-f199.google.com ([209.85.222.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <gpiccoli@canonical.com>)
        id 1kflM1-0004BW-6P
        for stable@vger.kernel.org; Thu, 19 Nov 2020 14:56:09 +0000
Received: by mail-qk1-f199.google.com with SMTP id 141so5165849qkh.18
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 06:56:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:autocrypt:in-reply-to:subject
         :message-id:date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=Bwxif4APQLk8upgVA7PbRwMOanFA67Tv3/F7TDUxrqw=;
        b=l7yMemMQvDagIsbkvwkUbmDBqOItgRGvlP2AwJd4kdMxz0kGwur6LtcJ8c7ebqjwff
         bo5ITKSFWBB/m1IgiVTLHD5hvffBZvmWmpwvhIe1BQOVCWXwOzUQ0OZiWn+8ISCVmXcF
         54W9e3HB85WCCTbu81QCjbu+QxwbXle6GKA/FOwqWk7b+KRRfOFn+1pGokxb2r/e02+3
         C13WN5tqvHGqJKEaeDSJED3oeKxJStLlpsBXiBYVROog/UhMPmsvQgK3nbo9fQK9J7N2
         5O8lBk6fN85TyYxOIUS3Dq45YxVnb+cMQGTAg/jyL9fpXuRuFkvnumgNwsmeYPv8eMO8
         pBlQ==
X-Gm-Message-State: AOAM531SXRUZzKZfHY+CZ75UEBp5bzJ9EtSbxMY+p0MDM487GdbsWdMA
        ME/Vs0kkWBJwDMuSw9aBmNCFimlgxTG1hDrP5rHUsuFfBzUuZ4iQxLbYHTeEt6HBUhiAeGW3YPo
        CwBVa4zP7eb1sSQDFNL+dy5Lv1sE0szwiIg==
X-Received: by 2002:aed:2141:: with SMTP id 59mr10938277qtc.117.1605797768246;
        Thu, 19 Nov 2020 06:56:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIeqwk3qXgv77e9tlenQV5kfqISxuAwfPzlZ/sp7pASerDcZH6RwuPEYV/RAZ+8C+jLwSpgA==
X-Received: by 2002:aed:2141:: with SMTP id 59mr10938240qtc.117.1605797767947;
        Thu, 19 Nov 2020 06:56:07 -0800 (PST)
Received: from [192.168.1.121] ([177.215.76.189])
        by smtp.gmail.com with ESMTPSA id s27sm18742686qkj.33.2020.11.19.06.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 06:56:07 -0800 (PST)
To:     Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     bsegall@google.com, gregkh@linuxfoundation.org, pauld@redhat.com,
        zohooouoto@zoho.com.cn, stable@vger.kernel.org,
        Gavin Guo <gavin.guo@canonical.com>,
        nivedita.singhvi@canonical.com, halves@canonical.com,
        gpiccoli@canonical.com
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
In-Reply-To: 
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
Date:   Thu, 19 Nov 2020 11:56:01 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha / Peter, is there anything blocking this backport from Vincent
to get merged in 5.4.y?

Thanks in advance,


Guilherme
