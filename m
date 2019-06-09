Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0F313AC6B
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfFIWaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:30:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43899 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729265AbfFIWaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 18:30:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id r18so7219255wrm.10
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 15:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=VbwrAx1UuhYUk33Eb6Nh7Ho50cD83TFR3BNTlq7pRds=;
        b=Xv7G/IV3EOLxpvGYFNodCktudkRopSI5EOZgt7FkFUy2H13fWaCDi7JZ4iBiSjdNdr
         Br+oQEBapIqJrTdR0in2ZsAZaSiwzG3FOB1Ecs8//ZBKm6vG9sjCi/4as5JyxcLFBoMx
         3RnNUDNvQwWRBy45VM5xDl9z8jgoYL0FaOZOnmTrgfBiKygKSkYNUrzgJH70Rsat8OiF
         SE5XF7dwHA1/3mh1qbOIDnqXrN8vl5wjO2KEXwPHJzIoOcWvGfBSZ4jkrGkV+75EZ1De
         BTB54sTiEgmrmRC6PEltVplR7pIfFOj0b3XrWkXypllPgfxCwiq0VFrAiou7wdV6xSEg
         13ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=VbwrAx1UuhYUk33Eb6Nh7Ho50cD83TFR3BNTlq7pRds=;
        b=VPbwZCsLOf0xTMI8pkq+yB7bA5+xgxE1Wzelvmr/QpIMPGoiW3ZNCi1WjHwhbDO8+b
         tnUotg0L9i/c1g4ZeS6EZiTrjcezspxy953cWNdfiq35+n+PSpDiHskAgNjtKACE9LRh
         iqRDAMgu+o5u/8HsdHQQonc6sm0WXXwSdkiF3OzNRHY/Y27rSWEnCaIbV9/HbXMm/H+a
         kuuqbDExnO8jpNZO9XypJkKPY8Gx3k+uCQKXktv0ogNa/YiUakkgs20sUsxpYvZmLoif
         /B/rdhIpcYTNz/3/Ur00+sDnAsJNgM08ctNCqdULrLtYkoJ99X0Al4nJ4IKWH2dKxlk6
         0Fhg==
X-Gm-Message-State: APjAAAX8xJG98wloTqGgwzBFnVMtBX9KWSV8+18+qq4rTHOoLLiDkefq
        vtuuRCwQzp60g4Vp5ibE3jPFBA==
X-Google-Smtp-Source: APXvYqxnDohVWMWpdwiz6rnPyllv0BfV0QvQ5Es7z3p0OgxWoRq7LCubNLGPO52u5he+3Yqe6M45Mw==
X-Received: by 2002:a05:6000:1206:: with SMTP id e6mr2968719wrx.182.1560119414287;
        Sun, 09 Jun 2019 15:30:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 32sm22129828wra.35.2019.06.09.15.30.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 15:30:13 -0700 (PDT)
Message-ID: <5cfd8875.1c69fb81.5cb9b.0f42@mx.google.com>
Date:   Sun, 09 Jun 2019 15:30:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.180-242-gc9c6a085b72e
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
Subject: Re: [PATCH 4.4 000/241] 4.4.181-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 94 boots: 1 failed, 92 passed with 1 conflict (=
v4.4.180-242-gc9c6a085b72e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.180-242-gc9c6a085b72e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.180-242-gc9c6a085b72e/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.180-242-gc9c6a085b72e
Git Commit: c9c6a085b72ef62ce2cdcfbee79476ad2bdbd703
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.4.180-230-g17950b5be=
27c)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
