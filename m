Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B158D82596
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 21:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHET2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 15:28:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37424 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHET2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 15:28:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so60441093wrr.4
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 12:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uI4sSNIaRY/U2q59QI6Ha3q048/V3O2oMk3iYhmcOCc=;
        b=RaFdzZela/aLzTBf2SiitHTwoE/SpqTIqtKyDg7jm3/S2GSqg6asu6sXN0An4oiB+H
         xY691CzFdLXTQJlkFSMzFyPmCTKDnuGdXhFF3q0+Nm35OMB5jgEjAqsIxjimZuSVcE88
         N/k02xJB7JpK/IHmYGTXiw2+tHYICHs/hNBFhncV8Tzy2RMnBqDDMjDjS90YMnXcCMWZ
         WOEp3rdk3wPuezRFUw/w4thD80WP65/U3oncc7vKhpujSvcDZfYgkk1ZcHz+C1ji4emP
         2At6YSbl5Dfh8Ywgy6tMVLTmhgUJkNmyjWVmx39ZLox8tcawOh4OAVchc2o4JCz0cVy1
         7Mog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uI4sSNIaRY/U2q59QI6Ha3q048/V3O2oMk3iYhmcOCc=;
        b=Qgu8S5hBEKvojCwq54PBG/ug9qxSBD7aZbpDga0jvC1TLehlpeCSHvQn0nkNGYJm4Q
         SAvASfgyc3CuugCnVfEhx2e6xblfipTmY/ZiAaHjRiHciworJGA1A0l6OIT71xVi6UZ9
         4E7czonqGx6YT3k4FYz3gFohUwfjn1xrjXUQm+xfkRXPGzyvPdXEoHCCbxx2Ib8rzYB1
         mfkVs0Wx0+7o9Et78+T8TK4x2R8NucuBJnNmePrZUctC6Ts6E1PAJvj+SBa8xi0CRKvg
         GVDRckuezGLk3h/oVXDSPyGPSpCdE+dTwClwnVqHCihlFb0MmsfP6j+PMZ5YS2Oagxg7
         01xw==
X-Gm-Message-State: APjAAAV5y5yfRh0NWu5dQ0O1Y5fucsr1a1oXkalSabg9YhDvf4wHGk9Q
        V3GmWWnXD/wLS4TGdwBsqOanaWa4+Hc=
X-Google-Smtp-Source: APXvYqyGe4T8tUpQDpFUTEs7nzR8SSKx5GSTEOoMC3+JQ9YNNQK2UKVAfHohiUeg7uiprW8XBWgCRQ==
X-Received: by 2002:adf:f04d:: with SMTP id t13mr48003153wro.133.1565033295223;
        Mon, 05 Aug 2019 12:28:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b5sm71250725wru.69.2019.08.05.12.28.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:28:14 -0700 (PDT)
Message-ID: <5d48834e.1c69fb81.8c01f.83ee@mx.google.com>
Date:   Mon, 05 Aug 2019 12:28:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.64-75-ge2fa6c5f11d5
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 123 boots: 0 failed,
 115 passed with 8 offline (v4.19.64-75-ge2fa6c5f11d5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 123 boots: 0 failed, 115 passed with 8 offline=
 (v4.19.64-75-ge2fa6c5f11d5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.64-75-ge2fa6c5f11d5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.64-75-ge2fa6c5f11d5/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.64-75-ge2fa6c5f11d5
Git Commit: e2fa6c5f11d562e4b6d9d0eaf3f9adea96e72032
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 27 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.6=
2-148-g63a8dab46af2 - first fail: v4.19.64)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.19.6=
2-148-g63a8dab46af2 - first fail: v4.19.64)

Offline Platforms:

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

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
