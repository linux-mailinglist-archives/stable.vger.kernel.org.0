Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977A2885BD
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 00:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfHIWUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 18:20:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36485 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfHIWUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 18:20:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so6850599wme.1
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 15:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NCA9LziK9CdkOswWY2Iy6T+RlQbkmJVGNKHZE28KrYY=;
        b=eIJSkMlCapEDegJhsKpIWuHd1ohuGKQWxN2fS6nIfNWQ1cHUtybSBcl8j9MywrFd0r
         Oo/PnXc+NbJQrA0vV6BVfd8PbuSZSvSMTqz6wyugyDir8BU1HVDfE+uU7yiP4ODb2lSt
         7CTcWbax2rhW/BPKPMgn2l7Aix6y2ABNQrEBCSIXb+bb8Mm96Ndh8J2ZZL/Ozjx4Dj79
         iODQDFuEU/3yTrVqIC1QUZMXokz0K4/C9HyFi0Wrj3Bk4laJJCoH+PlJeIyo3Cg34bBX
         J0du2gLTws16/XNo6jfvQ+3eK703/HL2c1sPXcTaGW4Df5pD14TtVCLPFwQwE+iC3gdH
         h26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NCA9LziK9CdkOswWY2Iy6T+RlQbkmJVGNKHZE28KrYY=;
        b=H5Kq0UFqao1K4u5ysuYs/t23+lwy+PQEso9D2MUDxmGkaFMx2vCis0rlNQcsjFfB1r
         FtYy8HuamLfipuMWSa0sriQwVcXbZ3Un5GGVY48BViSiiqPfkud6yImkYyb5hlSijxUx
         E/X2oRmPxOwqg2UZT2Ws5Pu3O8gqim09ItgctfiVV6gJAmRdd674fBGs2N4BY3ayolRu
         YptfTVAqwXdCMeWPcoipfM+NPAXQ0LTE0F4dQQ+6t9tLIJV+CIgyl0LWSc3dcvaTH7jX
         aq0LrpLOOm4syoakj0EUSK5xv+FCZW8OZuUEfXmyIFROCwXku9acLsKGA0FspkhsjSY2
         sgXg==
X-Gm-Message-State: APjAAAXny/4XDzfABFQL2Efa2duooRBKTFZNnGx2i6tA4jIHx2DbpafZ
        XGgH3RjLQyYaZ/uM9s6MpXiLUMYhe2dNSw==
X-Google-Smtp-Source: APXvYqxJhb3znLm3z5M6kG476eNLUkuCx/OmZn7TJDy8FI39sTicL5tL003wBSMCv5veDbuQ9aJX6g==
X-Received: by 2002:a1c:7ec7:: with SMTP id z190mr12880539wmc.17.1565389212011;
        Fri, 09 Aug 2019 15:20:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x83sm8241554wmb.42.2019.08.09.15.20.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 15:20:10 -0700 (PDT)
Message-ID: <5d4df19a.1c69fb81.a34d9.ac7b@mx.google.com>
Date:   Fri, 09 Aug 2019 15:20:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 139 boots: 1 failed,
 125 passed with 13 offline (v5.2.8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 139 boots: 1 failed, 125 passed with 13 offline=
 (v5.2.8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8
Git Commit: d36a8d2fb62c7c9415213bea9cf576d8b1f9071f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
