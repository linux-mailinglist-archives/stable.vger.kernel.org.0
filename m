Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90696156558
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 17:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgBHQGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 11:06:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39336 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgBHQGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 11:06:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so2397673wrt.6
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 08:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fFfPNFvgSk96YoaaBVBXCChjC7n78XttlOqJe4s/Q1E=;
        b=nyfzoUkxnO5+CEyGmuLan9pkqBVFsgi6tgHq3RMaFgGiLKL4P7LnJ3ZpVDKCIICab/
         WkFaiFokqwfXiMktH07xX6nBQi/RJd6JiR7TFcNwlb3igzjry/akSkmKxkwmIobmgxw6
         eRBhBPO+K5q6KPhnos7o9/9HNSoB6Ew2IYZ5qDcZuAlr2X46gJ3PtacUVBUCOmGmReVe
         LASevWAUBtzu2TeTXtnx+FkfzQFZmzpd6gE15o8NYdqnlajiam52HALqtPTGuyBBSGyI
         ztsCFV+GcerpP95aiqL6CAqir/XTrZXNCW09p8fblMdIrbtFx6vttYotgcb9luP4eH8Q
         VHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fFfPNFvgSk96YoaaBVBXCChjC7n78XttlOqJe4s/Q1E=;
        b=mKsbDTygtROgTKNlbaSLh6aZQ1aSvCQ06DSjLcco3nAhjjUwwVDGNKjhhD2u3xmarv
         xu5Q+g/SVumXqFmt6Lv7SjTHZEe/645Qv5TPis8wqfLfu/kwRH5X4lxYlK1VA4zaPtWG
         Rw6vWj7lIu+DYEV0w9y8N0sXJ4jgrOGcwJRu220jHbCaWzVbttGSeCxaAMLR7vk9Od7Z
         8ki1d773v6JoIYCAr5QXjBCQXjt3ZiyFlS24PDcTmw6zyp+9kvSukVzOEvtTfQIMrZ/B
         xwC1iD7171jBCdep2KkXrbqA9ZdWtXSP6HhxE3lqpjzhD/uN9WyYB47UsN4TOSMj6lfa
         plgg==
X-Gm-Message-State: APjAAAXCRva8KpbFS1294US8u9eVYXiExUsj7OPTT2W45dpK6Z/8awWw
        Gl15tVqkTh+bRSbWIa51GITtaf3ICMQ=
X-Google-Smtp-Source: APXvYqwInDaNmAWqyIBxN2IrFvO+lT8VQ4YPnMxGRKeLGJ3cZEbJiK7+11XRRm+WI6f2waYtP1pFxQ==
X-Received: by 2002:a5d:62d0:: with SMTP id o16mr5965078wrv.197.1581177991567;
        Sat, 08 Feb 2020 08:06:31 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v5sm8151469wrv.86.2020.02.08.08.06.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 08:06:31 -0800 (PST)
Message-ID: <5e3edc87.1c69fb81.4e0cf.1e8e@mx.google.com>
Date:   Sat, 08 Feb 2020 08:06:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.17-238-gbffcaa93483d
Subject: stable-rc/linux-5.4.y boot: 109 boots: 2 failed,
 102 passed with 5 offline (v5.4.17-238-gbffcaa93483d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 109 boots: 2 failed, 102 passed with 5 offline =
(v5.4.17-238-gbffcaa93483d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.17-238-gbffcaa93483d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.17-238-gbffcaa93483d/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.17-238-gbffcaa93483d
Git Commit: bffcaa93483dead5ac6145d67dd6cfefb9d9a2e4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 24 SoC families, 16 builds out of 171

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.4.17-102-ga59b851019=
bc)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v5.4.17-99-gbd0=
c6624a110)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.17-102-ga5=
9b851019bc)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
