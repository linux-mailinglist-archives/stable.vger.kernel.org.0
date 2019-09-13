Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34ABB2609
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 21:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387935AbfIMT2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 15:28:25 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:53534 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729340AbfIMT2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 15:28:25 -0400
Received: by mail-wm1-f44.google.com with SMTP id q18so3868839wmq.3
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 12:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZyJCNuOAdc3HwIafydT/ebM1uCX5N3TqLtB8kuskFZs=;
        b=sEzg91+T3IQujDodZVJVCtnkRGDkW5iDPJDg9IdSY5ZkbrQ+swmeGWvJjqfWwOGsGZ
         zjECKxBlusBJ5y7ju8VfPbOFp0EQjKy63haDQM/OKWYmtThC/4uBD1Lf49rB3Io6BmW/
         u+YqpQel9ncAM2sxnJK3w7QQ1wrPP4/qqT+d1LBu0QxTcp+hRAotIUJNhz/YW/RsFSwT
         KuR6nV8auQbN/EB+Ifw3Xw9WnjF5+GIvsdgN/LGB3ux/qmxHUYJmy9ON+BCNsAim9qxe
         hcrQaXkPHFLE1/6CqzgOWDha84N7oQ/qVkl7YDhUfaxfgd6SdvntheindBsGxyOmjvKq
         V1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZyJCNuOAdc3HwIafydT/ebM1uCX5N3TqLtB8kuskFZs=;
        b=U95CL0VyRRtt8t7iIvZ00Tsc5sP2w80LA73ap1x7/O9bcHxwlgjsW83n6laUKBedRp
         Kn/3KkMZoHHXeeJVRwUSRtUgnuoXkuGnw4N1Z0xyAHwisnp+EkJOdOk7HNtqCLcc/fnZ
         dn59e1XVYRhV3odaKCEH5G7XCcv5Tv5t3sSr1xjyU5D6xhzH5g0NtBOpI+HKPPGfr0uv
         Iy0A5I6uAEpr6XmSmdoyvJdA971/AOz1NEGk7rhLi6FXUAE5AbuilAWPBHD7BLowSYNk
         T/yulvu7wpsOew4vtw/7ml+s0/RgYze8G3Cbok8arT8HMvFnSe4k1kpixYHWb7zpXGEt
         hVJA==
X-Gm-Message-State: APjAAAVCBstrAQxE2MQlGel5Cv4X1iXzJlE3EvIze9KYgZnNPR69P7iY
        BhU9YzVn+f2ylbX+jb9Q+Z4F0xrkwOTbWA==
X-Google-Smtp-Source: APXvYqzJH4Fm+iEd0FP0eceRdCfYKofITDiSC1xnSPZWvKp9/J4YnZotOkrgsiFyD3oS5OkZyPDCrQ==
X-Received: by 2002:a1c:99d4:: with SMTP id b203mr4313236wme.148.1568402902224;
        Fri, 13 Sep 2019 12:28:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q19sm42489615wra.89.2019.09.13.12.28.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:28:21 -0700 (PDT)
Message-ID: <5d7bedd5.1c69fb81.b6462.d454@mx.google.com>
Date:   Fri, 13 Sep 2019 12:28:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.14-38-gda2614d2744a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 146 boots: 2 failed,
 136 passed with 8 offline (v5.2.14-38-gda2614d2744a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 146 boots: 2 failed, 136 passed with 8 offline =
(v5.2.14-38-gda2614d2744a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.14-38-gda2614d2744a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.14-38-gda2614d2744a/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.14-38-gda2614d2744a
Git Commit: da2614d2744ab16514a2288de2039732935749d9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 83 unique boards, 28 SoC families, 17 builds out of 209

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
            rk3399-firefly: 1 failed lab

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
