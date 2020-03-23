Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509671901D8
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 00:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgCWX11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 19:27:27 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52568 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWX11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 19:27:27 -0400
Received: by mail-pj1-f68.google.com with SMTP id ng8so589776pjb.2
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 16:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kLNo3TsyHqdcr281qTNxLwhyEDUDZVyxGrVOW6irKzo=;
        b=FrDMlCxUsiGa94W8pGzLAjQnfVbomkRx+PBjOwpccm4TOfal47qUATU4ozLsWTXnT4
         rc1JSqcPBQDCabfxBtRIO2wa7DNkMa0FHEB4K48c1SckdTGiJxSyOWyvqAS/LwhCBYku
         146RMKbTqfgy1HGCogHyDTgjrJFVDsQ6hJEW8kE+2y2z+XcNbjV6afY1V068lh/yEoTp
         qORrW/4OSibusW+JBjFSVm6u3dkZqv7vH6euTQe2sqa+uk2gEAWN+7xu+Nwtf/z5v/a8
         UGD+TelVFoNUNepcbDklB+Os4Jl+sfiH9x/qXNZkJNOJJZLY6hjL6jfLqFFBHC/LqtrI
         EaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kLNo3TsyHqdcr281qTNxLwhyEDUDZVyxGrVOW6irKzo=;
        b=TlS+8ESncoTETR9mIjUbqsrPv9cdT2GKK8BfkyrUqPujoeOuDvL4Khv1zt/KPVVLRK
         HLquE0yRui3JF4EarVuvKfDltlUtRBMaYKor7MBubPpHZNRIW7RhEy5TdgJjLkjttp6E
         mdD+R9h4SJWetwHnz+QMCkX/rtI7U8OgCFS0kJn+h7DY/lSi0PqWF9OTSb/8Q1hEXZld
         Q498jKIZWFDR7ly86t9O9+jpCTYVY9jS6ZzKWFLu9v8ZPfE6t2bbEnddz/cEVjcSi4Ig
         dVozFKg1mvA1JclK8BEiG/dJJo6OVgWWVTx8s0awoMIJc7vMPS9hzq4Z3+mnSoKSdeQt
         cIBg==
X-Gm-Message-State: ANhLgQ24WraYVneul1cx8fie/lPh8N5ua1eF69hhXMR2iZi9MrjT2SKz
        Wi7W2oQdRwRgINOOgdL5yeQbLnldcqM=
X-Google-Smtp-Source: ADFU+vspIQyM6vXm3whaJ+ZQh4KEUPWOVRlrw0UekZS5CoTvnJm4nDGzJ7dn2bAXs6MEirAqItr2iw==
X-Received: by 2002:a17:902:7c84:: with SMTP id y4mr24806956pll.30.1585006045890;
        Mon, 23 Mar 2020 16:27:25 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6sm13438061pgu.44.2020.03.23.16.27.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 16:27:25 -0700 (PDT)
Message-ID: <5e7945dd.1c69fb81.1a7a0.3a34@mx.google.com>
Date:   Mon, 23 Mar 2020 16:27:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-188-g42b2432a2ac3
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 143 boots: 1 failed,
 133 passed with 3 offline, 5 untried/unknown,
 1 conflict (v4.19.109-188-g42b2432a2ac3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 143 boots: 1 failed, 133 passed with 3 offline=
, 5 untried/unknown, 1 conflict (v4.19.109-188-g42b2432a2ac3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-188-g42b2432a2ac3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-188-g42b2432a2ac3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-188-g42b2432a2ac3
Git Commit: 42b2432a2ac36bb1d5f6adacf6c8b7d6161f8ebd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 82 unique boards, 22 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 10 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.109-136-g=
d078cac7a422)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.19.109-136-gd078cac7=
a422)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
