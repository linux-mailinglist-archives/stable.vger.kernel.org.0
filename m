Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D54918C19E
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 21:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgCSUqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 16:46:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38513 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSUqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 16:46:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id z5so2066132pfn.5
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 13:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/xA/CRcoBEO9WMB7ZyVq8QTcHwYo6iOI/lTzSbHUa6k=;
        b=cKYdR6o8YSZp3AGyH4PgmbM0OFMY3ED8DKzNbEyz1L4dhlLbgNBjimPh+D34eCtGiP
         fibBNLX7vEO2MAlWI4J+54V0A7MpXMeMN5Q0H+DAK4fEE3dzJCoDM3W7gRD3izpHaUbs
         wkU89haGNRSm42r3r6AK4MQSPBMYS0ueYbC5FKO5sG/AClL366yuZANMWNL2JVGNRs/d
         sAX81KvyT8ZLQgmtp9hnsrws2JZJ5d9SoUW14f/aTtVRgh7cHnKkCUYUbRAzxPMJ26/4
         An11ZuCZl/qQbxTsshcxqu2NF+GSw0QS65eJFAfP1NR4lvMInOHrtIHSANCcUW2yo39u
         jcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/xA/CRcoBEO9WMB7ZyVq8QTcHwYo6iOI/lTzSbHUa6k=;
        b=un1RblLuwOUQsO/mSDBlN9lkZCytGPw4f5DvW6vR7smTL/thIkISHuB/Os9zLuyoDR
         4Y1CiT+UM98hXfS0GF+ucsfsFNBhpWmDIyGUie2SsitQS+O0tI8+lAuge0b4fDynye6g
         gO89AmNHLQd1YE5NzxMkt9oCHAY5z5Gc4DpoaVkqmMJKpedfzJD73nUHVCMU7Etnqql7
         OSZvisJdrXFG+PCbQC48tCywZX4HuoBGLJRqjUN+mbvXvekMJjBz/oxz99ojZreNW89H
         25HQqdU6+uA4gkp4tZDrhhqssNwbL1mG9489Anp/BQRdQ0JS3oVrq0cFAAsJevpCECQ+
         53UA==
X-Gm-Message-State: ANhLgQ1pQ4NH0GQQFqyAsdEJQf+RgS/DT5UT4rH7hsDYMU6E/ZPi6MRt
        F/ClYXuVvZNAFsI3LwTC6c7q4RUCYiA=
X-Google-Smtp-Source: ADFU+vuIALNjsShsKYBchhOihzZFNCuC/jSjnWm5pCEPK0xuKDkafB/RnHcqgKM+6Q15xE7R8pisIg==
X-Received: by 2002:a63:9d04:: with SMTP id i4mr5206864pgd.294.1584650769560;
        Thu, 19 Mar 2020 13:46:09 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 26sm3107448pgs.85.2020.03.19.13.46.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 13:46:08 -0700 (PDT)
Message-ID: <5e73da10.1c69fb81.6383d.bd1a@mx.google.com>
Date:   Thu, 19 Mar 2020 13:46:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-141-g8977fd00fd70
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 145 boots: 2 failed,
 135 passed with 2 offline, 6 untried/unknown (v4.19.109-141-g8977fd00fd70)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 145 boots: 2 failed, 135 passed with 2 offline=
, 6 untried/unknown (v4.19.109-141-g8977fd00fd70)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-141-g8977fd00fd70/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-141-g8977fd00fd70/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-141-g8977fd00fd70
Git Commit: 8977fd00fd705a4e9273d09171ee66344cdc879e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 24 SoC families, 20 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 40 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 6 days (last pass: v4.19.108-87-g=
624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.19.109-92-gad35ac79c=
aef)
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v4.19.109-92-gad35ac79c=
aef)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
