Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301C495A0D
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 10:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbfHTIoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 04:44:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36990 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbfHTIoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 04:44:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so11472233wrt.4
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 01:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wW9XOQq6wETdAmsbQFHx5SrrW/pE7WJFHCJ+GMyxKDk=;
        b=mYUMaFmOuy4O25vemSUVz4gRbZntfJidNakXYflZoi5leiXdl5oAmQalkhUvQa+Xcj
         6/4lpKZ/gX21Mr3XiAtL47TUY8ZAKZXYBfZfcjH8BQtuFHMFGzyWXElOz9NWNI2HfY/s
         mnlcCP4H3JxKE40YGguaBH4m4wONfS2VovsQZ4TfuVCxQnLseR4g0a1o3Jw2TSozEWK+
         OMRFHTGdUfM8nyIgJa33hY+bU7Z7fRCNGiQGHuttoMiaaBmBRwVz6CsEpBz61j7DRce7
         GBb7FbTrQq4uNenxoo/tmxwn/9O6tY46X5aHXNYaVFU//9PXhifZrDyIf2cbpCOqHOsB
         8ldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wW9XOQq6wETdAmsbQFHx5SrrW/pE7WJFHCJ+GMyxKDk=;
        b=FebWhJtVK+ngenN736DOYIqjGiAipaMT/4emRk0FnH1eyvYAIYQLVd0t2uNa1QJh3w
         C48wvUz661mqIWLd6q8LVI6WRUoK9GLvpaNy4scaVOMLMFmV3JKGE1g3RK1S5SXnjyry
         VlsJ4IGcgObKYed9cUnEsEMFVOSHcRU6MqvvAt52Ox1l68gyvKRQGu/d9Zha+cPl9XRK
         P+u3IfoF2qAuT8oAWwgG5CS5Nnji8hEByi96aYxRWjUAqJ3B3FidpTNuxhQTw2nu/jZF
         AzGxSVjjSINhXsOyRYvtDtYWwcuer6BYfSgtYk3GQr9UQQK2/blZXt5e2MxwIYMXFcqG
         CBqA==
X-Gm-Message-State: APjAAAXMSxJc6PV3PLdf3stGtaDpbYd+cKZlKEzoOe6Z8xFIoUPIwhfH
        WLr3BKcWFwb0on1HtOwaKxby1yx/quFAvA==
X-Google-Smtp-Source: APXvYqyFks/+RqXwRsYH1X6JocPITHu/n/uZWxrKz1QhlHErAVl+Bt+8UxC9PsMUyKWbzsBUk/dxMw==
X-Received: by 2002:adf:f646:: with SMTP id x6mr34563193wrp.18.1566290643412;
        Tue, 20 Aug 2019 01:44:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z1sm22889797wrp.51.2019.08.20.01.44.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 01:44:02 -0700 (PDT)
Message-ID: <5d5bb2d2.1c69fb81.55212.ee2b@mx.google.com>
Date:   Tue, 20 Aug 2019 01:44:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-160-g2620f1970026
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 122 boots: 0 failed,
 106 passed with 15 offline, 1 untried/unknown (v4.19.66-160-g2620f1970026)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 0 failed, 106 passed with 15 offlin=
e, 1 untried/unknown (v4.19.66-160-g2620f1970026)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-160-g2620f1970026/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-160-g2620f1970026/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-160-g2620f1970026
Git Commit: 2620f1970026e1d146e0f45abe443419c046d0c5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 25 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

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

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
