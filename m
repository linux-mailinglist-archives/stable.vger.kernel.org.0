Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3D257CFB
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 09:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF0HQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 03:16:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34819 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfF0HQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 03:16:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id f15so1236515wrp.2
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 00:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ijk87EElqBG+wXAHKdhfZ8rcokxnl5cHX0dGwHMUVDQ=;
        b=OlcYOnNtJNKDfKgtnYA62UpmK69M3IerguhFmfPM6AqtNI63BoYInZSWzUGtIVEM0i
         G2qiAUTPuxGlOd6bfuY8xVhlLDqilJfsjUeOtpAnSs9+blOOpqAWQlyd+zYqnFrDDohk
         C0XDgEUqcFs8JSaWOKeuRjk0wQB1cIQtoEV+F78bpv+QmD8uP/GhZfYPnEXucQSDNCBl
         sCxR9Mv80Czp2csLJ1dW6zCtSLZ9aUki6hmJOWN5P8n338dloEYdMrmk0Sw4v6mv+aAe
         0LWEAxAl7EVyNKfQSBWcxuQP+gZ5hCN0HlMyUGfA7qTEZ4yilf+MqQqDOrQPfX0iir5W
         XobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ijk87EElqBG+wXAHKdhfZ8rcokxnl5cHX0dGwHMUVDQ=;
        b=SpviSeXMm9PqcKQQKyDn3kJVt0ZMoWdcaN5r1Z5/dj5lcG0PzxbevUQpWQ+nKHtF18
         SJf1dyT2ES3KaCFzP4tdTLxTgrGpAB6pJ2M8grTfUKB3cYMUKTFBQkhMi9S43Nf+w9Ul
         D7ZzY361yBy9tH7vh1/bbN5cig6ZXvZ4UjODeeCTmKAMjxaVg6rIXDnxtxoG7L7aPo7L
         uNNvVNi9REBAXEitfKgum7oEIUkoWuagilUvEWe8o42HZ1YOMzuyFE18C6U4XpTSGXSR
         Y0qYcqgDie4I+lndn/dno/uZsMCpQy2c4NVNUSOgvpVKu2TR7IfOXyq9fgjLdtQ+PW2n
         LZug==
X-Gm-Message-State: APjAAAW4bS81o9q952XGpbH/2j1E3bt4yO9oXAeqwilOXsXvYQ+zqlV/
        t2e5t0vTv4FWRMupQZnr550tIiDezJ3p5g==
X-Google-Smtp-Source: APXvYqyYpDAisBQh5QoR0kH+JPiTq5GTvinSZ/obGjnsyv8mSyBIC6Nl0TEu7k1fP3ygmPf14SnAFw==
X-Received: by 2002:adf:e442:: with SMTP id t2mr1831144wrm.286.1561619806867;
        Thu, 27 Jun 2019 00:16:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a64sm3997482wmf.1.2019.06.27.00.16.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 00:16:46 -0700 (PDT)
Message-ID: <5d146d5e.1c69fb81.f88eb.57d3@mx.google.com>
Date:   Thu, 27 Jun 2019 00:16:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 109 boots: 2 failed,
 97 passed with 10 offline (v4.9.184)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 109 boots: 2 failed, 97 passed with 10 offline =
(v4.9.184)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184
Git Commit: 09a70683607778bf96ef2db72e8c3b823339734f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
3-36-gc40261803d2e - first fail: v4.9.183-2-g493abc5bd149)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
3-36-gc40261803d2e - first fail: v4.9.183-2-g493abc5bd149)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab

---
For more info write to <info@kernelci.org>
