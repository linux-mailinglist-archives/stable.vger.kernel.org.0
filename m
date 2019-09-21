Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD08B9F28
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfIURU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 13:20:26 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:36869 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfIURU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Sep 2019 13:20:26 -0400
Received: by mail-wr1-f48.google.com with SMTP id i1so9783228wro.4
        for <stable@vger.kernel.org>; Sat, 21 Sep 2019 10:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hGIkSwC8C8Qobx5+Le//2bOdKI83CWkI1aiQkmbGCXg=;
        b=M6SPZ6MvpzZrfTv6cNpbhsuJvLP4qRTI9yPbuxAlxPrz/NFUSlr/UWKDRERekaANNX
         ZdlKdNHz3lUEBwzjo02MYgq0YlHRpoeWxE9czSJx1XNMjF9zch8qL4xUvuWpvbMuS5oE
         +LiUahPPscY+haWLPktP1KxI2tMtxYQYGl1qN5ulDwHAXMq7NgoJuehUCJmEguw7lked
         NE5YvMowEPUOje5Pe1ni3iZZ0s9QaIK2H8kngsYMjPp+/mIMde17fv+IPonnretWb2nT
         31HVCEF7qLdc+QPvG6MnZBIa84AUKlHIPjDxzPJMDnRseNSv1XvWaYDBKPg7T7BAiTR1
         CCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hGIkSwC8C8Qobx5+Le//2bOdKI83CWkI1aiQkmbGCXg=;
        b=jwoUvf/iQU6vP04dAeXEv3mI/cfkmTTEnCjh6dv7i8exLPRENssxA6SH9Qy+12IpCz
         NtMmKXlcbQeLcW/nV3FSa4xugRBPNychT1RAG71APqffz7Mk7s97AkvvcZOmB1hjKmbj
         3AaYlfT/IGLvGtfQ4y5p3cn3wkgpHnwOcyO+upAeXYF6xzqzJI6+HWFjncEqcbgShrm1
         8G/5lPSgf81ZbeZEXyNRtjN4U3s+YB1zgfJ5jhNJ0gnkLthLJz0h5FDNw2fjSsGah/qX
         fg9KsI82rHjEm1q0462KHiIKJKEwIY56hx01Wb5YR/ekPbLIaWKINqbt83ylJjBz7RJf
         9LNA==
X-Gm-Message-State: APjAAAU7iGdqI1VZL17idYm8tuW/CnIaKZSsZASdZd+BclL+gwJI8aEp
        EzZJbNgw87eLhunkdDsDClYhESJZUwn/Lw==
X-Google-Smtp-Source: APXvYqyu0kuptKIxvZ9z7vfLR9LB2AYb/ixDUfRB7RdJslkCeYNyQq61XlVSKHeodmIAJDBzxinG3A==
X-Received: by 2002:adf:ea12:: with SMTP id q18mr3680788wrm.378.1569086424168;
        Sat, 21 Sep 2019 10:20:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x6sm8372065wmf.35.2019.09.21.10.20.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Sep 2019 10:20:23 -0700 (PDT)
Message-ID: <5d865bd7.1c69fb81.26354.96b7@mx.google.com>
Date:   Sat, 21 Sep 2019 10:20:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.146
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 126 boots: 0 failed,
 117 passed with 9 offline (v4.14.146)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 0 failed, 117 passed with 9 offline=
 (v4.14.146)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.146/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.146/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.146
Git Commit: f6e27dbb1afabcba436e346d6aa88a592a1436bb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 22 SoC families, 14 builds out of 201

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
            sun7i-a20-bananapi: 1 offline lab

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
