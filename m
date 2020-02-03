Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30376150BF2
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgBCQb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:31:59 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43552 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730336AbgBCQb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 11:31:59 -0500
Received: by mail-wr1-f68.google.com with SMTP id z9so6830633wrs.10
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 08:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CbgBUSiwEpbCbXVU15eR2EKVYmItCdvyTVNMFQorXj0=;
        b=cGaZ8b+0GYh94Clisagt8L6luh4XANMrPZmBIqNY2/b1AP6cH/jzp3IABJ2FpNTV8I
         zaKFEA3O7fZS2lRkKvODNd80BtJA0/7gZOAId/1EJZM3vol7KPcpkqDXyQlwGiyFn10e
         nOHD6FxzxOf001Vl6oTCXCXrI7l9F6mAAgO2IHzlk0J347V5lBK4Z0A+lOwhWDmkf6Ds
         rh3tohQy2Xw+kdyEBJ84fS4lATyz4aeitlOo8lzdH+0l2Q7LFZeXWoQr30ZYTAFaetgx
         F4BqgNYGCxjDehf38Qc/34DKQhdpzkIYHK4aVwqGfHQz5/T0nniSgmjw4tIRZEywy3zR
         6bxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CbgBUSiwEpbCbXVU15eR2EKVYmItCdvyTVNMFQorXj0=;
        b=ADrPcr/yXjMzH7sNMgJ06wr7fqhYgesbTXVfbFUmoUPwV1foRSQgCTaZcHW1ZdY0Hw
         hCjyHA1v2x+zQxuhsvT3r7+odlTqHl3l9k6vs5cA0M76UpHb1yyhZIN432R4C/jIDCMx
         LuPenWyj8zMCFAIJgc8el5Vu8OSqP0OHrQGmjxoDBaAe0Kqy6Q5VhGRSr8/307NTe2H9
         FyuY2xgeLv4BXzTnCSxUFT6Ml3PiVcTnzsL4yNHuCGxwvoXufdz+LKgYwNsw3mEKxp3n
         mCJaLBTQP9z8RaNXrXFT9VrlZPgke/MWlUrrgw6zOLAz5b4RlBhzOlIaQ6+vLPSm2T0Z
         XwBA==
X-Gm-Message-State: APjAAAWT7C6+3Os1Bm00uIsoDZ60SNlkaDxaI4nGhewLfBgWzVQh/hpp
        MBvPPpGZYcDztN6AR9sJKxzcgYbMFAU=
X-Google-Smtp-Source: APXvYqw1XS1K7EzEMTWo6y+NdxKofRgMdzeZ9oeVA6J8vJYD/70FnoRDKxAl8+A3fIST6wIe4dFBrA==
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr16249283wru.411.1580747516697;
        Mon, 03 Feb 2020 08:31:56 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x14sm23332436wmj.42.2020.02.03.08.31.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 08:31:55 -0800 (PST)
Message-ID: <5e384afb.1c69fb81.e97dd.55de@mx.google.com>
Date:   Mon, 03 Feb 2020 08:31:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.17
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 75 boots: 1 failed,
 68 passed with 4 offline, 2 untried/unknown (v5.4.17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 75 boots: 1 failed, 68 passed with 4 offline, 2=
 untried/unknown (v5.4.17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.17/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.17/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.17
Git Commit: 313c8460cf0290fb1b9f71a20573fc32ac6c9cee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 21 SoC families, 13 builds out of 159

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.16-111-g1bde1c5138=
87)

arm:

    multi_v7_defconfig:
        gcc-8:
          mt7629-rfb:
              lab-baylibre-seattle: new failure (last pass: v5.4.16-111-g1b=
de1c513887)

    tegra_defconfig:
        gcc-8:
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v5.4.16)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.16-111-g1b=
de1c513887)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            mt7629-rfb: 1 offline lab
            tegra30-beaver: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
