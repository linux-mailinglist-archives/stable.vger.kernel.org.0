Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EFE1A531E
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 19:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgDKRYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 13:24:04 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35638 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgDKRYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 13:24:04 -0400
Received: by mail-pj1-f67.google.com with SMTP id mn19so1998982pjb.0
        for <stable@vger.kernel.org>; Sat, 11 Apr 2020 10:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qq21ZWRGrXiOfcmLilzpNPteFjZ37VA9OHfAz143c3E=;
        b=Lfua4ctNtu1IsJ2MM1D7wV0/k+m/JEObjP8bP+f+h3H0UZkxGvA1MoiBxuLtYrX0z3
         iyvjG+zIBGVcB09tXpA5he4fAeEgHZrbU9XiO0xJcuNiZs6o3y7OZK3NGgD8jkXVcYnK
         Wg8O5cgBCDCt5c4S+RQKYMkxn72Lb+HG49UaYy83LK+wgsV6ixkjThoCSe6UYNtyW3d7
         ZG4WK+AGRiWYQK9P1ZHyQGQuOZFBvWw+OleyyULf64IAqdYe4tWYT/DM008nXcBJSS+x
         26Nfmxy4dp7p0DXeBdG6t79l/N1j58EuWI6FpLv4YoeBwZIw5XDhlrBGRkP4cnl7d12c
         k/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qq21ZWRGrXiOfcmLilzpNPteFjZ37VA9OHfAz143c3E=;
        b=OERFGbRmGXWZpZ6ldmAO4JBrOVGYSRknuPBcn6ekdyKw5cTcCwHemryzNKmWBhc0Bc
         fQsFFE5mDTZFBB5lM8SlS3C+xQdqMd1hJl1bSOnm4qltfAtamcwr9shyzBKJQTy3E1LT
         WkY0Eniyo1Wvl3c5YjpOwnqtzMShsAzpQBZLatcSF/CONQwFDKyytpPEnfoU9X7xpHSO
         9kJMw6lsZTjxA+iqZZN/O0WHdR/jyiv6UDM+PGn0W3ydpCi5VOERXL0dMTOn+Pr4mYpF
         tALo+r9HEHtg7l8g2FdBJzDjZszUKJG7IcmeyTY/4iOlah2nvw/0/FFDfzWzJM7miEPo
         5hhA==
X-Gm-Message-State: AGi0Pube3HTEB+s9+vy0PSZlMioGsTS9VLN6KWTL9GfoXsEc27aAeYqu
        HQzo/myAPYF5n79Ax6PSOa8MH41Cs/U=
X-Google-Smtp-Source: APiQypKl4UeaVRkRY1Ch8Gs+4biDyAwu9Nq+Ys1Gha5k11KsAEv5T6rAOud/73DY85KnDmcdhuPkLg==
X-Received: by 2002:a17:902:342:: with SMTP id 60mr10390282pld.29.1586625841939;
        Sat, 11 Apr 2020 10:24:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c8sm4688640pfj.108.2020.04.11.10.24.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 10:24:01 -0700 (PDT)
Message-ID: <5e91fd31.1c69fb81.a2709.f9c3@mx.google.com>
Date:   Sat, 11 Apr 2020 10:24:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-33-ged218652c6a6
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 112 boots: 2 failed,
 102 passed with 2 offline, 6 untried/unknown (v4.9.218-33-ged218652c6a6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 2 failed, 102 passed with 2 offline,=
 6 untried/unknown (v4.9.218-33-ged218652c6a6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-33-ged218652c6a6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-33-ged218652c6a6/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-33-ged218652c6a6
Git Commit: ed218652c6a621a6c9bc9655eefed3c460f93d83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 63 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.218-19-g07412f086=
bd9)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

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
