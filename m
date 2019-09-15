Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B72DB3165
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 20:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfIOSg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 14:36:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33584 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfIOSg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Sep 2019 14:36:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id r17so5707886wme.0
        for <stable@vger.kernel.org>; Sun, 15 Sep 2019 11:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jU1y2C8cIxI/fIsQ/1zG4DeUkcy78FNsTT4wGqI3BLo=;
        b=oFOWCsdZI24YJp5MDCYR2eVg8xoXS+dWCqVblN97v0F7hvzzymJCIrE+9U7HUgr/4m
         vUKIG3l3OhzbDx4Um8DEWdHf0WVD9XlGK8F3Xo6DbW8dnExf2KbvhB5BbAwejFtqqyHw
         m3wDZ2nYCYwEw8Dh16jIrBnbTQHd8NR2V8uAzo4esHac/sptjwUMEzw90cblmkBWAGUW
         fZrSAWSqvEA5axePYOVjq0UpwekMy8ZzHhuFcqhqTqiPniZZ+I2Nbipf3Xs15+l3zbMS
         9O2A0hyWPTg9dRa3apU5ytIDDDDIpwE+EU8YFk7LZB+SZ2g//EBrt05gyFAAUdR0Rdpc
         nGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jU1y2C8cIxI/fIsQ/1zG4DeUkcy78FNsTT4wGqI3BLo=;
        b=SHctQgteGfAdsRdHWdCfjviQdc4zqozc6AppPe3RwE+vgi4ndDGNgCcXTXSoGgzUH/
         D1HaXUbN/4gDgPTgKe390/CwYu4bZaOO6YbvKQJXmu2avJz3gZc3d886tkNpaTFCJOKn
         T7cFLNfPQZjghzkkZiFlVZn3EK9gndfsphDY0SJPOL8SHtbDPuUqJOXuiKYx5vQYJ5tL
         yN+RfMa8T69qq0KxgSy4/fSfPOtyT/rwAZUmfyBn+zBXr0RlGAFf+Zwm7VkCdXl39ldb
         OuMznNO9cT9RGxiWC60gRSNJSM7+Y5JQ7fWiQ4fbyueMYfWKW9YVlVDv8RSVr3dQEitK
         Uaxg==
X-Gm-Message-State: APjAAAXYiR0YEczpcXLhwDZVlEZS9e1nuBOl0hiSYpYSa82j0/lt8V8f
        tIfYnXxdw2Fm0K1k//g/ldqwD61dt70=
X-Google-Smtp-Source: APXvYqzBE/vlCAfQfGny033OOoUcMZ34nxdwlucrDu9/CuDVM2N41viTQOXDGI4eaYRzDrGOgNLEnA==
X-Received: by 2002:a05:600c:252:: with SMTP id 18mr2933556wmj.4.1568572614552;
        Sun, 15 Sep 2019 11:36:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g1sm10656231wrv.68.2019.09.15.11.36.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 11:36:53 -0700 (PDT)
Message-ID: <5d7e84c5.1c69fb81.11222.ee00@mx.google.com>
Date:   Sun, 15 Sep 2019 11:36:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.72-190-g2dcefb93b77d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 140 boots: 1 failed,
 131 passed with 8 offline (v4.19.72-190-g2dcefb93b77d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 140 boots: 1 failed, 131 passed with 8 offline=
 (v4.19.72-190-g2dcefb93b77d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.72-190-g2dcefb93b77d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.72-190-g2dcefb93b77d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.72-190-g2dcefb93b77d
Git Commit: 2dcefb93b77d258534bafe3547e70384bb2e61a0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 25 SoC families, 15 builds out of 206

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab

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
