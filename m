Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49DF96C6C
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 00:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbfHTWeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 18:34:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37052 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730886AbfHTWeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 18:34:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id d16so181172wme.2
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 15:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iRoWNbtMioLCoY8oJ5EFyOArFcuRidwLPzS9IGy1AAQ=;
        b=LO0Md54AV2yENErU8uxMB+ELKbp//GV+VBKYk7wlLLo3vuLpPUzzUetIzSuZPNhSIg
         SQCrJoy2tHZEf0A9TI/j8HmPg5r7lznByDKa8ES5OrqwJyxAWxVHE8MIXZPkKn/p2WqC
         583ulRbWT9FGOCn10uFqxYnJ59/XrlaOQwTJY9W3Q2Ue6HESu3OJj8FnrAjp2Nb2+sjQ
         i91VqS6SlhbEVJYswLyAiSTlK5YJ4JK4RvuPijeWFFYa3HjHAhFTBPu2F/DUn1r2B+vI
         zwYwBs0RvLRDVUYQMDSK+veYg2EmoQRls+2Og15BvrpXncubrh7nzURTeuFptdG0gQoS
         ghRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iRoWNbtMioLCoY8oJ5EFyOArFcuRidwLPzS9IGy1AAQ=;
        b=Wk3sVJXXCxN6JVO2Lqgmth3P7efJtlOGZ6AYJhfaS8nsLKHC0DtSxnGyr9eZgxzsrk
         tdr/bkSxtL6qgqWY+fjwjMM5OXM1SDtzm9oYHEv3fBLjO5OVrZTpKSmWZAF10eYWbH4i
         D2rAaAw9L1Rr51nz8HfBHrpOMRkdrDStun2cm2idvmWUrjyNm3FVgsjH2MaIfF2/HiiG
         TPbvjdL8oq0X8N2e1/AqdWX0Z5KEqHzttWbju+3fd+sWNdvBBA3mM8qo1A+Gcm+AIVvh
         vdrXMg5V43kod6JzwDP5ikP6pJsKF4t+2lrbwl1II2av2HEKAjqcCn2VMC4SeDU09wZt
         viNw==
X-Gm-Message-State: APjAAAXEDf5C/Rb27tIHoW7hrLJ9nQodTWgp+Aqpof0FtcnU8+pizV7Z
        8a9EHQP4RvFnrVgA225IiW/cP4yw9oIyRQ==
X-Google-Smtp-Source: APXvYqwcxHB8zRzhCTAfcy8GEAaD64o70H3S0Wl+11rxzuu1xSsSzjRC45jmpjZnq9+r0S6ZS2SusA==
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr2290160wmh.116.1566340448592;
        Tue, 20 Aug 2019 15:34:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a6sm1063504wmj.15.2019.08.20.15.34.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 15:34:08 -0700 (PDT)
Message-ID: <5d5c7560.1c69fb81.db8e6.4d25@mx.google.com>
Date:   Tue, 20 Aug 2019 15:34:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-130-g204796489688
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 129 boots: 3 failed,
 117 passed with 9 offline (v4.14.138-130-g204796489688)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 3 failed, 117 passed with 9 offline=
 (v4.14.138-130-g204796489688)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-130-g204796489688/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-130-g204796489688/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-130-g204796489688
Git Commit: 204796489688a4ea05faeb84e08548aaf0321544
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.14.=
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

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

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

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
