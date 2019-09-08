Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F559AD054
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 20:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbfIHS0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 14:26:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45580 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbfIHS0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 14:26:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id l16so11392838wrv.12
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 11:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FBn69R4UNP855t99c/qM/r6D+pJMZoJdr97JVgO8Tlc=;
        b=Vd8OAfo4f46nw4FtY+pywBTN7e/jhNz9sGTZAjDSJJsLeBRHHUsVwp88d97HocLtQJ
         x/5ExugUfvcmKnmtidle94I0xAN6Ox+IAYy8g9jZNficjEC1dgYgxPUypx4UyLUZSsol
         loA/VnftKrt8IoMIpBdNPFSVGm5f3nxE8dri+7NT7LBQwiIrQXK7Xyiv6OFMV0N00Xa7
         /lBFDYQmjWADLMhc7FgWIXYa3Nwx8dJLSJKQ7e7BxUbPNNAkh6SgBU/yI4USJIUe4zFM
         3i7u8/1NS4XtZogNzIY5wFQ3hPNFF9Tpa3mg9lqOwlo4uF9A1A482xtA4ipQw34nI3ud
         R9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FBn69R4UNP855t99c/qM/r6D+pJMZoJdr97JVgO8Tlc=;
        b=Gi6Eq6FY4po82Q3tgpKG2t/qpqF2OVlu+jSV9aR0UlA3nMbPk7rSTjCsAktua2iG4/
         hg9dqH53nEKwhpb0puFwJDQwiu55BVKQ+u5N4d1A3j72LR5np48nFidbGq2NNSyEzgzX
         kayCviTEsGcw1HqTmZI2fcoZ6sLvD7fcvj15S4QO8UJBl1kh/ZFitdLUCj+wj7BDBgBy
         nij97Vtxgkt01LvSvmBJHxRafHVnLkf2lP+9Q3r4uo92vTkI4uvf8moHOqeBxMBAZzI+
         jud1vNYc2EG67JPp37J9fyZvVtQ3qM7fUhxWqE3iFBmSY46LcIgjsVJuh5matbtVH1st
         5BqQ==
X-Gm-Message-State: APjAAAWbMeG4LHLVMWWhIs/O+wYG7flb71+c3KRtpqMlKGBOKhHx+zgS
        trowOLtPvQOrwroK5WMRaLUXY8SWaNM=
X-Google-Smtp-Source: APXvYqyYXJUn8Q295k2M83JT7NCxw/DYTyVKKcV0N2/RFsxSclE41jAkS3JL7gkQ6o/9JywYcM0HfA==
X-Received: by 2002:adf:e591:: with SMTP id l17mr15225235wrm.199.1567967169818;
        Sun, 08 Sep 2019 11:26:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y3sm17970652wra.88.2019.09.08.11.26.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 11:26:09 -0700 (PDT)
Message-ID: <5d7547c1.1c69fb81.7ae9.3af8@mx.google.com>
Date:   Sun, 08 Sep 2019 11:26:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.142-41-g9ea9c62091b3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 128 boots: 2 failed,
 117 passed with 8 offline, 1 untried/unknown (v4.14.142-41-g9ea9c62091b3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 2 failed, 117 passed with 8 offline=
, 1 untried/unknown (v4.14.142-41-g9ea9c62091b3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.142-41-g9ea9c62091b3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.142-41-g9ea9c62091b3/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.142-41-g9ea9c62091b3
Git Commit: 9ea9c62091b32680f7e107f593241ab0edd80f81
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 23 SoC families, 13 builds out of 201

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            juno-r2: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

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
