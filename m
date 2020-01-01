Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C1012DD70
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 03:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgAACkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 21:40:21 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42628 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgAACkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 21:40:21 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so36237628wro.9
        for <stable@vger.kernel.org>; Tue, 31 Dec 2019 18:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aU95hSRfScW1efhOv8nxTJaHNC6EbX+eoh7gr8Q8fNs=;
        b=FhNIBEbXOMzKjvRvHdz67eVsdOln2tzuOPw9EaEh2BCUcDhjkCi65kGxGbXFT0PZhW
         ssyxJBAi4PbCM13tRfaHFYuFI8c2TAgm+GjBhnRctzYjT3/qMgAt0kpIb3vaThCMaQMA
         K5XspWOud71dyjr08p7D/0dCIyZTWGvrZVaUuZEwaS7aPlMKRheGF1mTWqxnKKM5KzQB
         mtnDPZVRnAj0YF6KYFl1yryHJZQZiq8FD+qT/CU+qXLcjTgabG100ZyKgI8aDM0ve0X0
         33uxMEnZ+J5Q49kLAcyKuuHSOfYNsvcsW7ooot4X2m32sLthE6KTkHodG+AjL6VLe1fa
         96WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aU95hSRfScW1efhOv8nxTJaHNC6EbX+eoh7gr8Q8fNs=;
        b=G1PHvjPlQAeQpzQmjWnn+Lf2IrNd1oYyujXwdtVF4k0Y79E1GANFGYJes9Tib13fJQ
         AZK8Ma9aOZZ0R3F73xkqWjtRIPiwy1Q82QRr0L5l/KIRfnlNOZCssLvQS1ZPLaLwifof
         7URPQ4Z/rIwHt5OYm1j/PcTsdQQSvgpeQH18TWtSF0sy7q3JdcwQZrWWZfMbHWtGfabv
         VUpFuU07mVGj+y4852vOZ6uohmFdbxjEf6xeYkBYVDBHofmVNumUVy3KDjRNvmMhk4h5
         VrZUaCokPOHB/gNFVdKFEwA2byDZcIgA0WkEHsCcV/4QYFezw49xlNDV6T1xDaIQh3Gd
         MZ5A==
X-Gm-Message-State: APjAAAWMneBYHtSwWjIi2SmpFUXeO1vudbiklhcN+glJRWaj5W+yPrGO
        NHkw3gkqThEILg7Zeb32crNQ9yjda7jVIg==
X-Google-Smtp-Source: APXvYqzc6eBAtVYwKCmrwcqj6NG0rq4YnE5zcspn0fTLEwt7noPYhNExlQR2OmOqlWknUAtTcKzYgQ==
X-Received: by 2002:adf:dd8a:: with SMTP id x10mr75092732wrl.117.1577846418804;
        Tue, 31 Dec 2019 18:40:18 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x10sm51276954wrp.58.2019.12.31.18.40.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 18:40:17 -0800 (PST)
Message-ID: <5e0c0691.1c69fb81.7d16d.d2e2@mx.google.com>
Date:   Tue, 31 Dec 2019 18:40:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 110 boots: 1 failed,
 97 passed with 11 offline, 1 untried/unknown (v4.14.161)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 110 boots: 1 failed, 97 passed with 11 offline=
, 1 untried/unknown (v4.14.161)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.161/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161
Git Commit: 4c5bf01e16a7ec59e59a38a61f793c5d1d5560c7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 20 SoC families, 15 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
