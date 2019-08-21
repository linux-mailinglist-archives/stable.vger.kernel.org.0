Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D2970E3
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 06:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfHUEPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 00:15:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33106 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHUEPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 00:15:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id p77so3818574wme.0
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 21:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IY9MDsvJ/wiesQOS5GIOQlH7hYCys/LJOvy3BQQwBp8=;
        b=1XWVeDejQtAeGrqT/a7vysa0WCYA7vhD2Awl2EWG2qlbSKtzSH/FhcLd2pJZyTCi/M
         sbLuMLk8aX4+VCx/8kG0KlqBIOpzEQU1eRwSz99y+J8JgVh+D6aRA0S41fTAcY0/vUpt
         2GFT9Ee3cOvSZzrjH4kzsTgheP+ZKkoYjdRqlUW2oJBUoZCW016CLaS15XZhQFsSstL+
         bZHsCyJsR719N8vZrC0bVyAOvGUgf2LCI2O03dk08h9nDqWg8pBxY9VTJBHyZxafoJbC
         6XhJnVIOCmF484acCmiJeXONq0S+mf4mUtjnZcPyaCdiLJQc/VIYTSZDkYO3P1Lv9LQc
         PHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IY9MDsvJ/wiesQOS5GIOQlH7hYCys/LJOvy3BQQwBp8=;
        b=fkDSffosRR6R5EWnF1hVcyI63nUe108CJrjzOsDrY/5h6BjvvIQcabBoaFE3yobszE
         c5sofbjvlO49xUhUzpTnVqHJYAKQHHZIPZD57u7qR8M/Cue2yZbHy0vpdV/XrOpn778o
         oRAWysI3CBexYJapFRK2/wuDVpJyX0FKNM9jSQlRUBiVx10+wHbut6QMb2w0t3ZQY8jU
         0B+4uxtq5KeYdYNSTc1s4pga3+ALcFe3Pzs/4R2XPJJhV84jGolgi9MfewMwpRdpfg++
         kwRKtiC9wPgbsdwRGLwB37SXj4GIV6yZ682GTskFiiVg3JmU3JUbSH+RUV4Xb73TIGQZ
         eYfg==
X-Gm-Message-State: APjAAAUub4ua6jafjds/qgNbQEFeABO6Zxe5B1fZD2BRYz5DsXkKf0GK
        2G+3n6ZfYx4xZq9vNdf4IpIJzncWpeJ3iA==
X-Google-Smtp-Source: APXvYqwV0mgo5tLhBZfDLHEAkr0u82EG0IQTL4fvKm7EWaoJ/ZaiDPYG2U1VDMOONYleKRsL8ijChA==
X-Received: by 2002:a1c:a6c8:: with SMTP id p191mr3157173wme.99.1566360933478;
        Tue, 20 Aug 2019 21:15:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o129sm4235026wmb.41.2019.08.20.21.15.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 21:15:32 -0700 (PDT)
Message-ID: <5d5cc564.1c69fb81.52578.2b8c@mx.google.com>
Date:   Tue, 20 Aug 2019 21:15:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-75-g138891b71be5
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 101 boots: 3 failed,
 90 passed with 7 offline, 1 untried/unknown (v4.4.189-75-g138891b71be5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 101 boots: 3 failed, 90 passed with 7 offline, =
1 untried/unknown (v4.4.189-75-g138891b71be5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-75-g138891b71be5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-75-g138891b71be5/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-75-g138891b71be5
Git Commit: 138891b71be5d153c4ae3ff25aafd1f623f52cd8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 19 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.4.189-72-g61debbcee1=
5e)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab
            stih410-b2120: 1 failed lab

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

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
