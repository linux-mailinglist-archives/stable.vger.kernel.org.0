Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F519A416
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 01:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfHVXxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 19:53:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43790 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfHVXxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 19:53:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8so6942677wrn.10
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 16:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5VB7I6T8XFnTp3MT/db7+go+R0NSh0iw2JkkuHQGsQQ=;
        b=eF8ZCI0dEuASXiNAwJKwIGR0QvAKYJIydLbXECyQfYG2yK5d8EhUanbabn+D4ZvEup
         pV58u5Y59jbA5CEFB6+w5Covx/QnxK5s/OwRoLdBTppXv/YdkA2WJbKyJWfLhElp6med
         ZNhunyyeCiPxRGiHAToUp7M9YOJFaLxiuk0WRXHFNpC9up6cX4SUSnkRgWyZBVSlckAe
         Mf/1+Y3g4eSxDt0wKjdyQktoEWVsa03GUSviNzppJn07fLqYcGdM156Y26tRqOn8Yoqz
         G7gOtuuplXM+XIhWP+h+rl5LAHDXIkhxK/89owGO6yMqkmi3IlU5e/AVwTjo+mfSLvDi
         ccbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5VB7I6T8XFnTp3MT/db7+go+R0NSh0iw2JkkuHQGsQQ=;
        b=NsPHk3Mf3pionQa7MMU/fJvZz6eBe0AeB1rHWHA1mBtLdNM02fdscZ4q0oY/ccpvjp
         sj1oz+C24Nqx+88kK5HG+kDDg7riyHe0ZORqw0v35WPDKsD1k7bJeljqD6RZ4K1m4+yY
         p8ej6+s5CEe4gXjAvpK70RiO+t3wyYXuOjekA3CN5et7FeS54S26ERLlTF4Q8+OH5rfm
         K5SouLR655m8QgIkyLZ89lnZns8FsyaZQ1cBIO+936Vv8JlUZPEZj/fypwr/KzRYhSX4
         2I+vtwiRFolCOdxzmNzGGiE+xhECyUCJgh0t7O3oOkcYra4kQ6XCI56B+UYsfCZ4ln2P
         0alQ==
X-Gm-Message-State: APjAAAW4Ww/7W44I4mGodYQ1VkDPv0VP1VReGxSqSRe7G9irCb9b/E9l
        NcPBUs3VdbvIYE3OVxLg9IDCD4iDgUxhBg==
X-Google-Smtp-Source: APXvYqzNERnhdd1Vd0+XjxYW6qt1WGk+M5SSQP1ytvFAZrhN6cFoCZP6REIzTweGRDJBcJR0Gh3VWA==
X-Received: by 2002:adf:ce8d:: with SMTP id r13mr1320706wrn.37.1566518003281;
        Thu, 22 Aug 2019 16:53:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c15sm3445704wrb.80.2019.08.22.16.53.22
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 16:53:22 -0700 (PDT)
Message-ID: <5d5f2af2.1c69fb81.b7f85.062f@mx.google.com>
Date:   Thu, 22 Aug 2019 16:53:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.67-86-g1ca4133a7b4e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 127 boots: 1 failed,
 115 passed with 9 offline, 2 untried/unknown (v4.19.67-86-g1ca4133a7b4e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 1 failed, 115 passed with 9 offline=
, 2 untried/unknown (v4.19.67-86-g1ca4133a7b4e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.67-86-g1ca4133a7b4e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.67-86-g1ca4133a7b4e/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.67-86-g1ca4133a7b4e
Git Commit: 1ca4133a7b4ede95223d2f4e85900ad6565ca8f9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 8 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 8 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

arm64:

    defconfig:
        gcc-8:
          hip07-d05:
              lab-collabora: new failure (last pass: v4.19.67-86-gd0621113b=
be3)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.67-86-gd0621113bb=
e3)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

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
