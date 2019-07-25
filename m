Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604AE7441C
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 05:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390132AbfGYDrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 23:47:47 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37633 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389014AbfGYDrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 23:47:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so23998699wrr.4
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 20:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hWXOP67imUsurGQp8bcybIqJKKlgn1cn9YYELC/T1ZE=;
        b=aMtWfTyfHBMe160QFhfFy8ebQEzJsLlmw1Ll928l7YWvfrub/anNSjw9A5RtmWB+3y
         McQ9eGGQxl2MWsL011hbC7sYyd+i7NFHv+ZirPMCsikRKN7Wmv4ZplvNDvyQ2XLFpWnR
         uqKeQRoK58xas060Iaec/4zB+wQXEm+NID3LKlUdEGnNixFMz8bRJX2xKFgnUuFufSo3
         xKP2Ylf1vDRNCYCJpxZ0HP54zrTcToe09ywLJGcOgDVbEaiJtKBvUdEU2akNH7pMc9uw
         SULza1+AqhEpH3dUDCgDaVZ7Cj0Y1pXZHIMEwDZ8q8qSNR/go+iM+glJC+/A97cyuARl
         tKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hWXOP67imUsurGQp8bcybIqJKKlgn1cn9YYELC/T1ZE=;
        b=aW0ElrsdcHyVvonbkVGqM9K9/h4k5Kbh4ED3V8Mx6vyTK7A+qKf/zp17tUhow4+KWc
         iXm+Y6jnHEetZT7ExcAFIi6wEXdWKxzzusTsh2A5FRFiDaHYxiljYR8JiaBmCOpkPH9f
         IUFU5NOCmWYc4ALNEf7jTwAj/zN0lmh7sJLK79uyQwKPj9De5CD5sckQ9r042Ev+ddL7
         fd6bQoAk4Vg+8bima9GVcQ2ZcIDsaH+vSNMz6bakKTyi9u3Mcnpv+ICkn4HS95nDeXGa
         b4qp2KU3+IwYCDfXHYLLB2GH08U660CMTdAjBzAw3mUNHXBJKr76Mcyo8+yuRDH6CNoY
         OU3g==
X-Gm-Message-State: APjAAAW1ENyhsNkXJUmCoC+iXVv5nJlhEycc1PiRxMT/jZXztxYZaSUz
        RTsXH14XGA1RqFwYlizDpXAGE/NqSWc=
X-Google-Smtp-Source: APXvYqydDgoe5Kc3Xh8acf5mcABG73HW4atvfrhYFFqeKWLZqufB7CjLSxAzjo/FAObgAVUAoXOwEA==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr8548447wrv.247.1564026464903;
        Wed, 24 Jul 2019 20:47:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g12sm67777485wrv.9.2019.07.24.20.47.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 20:47:44 -0700 (PDT)
Message-ID: <5d392660.1c69fb81.e3cfb.f1f1@mx.google.com>
Date:   Wed, 24 Jul 2019 20:47:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.134-179-gf0382b8e83d1
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 126 boots: 3 failed,
 121 passed with 1 offline, 1 untried/unknown (v4.14.134-179-gf0382b8e83d1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 3 failed, 121 passed with 1 offline=
, 1 untried/unknown (v4.14.134-179-gf0382b8e83d1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-179-gf0382b8e83d1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-179-gf0382b8e83d1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-179-gf0382b8e83d1
Git Commit: f0382b8e83d10a8840495f7243d28d5abd6502e8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 26 SoC families, 16 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab
            rk3399-firefly: 1 failed lab

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
