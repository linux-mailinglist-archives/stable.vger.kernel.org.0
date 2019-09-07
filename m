Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B35EAC547
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 10:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387769AbfIGIHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 04:07:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50692 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728485AbfIGIHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 04:07:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id c10so8685724wmc.0
        for <stable@vger.kernel.org>; Sat, 07 Sep 2019 01:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MMU7ViGoY1UzrtFf5o6NrTTVSIc04Yn8hIOV3EfhD6Q=;
        b=neBRztrX/MRvA5QYsuKQf/koWc6NFw518W8jk7vSyw6jf37jp+kMmWLpAHRkQiNpnc
         Gkau4vCb3/9cFZQt5K9GdUXzyZHiseVnMPNIiY6SELHYdW1kKfxj8RTUplV/3Z5mujG+
         WOol3eyfDDqWxFXARwEEDCRfTgH2JvwJhjUwADHdggpt0Yq60ukcrd1bRkSPhjAyB22B
         AeqyWJJBS1YQiUth6Kt0GxFKTVYyxKENACsxcUPrgMlDR45hNYy2/TqIrNlF9Du4M25u
         PlAiuFF/l4GDoqgCKZ6VQrD/LX44K9GjFGYkoaJYobgivUi5RbhqN8/L0HdyGuePAQe4
         Q29A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MMU7ViGoY1UzrtFf5o6NrTTVSIc04Yn8hIOV3EfhD6Q=;
        b=JguZqnl8kwkfF0Dx0i7GJzmvGzs3LyRb+cx6+siLnLDHd1th3R2HgMKOwY8t/4fn4w
         h2hss+WL6bYxV/4PVc68LM90GdYjSSz7DSfYrAz0jfKAbXB7itL3Re6tekk1UuBOsftH
         35yTMiUBXBokPabvQDfECPrc0r5jqz6I8+O4DQE7vyvUE+z7Gh0ftq9MUf6yI942H+6V
         M9QmNSccSvnBu5FvK5BXPPeUHRsAivVT9hsMHcEKJkqL4Z44wQQytCDksptHenIFin4E
         6QMeMsXt5J3MYpQhrI3ysj8I5GqZq7z56MUVj6D1ZcDXioxr2wLOpo6pPeqO0SoWk5hL
         m+8Q==
X-Gm-Message-State: APjAAAVT0JEyY3W1YkteJgO0oL6D5/NlQS60ed2aT+JTreMu5cYRfWC4
        BIAqBVVqs/FGMgrgtxtkDo2XHu4ZwNvAkQ==
X-Google-Smtp-Source: APXvYqwq9lqXNzMq5OWFrrMFw3zhdNHRZ9AXhyQJEquyJIolTExgtx8/W7nzYsKtuTARYeVrqetpRw==
X-Received: by 2002:a1c:be04:: with SMTP id o4mr10791105wmf.60.1567843619322;
        Sat, 07 Sep 2019 01:06:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q25sm8531746wmq.27.2019.09.07.01.06.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 01:06:58 -0700 (PDT)
Message-ID: <5d736522.1c69fb81.460fc.8a95@mx.google.com>
Date:   Sat, 07 Sep 2019 01:06:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.191
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 103 boots: 1 failed,
 93 passed with 8 offline, 1 conflict (v4.4.191)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 103 boots: 1 failed, 93 passed with 8 offline, =
1 conflict (v4.4.191)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.191/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.191/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.191
Git Commit: efbc4a364bd5469a616668127439e7cfca4c1d7b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 18 SoC families, 13 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
