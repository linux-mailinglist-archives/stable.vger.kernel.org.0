Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D70172F2B
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 04:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgB1DJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 22:09:40 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54496 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730569AbgB1DJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 22:09:40 -0500
Received: by mail-pj1-f68.google.com with SMTP id dw13so657198pjb.4
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 19:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UdNxwyBMB27VcsjBffe7DebgpdR0ZuyznsrDdiWi1og=;
        b=aPmMCmy+JMSfWh9eU+MMHOOQRMesC8rFl7K5HlEsaJ4Oemy6N/NQT7bhnCSLPGNgm+
         +iKU3KA1uRNbfRlFAm0uJ5GmvyBHXQfvEpPwST1m0q5KnNQeeL87tRgDH+wEq/NVSoIx
         Nf1pwiRDiXhHQDUeAF3YtBPDnVOSfKiG5lNn/UT4SfeiCFmYWptaynTMhwS9xe3AXoqb
         ONuW6/vM6KK97M5tQCPHSq10jII7+nlYTUofqJAAcmagm4vilolNa1RgqYU25+0pFiVx
         gLH0b3nd/7tV2+mrLNXKJ4T/dJz5NEfY2F7wRh+cQA0xDWWmJz6iauqQBy3Bf1DBNE/b
         zhmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UdNxwyBMB27VcsjBffe7DebgpdR0ZuyznsrDdiWi1og=;
        b=awFTKYTwNdNGpXoEOIMId8UPoPL4Rzgd2y5fyAkQyLW43pvwN6ye21cTze6jiUMBq/
         kXJSA+7o2LPPDN7zDDFMFd2YkszFcPOdanVCkaxeqinfpheLRQBw64TRsu0DBFFBJAl3
         8qGwv1B/OdEjR69uENIB/tys0+KfxqbRMbNe5JxAKNlaBCuIeAV0HhIt8x6wIkufY6hZ
         T1VQM98QzTY8u77pRYeUTPJJQpUlEU2chqYbm3EtQ13eI/O5MTDk0DdTG2M8q7m1UdbN
         qMRHuy6dU72npQnWxrjRZR7tLXpJRvtlWM4m8x5ekse/nxg8DGbTxuAWtRpCpSOJ3qy8
         NIAg==
X-Gm-Message-State: APjAAAUo+f89NdcOhioK0xXRTAECRI7l5F/5/o22wbmKYjLwuj3Nrf6a
        44pMBLuJVpBdEgmpooOyuI/rVh6GI9w=
X-Google-Smtp-Source: APXvYqwhRY4PcRnXmlTASUlp1f2DpeIYsES7KyV7soZM0QYUIj2PSfDhL58fg36eLS8U9U20lYbwZg==
X-Received: by 2002:a17:902:343:: with SMTP id 61mr1991222pld.332.1582859378063;
        Thu, 27 Feb 2020 19:09:38 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f8sm8560336pfn.2.2020.02.27.19.09.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 19:09:37 -0800 (PST)
Message-ID: <5e588471.1c69fb81.7f0b.7d96@mx.google.com>
Date:   Thu, 27 Feb 2020 19:09:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.22-136-g8550aa6c7855
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 106 boots: 4 failed,
 101 passed with 1 untried/unknown (v5.4.22-136-g8550aa6c7855)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 106 boots: 4 failed, 101 passed with 1 untried/=
unknown (v5.4.22-136-g8550aa6c7855)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.22-136-g8550aa6c7855/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.22-136-g8550aa6c7855/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.22-136-g8550aa6c7855
Git Commit: 8550aa6c78553db799becfc53c7e7890602862d6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 18 SoC families, 15 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.4.22)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.22)

arm64:

    defconfig:
        gcc-8:
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.22)
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.4.22)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-g12b-a311d-khadas-vim3: 1 failed lab
            meson-gxl-s805x-libretech-ac: 1 failed lab

---
For more info write to <info@kernelci.org>
