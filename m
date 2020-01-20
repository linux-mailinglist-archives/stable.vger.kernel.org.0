Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069DD142DE4
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 15:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgATOne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 09:43:34 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:35242 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgATOnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 09:43:33 -0500
Received: by mail-wm1-f50.google.com with SMTP id p17so15010113wmb.0
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 06:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S9wAQ4FRsjIqV8nItDaCvJb2gbnFVikWm5lqlnQnn0g=;
        b=guOWGFWMxrHiFWD1K3Tb/szv1c0hz5POs5M/W74yb+tQ7V16Yy8FP83X/L1LvpOhRk
         k85KsjyuB3l6CYaKU5h9kzq2OLYNhFcph/37xl4QYdSiouC5F1oDG1kpickvJx5sA5O2
         7I4GpwN34F3mVNxVfEPlTBo3x/EQqIdWo1q7MXdXPYn65NyVaHHD9JR/3QUsQk32ZcPq
         nMi7AkxJnbPtOJJ0LDHn+Dh6RcpAkXNGUaFBSy1S5/8RDHEbeXC5Q0V8foK1b22MI448
         bxoj0yXzjP33Sd/AVcFuom/dItrH+suuekgrMxuc3R5YhmVJfE0d/YmngaEaBiifv3HM
         oDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S9wAQ4FRsjIqV8nItDaCvJb2gbnFVikWm5lqlnQnn0g=;
        b=K2Wl9kpEMYebz5WjL/uvvR2jh8gpuUsW1zm4NSHzwcB1aulBsi7yUuhNQrflyv1X7w
         Sev7MWWNR3KreOreTKnISTeQZHGtFCsN2B0Qi32OmTHMuvFkKf+uCvIge0Wrma9fX11h
         9aQaR21Qs9yxLUUBkutFo1w6rFkw74Vny2TxBtgrX/x71BQIzNiUp2/Q5G6GxrNanMD8
         o325slvwxE3cviYIpTkHGs2gfiVWPN5zOS+HVrJSi0w6pyIbPZeR+ehRH1A5TybyLijR
         lNtSWCDT9hlcSjKDfjDq5vkK1XZlvYquP6F02XbYN0/xk2yz/sUAK8MZO5vv+pGqGC/d
         iHIQ==
X-Gm-Message-State: APjAAAUsY3Hn9W0UxbM/mWG1++PBp4acKT3LK1X8V+k9tWIySLR4cUzG
        aOOCLsqCxuFhPiVzxKZaTnqCzMV3Ey8ZcQ==
X-Google-Smtp-Source: APXvYqxGfH1c0IxB0ZcAb6L78eT36xpIxNxGnahuh2Xlxo8GvnTDgY9W2pzd7E4Cq+MyTdLBEdx/aQ==
X-Received: by 2002:a05:600c:2059:: with SMTP id p25mr20095061wmg.161.1579531411681;
        Mon, 20 Jan 2020 06:43:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w8sm82716wmm.0.2020.01.20.06.43.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 06:43:30 -0800 (PST)
Message-ID: <5e25bc92.1c69fb81.6425f.0620@mx.google.com>
Date:   Mon, 20 Jan 2020 06:43:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.210-61-g7b7b6e94c6ca
Subject: stable-rc/linux-4.4.y boot: 79 boots: 0 failed,
 71 passed with 7 offline, 1 untried/unknown (v4.4.210-61-g7b7b6e94c6ca)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 79 boots: 0 failed, 71 passed with 7 offline, 1=
 untried/unknown (v4.4.210-61-g7b7b6e94c6ca)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.210-61-g7b7b6e94c6ca/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.210-61-g7b7b6e94c6ca/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.210-61-g7b7b6e94c6ca
Git Commit: 7b7b6e94c6ca1a7e4ab86717a30e8bcc1fad1d18
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 15 SoC families, 13 builds out of 185

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
