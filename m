Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864F31564B9
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 15:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgBHOPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 09:15:51 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43732 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbgBHOPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 09:15:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id z9so2147199wrs.10
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 06:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=am1idh2nVgy1pXwQ62h7jtGrAFuSnD8F+KWUxYlcmXs=;
        b=TxQv0mSchmqS07usCQyjTdP/zhytitdi6QZgmK7AcjLzm/SzDdDSn9uoR+H+IsW8O5
         tI8yeLtHFItNE1zU9DQJ/EPgFVmI0ZcoWRcZ+l1TV2Ddj/sWsYbsQX58G/XKWNu/dpS7
         QQeuIlG0QKSHhATaMHTYH9kHXKj+KQ04HVoeASkQok6QgOVpU3wNu+Wkep6OH2+ZZu+w
         G8VGeeHYFXgN9BBaMUdN4Qg40Uqz6HvtgEB2MJ0PGxinWcvtELnKZ5tO5dmn8wsQtxng
         rp6GSj/F2YBBt8+nUms1F4lHDv9IKj/DIgXTBc+3K/YlZ1R5YAydYWB+28RgCjM91YZx
         9T5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=am1idh2nVgy1pXwQ62h7jtGrAFuSnD8F+KWUxYlcmXs=;
        b=clKuyfHhx2Sri4oyuSMZdn2QjXivcRxQAW8mDkSJmWbqIlAnsJuVtXtFAVLvMXMaqB
         WFpLCkESXQjC6NmKFZzjk5DB/L7o4mw3xpJLhlm3kWeQxoDSxxy1ANSiVVF4JTVEiGja
         k7Zri0mXhEfi9iMjDvYNN+cB43HOwl9nwnEAM+gJ1WKMZpKNeLCv/4hg0yBBXY0nbBrW
         svqvVfAwBAyPXqCCJ3MdK/tXUdKSjYEA5priT0yPOpV3AVyvcWIh7eiF7cU/Kc0GcwxC
         cMz1VMCkjrzra2z8vkbwiaHPthDnCI1xHIX9M3IKeF52nhytDcb4cpM0XOO2CGgoSm+Z
         Adqw==
X-Gm-Message-State: APjAAAWlS7LjJAB0GMhC0wwtjet17KOyySdvHMqaFus+ksLioIcWyzpc
        vPuZNyBpvL1+z2LTsKFL50K6aSZIScw=
X-Google-Smtp-Source: APXvYqz+iU8LTWKd049pLT38m2MDdeIFTYLSHpvRN5g5m5I5MMCiliBimlZS5qwgu4OXhXBCIkhr9g==
X-Received: by 2002:adf:dd4d:: with SMTP id u13mr5940494wrm.394.1581171349589;
        Sat, 08 Feb 2020 06:15:49 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y185sm7836885wmg.2.2020.02.08.06.15.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 06:15:49 -0800 (PST)
Message-ID: <5e3ec295.1c69fb81.2e354.1438@mx.google.com>
Date:   Sat, 08 Feb 2020 06:15:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.213-28-ga3b43e6eae91
Subject: stable-rc/linux-4.4.y boot: 39 boots: 3 failed,
 32 passed with 4 offline (v4.4.213-28-ga3b43e6eae91)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 39 boots: 3 failed, 32 passed with 4 offline (v=
4.4.213-28-ga3b43e6eae91)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.213-28-ga3b43e6eae91/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.213-28-ga3b43e6eae91/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.213-28-ga3b43e6eae91
Git Commit: a3b43e6eae916827423cc6389b593b3532e1f372
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 28 unique boards, 13 SoC families, 9 builds out of 131

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.4.212-56-g75=
8a39807529)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.4.2=
12 - first fail: v4.4.212-54-gb514f5a16f0b)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

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
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
