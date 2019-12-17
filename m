Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E36121FE1
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfLQAjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:39:07 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42966 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfLQAjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:39:07 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so9406318wro.9
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 16:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=adE3d74IQEm2R+h4Ovo8VJehhVMMOEO/gYb05omrXpE=;
        b=qzvUmSjy+soN+8YtqzlqWrdgKEvpyF6CGvk/J5w3NIQHy5gHw8YlCAt3D1dVNBvUPN
         OduixYJ6QZ2EL/nZo+mFwhzi2SLSESMUSYFLSw2XE3wYg9L/9uKXDF0/sAjEqOAKzbxC
         i/jjYinplPNSYvCtQJM+QqxuQl6csv0ekweX9Ttn8h4MLIhRKGQsuv/969ubz0fUeYQb
         8GlUqZw5ff2YzhjPDQmOGnJn+MtdJk5T/q8uPQyirrD5LenhDC9FNOU5KazebKjzfVpM
         zM9yggg8nrEknHTOp9Wr3Sz1GirJczV00B/lCgCl8zxJ2JM9cDXk1RzSbjRJ440qcqpY
         W9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=adE3d74IQEm2R+h4Ovo8VJehhVMMOEO/gYb05omrXpE=;
        b=ImJf7aLSo2n23L2Bn9XpkUmEh4hnfBdLBD8THk/bIXvwoAVpHuQTJ/drITpejp7cpd
         EACWmVx/jgu5GV/0CXf4ju0879D8LMzH+8ze3dmTurmfKoA7k1967BSSeeXlrOVzsopL
         kqi4xwSEDvvN9Rd7zDot6cqvs7X8vxY9sx5sB1kNcD0N1fKMLtoLEXVM0W1X6TtB8LDm
         QjXq+pz2Nna9xAxYeLS89OJI1lfnCkvGX2TYkzD20YmaKDmFuz8kvrwvC7weFZqUiUfW
         LF5nTte4Oy0RfLt15mwwZjyuY9Z+sM3+aSjZiUKtZZQTSpdrzdV3NPRbm+HQmBA6LPm0
         R3Jw==
X-Gm-Message-State: APjAAAXEfBqtRPnCkSUBd4KJPOzd3YUMh0cdXcnGl7W6LLtjoG1m+Ejo
        rkmQPCOPOJr7L4adA9lo+juSt0WqixA=
X-Google-Smtp-Source: APXvYqzeTtDl+GSjEi8ou4d3Ax3ZLaLKKg2LE/e213kiYCUHh+zwpnhoeZgjYrlgGx7Uc1/JorhmKw==
X-Received: by 2002:a5d:65cf:: with SMTP id e15mr34305097wrw.126.1576543145195;
        Mon, 16 Dec 2019 16:39:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t12sm22357140wrs.96.2019.12.16.16.39.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 16:39:04 -0800 (PST)
Message-ID: <5df823a8.1c69fb81.e8411.406b@mx.google.com>
Date:   Mon, 16 Dec 2019 16:39:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.16-181-g5770ae7aea0c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
Subject: stable-rc/linux-5.3.y boot: 129 boots: 2 failed,
 120 passed with 5 offline, 2 untried/unknown (v5.3.16-181-g5770ae7aea0c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 129 boots: 2 failed, 120 passed with 5 offline,=
 2 untried/unknown (v5.3.16-181-g5770ae7aea0c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.16-181-g5770ae7aea0c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.16-181-g5770ae7aea0c/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.16-181-g5770ae7aea0c
Git Commit: 5770ae7aea0c5937b7ac1e2007f4c04adb0f58d4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 80 unique boards, 25 SoC families, 19 builds out of 208

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s805x-libretech-ac: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
