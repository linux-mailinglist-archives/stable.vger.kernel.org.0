Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A69F5C2F
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 01:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfKIAFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 19:05:24 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38556 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKIAFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 19:05:24 -0500
Received: by mail-wm1-f65.google.com with SMTP id z19so7891472wmk.3
        for <stable@vger.kernel.org>; Fri, 08 Nov 2019 16:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f8UQyvuvWgpEq2N3T2nQEuiH1x2TFVpMkfEXRizzQ10=;
        b=EE9L1GpMOW2e+coB0xOwigRzw5q0m/sLCG2wgeBZNuPNlGDJKXSymW0OEKeyUxgVIC
         tZLn9woXASktEsj2ffMZl5Wo6e6TBgIRp4TXMjSw32N5OqZIGKEZLHtjZkTFA0F2So68
         b2i2jgUzBmQ8EUFFKRS145Vf2fQSaejtwFC4i6E2ToxwsCFo3esU7Og5nIprJGGLJ0j1
         8lwyQMIp7vcTNkI2UEJbJhABsw4SFGSuxi/pe2zjOOrxf4k3ehP6BDtqIE4Tp9aPKypP
         zAL7YzzEALMjRZyqnyhtzYF40Ptvf1sm4AmNokRVlDL3wnnMEFzLp5ufmZU8qPdMweTb
         Hk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f8UQyvuvWgpEq2N3T2nQEuiH1x2TFVpMkfEXRizzQ10=;
        b=IaXfS9s22MaLJ+erqFqIWPsxJt8iNtn0VchCCGP6UgfkEEGddmNb0dhQUpDPnwU+OZ
         YAHIZ9ORMrfF4KlOgPZG0RiY6VLCwj8mnrySrdHMUYgXhRtt3JelKn7KvoicMffqNuVl
         P+4fhP3/bW+RW+WKHeOi4ERUAF8Dqh3pqs34slRE9f5lDBlb3vppOpk9rLlSt97UTHYd
         ZR34GBduA3a6Z0yTehnVuvYFCU5CU+yD/3X2NONQcRwWnNyeXaIITLdSoQy5pKPBVfEP
         CZXQq2V0FwYroZ1l+D0JcVM2f5Fr9HMES0slA6QPtIDr06u2t6ownTgogTKFGzZ+ZvUZ
         5g/A==
X-Gm-Message-State: APjAAAXLvHLmDGwEpG2YQcZfkwN3gHEFkskpzk3ydEujG6XMdj55L0Vx
        3aaD07gm2YAzG0P0LeXHH4RXYKev7tkL/w==
X-Google-Smtp-Source: APXvYqwAxKK1MFm1gYZe8XsOkweZ1YGUMSPs8I8vN7roUoSrYyIR46Syu/CquV1it/flJxwhqtKE2g==
X-Received: by 2002:a7b:c3ce:: with SMTP id t14mr9919927wmj.22.1573257920585;
        Fri, 08 Nov 2019 16:05:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 19sm11444144wrc.47.2019.11.08.16.05.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 16:05:19 -0800 (PST)
Message-ID: <5dc602bf.1c69fb81.7a6a8.9f1e@mx.google.com>
Date:   Fri, 08 Nov 2019 16:05:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.9-141-g11077993d891
Subject: stable-rc/linux-5.3.y boot: 126 boots: 1 failed,
 116 passed with 7 offline, 2 untried/unknown (v5.3.9-141-g11077993d891)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 126 boots: 1 failed, 116 passed with 7 offline,=
 2 untried/unknown (v5.3.9-141-g11077993d891)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.9-141-g11077993d891/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.9-141-g11077993d891/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.9-141-g11077993d891
Git Commit: 11077993d8919cb6ce838e60002b129d8321ac80
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 24 SoC families, 16 builds out of 205

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxm-khadas-vim2: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
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
