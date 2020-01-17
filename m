Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E12140242
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 04:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAQDWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 22:22:55 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51406 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgAQDWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 22:22:55 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so5983971wmd.1
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 19:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LNBvJKpursuZIsa4tr0qGzUaYHSe3kAHhxDsDY0PLmo=;
        b=hS9aKNt1peWtY3b3oFS66zJiSjn6ui72tr+O9KFbBNsOHIs1LVSU9DYunOpHF+VGlp
         wUAvnA5iA+c/MQ7ssJUaAw6pNohvuIAyI26EK/7QoobVnGJ+5cTDGbyUuz+toINZXfyw
         xFtto0m7ap5wx0rr1oPlqcom3ogh1B262q6awMjFHptqDM6Z/JDuy9wbEQUqe/NsrFH8
         8OlaIjADBKfeDtoLJHwn3ndCZjfRUJYZjOG0gU7yaxnu8Pgw/R06q4fhlzy+6Ur2zuYQ
         mrHcaFR1t6izlHF5OQZ4kTCelvGdvTYFAKWytdHQ9Ic2yuGs2xxpb8tmmxUBRoy4Imkl
         uNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LNBvJKpursuZIsa4tr0qGzUaYHSe3kAHhxDsDY0PLmo=;
        b=NsEMQCFCqYolaqQT5qg2lyo14Y+S3uTaZCgMy52F8mbsVYPCL4joT4TUAyfyVFBTO1
         qC61SjiKIT+7CA4zFwrlItZnrVEuIOZ4FFaY6DWT2rttLaPsgvJXcsSq3l4MTHsdazX7
         jx0N/V8b0+MjEd7egQx6eHGLMmzWnUDGlftUjTUZgyBRNeuAH+TpTzQ4ygSazSB+iHVH
         vtqIsoiggccb0g2PxSAr8hvMyus0jm1T+sWyAR+DL3kZxMuSwvfR8BNFsnGoB1YjUhHg
         DFZO30eBtcAmKFDny77pVHz7ZvPLKTRft10IJJhyc8EQsMn4aI7cdSJcPcoVJWdr20sI
         XbYA==
X-Gm-Message-State: APjAAAWydACTNZfd17UrAP/GnzfAVToWGzEOxlRbBy+qUupE991e//Ht
        GNYpnnTiW92h39KYMl4OVeH9KewkkvgoMw==
X-Google-Smtp-Source: APXvYqwoSITAZR9m7332JbvkWJTK4kMnrg8j8Y6zlse+31UXQ4qEtJhHpKzHoY+amMNqHuos/b4BzA==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr2204811wmo.123.1579231372882;
        Thu, 16 Jan 2020 19:22:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z124sm8310093wmc.20.2020.01.16.19.22.52
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 19:22:52 -0800 (PST)
Message-ID: <5e21288c.1c69fb81.a64a4.042e@mx.google.com>
Date:   Thu, 16 Jan 2020 19:22:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.96-50-g3904aafeda38
Subject: stable-rc/linux-4.19.y boot: 99 boots: 1 failed,
 89 passed with 7 offline, 2 untried/unknown (v4.19.96-50-g3904aafeda38)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 99 boots: 1 failed, 89 passed with 7 offline, =
2 untried/unknown (v4.19.96-50-g3904aafeda38)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.96-50-g3904aafeda38/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.96-50-g3904aafeda38/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.96-50-g3904aafeda38
Git Commit: 3904aafeda38d7b29673da5404806176f4fd72db
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 21 SoC families, 17 builds out of 204

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.19.96-17-g17243698cd=
fd)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.96-17-g17243698cd=
fd)

Boot Failure Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
