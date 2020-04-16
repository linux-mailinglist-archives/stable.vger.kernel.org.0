Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634FF1AD32D
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 01:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgDPXaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 19:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725770AbgDPXaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 19:30:55 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C1BC061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 16:30:55 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f8so236000plt.2
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 16:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xui3cUYrKYZ53Jp6zTo/cDhMNVz+Gi5qMy3YdQcwxPM=;
        b=NSnO/Rcj2z7EW+mg2z14U85yuutgshxvf9jnhSnK7EQG9zEg7T2oA9FQEIGQYpsl72
         73wKvT55YzAC128N/XNESFAdWyQBwQfW3TmmudO9WVwedzzFjzs1VZZlqXrIVfV/98GJ
         4LhGz0HSTJqjzecaQJlBjb313BctvUrQg9J0hn6hQU3V0Vu52lwkUt/00vgn123ymv+b
         BsMubz604QZqkIlt6j+J+v2vW1fzkkzyBGRU1IydON0Fx9UxAtBxCTBo5GJRujP/nEid
         3NXoeYwJhRoAeYeizyNDO4uFiME9J3kCHpibo7+j4eJX2C8y9010HJ+2Sx20ggXr8kRV
         6qYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xui3cUYrKYZ53Jp6zTo/cDhMNVz+Gi5qMy3YdQcwxPM=;
        b=FUBqfbzxSivUrKtZTbSZmkppj16j7LzSD4TCtCmLTBGwlSFv2orDdz82/LHCWPPPxE
         qCdyguP3k6iBpA0UXNBepckeRQnY46fwOO+3ImDk4AI5ocZXLX42IfBmVvGaj+1xzcUn
         rxfPcTGkA9nwN0fA3x7eMncyzODdM7VcLiuQPyBs9mLKYLZuRoN4wWL3iFnqDO9DaTjJ
         bqmsaR5y8EYT9vlRqLKHNbMN7SHK6VvStoZVpUSjUSgvdmuirAQ+jURfcXOxplxCPD2t
         O1zqdOVZuxunVCDg84IoXu5FxmyS6cg+1/K8lWHMZgs9cWkfJKBP7RRzqFHOVLbIoKum
         76sA==
X-Gm-Message-State: AGi0PuZsdVgRV3Qjjqt9AbHX6F6dpwais0CbHkJ1bPoTL5SJ7GRgvFeU
        5Z2k1ogs5AqgGvle/vxwDnV1hUtmI/w=
X-Google-Smtp-Source: APiQypKiE2E+SV4uji5t/zvolYFk6a/puLfOY3K7GIZhiobILPYPBR3Y0deEz5mAxKSBdrbAthTinA==
X-Received: by 2002:a17:90a:2e15:: with SMTP id q21mr916018pjd.166.1587079854039;
        Thu, 16 Apr 2020 16:30:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 140sm13067178pge.49.2020.04.16.16.30.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 16:30:53 -0700 (PDT)
Message-ID: <5e98eaad.1c69fb81.da243.be27@mx.google.com>
Date:   Thu, 16 Apr 2020 16:30:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.3-294-g576aa353744c
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 164 boots: 4 failed,
 151 passed with 4 offline, 5 untried/unknown (v5.6.3-294-g576aa353744c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 164 boots: 4 failed, 151 passed with 4 offline,=
 5 untried/unknown (v5.6.3-294-g576aa353744c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.3-294-g576aa353744c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.3-294-g576aa353744c/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.3-294-g576aa353744c
Git Commit: 576aa353744ce5f1279071363e4a55e97f486f39
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 24 SoC families, 21 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.6.3-285-g1113b108c40=
4)

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.6.3-285-g1113b108c40=
4)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.3-285-g1113b108c4=
04)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.3-285-g111=
3b108c404)
          meson-gxm-q200:
              lab-baylibre: failing since 1 day (last pass: v5.6.2-70-g6225=
1e4703ac - first fail: v5.6.3-285-g1113b108c404)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
