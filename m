Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A3597145
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 06:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfHUEsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 00:48:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36168 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbfHUEsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 00:48:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so675477wrt.3
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 21:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sngVHWedH8NJDfI2UBJQKRTbvSVX6kFwJ617eYnGqAo=;
        b=UdJQyKN/O+EdH8qS5mjyvsLbWLVouqWY/1VzqEAUn5L0b7WlZASO0m1f6Uc0q5/hDm
         cHeTG4VGJv5871LC8G2a4dbY5G+oZC3dvbKpxacQ8pkxjyD6i5KAH6dGOLJWoFgxPWc+
         zgj6yjZjW4T0inniJsaSyfmRVErytHhb0qOyq+1YmZ8X1/7YId9MY8ZgdT4r6jA/G/MG
         P8PHHd5FjZK25C293XpuwPXGu/EIwoqXGJfp0pd0uyqUwfoV8SLjSO1LkFy7gd+UgqBc
         3LzPo9D3OOKGeop7h8Ts3lnlbRPj7ygoTl0VDOkgaSfvDHLg8Af20vbP3w9G05H/hoOR
         3UBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sngVHWedH8NJDfI2UBJQKRTbvSVX6kFwJ617eYnGqAo=;
        b=tQHyswlJgkGWqxioMdl37fhkgAJdX/ghTVXmIiReISJIahQSo1MuPgoJMFtuy4jUUQ
         j1j1BdU56iKoe9kZjRC5jGjJbNajZPL6PSchMCcV7lm/92n8hkC+uijFv1tgc7dFGvtV
         zUG8pTPNN6I/ZpcVd2IXF247STKZVpmVE96nBIQBxZuz8QdgvGY53MPw1JszulXB3HA3
         9LY81rtgRF4PgDHXGgqAEeT5t5BCWgf837c8+PAYz+/eod6ohtHwA6JcnpJyJIi9Grs3
         TCGGtKpS1B5Kytbp0Guyy0t8FJF0p+fnub3fbeod7QhupEdNr+qaZSuUnpV1+RQCs89C
         j0Rw==
X-Gm-Message-State: APjAAAWqP8mzlS3uLAGdcnOHiul+DRQz8azHgwSxzd4OUPnnTPYue9CZ
        tvfsPjU3IDkU7B9SKbqe7N7jmVkXkDKPHw==
X-Google-Smtp-Source: APXvYqzRPbClXE/IbROSjd0wVe+uP+mCLYkaRwIEHrLHOBUY9RLwVEQupypwO0Udbnl7aG0s9aCUIA==
X-Received: by 2002:adf:f6d2:: with SMTP id y18mr37639584wrp.102.1566362898649;
        Tue, 20 Aug 2019 21:48:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d16sm17396118wrv.55.2019.08.20.21.48.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 21:48:17 -0700 (PDT)
Message-ID: <5d5ccd11.1c69fb81.e5187.0869@mx.google.com>
Date:   Tue, 20 Aug 2019 21:48:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.139-62-g3f2d1f5446a4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 106 boots: 2 failed,
 93 passed with 9 offline, 2 untried/unknown (v4.14.139-62-g3f2d1f5446a4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 106 boots: 2 failed, 93 passed with 9 offline,=
 2 untried/unknown (v4.14.139-62-g3f2d1f5446a4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.139-62-g3f2d1f5446a4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.139-62-g3f2d1f5446a4/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.139-62-g3f2d1f5446a4
Git Commit: 3f2d1f5446a428154246a8cef702bd3c26914329
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 24 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
