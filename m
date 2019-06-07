Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780FE397EA
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 23:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbfFGVjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 17:39:25 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:36469 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731372AbfFGVjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 17:39:24 -0400
Received: by mail-wr1-f43.google.com with SMTP id n4so3508918wrs.3
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 14:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=575d0z980F6D59BozeRQW6fBFMUbOJp40diByIuLzg4=;
        b=gfdyf2RSyk29L3hjscHoQ9PADm7gWEB9wgheKy25PGagkmUKhDi97QQB56At5FbSza
         Ew5zn+PwrdWyLQ4nwoi4Cu/VxTq/BWydB4+k+EccthtK7V2GszgZjoFoQ5vMf6dVM1AT
         5ZMLdTTCmf3A2phcs15Dc0CkR8xpF34QEQ87gGLwgqjlAgsGjEZHTL2X4Fq5NEl18Bae
         /g/VRMVdcRgaihGUIawg4cmGRHW7Gm1tjF1i88kKHl/RPutM7dshEIzzzkZNMYBON2AF
         ZF6tZfJcWRkrvPukNv09jwOhyEMGcW8KD9HvbqX0QS7/z1WFj3lQS4x8aMQ5yO6Z8zTI
         7EWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=575d0z980F6D59BozeRQW6fBFMUbOJp40diByIuLzg4=;
        b=qiRnzJ6fWTo0yhg6wvfP+fdgsoDQuY9RRcViWRrZUPujAs6QF0xqb0m05szJaeN1Y6
         KD9t+qTN0tne72P4oVYoUFc+7jYtPZUqS1Wy3KuKClA/dMBkqKTXF1Ed7huNjjRRnTkm
         X7gAzJr6s4K++UBmO3qKrzFxMgpH+yN1LpbrnoOxXKrLXkmEznFOLjc7NhhZMnqvPVdx
         0KASiK/t2DfC3wY4bkX/1TqqMQO7P630j1BWJNM5nntIPQB4clAiuarngp9TB56r/yBa
         x25xe+JdUel4QJM8sBE7PrraWUymJUQOBjpK/AXmCHdQxbs9PN7a4Kp6ANHnVPKMjBOl
         7+Cw==
X-Gm-Message-State: APjAAAXX9ShXk/rhyMlO94Zft+vxtyrHkutanCdvjbaDlW3OCuldFzyP
        Xova0gLHbxNutzotOKrr+bLRGXmVQQ2Ziw==
X-Google-Smtp-Source: APXvYqyfuFQal3MnFw2Uv8xSj9zPAwTZ8UgbBkJSqjP5xj3Urd+cTJYFJUHvoU5v4+hraJdALfkhXQ==
X-Received: by 2002:adf:de08:: with SMTP id b8mr3255306wrm.248.1559943563190;
        Fri, 07 Jun 2019 14:39:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x8sm3044585wmc.5.2019.06.07.14.39.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 14:39:22 -0700 (PDT)
Message-ID: <5cfad98a.1c69fb81.9d3e.2ffb@mx.google.com>
Date:   Fri, 07 Jun 2019 14:39:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.7-86-gcef30fd8e063
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 139 boots: 2 failed,
 136 passed with 1 offline (v5.1.7-86-gcef30fd8e063)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 139 boots: 2 failed, 136 passed with 1 offline =
(v5.1.7-86-gcef30fd8e063)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.7-86-gcef30fd8e063/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.7-86-gcef30fd8e063/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.7-86-gcef30fd8e063
Git Commit: cef30fd8e063aacee3601ac8df2c4d1c5980b759
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 23 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.1.7-86-g0765c25688d0)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxl-s905x-khadas-vim: 1 offline lab

---
For more info write to <info@kernelci.org>
