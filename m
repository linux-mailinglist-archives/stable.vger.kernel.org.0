Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE6B117E86
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 04:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLJDri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 22:47:38 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35036 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfLJDri (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 22:47:38 -0500
Received: by mail-wm1-f66.google.com with SMTP id c20so1542088wmb.0
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 19:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WfzSSNZmKBjVjfiCEqWDQpimnpwthq5xMVw5QJL+rD0=;
        b=C6mTj93cfcJ1UL4Ety34ZrzBQ/WHX1gfUGm2suClPgRGGiDrLBvOThy0uas+OBNZ/p
         tF43rd89RI6KX3i3SWVyxtZqNSc3i1tvmyg+q2h5Rx94BsMTs8uXoJM3409guc6AH6lR
         2RiQ/0BE3y/o4LrOEuSrtFGcKKe/pAjUdLPx8mVEoK8eXUVHbju6RYSFNru9AM8YBTTN
         dDoRva2OB2/xqO5SILVJZiKp7FFa8wAImYnpGgcOUJcSa1HKz0HtTWczLXQtM7DwpVPw
         JHmxyoM0ALso8LysLmYLcPHS6rbxy8gkEuSiUrWiTj+YNvgwyASrysB3+4PXc5D91LRc
         Ue1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WfzSSNZmKBjVjfiCEqWDQpimnpwthq5xMVw5QJL+rD0=;
        b=lM0QO9Xx6zE4WyG+JbJ55m5zjfOFC+5NFq49ihgRP/0dXHLJ4w5FDgVKLfCVJoh7ni
         GsRV8TbJJgxzDUCIn5cHUbfJT4LsN/500zzcthgduYzqSrHDUjp751LX8RgpKRZ7wnWP
         dcrzZpTc9PDdAvLxEwCvrGSIoqnOPAk84u2J+s4pDQbxu+eSao5SN2mDhTB+GhpMpU4N
         1xGdpfex1mujEOK2GwjDf96tFy79cHkEAuGWlCYkE616h53FgLJblgDxSoHFx1NVKeAs
         XhJS8SlvngtOnasbDZ36nFa/jynSgSznrYbNIRydUpIi3z1ZZ7IFARXVPceBJq+TM3Q6
         t/5Q==
X-Gm-Message-State: APjAAAXJerUS4ylQvOIFlqlv98FDJ7N6y907P8gVIPLnDESPQeIdvHHv
        luJ6xI+n02IsN4hudUalGJ1oZEZ7s0DJKQ==
X-Google-Smtp-Source: APXvYqy+PkBHsEJ/jCmm+ebyDzFtelZkJOUlnQWPVE8WYZ7gz8TawEhrvdfm2SNo3+4grXj+i2hDqA==
X-Received: by 2002:a1c:204c:: with SMTP id g73mr2530823wmg.33.1575949656225;
        Mon, 09 Dec 2019 19:47:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d8sm1656814wrx.71.2019.12.09.19.47.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 19:47:35 -0800 (PST)
Message-ID: <5def1557.1c69fb81.3b7c3.83c8@mx.google.com>
Date:   Mon, 09 Dec 2019 19:47:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.15-98-g0464d9defd01
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 148 boots: 0 failed,
 139 passed with 6 offline, 1 untried/unknown,
 2 conflicts (v5.3.15-98-g0464d9defd01)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 148 boots: 0 failed, 139 passed with 6 offline,=
 1 untried/unknown, 2 conflicts (v5.3.15-98-g0464d9defd01)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.15-98-g0464d9defd01/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.15-98-g0464d9defd01/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.15-98-g0464d9defd01
Git Commit: 0464d9defd012aa5bd0e126aaba3694d2e30cd7a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 88 unique boards, 25 SoC families, 19 builds out of 208

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
