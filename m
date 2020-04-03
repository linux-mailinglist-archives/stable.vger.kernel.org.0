Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C9619DB42
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 18:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgDCQRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 12:17:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42023 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403778AbgDCQRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 12:17:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id e1so2861011plt.9
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 09:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3wIrb42hBbEGJzjeUfNulfTRBbE/9xRnleYyMdg1GT4=;
        b=msjlujgPvtzNcLT6CC/BN+Ue1d3wYOoc1FFPS8br5dS4HDib4IaToOjF8u8d0U6TUg
         6J94BHaI35Kql3himAbXEqet63Yxo99bsubV/oFnPCFRyERPpGhyRkIm/eSRUr5enJGd
         eowDlvbk2Vpo/m0o4bkKpbeMJciIvyzrjUqjJ00CgRhALIrKR17RY4l0f0faaGx4eLSh
         kx0ln5jcCYDtOqrWMjRVsisRk2xQjHUGi/r33hfH1mXjZzdG6AbUuSdL0zl+lNnwp4Rj
         gQqYpduje2ZaxyDYsXL0MnCk9dLNrTWtuhhNX45inAc5UG3b3buLDJzawYUUmtqkwY6Z
         ecjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3wIrb42hBbEGJzjeUfNulfTRBbE/9xRnleYyMdg1GT4=;
        b=XDL3coBlT8s3UKZsgyeGJm74e3S4MoFte0r21+iP2V+GejoIPpTraSmpPyfBOOo4bY
         8+Sk+yNhjEW3gigF3GzwJAjMGVQCXdFxtihZl3jSSPBhug4grgyFJnhO3WTN4R/wU6dU
         XKRRLMfKobynyQUt03lQLSXtiisvy8IuQscpPp/fhmRXquBPypP8nSvapx9MigHQS3mj
         p4G20D/yCRGiyAboKqoQk+b9tkbg9fbin5qP3Tutlo8fqpZQiaBSJQBtHaQRW1MJqvS9
         Mtftd57ZvMDGUj1VZDhK1rlvIhW1I1495pg5moFGukul3xODuV/whL6p1r9l77O1C4AE
         ALfg==
X-Gm-Message-State: AGi0PuYxrEsyIfBIqD83eQQKrGk9hGiXS21+W+TXXf+3LP5vXAKoFzpz
        Ped0uzQ9x7r+tHBnjwgkeyie11ZD2l4=
X-Google-Smtp-Source: APiQypK4dH9FYQdOlZqpjQouQJxXs0qdUVDJosdbL1obbuPdXv8OmiixW/hNnqmdG+dcCLXsfLmLLA==
X-Received: by 2002:a17:902:b586:: with SMTP id a6mr8589482pls.239.1585930654740;
        Fri, 03 Apr 2020 09:17:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9sm5557024pgj.89.2020.04.03.09.17.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:17:33 -0700 (PDT)
Message-ID: <5e87619d.1c69fb81.445c2.93e9@mx.google.com>
Date:   Fri, 03 Apr 2020 09:17:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.30-15-g3db2f4cba70e
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 167 boots: 1 failed,
 156 passed with 3 offline, 7 untried/unknown (v5.4.30-15-g3db2f4cba70e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 167 boots: 1 failed, 156 passed with 3 offline,=
 7 untried/unknown (v5.4.30-15-g3db2f4cba70e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.30-15-g3db2f4cba70e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.30-15-g3db2f4cba70e/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.30-15-g3db2f4cba70e
Git Commit: 3db2f4cba70ef0a7956ca094c8f6e45c6614477d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 101 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v5.4.30)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 54 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 18 days (last pass: v5.4.25 - fir=
st fail: v5.4.25-58-gc72f49ecd87b)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.30)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.30)
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v5.4.30)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
