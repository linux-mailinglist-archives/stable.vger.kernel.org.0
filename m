Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F80D4FE07
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFWUhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:37:17 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:53006 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfFWUhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:37:17 -0400
Received: by mail-wm1-f42.google.com with SMTP id s3so10839561wms.2
        for <stable@vger.kernel.org>; Sun, 23 Jun 2019 13:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ub0AfvXz46DraPfal6//2UQwl1L9AoWMVlc9IN5qZ0s=;
        b=nE7zXnYr8x0Oq9mcYaPrskeRVAv9wra0KSAXWAR/4VzH+sryfSmq02V2YXIXYz9BkT
         GhWpaMyLnhmCuEY3OiDs56E8EI2pTSIl+ycfxNneKCmr08pyILdPNFeJEsmwF4mjxQ//
         8Be/pnJ7AsH1EX0sFILpUfc77bh/pMto3wR+7V6OwRHdYNLElazSbJDEzb2OZB2/iLeS
         ZINC/oGpKkWrygHexzVbyc7YyeS+3L2kYQXGyLSrLANugHfyPuNag9oj2mFAecElFrLF
         KLNZFAfSw26aE8mROOhGBuvbmn58/7P1pJcA2GvWArmEzNSv3Q5A/vcjUi2rnrkofX2y
         B+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ub0AfvXz46DraPfal6//2UQwl1L9AoWMVlc9IN5qZ0s=;
        b=BP/5UQcHNHAqylIrCOFr4GnajIsksoo5QM1BTszHFrT+vjN+7PB0dl1EIiHrc2XTuV
         +HogsMNxyWZ/LWOVMvWtxVyyY8yXpg/+8U6CkG8r2blBPAOgu9qZsfWX3q78tFZFa9G+
         Knh2bcJfURToQR6+iEHQI1uBjnuLqxiW/w/YIi7zkwvXKyUfUGYt+wbpAuJfS6TPznb4
         lJ/COELzydyoycHJex5wTP0kZuWkQmYqnmlAFZfw//gDalWfojkZW7Q7THh0eGeaw9ud
         gRy02Sb6y4dnokeyqHUwjPIz+8+hwSRNW54EkE8JJUT6aZ/yG/aB/AqAoTD91YRt0cB8
         Jvpg==
X-Gm-Message-State: APjAAAVDVz7DcV2qdxtk5ZICfxLigxaBGN3YOJOTkgJ9Of5Gbs1EwfUA
        6ksUz5sbIEQrXtVGGCAsx2y5wMXO61w=
X-Google-Smtp-Source: APXvYqyLfzXlGTpY576YlqCkS7t8Q9q/suLj3Ce9iX1hvUqDymKlKEbOrFoi7iNT4P7XFnEEHJD7ig==
X-Received: by 2002:a05:600c:23d2:: with SMTP id p18mr12176744wmb.108.1561322235204;
        Sun, 23 Jun 2019 13:37:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y17sm14932310wrg.18.2019.06.23.13.37.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 13:37:14 -0700 (PDT)
Message-ID: <5d0fe2fa.1c69fb81.b385c.292d@mx.google.com>
Date:   Sun, 23 Jun 2019 13:37:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.14-13-g5c276064ec4a
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 128 boots: 2 failed,
 118 passed with 7 offline, 1 untried/unknown (v5.1.14-13-g5c276064ec4a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 128 boots: 2 failed, 118 passed with 7 offline,=
 1 untried/unknown (v5.1.14-13-g5c276064ec4a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.14-13-g5c276064ec4a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.14-13-g5c276064ec4a/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.14-13-g5c276064ec4a
Git Commit: 5c276064ec4a2bc5299ae17c5752c835138dc32d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 24 SoC families, 15 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v5.1.14-13-gb8258e6be3b=
b)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
