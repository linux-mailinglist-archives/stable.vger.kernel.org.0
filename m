Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DD8ACF12
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfIHNqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 09:46:18 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:36717 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfIHNqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 09:46:17 -0400
Received: by mail-wr1-f52.google.com with SMTP id y19so11031698wrd.3
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 06:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3QnZ14tsqGTIYOYHonotm7iIPWq9FZ5g6RQ5GToOvoU=;
        b=0iKrMEltBUREmedZW+MTOWQPll/28TgFI6p6+2aP54o0qDgBMaL1+gpoqbTkl9IXz0
         tAEYyqzxhDJCslq2mgrhiTKcV7kVtjNCVRNoKvkC4phIYLYK6BYs/gQPdbgOwQfcfxxO
         2iXuJXoCF+EIdtTjixVAC8iFZR42eg7kGdtm1dM/Mzob/N+X7nEyapX6V72fMBujvymn
         gsMyCShtQbUgQTLwFMmf0BiI7NQJ2HII3StkjRt2wTSLKGyl+SHOCwRQRdyPdrvNHZKu
         DhqB+9k9rE4EqGuP+2hVdmJWTpCA+woq0KKw9DbxnX7ZwiZwgRILvC+qPtP5p73a2mfs
         pWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3QnZ14tsqGTIYOYHonotm7iIPWq9FZ5g6RQ5GToOvoU=;
        b=nHDBUrq/le5RxiKscIkp+qtZS94K3BuKQZPibM9wwALDiAYcMHABoZwuLyToj+bbPL
         JecI50FuJ3r6x+9k6Dbm5YeP7fepYM1zMyv4UliR0T3GNOTghkWxC5wPEIvqtf+Qr8ac
         nmoKKeThIAQAymbrYHSBd6c5bB5Cl7l2Cehf9YjoXGPZpuRD4EtxkMijHbWO8Stb9ruW
         fkZDBEwLYbA38wU6e75JD90IvEhYfhqCub9WIaUxqvB2aShJH/0ysGZDBm/IlrgYGrLh
         TQ9uWxsbfGgORTEPrmUMfeRmpImPx/HaOuU+wnDdJcH9K5bp22lO8ff0GCRA/fC4vt0V
         iLmg==
X-Gm-Message-State: APjAAAVZJo6+uRcN64ygMOpNWfW1RgmF6nNPWIfNxPU06iquO8mE6xTr
        WsbffjnQPy0ngZiJbkMrRBa9riLyoF0=
X-Google-Smtp-Source: APXvYqzP4yXh4j3G+DyqJcm/9HkFukZPbTc/AoBwdzTQJRgWZFHUipgy0ZxohaDDIts6ZBz1kywXBw==
X-Received: by 2002:adf:a382:: with SMTP id l2mr14407279wrb.194.1567950375788;
        Sun, 08 Sep 2019 06:46:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g3sm17238231wrh.28.2019.09.08.06.46.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 06:46:15 -0700 (PDT)
Message-ID: <5d750627.1c69fb81.63f0.06dd@mx.google.com>
Date:   Sun, 08 Sep 2019 06:46:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.70-59-g8d49eb84b4dc
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 138 boots: 0 failed,
 130 passed with 8 offline (v4.19.70-59-g8d49eb84b4dc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 138 boots: 0 failed, 130 passed with 8 offline=
 (v4.19.70-59-g8d49eb84b4dc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.70-59-g8d49eb84b4dc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.70-59-g8d49eb84b4dc/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.70-59-g8d49eb84b4dc
Git Commit: 8d49eb84b4dc2015f7757425dcba0b0d66a98164
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
