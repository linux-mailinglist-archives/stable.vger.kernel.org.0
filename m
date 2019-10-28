Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739A0E780C
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 19:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbfJ1SEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 14:04:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46298 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbfJ1SEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 14:04:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id n15so10861997wrw.13
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 11:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X23dUWT8EGqbYrJOUZIx4lV8t30cueQYpCwBP9avtNU=;
        b=KHVk+wwmS88h1ruzLrXNI/DOpXWyWbtsXSvdiux9LRw/FyeT7xkg4WiLbNK34LXdoE
         avWoJ0+hC7XgKWRAhfyJs1p4H26oCJwIlCcdDtK5461/05B4V9uy8qb+gT3YNYoEnyLw
         nt4CaUEawwigPxyTOse/2IBIjWn9jBn+4a9dY7i8rrv2K4EYP0dVvvEgDK5EmmzAJz4A
         ZSgzgqLMp2rjKjy4uG+JeZwV6FoVp/RxFzCbTsM9QSMntV/GtbwlV/yUAo2l2qy99ggN
         bZj+7/kqMvXwnZTkbKZwlCtjU9FP5c6YFv0P4EnRWMhdvUZqSbchUy8SJ2CVnf3HeSy3
         Z0LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X23dUWT8EGqbYrJOUZIx4lV8t30cueQYpCwBP9avtNU=;
        b=hVXDuptUEzfBeoQsLliVesshkqEb2k3YS8c3iRfIWGzRN0qQG4wQx3cDuMzrhe/Puj
         OGoArtP4t5ocY4zNFQ8j5M3oz9gdmj0UEyugLdteLKgo0FD580J0p8/czxnFVg7NYNrE
         ZzaWEESgviVMm8eTZLlUE3USLHYTYEkSyBhy5lNH5wyeypliD/ymoWZuXArQBbPsHQpp
         dLKmAOvDQO8+SJo1leVbN6PKA6ovO6eEbw21B1cio0JTTlss+w/j/bhI8PEVhrp2lpDg
         OLvIU1vLZoRhe0hfp5v1T5MMgpqucs5TXMbtwRU/Orxnz8ecQC+DSq0I6/kTqDjG64JS
         CvOw==
X-Gm-Message-State: APjAAAUIb0+0wWA2kurAyjo7XkUH0nQaMDWsNHodw9m06s5jDv8A9YbW
        aF6T/cwrAYs5R2seYmWtziOmmydIWMzjUA==
X-Google-Smtp-Source: APXvYqwYun2YIVv5XO51cvthIcKvuaAxZWh+nOYNQy0PjPHAFs+kM0C1ClhaB90bNVcgGcxp1+zWKQ==
X-Received: by 2002:adf:dc8c:: with SMTP id r12mr3263595wrj.199.1572285846917;
        Mon, 28 Oct 2019 11:04:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a23sm343046wmj.2.2019.10.28.11.04.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 11:04:06 -0700 (PDT)
Message-ID: <5db72d96.1c69fb81.54a2c.270b@mx.google.com>
Date:   Mon, 28 Oct 2019 11:04:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.197-48-g263ebb72c5fa
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 100 boots: 0 failed,
 92 passed with 7 offline, 1 conflict (v4.9.197-48-g263ebb72c5fa)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 100 boots: 0 failed, 92 passed with 7 offline, =
1 conflict (v4.9.197-48-g263ebb72c5fa)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.197-48-g263ebb72c5fa/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.197-48-g263ebb72c5fa/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.197-48-g263ebb72c5fa
Git Commit: 263ebb72c5fa6a7c3f395976e20ed2828d82815c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 19 SoC families, 14 builds out of 196

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
