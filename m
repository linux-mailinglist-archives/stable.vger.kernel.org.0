Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DABE7B46
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 22:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfJ1VVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 17:21:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34989 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729265AbfJ1VVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 17:21:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id l10so11430105wrb.2
        for <stable@vger.kernel.org>; Mon, 28 Oct 2019 14:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EVi4JNVeP4twduDSxXG840l0kWSM9tp/+FoU5hvDkuc=;
        b=EpGXFoZnJJgzQR4UtEND9DwWvbqH61DeJf8Y7YhyxkjnzF9LIKc5p+a+CBxZUyiFcA
         J8uLqcTTM4LLYYdk4Gh2LB8jFZrB1a6HxMrNV45O3FbEz80JLNYqRjEv5asrjlciXC3K
         nRvPacwXlqVKyes+QI17M5GOwPNMbSa5f48iA0yZSryBkl2JSzhjpc8dKE+EWP0KXMF7
         GKdu09UaU6MfJa7FDPQMIykJPn3rE09dJf4vmCj7lTJCpvNNZDVAfNmm4+ipz3mxnKk+
         ecPWv4Nc9f9zWqW4o7aBWqAM+SSEQfv0Bv9AzqxsRUpFowej5O8yiJMEGDD6/aRTLT/I
         glTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EVi4JNVeP4twduDSxXG840l0kWSM9tp/+FoU5hvDkuc=;
        b=TlnBvIB8CtCyote3QMNYsnmYkB6WREOXsUGzjorMY6QdIouwEQHXg9jD8/l8ZiyM8P
         hEfPQws/7YJWajPfkbDLtkQ+IavjASpJHnsL+g9pmGIzp4pd+6Fw4VpsV8HAH3+V2HZD
         CHey3WYKgsnGcBh/Btj/AgrkX+R/l6yuqlEJ8yoAywOO/Fq34nTAHhacROI24/mkvb43
         1hQysgTjhV/iIY6J7mpoqK/g0i1wmxWhKQrWzj4nkH4x+IVHraGjxf7Hcj+NsWv5ByGX
         4yfLto4DfsxxnIFegp1ltApZ139/A1QhAgxmAIqY+6owjfzWBjZOuE5nYt6revBjiFVx
         LOUg==
X-Gm-Message-State: APjAAAUq7FmTr+IArselD+/aUC6Dq6liDsCqDTigxc8H81v/bu7CFJaC
        0mAfkmbbuu65g1v6YgPt2Bqle7coeSS/Lg==
X-Google-Smtp-Source: APXvYqzj9zE0x9GUNcjqIWwcknvpZXutAjArrPuDOGnZOAx7XumXQl4YOXMofwriRlNZpzDDAdUYWw==
X-Received: by 2002:a5d:4f89:: with SMTP id d9mr17380944wru.286.1572297692170;
        Mon, 28 Oct 2019 14:21:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 200sm824279wme.32.2019.10.28.14.21.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 14:21:31 -0700 (PDT)
Message-ID: <5db75bdb.1c69fb81.32fa3.5770@mx.google.com>
Date:   Mon, 28 Oct 2019 14:21:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.3.7-197-g96dab4347cbe
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 144 boots: 3 failed,
 131 passed with 8 offline, 2 untried/unknown (v5.3.7-197-g96dab4347cbe)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 144 boots: 3 failed, 131 passed with 8 offline,=
 2 untried/unknown (v5.3.7-197-g96dab4347cbe)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.7-197-g96dab4347cbe/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.7-197-g96dab4347cbe/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.7-197-g96dab4347cbe
Git Commit: 96dab4347cbe9212292cb3934e4d16cf1dab94c3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 26 SoC families, 17 builds out of 208

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 2 failed labs

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            sun50i-a64-pine64-plus: 1 offline lab

---
For more info write to <info@kernelci.org>
