Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA72119856B
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 22:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgC3Ugd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 16:36:33 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37677 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgC3Ugd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 16:36:33 -0400
Received: by mail-pj1-f68.google.com with SMTP id o12so107226pjs.2
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 13:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Iuxad5TpYZoveuZcz3ZIpVAzNkdkTGL/32vb/FDU36g=;
        b=1/0EZ3JamCew69j9U6ZX3aQrohfLy9ZbVwBCju97WPnKHMKUGPgE4hSWfvu4mVuD5Q
         5blQh4Jd1p9pnRpXhYSSfhjvrNVyPAOfQxv3Dic/plkhl+Oz++WF+sxUEa34hO10LGsz
         uXJDJrELWvoNNvubOck/7dEGKqCVs0gZBgSLSDu4g6p1/DGIEniTR3xNBQqhqQt5iN1g
         4EFUmNk8vvao2tiD4JXxMA5JFDj2CFOodl1MNFg1KjMSbOHopzf+oZS+5Q6QJgnMW4UN
         Tz7FDHf/RmzJ0iLJvN+Emok/kIyIPBiofKIp5ajcsx2oq0wtp/8WEYXFpu3kopNhdHkt
         gdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Iuxad5TpYZoveuZcz3ZIpVAzNkdkTGL/32vb/FDU36g=;
        b=HOFMuRZoSac1M5w0ITImeEZrIiB7XiREPyKu6C6ZC7vpBkYfNz+MtfVcaGzt9x539h
         ET3SSVq4afhuLkub963y4IJqURIyoUj9xBweutA3VivEUMd9OBlAbtgniTe7BMeHZhmf
         CoPRDkXacXWpqprAWFNcFe3uuJRjIebUlxWhtJInI6XNDCEnCova2FBDnuN2PC/JHnVn
         knqqo+6uPxbaan61icRu8iPXCXpsxt3Zb+LqN7XTbm55cQ3PgUC9G0iYXSmI3AaHt+tA
         7m3L7rTvYZPGN+tTwE38s1RtkG7ywVRPt1JPQcZZ5QvAeZ8ytGXcJSAC6OH7LpGfblov
         Vstg==
X-Gm-Message-State: ANhLgQ3r/z80Qyqikh4BO1/wDc4jdU17NJjP/JMlqe8zj3GQXwWKQCX3
        iGxx5/HlwsZoz52G36eeoq9ZvK8zRVQ=
X-Google-Smtp-Source: ADFU+vvowW6cDkwg6r/OLG+2x/Y51G2UXIBqae9DEmJIq5Xc4ztCPBTU/m4nmn7fHWzXlly6T2QfSg==
X-Received: by 2002:a17:902:7297:: with SMTP id d23mr14097155pll.63.1585600591798;
        Mon, 30 Mar 2020 13:36:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9sm11371681pfo.135.2020.03.30.13.36.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:36:31 -0700 (PDT)
Message-ID: <5e82584f.1c69fb81.f37ae.0b78@mx.google.com>
Date:   Mon, 30 Mar 2020 13:36:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.217-66-gd657a74689fc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 98 boots: 3 failed,
 89 passed with 2 offline, 4 untried/unknown (v4.4.217-66-gd657a74689fc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 3 failed, 89 passed with 2 offline, 4=
 untried/unknown (v4.4.217-66-gd657a74689fc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.217-66-gd657a74689fc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.217-66-gd657a74689fc/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.217-66-gd657a74689fc
Git Commit: d657a74689fc59d183702334e90a7ff228df531e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 18 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 51 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 4 days (last pass: v4.4.216-127-g=
955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
