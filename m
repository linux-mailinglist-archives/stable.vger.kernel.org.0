Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F9560FC8
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 12:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfGFKKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 06:10:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37554 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfGFKKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jul 2019 06:10:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so11889666wme.2
        for <stable@vger.kernel.org>; Sat, 06 Jul 2019 03:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LTYHuAcEiTADjXh81m7VrSjapv6hfDEK7BlZxV/EhG8=;
        b=xt48nEUT4T9vWf4pdYKhO6nTu5aeGsYwnfgAir5FEMtCYJSK1Az8ND848Ptaa7hRIm
         BO4QUQbzjuylhrWjIClQiYScfj3nNiVRxqwZRO5jtlsgzqjnkQn/rd5snncwZh2YnaS9
         kYbjB03JJkGzcyHsKWHfiIOhrNIp1clhjUtlQfcl3v/ou8NfGrqyCrQ0o3u7TITsKjTR
         0WFAE31PW3SrCMuOH9HgLLVLGdKU1ToPyzmgh5zuZnnlVARAUCfuAsoHj2qpmqZ+HvFo
         5e5nsJZI8JB1R9e++gMdWGvo8b0ASbGCkkqqGCxk56ogPUP6y33PCSF3IzbJa5I6Bbyq
         rVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LTYHuAcEiTADjXh81m7VrSjapv6hfDEK7BlZxV/EhG8=;
        b=iFALJtO2fLljwRmWW4gx5vHY/ZFk0HMTkivu7tfGeYZAv3yqtURRwWev8a0/83UKqB
         jep3YYJMs5WFCzXkoIYfojKuGU6Kp8H8IeH1rExSxp/yZzM60BfgF6BIcBr0ZwQ4VyOM
         IyDQzoJ0XjUcA/IpFXQ6973NXKyndijiN7S9q9IyTyT8TF/+emJqO/4CZSMM80yXflt9
         hcdHOX10nUsdbv4yyWbytO3tKh+ZLy9he4ABO79ebOTHFwSaXF6CuPAZRMj7X3MGzKj0
         AzHNaqJ99zclyH2hRcjFNOEfH/2D0xJ6RYHQdWJiLw2KnRTugoIS3fv4+VhLFtoDi3tR
         sOMg==
X-Gm-Message-State: APjAAAUQO7GmYfxImDXo690Px8zt6FHoNhL2h2zzO6pOGfIG0OtHbq8Z
        3J2HI3rmU7Cgx1qlmg1MLMVqxiXo3o/YLg==
X-Google-Smtp-Source: APXvYqwX6OcfFa1Pgz48QQFzUcrXtHhn5r9PAlOtASlySoXcxG2KQ2bNK0+IfE2ETlCOS6UzvwICFw==
X-Received: by 2002:a1c:988a:: with SMTP id a132mr7394681wme.165.1562407799077;
        Sat, 06 Jul 2019 03:09:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h1sm10329121wrt.20.2019.07.06.03.09.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 03:09:58 -0700 (PDT)
Message-ID: <5d207376.1c69fb81.50c36.a1cb@mx.google.com>
Date:   Sat, 06 Jul 2019 03:09:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-73-g71b130d46805
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 100 boots: 4 failed,
 95 passed with 1 conflict (v4.4.184-73-g71b130d46805)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 4 failed, 95 passed with 1 conflict =
(v4.4.184-73-g71b130d46805)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-73-g71b130d46805/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-73-g71b130d46805/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-73-g71b130d46805
Git Commit: 71b130d468055291345db697052e5256d6e46397
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
