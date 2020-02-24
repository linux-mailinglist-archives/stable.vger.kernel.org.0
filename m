Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C597F16B509
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 00:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgBXXVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 18:21:25 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53751 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbgBXXVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 18:21:25 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so415322pjc.3
        for <stable@vger.kernel.org>; Mon, 24 Feb 2020 15:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p6VPj6r6G1FJaS4LY4Hu5NXrV3izB9JHH7eCfhkVExM=;
        b=ulFBAnT2jb/lec3I73C55Z2ygYykchYtmNw1ltG0+GtUcXAz0f7cmVfK175Kkwu32u
         2XEt83qTxiknxmLZge4+CAYL7VMmOg4pb6joM+VbdkxesTieaShZpHSJ2gaTF0v6pfGJ
         dBSv5amUY/bUawZvi9FaR4esQXeraOefYYHQ6SawNCxcjmBYSAZ51wm6zPqc4OSjK4X6
         Xsp/lbYOv3CK42tY31iWs+h4+aG1uYA0zoqgIc82nIkj6I4X9rwZYGFarBU8FZRtUBua
         jChz0iP+yUz0VD3Q/aSDQOaXXFGrxXdU8UJnaigPlF9F2+LGa4uJKj6IPcm1OZfV8mT/
         MD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p6VPj6r6G1FJaS4LY4Hu5NXrV3izB9JHH7eCfhkVExM=;
        b=odd9D+gAsoenX9P8dVsybt37hGEgrkaec5B3Ba9M12N3+s/lVU9FdOf1XaE31DYF0k
         gLKROvciOBZKrucx3XpvXMmhoN1X1KF+XF7IHaQnx1z/TwX+haPLNRQch1UazXkzj5ID
         wMLXpIWnVKUub6gn/MH0tILs6WK/cK+zdUn2mAEiJSqH7NwxarwGM2Wr+zYYWuFJP9Ke
         mW0+CpdUqdLLv6Nxg8cIXB3UD0LOEFxPHwSzF+jfOTh2riKUbZcRwPrGvsPKFyELrcU2
         vJ5O0ZZZk8kYLPeNvaO+TX1V/J+xnX+3AxMt5alupGdKrRpAaBuqKMajMTr78PuZ8WGB
         zXRQ==
X-Gm-Message-State: APjAAAUASIacvuFUz1W00gwIoaiVQsbQ62XeG2byIPZaPOqQuEKu+cex
        /9oBRLGSIl/G948irh4ndFe5wyLZgAc=
X-Google-Smtp-Source: APXvYqwqGITOdnUUgorF6JG6FV6HjTm1qzXBiGz6z1mpMfZwVkScvbBGC+uucfKhbRkwzjQi30kaxQ==
X-Received: by 2002:a17:90a:f316:: with SMTP id ca22mr1672384pjb.59.1582586484457;
        Mon, 24 Feb 2020 15:21:24 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm11259943pgs.89.2020.02.24.15.21.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 15:21:23 -0800 (PST)
Message-ID: <5e545a73.1c69fb81.280a1.d0ab@mx.google.com>
Date:   Mon, 24 Feb 2020 15:21:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.214
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 59 boots: 1 failed,
 56 passed with 2 offline (v4.4.214)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 59 boots: 1 failed, 56 passed with 2 offline (v=
4.4.214)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.214/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.214/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.214
Git Commit: 76e5c6fd6d163f1aa63969cc982e79be1fee87a7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 12 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 9 days (last pass: v4.4.2=
12-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
