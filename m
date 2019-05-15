Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60101F704
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 16:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfEOO7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 10:59:00 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:43664 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfEOO7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 10:59:00 -0400
Received: by mail-wr1-f47.google.com with SMTP id r4so3037319wro.10
        for <stable@vger.kernel.org>; Wed, 15 May 2019 07:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5lBv90kLsk53rZLDfAQHyn3ShZ1PpcnXQ3v0oMND3b0=;
        b=U6fVipNZgVxyRMat/NF+7Lt5/q6A3PUO/jUTHtNdS96eBOEWJVTKoyDTOPs27GVH/m
         oG+nZasaZd+kXH6sIWyLHifUlxBqTPBl12ZaBXrz0R7MB9aN0LN70p0RX0ne8h2cMydD
         mMDj2kCpEXdRNtrzSCDKqc25VVCljGHFwr/h3JIZvUvNmFmuefWGVW4DAx45bm1HA5qH
         SOmJ3WofO5H/2HUqtMGsG1SXI8mSNjBHX7v7YBxpxQaMNJycAJ/QDkoO3SQAo22kJ+JU
         Lestl4/C25P+9reGikEArC9zvXwn2SmL76lukh6hHtkLoRWWM4LtjqU8JKeX6DuS7Kho
         Io0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5lBv90kLsk53rZLDfAQHyn3ShZ1PpcnXQ3v0oMND3b0=;
        b=C2iePE7m2T3EtSUgetb6yI6LOubWq2/RIedWUazakOSdqabtphxFyzwrkdCwcsIZ1A
         cVanA/NWiCm7JaT0DPdQ4N+1oMlZtlqvV7ZHTwWmJW1LdS6akulWVF6qvbwcjcMbseOr
         OelCNaxU31cvQFLJsBEEZE5H9EkDV+DOcYB963cxSDy4/LuERihGC7dFkkyPKtfFbJg8
         inNywWLjAOq/2PP2eDPCOqkVoEDbCAjm8T0f80UQhEUgGHkuAneQmnEvJOoGsT4O45Mz
         93V3vmBJWVN48Wbev8Fuk5QP3gVLWXHcRfOo1GZekNcpnjoXMfVlQyVgCHbZZCf/hjuY
         mgZg==
X-Gm-Message-State: APjAAAXwrkIvoDwolVixJSLGaAnHFFOhkchASZ9w225mMwRVI2mDVjzw
        1i9N5QUTed0piYBG95VNwrj2XuFH9UxU0A==
X-Google-Smtp-Source: APXvYqywi7dxvVcJ2KqG4fqdxzygPkACwImGxTifLCNVlnQC+RqEJSNZIJKTYBheaCJe1YmXu8zR5w==
X-Received: by 2002:a5d:53c3:: with SMTP id a3mr6746569wrw.60.1557932338771;
        Wed, 15 May 2019 07:58:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a128sm2533056wma.23.2019.05.15.07.58.57
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 07:58:58 -0700 (PDT)
Message-ID: <5cdc2932.1c69fb81.2ce9.e832@mx.google.com>
Date:   Wed, 15 May 2019 07:58:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-3.18.y
X-Kernelci-Kernel: v3.18.139-87-g06310902672a
Subject: stable-rc/linux-3.18.y boot: 59 boots: 5 failed,
 51 passed with 2 offline, 1 conflict (v3.18.139-87-g06310902672a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-3.18.y boot: 59 boots: 5 failed, 51 passed with 2 offline, =
1 conflict (v3.18.139-87-g06310902672a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-3.18.y/kernel/v3.18.139-87-g06310902672a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-3.18.=
y/kernel/v3.18.139-87-g06310902672a/

Tree: stable-rc
Branch: linux-3.18.y
Git Describe: v3.18.139-87-g06310902672a
Git Commit: 06310902672a635a9042eb91b9f696da27d731eb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 13 builds out of 189

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v3.18.139-76-gd3d7f4845=
dc0)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu: 4 failed labs

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
