Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E1337D3
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 20:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfFCS20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 14:28:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45923 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFCS2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 14:28:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so11074919pfm.12
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 11:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=H2KnmQlRLCh5oos58tvSfHMS/oTy7vw/weDNkzQ9mXw=;
        b=Osy9dyJU8mdbqfn/ryTBYyAnuCi6ddWgc13JdPVa61y5Mybc50GsPEf2EtnfwsORrX
         r+odil30tLtdjFnlTTgYnmlG2pjYqNngRqiNjD/4HsiQmPhqdUCRMSmLDEWcUdMLp2Gm
         X2bR5uMN3LaGiz3uIGesI2PMeSIKnwJX0dtgIENMpbozWXhKIjVKdEVHWqO6vXKbvMh4
         snnH5m6kkQ+Ipp41Yz5yIXWKfS4p6KoFJtvPIZbXW0ZEn0tzQtUkUD5UQG8Wn/Mh5Ef1
         letYrDo0dPUMie4oVzcjwJwU6v9kg2MFmkzTJOBVqMor2RLWm28f0ICk22PxeuNcvjdH
         +AQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=H2KnmQlRLCh5oos58tvSfHMS/oTy7vw/weDNkzQ9mXw=;
        b=KR4ZawssS2uivhTT5B9gDYXZeNI6rXiL9ehGtiMW128S3BumbmO8Df8qlTJcCmn47V
         R03st1lDRUv7fG/uyjdbQTYMQqAzLdWjqd8rCE0as3JE4dF40Q/JCdvNf5pmZCSmW10g
         jSBwRyUznVuM01P7Ae+psQjkAAPcrFtIHfTXEJ8PH+Xt4/kZDfUDoq41bmWDaOE96dB8
         ECtjMGZU9Pp8tdndpa+xTw2bY36QM0ZLzr9AN2UVdZ54LUnkHwOopEYU8fz1xyncPIei
         NVIgJUBy8zmeRor8/+x8ubdYIpHfBmCTo5hjNSXlv61U8yTM+3RhQc4nw+0B76yKD4lt
         gk5g==
X-Gm-Message-State: APjAAAUI0WQ318kxzjPVfQIJqReQaBfPrwgBImEP/E1ierCTP9rCWASY
        ahD+87xD/KLaFsbEB6hlpuQRHg==
X-Google-Smtp-Source: APXvYqxc+sUBtBlkORTYGFxV2li2uxx7HGoc6f+neIPlW/4tH9Sa9FrWSa0kVEmT7JKTnxiDBuojsg==
X-Received: by 2002:a65:62cc:: with SMTP id m12mr30152306pgv.237.1559586505034;
        Mon, 03 Jun 2019 11:28:25 -0700 (PDT)
Received: from localhost (c-71-197-186-152.hsd1.wa.comcast.net. [71.197.186.152])
        by smtp.googlemail.com with ESMTPSA id z3sm418119pjn.16.2019.06.03.11.28.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 11:28:24 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     "kernelci.org bot" <bot@kernelci.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
In-Reply-To: <5cf53378.1c69fb81.9dd1b.494b@mx.google.com>
References: <20190603090522.617635820@linuxfoundation.org> <5cf53378.1c69fb81.9dd1b.494b@mx.google.com>
Date:   Mon, 03 Jun 2019 11:28:23 -0700
Message-ID: <7hmuiyjzg8.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"kernelci.org bot" <bot@kernelci.org> writes:

> stable-rc/linux-5.1.y boot: 132 boots: 1 failed, 131 passed (v5.1.6-41-ge674455b9242)
>
> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-5.1.y/kernel/v5.1.6-41-ge674455b9242/
> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y/kernel/v5.1.6-41-ge674455b9242/
>
> Tree: stable-rc
> Branch: linux-5.1.y
> Git Describe: v5.1.6-41-ge674455b9242
> Git Commit: e674455b924207b06e6527d961a4b617cf13e7a9
> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Tested: 73 unique boards, 23 SoC families, 14 builds out of 209
>
> Boot Failure Detected:
>
> arm:
>     multi_v7_defconfig:
>         gcc-8:
>             bcm4708-smartrg-sr400ac: 1 failed lab

FYI, this one has been fixed and marked with Fixes tag[1], but it
appears the patch hasn't yet landed in mainline.

Kevin

[1] https://lore.kernel.org/lkml/20190509171527.2331-1-f.fainelli@gmail.com/
