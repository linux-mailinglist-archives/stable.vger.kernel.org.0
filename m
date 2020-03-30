Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976E1198762
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 00:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgC3W3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 18:29:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36159 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbgC3W3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 18:29:32 -0400
Received: by mail-pl1-f195.google.com with SMTP id g2so7331738plo.3
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 15:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XUI/++wNiFEuXRVAxOE6NGRAKFQQjYvGoem9pwjchRg=;
        b=GpvZZlqlJ6wCHevw0fu6n/VBeKIgxLi+Cc1+AoJ8zLwnZmMrpgOykyqrQMqPOOqVn1
         Z+bV6N+RF+0uSMKJauMxNfJAgNSyFxHKWXia0BS30a0HPIW48n8EXO6eIWNJq2ZbD9GK
         dzwCSzKiUnrK44nA5LhxPKIdxq7ZfUmrMW4lJJXml+v3KdfL0MdqKzHzib7Kd5SU6wj9
         7i2rGmAKuu/bJxVkuxkNrFc7Ok42E5TZ7yJOOEtPhaVHpkm+pC7RUpTyC5G0mY3ylDkB
         cV5kUbMdz3yqVCYy2s6npDGe1KcAKdcDVMMQezxzV6WPG5vUqk/rWZfTnldo8Cslq9Ll
         5TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XUI/++wNiFEuXRVAxOE6NGRAKFQQjYvGoem9pwjchRg=;
        b=tuVvA/lNtGvMrdexCLVMOu4DWMlSUwXXo1Fo6ESOk7NE+ig5PGWTQk2QLFix75hNKM
         1Kb0QBp5/IgP92xb+mELrjuGsSvotTcvLHr1Wu8gxnACFQe5RNxbZioey/xJKdPZ3uaD
         oFBDSGRfhoAsnzJiHQzHgcq7S9ppmtcLG3w8xghyvo/Yng6QuZQQNBZVYdYBRole2xvy
         jelYi9CZiXsd3TV5Egt8H2rffd5q2gTF8stXMiDH4CVTqRdyV6wGG8R4uVaPJPlXZhEx
         gnOMO5OVtlhGu42HWsAImZGCG113HLSv/R37WlCZ1InestxvKGxY01ZoIoCwh1jKdB7p
         Aapw==
X-Gm-Message-State: AGi0PuaKHPqQy5dVK/NkqtjhgfkA2wD+937p5SoaG/Mfue1YyVXi42ZZ
        ZU31AN/ee9j57k763nuSUD47exh2XRk=
X-Google-Smtp-Source: APiQypIrznWmZnnlbyUNb2MR4aD4QJyZdls2hgtUyZkwSG1pzKr7OF5Gd1NWruhKlPdKHkuj5RYgjQ==
X-Received: by 2002:a17:90a:1b4f:: with SMTP id q73mr308500pjq.188.1585607371309;
        Mon, 30 Mar 2020 15:29:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kb18sm496967pjb.14.2020.03.30.15.29.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 15:29:30 -0700 (PDT)
Message-ID: <5e8272ca.1c69fb81.506f9.294f@mx.google.com>
Date:   Mon, 30 Mar 2020 15:29:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.217-71-g6d7e889c2478
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 114 boots: 1 failed,
 106 passed with 2 offline, 5 untried/unknown (v4.9.217-71-g6d7e889c2478)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 114 boots: 1 failed, 106 passed with 2 offline,=
 5 untried/unknown (v4.9.217-71-g6d7e889c2478)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.217-71-g6d7e889c2478/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.217-71-g6d7e889c2478/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.217-71-g6d7e889c2478
Git Commit: 6d7e889c2478cf33e82cfaeedbd9b81867f05dc6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 51 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.217)

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

---
For more info write to <info@kernelci.org>
