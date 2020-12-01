Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B3A2CA681
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 16:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389010AbgLAPEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 10:04:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59891 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388658AbgLAPEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 10:04:09 -0500
Received: from mail-qt1-f198.google.com ([209.85.160.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <gpiccoli@canonical.com>)
        id 1kk7Bd-00055l-C8
        for stable@vger.kernel.org; Tue, 01 Dec 2020 15:03:25 +0000
Received: by mail-qt1-f198.google.com with SMTP id t22so1476402qtq.2
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 07:03:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=03aW3appDRquFTem8NKdNwurfEBt6THO7qtROGC6hF8=;
        b=fWsYFUhCYb7/wR+kwcmNs+Dl3nLNUL35FxCqQrLoyQOZ3SN6VY4Py1xrVDInIBbtP6
         XIik6vmcUxH1kvQBboj6zKLtgPuyfkbtukvIjmizB/k//PqtVhhJSQb1AsZj44hqgrpE
         kmtpo+h3vxEIqzpWp7YNVRYF2PHGd6IVtHhY/LdWRezl8zWox0QcKr4pfeFj/Mcrwbc9
         5Lp8rhPD8p5tYws+xHdrLrrJZSjs5Q/ptBvk/gDoKOIYkijeal0UQB1gP2TyQN7BfFF2
         8Hd0mYNpSzJHb9kAdAbcTt00jJuBAiBPCJeM8D/5ucszQMALcCv5v/sGx8wcUR1wtATd
         3lIw==
X-Gm-Message-State: AOAM533bjowbRdohHlSu+TFm3AdR70HnOXVx2FAxeIgBlq4MTg0Sg/WH
        JqLWHDH2wi3nIsF6WzVjD+862mP9HF3qbcHFwABkjwO3wUZTfOyMMZz3+ubMgY8qECPQCIO4hel
        LX6Yuxf/TgUHeG3vl+VHbiukDm/hC7QxfcA==
X-Received: by 2002:aed:2946:: with SMTP id s64mr3164800qtd.73.1606835004372;
        Tue, 01 Dec 2020 07:03:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhCOEH3tdpoPIsJf7Damqz4tZBE04wTcuEVBjySz3qyzcNv7MDF5mDP61cBvAgAJKwFxIuMQ==
X-Received: by 2002:aed:2946:: with SMTP id s64mr3164766qtd.73.1606835004069;
        Tue, 01 Dec 2020 07:03:24 -0800 (PST)
Received: from [192.168.1.75] (200-160-92-130.static-user.ajato.com.br. [200.160.92.130])
        by smtp.gmail.com with ESMTPSA id i9sm2092277qtp.72.2020.12.01.07.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 07:03:23 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        bsegall@google.com, Ingo Molnar <mingo@redhat.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        gregkh@linuxfoundation.org, pauld@redhat.com,
        zohooouoto@zoho.com.cn, stable@vger.kernel.org,
        Gavin Guo <gavin.guo@canonical.com>,
        nivedita.singhvi@canonical.com, halves@canonical.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
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
Message-ID: <e87e517b-7f97-66ba-4f17-718330910a7b@canonical.com>
Date:   Tue, 1 Dec 2020 12:03:18 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Sasha, sorry to annoy again, but maybe Peter is very busy - wouldn't
be possible maybe to get that merged after a review from Ben or Ingo? I
see them in the MAINTAINERS file, specially Ben as CONFIG_CFS_BANDWIDTH
maintainer.

I understand the confidence in this patch is relatively high, since it's
a backport from the author, right?

Let me know your thoughts, and thanks all in advance!
Cheers,


Guilherme
