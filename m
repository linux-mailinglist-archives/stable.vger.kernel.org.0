Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C69B25FD
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 21:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbfIMTYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 15:24:41 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:56285 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfIMTYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 15:24:40 -0400
Received: by mail-wm1-f54.google.com with SMTP id g207so3858432wmg.5
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 12:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pd40vG/uG/GzoenlJau3I2g3PG44k2MY+K/oA0okfbI=;
        b=WWxE4nIdoes0s8WDk7R0G5CZu8lqGpsXT+aObSuM+rOIuNEaWLTvOTC3JhmTh853/z
         5i+KEjHoTblzgBcjivx/c/Moeq38addSIlcMiPelJ0ho7nh4lEyP0jIbAgL+UBSUvTez
         Btao4hhGSAmW0qWGENIeB1q0qxsDrBWMotdMelv5pJ/jbW3Q1FANFkD/G7kBjc8qbZ7D
         XIIRBPqxJts8Lpi9ojnhkmWSdh5iCSzHy2XYTjvY4B2PfPwTnydekmcq2nDaa8FE8UHR
         G9/cq1rnaLNRplKPrN9unUjHpzqLQMdaFdRI/yhUpT7MUQUPf1Lj07EiUL8Td4OKz9ah
         24tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pd40vG/uG/GzoenlJau3I2g3PG44k2MY+K/oA0okfbI=;
        b=WG73mKec2DCAN4qFNrf+anpClJ5bWKnWwjswSHUMrEAYYqnXYenGaVVF1JWE/i0qD7
         ipKX4Ex/8X/30Fuuwb8/AYdTkHYXdhAQWHrvnLtnHxqzYzOwvi6Un0wqsQ6Y05lS0yWQ
         hMppCUeAdsHko35CY/fHARu1ia7GFxUSn+cjf+0clRMzTOdFTWgBQhDaDwaE4gcmDITB
         MbW+SsCtaGOaqiXFlSUX2FyAVjF9yAcvUHoThkh0FUcuVlpt8iouEDOgdcBOeheaaYjJ
         9EFbEGUlOaqDC+fqn/5mnLPr4iw7mH/tX0PYr2vgwTGeAuwoep70wDNbQBapPs15jw3c
         mUHw==
X-Gm-Message-State: APjAAAUh4+tXocaBtzmL+SXUhyiyACbBQj5PAK0GEpn3+4PTbhj2DHsM
        LtMZejNNq71QvogFlnyU2qYHSQ8KpthvaQ==
X-Google-Smtp-Source: APXvYqy40mMsumqllW6kj17KyMJZzcTapxV4Z9ERG5cI3f7G0leuWzJcPClDR4/VGO9o6wRVQfVvpw==
X-Received: by 2002:a1c:c012:: with SMTP id q18mr3530073wmf.162.1568402678033;
        Fri, 13 Sep 2019 12:24:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y3sm40111522wra.88.2019.09.13.12.24.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:24:37 -0700 (PDT)
Message-ID: <5d7becf5.1c69fb81.7ae9.2c79@mx.google.com>
Date:   Fri, 13 Sep 2019 12:24:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.72-191-g490747a3f68a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 136 boots: 0 failed,
 128 passed with 8 offline (v4.19.72-191-g490747a3f68a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 136 boots: 0 failed, 128 passed with 8 offline=
 (v4.19.72-191-g490747a3f68a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.72-191-g490747a3f68a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.72-191-g490747a3f68a/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.72-191-g490747a3f68a
Git Commit: 490747a3f68a8ef2bba5b0cb5f29b896c02885c6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 15 builds out of 206

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
