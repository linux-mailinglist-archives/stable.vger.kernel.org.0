Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6228F1402C3
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 05:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgAQEEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 23:04:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35255 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730545AbgAQEEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 23:04:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so21292629wro.2
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 20:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k9Ade64XwesO/2SbjTwZDbwJ9uRSX/lcnej0anS+O20=;
        b=IQJutlEZwagUhTjyTwmCk+4zP+pi5OWS/7SDqmYZtqLxVVASAnXNZKDWI2UbnZeoB6
         XcKvYTkMm0wUluURyFB/8h1U+X4dkC06LMhSiIQhYWdPldXos16tOolTy7KBc9M4el2P
         vdNaQybHtNC111sJXi6ecCU4j+cIx632pwkwAym1N15+ZSO/B4z4mmVA8RDC11M0XNiK
         hydilzNrV7AsO75IbbG/87K/o/J/KAnaIcEGH/SKxk7O1KjSFwhZzsoclRPvOk1iXUvD
         6DRLsww8MowU0kvcSHILca2LN/dF6FeIhTLtWcPARO3USlXwL40d2J6uFhfA9Su0JUTa
         PWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k9Ade64XwesO/2SbjTwZDbwJ9uRSX/lcnej0anS+O20=;
        b=p/eci99wvORl9mDoVBdfYpm6wdItCEtgqaHfGc4srgyNocE6hBnmmyKzjbRlsln8Xm
         IWAgocZPwMma0nsri/qLCmxBwCNoP5MeoIiEHNbH1y4ZfUkVeNkh7kCCvhSdHYbi9pxz
         W169+tPosyg6ksGDVjlEfYJsYS47hQusDsZFt6C5PUKSESqJi7NZH1CCXTvjQ5dBTuZU
         UP4yiwE5rkHchFi26Y+/VVnTMbBVKE6GusVbkIbwyTrAX1/4QqffTwWGfUjHC/hVzxgI
         uIBsfjsYdfUw1jH273/919a6MUCZPdJH/G4EVVUce9+N9PZARLGYn67XSv88sRrIozUD
         Bahg==
X-Gm-Message-State: APjAAAWmg4RhWEGHk+qIoInKqUC0IKUsgrA+1hRw1SoxsvGeF9ThJtL2
        +ZHSbDOr7Bw6zLNbhB7RK9+nEvOUtKZXWQ==
X-Google-Smtp-Source: APXvYqxQq18vk/1S+q7Puhib7HZF1GtY1fwtRrfmSBgPyrSRIQsC/A50CquC9OO5BSmehQ7eR02d+w==
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr811067wrx.178.1579233882812;
        Thu, 16 Jan 2020 20:04:42 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f1sm33077490wrp.93.2020.01.16.20.04.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 20:04:42 -0800 (PST)
Message-ID: <5e21325a.1c69fb81.bbf20.72df@mx.google.com>
Date:   Thu, 16 Jan 2020 20:04:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.165-72-ge0cdfda22253
Subject: stable-rc/linux-4.14.y boot: 109 boots: 4 failed,
 97 passed with 7 offline, 1 conflict (v4.14.165-72-ge0cdfda22253)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 109 boots: 4 failed, 97 passed with 7 offline,=
 1 conflict (v4.14.165-72-ge0cdfda22253)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.165-72-ge0cdfda22253/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.165-72-ge0cdfda22253/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.165-72-ge0cdfda22253
Git Commit: e0cdfda2225350bfbf0a3d0a6ba1c2717512f26b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 20 SoC families, 14 builds out of 194

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.14.165-20-g241f53838=
006)
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.14.165-20-g241f53838=
006)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxl-s905x-libretech-cc:
            lab-baylibre: FAIL (gcc-8)
            lab-clabbe: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
