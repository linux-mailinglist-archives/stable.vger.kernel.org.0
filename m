Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647D88E111
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 01:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfHNXDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 19:03:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36844 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbfHNXDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 19:03:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so635850wrt.3
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 16:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YcOnCRhvASOCE8YHTM3+3xNRALgdjiXsHUDG2PLCBIc=;
        b=JVMVTbGwkG9uEz2tJWcE7S0yuqviAy92OSYtqMBAoL1EH5wlly3JT0Su9RFFZz2Esd
         JKvEZEvUSAqH4MOLprUUUNTk1Qsh2mH+LMdLZr8biaL8PlayHDQ/kZ5QGOUbLVQFYPb2
         0fBLcS1IVBF8qjP1rznBXcRMirFeS6I3vJkddBSfyESbIy1HJXpifl6Y7U/TLS4ShgcU
         VSKp7N4qytLsJjuw/tutawuwDGjp5nATc0jPHPGSlTQnfwupY8/AVaMhVs/fiKASLCOX
         uIkegoIEFnGxS6+eodA7A+0b7b32/keucT9DwcpS8ty4gD+4NzyBfFRPP7ZB506YKDuJ
         NA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YcOnCRhvASOCE8YHTM3+3xNRALgdjiXsHUDG2PLCBIc=;
        b=Dc4xCBtfganI4Vx+6jxGL62NrSd0WHQU3rp7z5s+x0mepuQ0fVBnCFAfMvk4wEqX8h
         YujaiSZbxJmAeQ0xzk6DUP7WfpLjVDBLnltvtJjygS6aKxg+/VzopAIBQ0fsJotoTgra
         0Iqleu8WjUwjVyxzemcC56JzDXJ8w6ukKl4JX+tIEL9imQKEY+vfT7UQjWuVG5Lm8ecW
         xlN3lF6bC5I3d6QMrIgc2/oj4n8CyF6qDEyCFD6WOJRRObFuAe6iGktSu8+pNX6lENRI
         mLYzAAjeBHdgxjthbuiWqFmEU4v2QypxAmImajrsnbUIwLjBt+GU4Qxmx3LNGoT/c3mX
         gmLA==
X-Gm-Message-State: APjAAAUngAINU6F++yFGRmuQs5LN5TkyqEPasH1X1l2ILZ2gzNWp1ojd
        sp2awZ8Wl7GjMG4mwMGbG2MQUY3yvSZCrw==
X-Google-Smtp-Source: APXvYqwUQNBknVURV1mW4TmINppAM25sK6NhQNFB6iiKUYH8FhktfvtGyNC16WgO1urMrqLyF+pHRA==
X-Received: by 2002:a5d:4b05:: with SMTP id v5mr1885170wrq.208.1565823827697;
        Wed, 14 Aug 2019 16:03:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v124sm159419wmf.23.2019.08.14.16.03.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 16:03:46 -0700 (PDT)
Message-ID: <5d549352.1c69fb81.2e7e9.0cf3@mx.google.com>
Date:   Wed, 14 Aug 2019 16:03:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-145-g2440e485aeda
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 134 boots: 1 failed,
 119 passed with 12 offline, 2 untried/unknown (v5.2.8-145-g2440e485aeda)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 134 boots: 1 failed, 119 passed with 12 offline=
, 2 untried/unknown (v5.2.8-145-g2440e485aeda)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-145-g2440e485aeda/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-145-g2440e485aeda/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-145-g2440e485aeda
Git Commit: 2440e485aeda5f36eaf2050eb1bb61be46275b39
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 27 SoC families, 17 builds out of 208

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v5.2.8)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v5.2.8)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

---
For more info write to <info@kernelci.org>
