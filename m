Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE66A5DE4
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 00:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfIBWyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 18:54:37 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:34728 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbfIBWyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 18:54:36 -0400
Received: by mail-wr1-f44.google.com with SMTP id s18so15414808wrn.1
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 15:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c99kdt2dIw9fplfnXj9odr1EihTp0AFjT7R0Ns7qDjg=;
        b=kLxv668DqsuGFbCcWQK7k4xgnB+9kZRIjfp1lzHfth3OhDW1fIzcZ7+DXFzTIZ14M8
         H2SRmZDnWfzub/UJ8d78CFiKz17d29EBsaaDgJHDJkoio3K5ji7rsKSr+sPR5LUjCRPJ
         BDRI55HDhWcy1swobJk+u59MZZdPiI2bUB0+K8+xOywMIQx1hd56H4//4FXmeYJdTcNn
         a03SbLMpt/oG4qWc7lPE7v6gpGgWWxkLM2XOaYcd8Eh5qx+jrSr0JwL0JudrkzbbKW+K
         pY6wyR3jtbqqqk5hVoYl78ZExAPgRfAq9kiWgT4147Ay4f7BiqKn/Eul5LHT2HnSWwBj
         8MPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c99kdt2dIw9fplfnXj9odr1EihTp0AFjT7R0Ns7qDjg=;
        b=dq0mCFYx5gNnuSJqDdKotlMJowvFjQuT3mBGe4G8P588MwZmi+PQLIqqSpk/gwSYEc
         x9qsmwl5PUyNxSTrDmd4zpSIIbrqvAeyKvxEkK0BY7jO0ndCrfAzlvuXVAOqmtqjwQpK
         6pQ6WXlHaW72erVXEhjQAL4ARnuUTH6OLvAwW+QYDKc4hcUDFZlQp0PPDyU52Fv4dNbx
         d/1/Aicc7A1zOzs4fm78CxXpfgRwDbwRR+mjJrXNuLU9If6UccvyjgeZ9CMw47ZwbapL
         OoqA+l89EAeWaW6xp1aGs0NBGZpUJmu0Bbca1odcU/1Ue8NDHrTvf2vBlTztcUoiCTQH
         jtKQ==
X-Gm-Message-State: APjAAAXzLd5tHPiaBGNnVgUa11e4AemaLBr2RoH9qEavDKmy9GQwlv3V
        Dr/iPo3EU2Z6VA2NpFHr9W/IDGBfvltZXA==
X-Google-Smtp-Source: APXvYqztcnsA7njf/0xANCLVz1SA2N5nZdcyifa7BpEaJU30Z1TMCV+N+KqgxMpsgUMPKH8nOzLH8A==
X-Received: by 2002:adf:dfc8:: with SMTP id q8mr5368692wrn.121.1567464874444;
        Mon, 02 Sep 2019 15:54:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t13sm11250816wra.70.2019.09.02.15.54.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 15:54:33 -0700 (PDT)
Message-ID: <5d6d9da9.1c69fb81.d4e22.f9b0@mx.google.com>
Date:   Mon, 02 Sep 2019 15:54:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.69
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 146 boots: 5 failed,
 133 passed with 8 offline (v4.19.69)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 146 boots: 5 failed, 133 passed with 8 offline=
 (v4.19.69)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.69/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.69/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.69
Git Commit: 97ab07e11fbf55c86c3758e07ab295028bf17f94
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 25 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.19.67-86-g1ca4133a7b=
4e)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-cubietruck: 1 failed lab

    vexpress_defconfig:
        gcc-8:
            qemu_arm-virt-gicv3: 4 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
