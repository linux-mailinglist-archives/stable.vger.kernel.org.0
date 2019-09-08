Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD80DACA93
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 06:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfIHEKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 00:10:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33731 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfIHEKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 00:10:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id r17so10251287wme.0
        for <stable@vger.kernel.org>; Sat, 07 Sep 2019 21:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hwcANaNjhRmKYWlpaEVmtO/oA5WfoxzEqtXokhJWNfE=;
        b=q9bxWctpfRwA0P0l3xXfsCD1QMvEaj8KuZxY3eZWgDbfhmHi9Fg5LfkUaC8/hdXl+R
         rjA+61pCs0hcYf9Geh8rHxuz5Gmr3/apc3wCL+21ide9Pf7aizkMSXwG56bEUirukYte
         ntgCmD1MHBtuugmyROd7H7ekEXt+ppIMhfsYc6F/dNPqkyBH2Ns48VwhdkgxU1bPSUst
         tFw1Vu5Rx7/jnk92/S92/J4euHhYleFRMj5PIJExkaUDw9mIreNZPeRT5mf5JrvXTsmz
         dsGvAGfhFiyqieAVC9rg7+T8n+FAAxTvSskSYWJC+xuyRdwq1Dq/W7pIj7ZaJOaT3/PE
         /hNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hwcANaNjhRmKYWlpaEVmtO/oA5WfoxzEqtXokhJWNfE=;
        b=M0iMFRwO43Rc0NRjUHiWgzA2ZZ8MOXhu72QtGVzlsCwhAJKp8OiVUyAiWhlEIAK06D
         mHdk1+EMTDeL2wdg18ul5yGPD4wr9TqVKlmkVlWbMKZXffXcyc9kMyeaupXTttgH9Ix2
         oXOXfSbLsZMU7OmFuhggkjR+zhcxE0CpQpjp000LUuofyseI6UPNR6MhD07/+XbBPwzE
         4bRGesx20KoUM36VdNYZyTZdahKd99OpLNbDWAgbW1rhOEe4Mp/Lg7Ox99A8pEnnnXXp
         jhz5YGO9kX416B1Saf7Xkervp1JyfaHZLqVts9hLvwIHRhuC/N11seED1zVCvDpUJguX
         v2JQ==
X-Gm-Message-State: APjAAAXR9Q2xKcIzBsOa5O+Gl8ynHW+uSUKPMeST1QQMvKsbwQD4bQsB
        zQ4eOlk+xexT05J5SCvY4EQV/nLP0TA=
X-Google-Smtp-Source: APXvYqzHpNPoItMFns9HIPr9YqNuq9fX14NSVuIdX/YLrS4wycV9HK9zDguDhTcDIkFgbBbfkU7/Sw==
X-Received: by 2002:a05:600c:259:: with SMTP id 25mr13025304wmj.158.1567915848071;
        Sat, 07 Sep 2019 21:10:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b194sm23092952wmg.46.2019.09.07.21.10.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 21:10:47 -0700 (PDT)
Message-ID: <5d747f47.1c69fb81.659d3.7fac@mx.google.com>
Date:   Sat, 07 Sep 2019 21:10:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.12-76-ge244d51f8600
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 149 boots: 1 failed,
 140 passed with 8 offline (v5.2.12-76-ge244d51f8600)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 149 boots: 1 failed, 140 passed with 8 offline =
(v5.2.12-76-ge244d51f8600)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.12-76-ge244d51f8600/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.12-76-ge244d51f8600/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.12-76-ge244d51f8600
Git Commit: e244d51f860019964c2085aba6a3bd72e76c04d2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 85 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

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
