Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4751E8C5E
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 17:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390264AbfJ2QEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 12:04:46 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:35739 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390263AbfJ2QEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 12:04:46 -0400
Received: by mail-wm1-f43.google.com with SMTP id x5so3020177wmi.0
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 09:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4HdzwIA7gZw/BrFm7V8Z2FFUoCxz9wY+BEojLm21lTE=;
        b=VSTZQMtH+WebULZg2csnVODNbNWtJSOIBdo6S5uGDYt5IoTvbF30v/GDNQKpl52W5b
         dq5hOp1hdP4sUCX9tvM6eBsYA3P1fhNUUKa957GfGcq64VdS4ySj4Vtq5zMlEWxE2Jd+
         nsRpX8YvXUcjA5aM0WaPmsWiIzF6vyjpUTeTysqzASX4mXOywstIS7dvUlaUr59omCwu
         wBM1dWAJx7/V5KT7HjfzKT5eysjZCJVOUkjSd3jwIYOYRb5nfAp4xFVhThxaotCidD6W
         en6wqm9ZCKXLXyl0BcgDpZ2OEWBTqTbQhmDkL3H5RnhCOoTEE9Jm6rpPIf8NeWY8Mh/C
         65Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4HdzwIA7gZw/BrFm7V8Z2FFUoCxz9wY+BEojLm21lTE=;
        b=pTyLukpF7w1AgTV+zfh0pPDjtV00YXuHBdGaLOPNlbfWvQlpzAe0IiYeJwbIVveUWw
         3vmWVtQ/5r78r8ama09xVp3jlgUnp5r9VYsDPRl4bGHkcZiH9CbK5YM6oKFVpLR0WIzb
         +05xA4U7ibqFztCjBbCRzGNI8fiY9FEke2jyYFSPG1xvWVUA2KhSB66LbsTLgh+3tZqZ
         mShxegGBa9pf/fcWS1bCtprkF4I2jVNxr08WiQCPIpGEhg0NZjj8LPTkREFln7mXcVUz
         nYjtB5jEUpERcX9CU6tJiU0ppGde8HPpUvOdbk73MVZwEbt8HRb2wlLSBsG9x9kEBLXj
         tN1A==
X-Gm-Message-State: APjAAAWIq9IRME3ep18IVyWXpjtUK/hgwhmY3nKZ93BwdAMmXru6nSMx
        jE9v2+VfWyBZuseypX6LiGIaHXe/Q3drvQ==
X-Google-Smtp-Source: APXvYqw5qRtmu86g5VZOxYTR4c+FlH+dHLXKfSwyrL1hdeXRZhPBqzfxL7UbzDstIPzT5YEt9rhAYg==
X-Received: by 2002:a1c:99cb:: with SMTP id b194mr5139638wme.100.1572365084436;
        Tue, 29 Oct 2019 09:04:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w22sm3465608wmc.16.2019.10.29.09.04.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 09:04:42 -0700 (PDT)
Message-ID: <5db8631a.1c69fb81.9876c.21cb@mx.google.com>
Date:   Tue, 29 Oct 2019 09:04:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.198
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 98 boots: 0 failed,
 91 passed with 7 offline (v4.9.198)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 98 boots: 0 failed, 91 passed with 7 offline (v=
4.9.198)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.198/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.198/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.198
Git Commit: 9e48f0c28dd505e39bd136ec92a042b311b127c6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 19 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
