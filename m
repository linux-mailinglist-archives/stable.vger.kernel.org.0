Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73451EC1A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 12:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfEOK34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:29:56 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:38382 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfEOK34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 06:29:56 -0400
Received: by mail-wm1-f43.google.com with SMTP id f2so1930443wmj.3
        for <stable@vger.kernel.org>; Wed, 15 May 2019 03:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eMUqRG6wnu+9hMpz4boHz+9nlRdZM9eljm6cFmYiy0s=;
        b=OLImXAcjdWb2a84YaLBt1KuyYuePNf2U5UX66SoJik3yyqf4PHhs62Icif5aEXBH7S
         p1nRU4ZnVJkCP6dCW5iYp7xEepk5Hu8AxZwqKPFyA5h/9N1NP6GKZ/BmqjUmDczIjBup
         EDU4irE7FKTlUNQRDGAXs8u8xV8zkdokzyG9Z6RsjE6DHxOMmgbUeo/9cjCVE/bzL9Fa
         +gzJlNXoh2EgyjaSVVdscMK4kbe1HZeVMCm4HbzZnuyaE1NaKTDvMpP+9wmt4Xo85FzS
         jMiKZmD5ZSRws2Yeysqf0+PKXY4QQ6Dr+eJVGHrSViH3d6c7FZzf3+7M5bKUU1YM2Z4C
         v3KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eMUqRG6wnu+9hMpz4boHz+9nlRdZM9eljm6cFmYiy0s=;
        b=JYkf6zxyi/5kJ1ENFeVH8dD6o3ekv85PJsQHzTa2h7bW7HDAyRNhEs7b85PEeRTD65
         SeOnLiEQLqsc4vUOXgq6+5O56yLq5EzTKUnDr7FgmCXBye4lKo9iUH36JZW/oPDOyTbr
         PrBmVagXryIbnZKEGDf1Q8RzEQBIIdE8KlKmYYkV9X4dL4168y4mzx386MIqZEfxOqtX
         eBf2fBGWjrPTAFQG8+A5MnYsseIGxoeIlIXLeRpr90t3lnCEBaHun9Fu1m/A+8qgJsnc
         2sKlKh4SErsO/Ug5SaKs7cyByA5PKPRajn74wwVkKoEfRmDpULQN11PQk/O/1CjLupsx
         68Ag==
X-Gm-Message-State: APjAAAVc9f2KzSrFOsiX+YRfH8ImalN87cm7JzMpvK/dB9Pz/bxsm9sZ
        1fDigTTGmwhj9vuAFGTji49n5HlhWh+6ZQ==
X-Google-Smtp-Source: APXvYqz3I3I6YWl9uQJrrt9bFs1DVWfTg6mod9Fr5VrBziqFopv3QEh55XLM72TZ4qkcKz39BZCaYA==
X-Received: by 2002:a05:600c:28d:: with SMTP id 13mr8927388wmk.15.1557916194029;
        Wed, 15 May 2019 03:29:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p14sm1472096wrt.53.2019.05.15.03.29.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 03:29:53 -0700 (PDT)
Message-ID: <5cdbea21.1c69fb81.38428.7d1e@mx.google.com>
Date:   Wed, 15 May 2019 03:29:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.43-88-g685747c7297b
Subject: stable-rc/linux-4.19.y boot: 131 boots: 0 failed,
 127 passed with 1 offline, 1 untried/unknown,
 2 conflicts (v4.19.43-88-g685747c7297b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 0 failed, 127 passed with 1 offline=
, 1 untried/unknown, 2 conflicts (v4.19.43-88-g685747c7297b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.43-88-g685747c7297b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.43-88-g685747c7297b/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.43-88-g685747c7297b
Git Commit: 685747c7297bc01379199b1c647c4f0bc709503e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.19.43 - firs=
t fail: v4.19.43-87-gc209b8bd5e5e)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.19.43 - firs=
t fail: v4.19.43-87-gc209b8bd5e5e)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

arm64:
    defconfig:
        meson-gxbb-p200:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
