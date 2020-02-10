Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E62081570CF
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 09:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgBJI3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 03:29:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46523 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbgBJI3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 03:29:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so6342554wrl.13
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 00:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3vgiPJpHRpLBH9e+CgaUAqqiNCX9uT5QktPiwZihddI=;
        b=JV2YPeRKZghg7CxB2tk5hRr94jw30iscVH3NIesN7acpLA9bXtvX9tlT+79qByRjvV
         /KH4/rIUTsadRUHM7kZXxEH1WylOy/qLXL3mcYpsjvycI+9M9ZbehxEh9w4p1NfSqjAM
         Mb6DmSO0HptPXMup5hGxLFiTY8FyJBeL/sciD8iHMiYyJMeS9cvSiqMdul5mrJHlXl2c
         iIoCn6Zm9TiVXlZnKWK8C13I991i/zpDRciBBcPxEAozwmWWb43Gh8K8EhKX9dk+Jxt4
         rEIKOKPgXMWC5jJZkc96jazKOcxNHoSBrNWo6SjjuzHN3KQqKMkTimSNf5asV2K74VYr
         IjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3vgiPJpHRpLBH9e+CgaUAqqiNCX9uT5QktPiwZihddI=;
        b=apskQI+OapaNHQU9f1SyzT8rsULycKOlIXORQTyJgjEFHx5ORIc+HgF8Qcr0IPJJkQ
         61Gjo8JbqxohYBssIDa2AxatZYZzGCbp6sbhGCnLG8ebeNhAmbk4EGiADmizsZLgkB7g
         VYay5eQbui79+wmIPjvOXgsCWlQwnPVRoBNGSHKakeIyEBM4lW/MOVyJthrNQWCXeM9V
         4/RUaIBbkkgV6HaTzbaVAKY7oHYYXYH/51mZYEKLXGKLfz6xHkWhzRzSH6eVqlGWYyM7
         9hGkWQdLgCCZT+aiz9qK5SWNleht2GnryNxLoqiwPdogMcdXzqT0dPuZ4JifJ81GBwAW
         /EGQ==
X-Gm-Message-State: APjAAAV3pdNJ9qF3ProSH7OynWzI4OyHZ43vqzg62d2vY/84NoHCXibw
        qo2wxIWoDyViYzkRpRazS4cVDuq+WYk=
X-Google-Smtp-Source: APXvYqz0fgHm00aggwdkCecEOsmZpg58FD8/fk6WGnReisVM6jiSJWEIbwF007yNFXsYjOaUE8mRbg==
X-Received: by 2002:a5d:61cb:: with SMTP id q11mr549904wrv.71.1581323369848;
        Mon, 10 Feb 2020 00:29:29 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l2sm8851394wme.1.2020.02.10.00.29.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 00:29:29 -0800 (PST)
Message-ID: <5e411469.1c69fb81.cefb3.5154@mx.google.com>
Date:   Mon, 10 Feb 2020 00:29:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.18-309-ga4a7eef3f918
Subject: stable-rc/linux-5.4.y boot: 56 boots: 3 failed,
 53 passed (v5.4.18-309-ga4a7eef3f918)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 56 boots: 3 failed, 53 passed (v5.4.18-309-ga4a=
7eef3f918)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.18-309-ga4a7eef3f918/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.18-309-ga4a7eef3f918/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.18-309-ga4a7eef3f918
Git Commit: a4a7eef3f918cd8641bd23519a7b3dc6011f2e65
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 13 SoC families, 9 builds out of 156

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: failing since 1 day (last pass: v5.4.17-102-ga5=
9b851019bc - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.18-307-gdb4707481a=
60)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

---
For more info write to <info@kernelci.org>
