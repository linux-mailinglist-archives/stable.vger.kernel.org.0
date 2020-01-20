Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E43F1430B5
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 18:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgATRSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 12:18:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34966 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgATRSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 12:18:25 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so297843wro.2
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 09:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2caliUwThJKrSS7bVqpYtdgucAPw2K2VvUzmumCISbc=;
        b=Q7k0UZTNTt4OdwfcTtBVQjKvIa8WJWMeTybHrxeVJhzjCDW+R3Dbn1Qx4zuKfUodXK
         EKHIKxSFdKZs2YZv4FZqiboqv/sk6QmaLV1yMO1qKvmnHxoT9LNGVeBDHQv9AWTa9pj8
         Bkkcb7AFUTJKmSbe+ZdF5ptuDqdY76qZK5z747yVkuTL8LY6ho8YD6WrPRYkUE9V7pvx
         Wah1MpTFo36wDaBGvQjainD+susDo8owvj3NMEjnzyp1wpJuZNnnWIECstHJdxMJqFjk
         NEh/5ws2R7FZW9nxP+htfbzbVMkgS/3z4K3bO8zZxRj850nQTq2miM/N8UV+XtY0egCG
         xScg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2caliUwThJKrSS7bVqpYtdgucAPw2K2VvUzmumCISbc=;
        b=sFsoopCCxKeSQWqAWMChhR5eVYY6mgEYdV0m1mGBE8MnO1UdtB9CEIaV8w8Z6yPSgJ
         Y0oH6mkwKHSvXNkY6YBbAb/DAcIf88EXOtMGBofjcO7xtn0dr8sJUwkgssu5/SizabVg
         d7FMvZZPR6ZBnRLbxNg1FD7dmJD94yu2doc9cRtbeB4lhCmu0pyAj9WxVhlE7SAFMOEr
         0pNW++OlvyX8Ha95NvkZjoCMuV/cny7q8Xd1QSgrA8XPUtetwTL4I20mO3K93OzFaVdE
         /blyUSDNTmtC/H5UsdfAQ2HSNR4iXT2dkpxIMzcLeT+HKbZ/twaJB2mx16VvHCP4b5SA
         bH1g==
X-Gm-Message-State: APjAAAUmcNmSujT7M6Y3zhtXWLE8LBaVc8sXA30LsB450trhefP+dKmJ
        YglaRYwSYsKINX/4cscN6vASk8pC3q/iRQ==
X-Google-Smtp-Source: APXvYqxiyjbBcf1jwnPGQYSJfulArCIloGgTSt9jkTnek0OxoqT4EbilA4XwsHUY2ENCG48rOXTclw==
X-Received: by 2002:adf:f508:: with SMTP id q8mr539212wro.334.1579540702878;
        Mon, 20 Jan 2020 09:18:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b21sm27268wmd.37.2020.01.20.09.18.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 09:18:22 -0800 (PST)
Message-ID: <5e25e0de.1c69fb81.e8179.0237@mx.google.com>
Date:   Mon, 20 Jan 2020 09:18:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.210-77-g2f9a91e62a20
Subject: stable-rc/linux-4.9.y boot: 96 boots: 1 failed,
 85 passed with 9 offline, 1 untried/unknown (v4.9.210-77-g2f9a91e62a20)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 96 boots: 1 failed, 85 passed with 9 offline, 1=
 untried/unknown (v4.9.210-77-g2f9a91e62a20)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.210-77-g2f9a91e62a20/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.210-77-g2f9a91e62a20/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.210-77-g2f9a91e62a20
Git Commit: 2f9a91e62a20c3dbc8fcf254710b0d6d6816a5ee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 18 SoC families, 14 builds out of 190

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

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
