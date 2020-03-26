Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55AF193AB4
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 09:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgCZIVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 04:21:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41705 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgCZIVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 04:21:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id b1so2499803pgm.8
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 01:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5Ig5jQR/R19HeABvvN9qMBi3geLYni78LT/qUcTDGE8=;
        b=SVTaJqX1SIvALzBuuwS0odox7rEpleeDv01UUiycEluu+syqFpXTyorjrpg+MKbeY+
         nzbAb2VgpA1n2A2aqICWs8G6Jgxuh/re+2nwJvnHWQLP4SxZirQZzoqNGVMOjX/tiVsJ
         GVLwDO0ega5wqNI5hHjiGJHNAH7cQV0v3fuPyl1piRS0cZdOwD0fCl0QSLl/hHNqyEDJ
         TLfr/v2qBs4wzSImc6qxKK6IgfrPS8AlvZ/26oidNRNDHyxBAxzxGHJGuh8gN1+LDUXw
         PHR1N5aoPvVVBtVbzGBIxlwIW1usvQGsZ2HttJNSbsf8ktrMwgtr/LSH9aL6q9w2bgC4
         je4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5Ig5jQR/R19HeABvvN9qMBi3geLYni78LT/qUcTDGE8=;
        b=q4VI0Y7d+7KxGVSrraHgicb2BxZZWQN7AzswPucH0XUkbQF221XoWmWKO+NvaglaCd
         /yrlGqUCG815LaNHbUXvmZp3Q+IPJrBaSZMxasMX58s/aVOKWHZZd8p0uxzDSh6e4HDH
         X1oZNDHqcGfoNWhBAbLngl66Y2a402tyiRb9A7wcSZ2UCxRQCEhQd5SKxUcqTzBAxm+3
         UIzzLOlOJXs9mSGbDanlwthM8j74otgT55ILYegy4eW+i7VXOg/bYTCf8YmzIoDiAqDm
         yttC/z6q5gahycUTj82epUr6dRjSTDKU7WXebwAtp2eMXu9BNVkXw2ywecN8UdCM7geY
         N7zA==
X-Gm-Message-State: ANhLgQ2xK7EnTnF7C03np6iyHeaOjOm/Nws1DSTWYxtx0Yd3+e5dJEih
        HEPsYJ4zgspA8PuwE9FmRQYMcysGejs=
X-Google-Smtp-Source: ADFU+vucn2s5DWbRjIgnWoQa6m4742kCI4iiXnLMGG2hgw/3j/Ev9qTrEoVY3VekPRqbrS/4ba3oDg==
X-Received: by 2002:aa7:8685:: with SMTP id d5mr7943180pfo.3.1585210871109;
        Thu, 26 Mar 2020 01:21:11 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm1051763pfq.159.2020.03.26.01.21.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 01:21:10 -0700 (PDT)
Message-ID: <5e7c65f6.1c69fb81.4ac11.46cf@mx.google.com>
Date:   Thu, 26 Mar 2020 01:21:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.113
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 113 boots: 1 failed,
 106 passed with 3 offline, 3 untried/unknown (v4.19.113)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 113 boots: 1 failed, 106 passed with 3 offline=
, 3 untried/unknown (v4.19.113)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.113/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.113/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.113
Git Commit: 54b4fa6d39551639cb10664f6ac78b01993a1d7e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 46 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 13 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.109-202-g=
69e7137de31c)
          meson-gxl-s905d-p230:
              lab-baylibre: failing since 1 day (last pass: v4.19.109-192-g=
bae09bf235a5 - first fail: v4.19.109-202-g69e7137de31c)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
