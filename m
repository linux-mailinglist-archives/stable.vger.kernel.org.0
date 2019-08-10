Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE348875F
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 02:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHJAnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 20:43:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39873 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfHJAnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 20:43:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so9591341wra.6
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 17:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pvfmXZcFjgZqOYmpZngt1VEQB6tp3GiqLc7K4yTqS70=;
        b=UWqnAc+KkXihOrlsH1WenzhZz664v06W8tUqXMeAR9/JXS7FMO98tD0lTqy8BVyKUe
         wrkNwac0b4RiIYd/K6y/Q1B7xCpF+RSQSjTH+HrsxKKNo8UFmdRYpZDJBt2Q0u5wGoX8
         /TiCvLFX65bSZYr0KEZ2Y3LvcWH+VDwQRO6j819RbL9vZVAUh8b0Ovn8BS5VWR0H4NJA
         CdookGi+Az/F48r1yK1L0r7kUj2A4FnklD9Qhs+rc5CqH+J4hIhaR0tewEaxdTSWcviP
         vFuGbFdK45jiKHoxyKmz2JY9L2GkbKKBMrj+8etJL0SZIsdDGku2owo9s0QywvXf3fhc
         Xg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pvfmXZcFjgZqOYmpZngt1VEQB6tp3GiqLc7K4yTqS70=;
        b=qDZjMabaOuuGZrHzChFV9QRKM4sNUQ6PNEolmwUaSldOzRdDTR4lM7+7KtbVL2Sklt
         p9Uy+wCR95AD9OoPZSJDj+aqL6rvIDJHSsEW7RlOjCnuNXrmoYB7xU85wUrMFfPl/2Zt
         j+1JZLClbMeBh5UNGeXbYnvmKMCv1vajhzVJlnmbDza0q8U0mZcRqNWTkdq5TcyLYh41
         q7F5hLa+JBFOL8xu0Z9oq6Na3F69eCnwYPgSB+DnFpHdqNdA2AIxTh48RQ1+EN2ECais
         E9eap08cU6kjnoemOnr1Q3DSlVH+H8O3lYYSvvuDaJI4C9Wfz6stBXV+tVYDYjOPsaj6
         Z2+w==
X-Gm-Message-State: APjAAAVyGRKS1RzCuQp6YHLiUfxvgcjW4bcUazd2qm2ZkyImAsxqR53F
        P53vmdGmnqvKxRBT9PCA+b2mIeUXKvvAbw==
X-Google-Smtp-Source: APXvYqx3l0o9+xpjWQYGg9Z7N3DYvRozjp/8EJVZhcjMPpWKnOyFgPm+R36s002ajZaO1lKIAVRNkA==
X-Received: by 2002:adf:9484:: with SMTP id 4mr186979wrr.14.1565397832814;
        Fri, 09 Aug 2019 17:43:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f17sm7000894wmf.27.2019.08.09.17.43.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 17:43:52 -0700 (PDT)
Message-ID: <5d4e1348.1c69fb81.3cc5c.4425@mx.google.com>
Date:   Fri, 09 Aug 2019 17:43:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 127 boots: 2 failed,
 114 passed with 11 offline (v4.19.66)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 2 failed, 114 passed with 11 offlin=
e (v4.19.66)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66
Git Commit: 893af1c79e42e53af0da22165b46eea135af0613
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 27 SoC families, 17 builds out of 206

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
