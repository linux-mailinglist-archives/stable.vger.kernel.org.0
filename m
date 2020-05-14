Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEBF1D349C
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 17:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgENPKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 11:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgENPKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 11:10:12 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DC1C061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 08:10:12 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t9so12687323pjw.0
        for <stable@vger.kernel.org>; Thu, 14 May 2020 08:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e+/WPxUbW9BRi66RGIgGjQni8+u/6ATO/Ii3B4A3A4Q=;
        b=o7tpAHRmJvilRhu8GxH0m6JLSButuqEd1nD0C48avFNmkD4YRkC0XNe5ib7/OW3rYZ
         KzhiisaL/4PdsyCjgiOFzDcv0cnPaJyTp21xepz7EBH6Vk4dU9eQioCUSTWMQtIK/UU3
         jNL0KAah+xAFJhkqvDADgmbxkXLk4jwLCZcRyxQ37gi84FcMQiM8rfi9nTO1N9bPnpfp
         /axSxPhNBeXo13fHsvus158djjRRt5G0Uncp0RQwVpB+6NbHKvU4r5Sfk6iGTN1VINQ4
         UsF5lGuMb2oDe+Voyx+669V1Z16QIuquaKOYU0ct90QU+2QKkDUG/Jnrzn4Tvi17JWqe
         32bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e+/WPxUbW9BRi66RGIgGjQni8+u/6ATO/Ii3B4A3A4Q=;
        b=VomFaVNgqtpqMitDcokRWNGL6HOrTrOhTv33yceQeFuGqWLafTKv4zi9F5cYxhITip
         9VuF84rfw5mz9up2aH/3OJHNRPX1/y3V52v/+dtA4X972VBmTddOjO5MvVXnAK1ZQYTp
         vP6EnUcjl5297LwGrQ5m5txS2C1/uiJbCh3CtpqpqqEmjurNKhHEtYcosXg/nBzz4Rde
         dn88dnU5+fqP5WPB8IXI2OqfONuSioDdzGN0tR86lDc9tWQhC2yoqliiL2osK5ji7b96
         gw7AwH1uw9c+m5WRY5VmWJ+dwieu/MrgGVxMvc0aXwBws6/MYeihVHFvtahC79Wk/Dr8
         GX9A==
X-Gm-Message-State: AOAM533e0ejY0ck9Th1Jc18g0fgmQMIt+a2G23BaXLELsVZdrRrGlodd
        GGzRSPwCptoJ/JhNCW26th3uZzH09KI=
X-Google-Smtp-Source: ABdhPJwR3qlON0FbMTC38u9QCARrWsr+ry+g/zLR1jXLIJmGhRh72Tn5935s8FcpfNaEYkomeJmeTg==
X-Received: by 2002:a17:90a:cb0b:: with SMTP id z11mr3296645pjt.58.1589469012084;
        Thu, 14 May 2020 08:10:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b75sm18629362pjc.23.2020.05.14.08.10.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 08:10:11 -0700 (PDT)
Message-ID: <5ebd5f53.1c69fb81.47af1.1593@mx.google.com>
Date:   Thu, 14 May 2020 08:10:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.6.13
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.6.y boot: 124 boots: 4 failed,
 114 passed with 6 untried/unknown (v5.6.13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y boot: 124 boots: 4 failed, 114 passed with 6 untried/unk=
nown (v5.6.13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.13/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.13/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.13
Git Commit: 5821a5593fa9f28eb6fcc95c35d00454d9bb8624
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 77 unique boards, 20 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.12)

arm64:

    defconfig:
        gcc-8:
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.6.12)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12b-a311d-khadas-vim3: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun8i-r40-bananapi-m2-ultra: 1 failed lab

---
For more info write to <info@kernelci.org>
