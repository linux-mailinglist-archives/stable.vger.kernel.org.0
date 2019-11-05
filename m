Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F4DEF4AF
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 06:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfKEFLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 00:11:21 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35022 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfKEFLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 00:11:21 -0500
Received: by mail-wr1-f68.google.com with SMTP id l10so19744014wrb.2
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 21:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D60qdc1NRvgwenO+TXiB5E0z4E0k/lieVI8azX+EcZc=;
        b=dGkoLvRZf2NoFHtsrnkiBfRgIY3EqBsaAWaFD7/MdLI2Tsoqn5F3UcgaT4HpBDZq12
         xwUaBJe4lX0DMTRzp/TRwHa4du+KPf4sRDxlyb2pi9ZD11efDIycN/MaQITSszJarA9u
         XJQZOCWCA5boyX1esSDkgkBEekIq8tp7N66/Qra0VIU0bnNREPxd8whO6f62ihatWKAJ
         dlI1pDD1ImOyAqeKmgtkRrU0iMlUgqt9COh4dmzKhXxizKzeQxO5pwP7VGUE0YiHsVn9
         7CGLIOYBlUQ05cFRZoNXI1BeyxHvO8MYCxarF1ATb6cQ41IhD6OinF2sJiUOVh/lijKq
         yzoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D60qdc1NRvgwenO+TXiB5E0z4E0k/lieVI8azX+EcZc=;
        b=hOCvuCfuTIjIWP72wPd22uPbF6TWl2FuOzpmOhmZdpfpxTJBIaQ/LK3w+toIh1vwYN
         pbSl64rvrxM2jEXxRVSWUvShHNFh40qc13lp9D97tHqTLHKWqYRaoKOzL01Y56TkgRKT
         JmjHO3MMu0Wh5irXjS8bjVvxPyBqbaa8Pnhq0brQGn0UenfH7Ke/rcyhNM4/m83ZGIdF
         PA2RYVIDrMuK74V9c/UxiowUYgjo1OvAyd1cE9bA2knE4P6CMEVjdlDEXAWrDZg6g89N
         wN636p7p6o5GgW9PtVeMiRguCNnbjnQnHfnjFpoEl8cwqlkcI4QVbQwdmb6WPEQCn8VF
         vp9w==
X-Gm-Message-State: APjAAAVXxa48HS9o6uaf9Zco/Q3CDVNh5o6Fu0XrlPKl5Yc+x/nPO+Ik
        0rR2acvQKP8NAaSYDiI3RfhLQTTt+C/LFQ==
X-Google-Smtp-Source: APXvYqyUexGZwrl6EMMdRaPzIQ7JwAKasEz4X3QHOB8I0JRYsAwUXsxMopXEb16c+/ePQk8rYsYVCQ==
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr25499026wru.159.1572930679255;
        Mon, 04 Nov 2019 21:11:19 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w9sm20632207wrt.85.2019.11.04.21.11.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 21:11:18 -0800 (PST)
Message-ID: <5dc10476.1c69fb81.3506e.5df2@mx.google.com>
Date:   Mon, 04 Nov 2019 21:11:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.8-164-g75c9913bbf6e
Subject: stable-rc/linux-5.3.y boot: 128 boots: 1 failed,
 120 passed with 7 offline (v5.3.8-164-g75c9913bbf6e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 128 boots: 1 failed, 120 passed with 7 offline =
(v5.3.8-164-g75c9913bbf6e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.8-164-g75c9913bbf6e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.8-164-g75c9913bbf6e/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.8-164-g75c9913bbf6e
Git Commit: 75c9913bbf6e9e64cb669236571e6af45cddfd68
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 25 SoC families, 16 builds out of 208

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

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
