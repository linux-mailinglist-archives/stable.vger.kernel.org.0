Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C9315A9AD
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 14:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBLNGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 08:06:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39050 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgBLNGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 08:06:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id c84so2351654wme.4
        for <stable@vger.kernel.org>; Wed, 12 Feb 2020 05:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VWuGOZVS/JSczpAJ6wfhPhGOiDdMMsZXpz771AD/ci4=;
        b=tObiNxauFZ30qV+qTtTSdyQ5yTj8BQ7vbcKQd5OFqDtt22moMOV3qPWejxYeGhXBOb
         +VWpWi4iAblM/W3EkDoMq+JpJFGeJddmEYa2Br5dpwCJ88S+kdmGYQF1l5FsV/rS2+VA
         e9FfzDQ69cYsFL/9J6sQznWqY7C2XP82YJxuC3MXY70sjf7LOc6O+gF7p4fhs835L1dZ
         6wluBEZGAlIL3poifDEowVhwS8mWblaDx5LLIBoMZE6G5wH5Tfx4lTxu4iY2jHqRZEQA
         J6xU6fDA74JzhGl/mElMPoLKAlw/HN659e3sf7/oOfEp7Mjciw6Z9Fg/uZXKwUGeJSW+
         8LIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VWuGOZVS/JSczpAJ6wfhPhGOiDdMMsZXpz771AD/ci4=;
        b=Qv0bCsvQTmI5GPS4QgqMccP2j3EYPWypbKz1XWJejvfSN6hVGb3J3WrpI2N3QNStsV
         awPHXDMNE9ljTeR2iqHSeDgVk0bf5bBQUPuTnO4sNMPFUTc4GU4+kFB4b81NI1VdWy2O
         Xvj/KbGCZbqOGwg6nRzJQ9bvvSMqRk2fbBi1CjRoyHjaIyOAYW08YIIBJR2RQL5pCyHm
         ab1cBVTjRYVVcvcHB5rKQNFYSW2uZNXNVxnum5rwSY22Dvb0PT3yyTt/iH5GN7QBQLSq
         1H+hCs3gpO1iJA/xM3E2vncDPsi+mksYgI06/V9kRO2TKDDJB+y1GB2USSMl538aMBjZ
         mrgg==
X-Gm-Message-State: APjAAAWggR8ei2mi/cHI6ZJfGVd1vnNX3MEQPCxv+UEUJ4WrDE4D7LQv
        4LmDsOBq2WmyWxWQiVWGogmM2gU2J2O0nA==
X-Google-Smtp-Source: APXvYqxjPElYDoKOivgw/upP5i5KA/lZcrgBeUcY6e78qZgBbJ87bYIXNmM73e0WQ+1zmceGj2eNWA==
X-Received: by 2002:a1c:988c:: with SMTP id a134mr12253896wme.163.1581512766630;
        Wed, 12 Feb 2020 05:06:06 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g7sm597630wrq.21.2020.02.12.05.06.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 05:06:05 -0800 (PST)
Message-ID: <5e43f83d.1c69fb81.3be10.3744@mx.google.com>
Date:   Wed, 12 Feb 2020 05:06:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.19
Subject: stable-rc/linux-5.4.y boot: 93 boots: 1 failed,
 86 passed with 6 offline (v5.4.19)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 93 boots: 1 failed, 86 passed with 6 offline (v=
5.4.19)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.19/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.19/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.19
Git Commit: d6591ea2dd1a44b1c72c5a3e3b6555d7585acdae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 22 SoC families, 15 builds out of 162

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          mt7629-rfb:
              lab-baylibre-seattle: new failure (last pass: v5.4.18-310-ga2=
8430b8529b)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v5.4.1=
7-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.18-310-ga2=
8430b8529b)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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
            mt7629-rfb: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
