Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D33DAFF79
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 17:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfIKPDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 11:03:46 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:35088 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfIKPDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 11:03:46 -0400
Received: by mail-wm1-f42.google.com with SMTP id n10so3976151wmj.0
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 08:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yUhnEerH+vrObUKloQ5q6ycRatRz0LpgTbhZLC+X49I=;
        b=EWGm79lpEJw6nOcKi3El/CNDf7voNhEV2rmKNky1LxDhFXq+OnBkLQuyCCugddd73D
         ICg/Cc7pEB66PPtv2c22WZRXd4tVlT0bf4YuVDfbWsRA/f61BuditiHBMBjRcFCgDaml
         Uve6GVHEkirWt3Gv06Edr4dWRIjBuFb4HZd2W/z/Xp9f2hMvX0S7p8ecL/PUYRV2d6s4
         IqZ+JvOXeamUYxLtYGBpmht3Hxo/1S4vVPMTXIDipveuGoq14hZclurj6UJ8wLeNvWno
         PW9USBYjgrVPqmIFuJCJLsidOI25rqms/T/U0mS5jls2gdC+bC/C6r5dmVUxwnC7btxo
         MEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yUhnEerH+vrObUKloQ5q6ycRatRz0LpgTbhZLC+X49I=;
        b=VANSQtkAy9Ks2w2npUKKWJRxA0D59RujILoktJ+UTzYnH9GEpOLAjqteaoxScdc3eh
         m8c9YtZwhftlcQrxC+UXtsfEryszQwINTlLle+fV5hxfVaHkKtsgde3U190tpEszmdpZ
         c8nMzWRWYdm1YakKIAuwDdFA2wsZC3otPub6kRqoBc+E2I94LU9xwUeXOPHNmbWCutTy
         vQWx1gSc4QltLFZ3cxpzVX3RNvgDs6e7E7xQdjK2tKKNQlUxmC+HZ4lXsIa9UnaX5DrQ
         udPjgvHBzmQ9YWn3Iha+P3mycg3OXtTmQTOCTKqCzDRZ1Swj/SuYBCXnM4q/n7FVOWzj
         d73g==
X-Gm-Message-State: APjAAAV2gYFU3OSod4Z3MdGZ4kf4m8pB4kO1lEkilNx/2UjSLAcB1F1g
        Kqi9ftFY1IulBx6ijlkNCQ+yhqXql+0k7g==
X-Google-Smtp-Source: APXvYqz2+c2tgbaBLYjG6sQL3SssynCGZpuaikA9TV5qOAHO4r04obAknBUwU/S+iTpVDtnOZ7ko6A==
X-Received: by 2002:a1c:f403:: with SMTP id z3mr4011102wma.74.1568214223120;
        Wed, 11 Sep 2019 08:03:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i9sm28565915wrb.18.2019.09.11.08.03.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:03:42 -0700 (PDT)
Message-ID: <5d790cce.1c69fb81.799b5.93ad@mx.google.com>
Date:   Wed, 11 Sep 2019 08:03:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.72-193-g7ce5ae7d905a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 129 boots: 0 failed,
 121 passed with 8 offline (v4.19.72-193-g7ce5ae7d905a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 129 boots: 0 failed, 121 passed with 8 offline=
 (v4.19.72-193-g7ce5ae7d905a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.72-193-g7ce5ae7d905a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.72-193-g7ce5ae7d905a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.72-193-g7ce5ae7d905a
Git Commit: 7ce5ae7d905a43fcd6d7f3207a7a11d3b4271f28
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 15 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
