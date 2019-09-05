Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F8CA97AC
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 02:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfIEAi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 20:38:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38057 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfIEAi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 20:38:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id w11so405337plp.5
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 17:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=DVY4kpFPkpbcHQ9NAk49JOazH2N2FonoDOdWz04IiHo=;
        b=PtzQ86lXn7C+yDBHRJ0jHmYnma1VFTuU6wVHR269sP/KRDxZ97XH9fxVzaCGSmDLEY
         L7R+9ARrtkaaRQOdsCgUxNvCiBVlwN51D6YZNFDdb0mww58iwfp1rpXpBvt0/rjd6+3F
         y7vv6BgiT7cYoNMdiWGwsPhh9e4FxM79wvUifJOOmrZ4UX79YXdZiqCJtDVf7GSgEEgg
         UdrMOXQ0XCiGx6rOKwtxohUaYh7qqB3agA55e84UUkEjeJV0tqJIkeL9AfmUlEQSK4Wk
         VR+e6jndIMPJqlAeUKyEb0PAMDD8aDQ8zFTzT+UVZZmADiJiyFrgBKkRboqCCl/e+Cqk
         Xv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DVY4kpFPkpbcHQ9NAk49JOazH2N2FonoDOdWz04IiHo=;
        b=Q4NfA5fDQa1F43S7+gfM6gIZso2Q36b8KlX3ElHwKnN4LZO0WY6sM9+9zSN0OEyUCA
         w4DbCGw5h+9vptCHE83zSvaHtbHQz70IIN6huxTiD7eXB1LQzpvHMBzSMlE3z1jvKag8
         lVdI7mKvONXshOx4WopCZHKq7bv7cBAKDf1F9dbDW/w/NUbCjfekayLsUrKkBTmFE2Fn
         M7UGceilDyLxfC81K2eBwZSpxdk0JiPHLYaaoim0fGGCad5GrzXdX1Il8aLODnur8SI+
         ss0PXLMb5/0gKbvf8imUQk6RI7f0jG7OJXvjdhz05v+LVBEbbgAypKSY7CqVNh/IByEG
         7Yrg==
X-Gm-Message-State: APjAAAU7Sj3TykWJA54aL1nxsJfxnVIU58elcUcFeQ+tzMx2Ar/XFA8x
        ZU8fQ91Ye3UKsDYdkcsoHZCNnQ==
X-Google-Smtp-Source: APXvYqw1YBLv+apopZTVFjiJBpcYNNpIx9+SE/LIGS1HxCffXdm+0GlrhcfziABNqxx+Imc0YLlkPA==
X-Received: by 2002:a17:902:b497:: with SMTP id y23mr509672plr.201.1567643936245;
        Wed, 04 Sep 2019 17:38:56 -0700 (PDT)
Received: from localhost (c-71-197-186-152.hsd1.wa.comcast.net. [71.197.186.152])
        by smtp.gmail.com with ESMTPSA id w11sm262656pfd.116.2019.09.04.17.38.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Sep 2019 17:38:55 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     "kernelci.org bot" <bot@kernelci.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/57] 4.14.142-stable review
In-Reply-To: <5d705444.1c69fb81.c4927.1cd1@mx.google.com>
References: <20190904175301.777414715@linuxfoundation.org> <5d705444.1c69fb81.c4927.1cd1@mx.google.com>
Date:   Wed, 04 Sep 2019 17:38:55 -0700
Message-ID: <7hlfv3shk0.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"kernelci.org bot" <bot@kernelci.org> writes:

> stable-rc/linux-4.14.y boot: 144 boots: 5 failed, 131 passed with 8 offline (v4.14.141-58-g39a17ab1edd4)
>
> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.141-58-g39a17ab1edd4/
> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.y/kernel/v4.14.141-58-g39a17ab1edd4/
>
> Tree: stable-rc
> Branch: linux-4.14.y
> Git Describe: v4.14.141-58-g39a17ab1edd4
> Git Commit: 39a17ab1edd4adb3fb732726a36cb54a21cc570d
> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Tested: 68 unique boards, 23 SoC families, 14 builds out of 201
>
> Boot Failures Detected:
>
> arm:
>     vexpress_defconfig:
>         gcc-8:
>             qemu_arm-virt-gicv3: 5 failed labs

All 5 failures are for this same QEMU target in multiple labs

It is also failing in linux-next and on several other stable versions.

Under investigation, but smells like an actual regression.

Kevin
