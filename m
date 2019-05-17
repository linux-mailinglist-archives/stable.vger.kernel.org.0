Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9126721A37
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfEQPBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:01:31 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:44837 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbfEQPBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:01:30 -0400
Received: by mail-oi1-f176.google.com with SMTP id z65so5343425oia.11
        for <stable@vger.kernel.org>; Fri, 17 May 2019 08:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gFZjU35hwEjTQqIvMQ5GQAUjJZfqM21eJyrJP0IyFCA=;
        b=HVLSeJ2VAvZ1yNf7USFyZspJAQocRcGfO88+rMEa+0IBZlgzbFB/KUHU1P8i8QY3lQ
         N/6KKSKMFnjgH8ORO+Szo6tObNyuDhkTh2pI6oUSdp8hjvABX9HV4YB//uXzt69ovi14
         ygIX0HSFAHWpIQ/gSDiyG1D9h9RKKv200GZKtIfkKbQqBKrm5js9R+B2GQ6sk/rGRHSC
         j4NV9lXODhQL3eAVWw3X/icnkWJQ7WbCl0SIGRLOJTpGZtnvSkp1ATsHlle4eJl/BeL2
         SPMX++O3rsv87upAMqTBF9g2tCYu+gtmuJymoJu+LoEgiMVYUgUSGkc3XbNqPrkj8XfX
         7EJw==
X-Gm-Message-State: APjAAAU5qPbcxYKeEeYxnkEWD9uahzeIiDIEks5VOmBOj4Se4QtVXZV3
        F+D9q6va8ZuBP35fh+m3Vyo4pbV2LIM=
X-Google-Smtp-Source: APXvYqxqkpsV3Smzr1eU9xVOL5SQF6AC/O7RTcAsHQdnYA4mHgIfAzO4aysg7U3bScC4lJLxPYubDw==
X-Received: by 2002:aca:4ac7:: with SMTP id x190mr3228266oia.38.1558105289560;
        Fri, 17 May 2019 08:01:29 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id k23sm2879474otj.39.2019.05.17.08.01.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 08:01:29 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8e_FAIL=3a_Stable_queue=3a_queue-5=2e1?=
To:     Linux Stable maillist <stable@vger.kernel.org>
References: <cki.0DFA48C38B.A7FUXQ4QCE@redhat.com>
From:   Major Hayden <major@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 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 UNdR
Message-ID: <a0c49c3d-ed2f-791b-a76c-8d34800b9ed3@redhat.com>
Date:   Fri, 17 May 2019 10:01:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cki.0DFA48C38B.A7FUXQ4QCE@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 5/17/19 9:56 AM, CKI Project wrote:
>   s390x:
>      ✅ Boot test [0]
>      ✅ LTP lite [1]
>      ✅ audit: audit testsuite test [3]
>      ✅ httpd: mod_ssl smoke sanity [4]
>      ✅ iotop: sanity [5]
>      ✅ tuned: tune-processes-through-perf [6]
>      ✅ Usex - version 1.9-29 [7]
>      ✅ stress: stress-ng [8]
>      ✅ Boot test [0]
>      ✅ selinux-policy: serge-testsuite [9]

There was a warning (not a hard failure) in stress-ng on s390x only. We're taking a look at this one and should have an update soon.

- --
Major Hayden
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG/mSZJWWADNpjCUrc3BR4MEBH7EFAlzezMQACgkQc3BR4MEB
H7GcrRAAius8X9XNfQ2dMqhJG8uUQgGIkvFM5ia1ivGfDgcEXt1Kk73uNnPIy4Go
i3OmBVeh/tABqFwo1y3tC7jtvAl/f48++OKf4FoczQu8CU/dPZ7E75cOP00L8ezR
1effjmFbia3bCBJGXiMuBRK0DnXuXOcznvmoJoPyHGp84djsP4EpKFWpVgBLm+aT
waUrgAp9qTJ4BZ7mlcmbL5ShVkWe6IustmDYwptcpoB6x6I+I4OBkK3cCNyt8zzb
Rl5bcXUmRgsWRK2nO7mK5yDbZZj/MkTKz2cxSuxj59Ch/4/Eh2AZWbA4g5lVlBji
tWEY/q1D2DgvsGAn4Xqf5vB+5m+R2UHwb0H8mjGIXHE9by+ErtYqkuIF+d78ggE2
gWEdZFZboa0fsr5ivQqu38AwKoN59n09XNtl9k3IV3n/UES2Q674yg/KrL3UGDah
gpb82iJPADGIgcGJaTqdorvKLLb65fsbXN+HtSNakGz+YWMQflSmCTbvHsAzstLn
JskzFeJhjxfraL/cHfFmlhxx8kydBscItyyWJA/b+yHANb38nF1dEuUguSk/IkRr
/78iC0paKpxLgGoeIGJLGE8//k7JUmzLSnwg1W8r2FESWggcSKV6nfZVkCag4eqT
3wDJYMiD9AqU19aoZKwiDUiJBEP02CPuvKli9V8/ikCs/dyygk0=
=yr4J
-----END PGP SIGNATURE-----
