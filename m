Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C2262770
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 19:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732156AbfGHRmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 13:42:22 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:33806 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730527AbfGHRmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 13:42:22 -0400
Received: by mail-wr1-f52.google.com with SMTP id 31so1293147wrm.1
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 10:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RDRGTN8x919ptUJcgdMpXaqUnSA3Nby8GPaC88Pdh/U=;
        b=Q2MdZ1Bxa2BBbonFusRA5552As2FxrCbTQXoX1Md1WDJuxDzCOpumWqvJG2QnYzYz7
         yv5n1j9oecjzoAC+z1txaMRpThD2Pi5QHgaC/WNvtf9IxZsli2qtIb4Y2gwo2pCDzSJA
         FzFTsIbFpryaABq4pyERVZlMr4J0TJJf0f48eIo0UCjZmaBtR8F2EkQAJcHPqogsxn+G
         4TArmq7bpIcpWL1O4HxA7vT0WTgjR8G2BYTnkKJ9Rc2O1vg9BxZesQtqTRLoktcm88Ko
         jze35/msb5nUx+cjzoF0lQuYAkku25eTlBsw2BsqjjVF8vb9gLfY+DLM4MGcVGw/zeTX
         bVAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RDRGTN8x919ptUJcgdMpXaqUnSA3Nby8GPaC88Pdh/U=;
        b=Dvi4/eAgCmhZtwUABPgz0J4nmcEjb8nOa6cHAMu0HxFY1Zrq/RW7THPLGhgguA8+8H
         3t5sYUQd5sY5NnajB0ub8N7KTYc8vOws1gp+HN8bhuqXOu8T0iRQcTt2g5R+QeUAX7wk
         xmfPUf561JsAL4nyH2TFFAKSlCOf8DyTC/+foWLRYiAfMI0fOt7Deh6lGbf/g2Yyd3Lk
         o862pClw/2ujk4udqZ9JyajZNVtrfaOV9gv2MmmmTGplEm+TN1mtJuOmQ2cHo609+vX9
         02ZPFhw2j8ZNoVO2L6WPNIzmuGJeOF4l7HQ4HmMvnMEip6ZB4Hbqo//j+6HWJjSpJec8
         srVw==
X-Gm-Message-State: APjAAAV4/iLV6nVQQ2flTc+a/sHDrRjldGbR+L/VKtPnNbZII1BgwlcG
        N/ysEvrhrdcwmZXsiyji4eGX3rEZJxtw0A==
X-Google-Smtp-Source: APXvYqzF7CXkVTOiOI+4lqpMaktncsFBTyl0H5cNG/7gg13t5FAeysJeRpjOWdiRPFJ2eyBo41LcKA==
X-Received: by 2002:adf:f2cd:: with SMTP id d13mr17499528wrp.242.1562607740501;
        Mon, 08 Jul 2019 10:42:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z2sm15549753wrt.41.2019.07.08.10.42.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 10:42:19 -0700 (PDT)
Message-ID: <5d23807b.1c69fb81.a836b.6bce@mx.google.com>
Date:   Mon, 08 Jul 2019 10:42:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16-96-gadc3bfb5810c
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 108 boots: 3 failed,
 105 passed (v5.1.16-96-gadc3bfb5810c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 108 boots: 3 failed, 105 passed (v5.1.16-96-gad=
c3bfb5810c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16-96-gadc3bfb5810c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16-96-gadc3bfb5810c/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16-96-gadc3bfb5810c
Git Commit: adc3bfb5810c7d89758b29f1736fc927757ea64f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 15 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
