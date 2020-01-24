Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CBD149192
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 00:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgAXXGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 18:06:54 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50334 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbgAXXGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 18:06:54 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so1040819wmb.0
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 15:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QQ5es7Shuwp7B9fH+dtx89Q3KOkeNqWcVfK90yrUn2s=;
        b=YG6zCr2lTlh/uOxha2q/FwDkcWUr8O0k7Ti9w+c1EKrtjVegcruMcX/l5J5j9euena
         3qmyFeP//JGSzC1KdLjTNDLPNWq/wVbaaQBHqFBnnDpH90G+DYD9zh5k4rDF8ZO1fNQK
         E/LPqbqEixnKOKgQ0mMq9ADylXPikQsRqtbfQj7v6sX4hJ60Y1qz/CKN7BYgGHxUR3cl
         p/fEisCoKMXI9ZGIxkaeiWOFsYUwchRYQ0eU2h0RxJsxlpfJNOAisyjomqN/7+9enNkD
         YJ0I2W3eeJ/zoZ74V0PQ6GCez+cGGptBY6Ut9mZdCBEDdDAWKqufSEDUGpd8Ar308K9s
         fd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QQ5es7Shuwp7B9fH+dtx89Q3KOkeNqWcVfK90yrUn2s=;
        b=TFTfY/rY1GJBKL1eivOZcJ35R1RbxvpsXnj3Ja0vPZI42OW4kJnRXX++cyI98bg1+R
         USEMZGVzHSw0PorTCqtoil6Ev9/RzAN44TUohPbE+4ZRgj1MlzuXeeJVSI1oWV0+tJHw
         xRwL63S5wafJIs1MpUFNw7YFNTBRyd3SO3zpWUiR+MzZz6AAPpwtXMu5dYYKoU0QWyeo
         S9FCaEal8HiBDEINhFCnF0eJJbnlf+zt6KI0pzxwfFcPpcDFohiuuVMFluwpQZ7Bj8tH
         /RBW984KI8vQZ4hpmbn+24JAvVSSBECOjoHKEFHdR3qujquxgmW/Zqa8eZ092dayectW
         48MQ==
X-Gm-Message-State: APjAAAXXjMJqUWyQd71RPEpxyvZ574198z3VsAtaQjTZ8Zo3FrhSKZ3j
        ZCPCaMbFvENcTXmHB2Kgr9o2ICHNL6FVfA==
X-Google-Smtp-Source: APXvYqwgbVzTMZJ64QYjE3XhCh6AvwEd+j6FQNGY+9LY7dKDCB6jEQ0Em/TpHHTrQO39OBtRMbaiuw==
X-Received: by 2002:a1c:5ac2:: with SMTP id o185mr1286528wmb.179.1579907212524;
        Fri, 24 Jan 2020 15:06:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v14sm9408271wrm.28.2020.01.24.15.06.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 15:06:52 -0800 (PST)
Message-ID: <5e2b788c.1c69fb81.e7a4.8411@mx.google.com>
Date:   Fri, 24 Jan 2020 15:06:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.98-638-g48b1f0e79f38
Subject: stable-rc/linux-4.19.y boot: 63 boots: 2 failed,
 60 passed with 1 untried/unknown (v4.19.98-638-g48b1f0e79f38)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 63 boots: 2 failed, 60 passed with 1 untried/u=
nknown (v4.19.98-638-g48b1f0e79f38)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.98-638-g48b1f0e79f38/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.98-638-g48b1f0e79f38/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.98-638-g48b1f0e79f38
Git Commit: 48b1f0e79f38bfd3826a25bd375fdf4771ea29a4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 12 SoC families, 11 builds out of 198

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.98-640-gd521598be=
d24)
          r8a7795-salvator-x:
              lab-baylibre: new failure (last pass: v4.19.98-640-gd521598be=
d24)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-khadas-vim: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
