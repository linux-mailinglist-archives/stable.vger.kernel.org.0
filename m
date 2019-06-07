Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B93959D
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfFGT3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 15:29:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42289 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730182AbfFGT3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 15:29:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so3210379wrl.9
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 12:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=H5o7ahuj8beM1VlZUYu5wUDdFRRLeHBiUcP6ZZ3QnCk=;
        b=KN9tUDUefjJxLRJyuUkT0oW3xF2rucFg32mnJyMTF8/3m+IAnxpaX7SlUqOeBUU29Z
         I3rqtY5TNv0T8MEesm1wIPMW9PtGcQCd0/egqQ/d4qJ5X7Va3VcAMa2vBU9co+64tLgm
         DeLtFNA7S8RSIehNKF53pP1XuNvc3PNEeuBaTzy6AM0NP0dcQSa6yyu359VTF0tsCJZU
         2Tsg6EVsGs0wvK0FmKygdJp5rXtfqrIpf86tvxN/c9NycEu9LU/DQySwcBYufaoY3gpo
         okbGOBn3fDyboILCd6PPRhOYgFUUIDQP+CNVgeXitW4e7LG7rrpWd8eUfuMeV9i7m/kM
         ht5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=H5o7ahuj8beM1VlZUYu5wUDdFRRLeHBiUcP6ZZ3QnCk=;
        b=i9YKm3eZmWo1hR3wcQey0pD38pkG78Kgv1ppIFpyq/yQhDk3u56Jt66N8Wdc5L3yIV
         gSTKZPfnAKK2Bpmn1YBYO+UsZVeaTUtGc6AHUyOM18iE1j5G4nI9XpXNewBoPy+qRCq6
         TkK8vrNO0tf5gA5fsjmVQUbAwAqUDwnmn4oY3Mn9aafFm3Fijwfox8QdXdlWnf88LSpt
         T3mA9Ec24mUvydyWBgGHN8+n8HqaTIW3srXzfFAVHT1b7UTUzuwQOjHXLl1xVJXa5B/k
         0B4APj/opxb1MzWKhnn25Hd3etK5eGqnkroTZoariupjHITFNk6MOJnfCyeMuzfD6Z8A
         +l/A==
X-Gm-Message-State: APjAAAU8kIbvIGmV/IOlCc2t+kZZ9Lo5mBUuRoi3r4BllWrvVKfHSXY9
        /gEQtbaAGOTO4iTPVfx90d15Vw==
X-Google-Smtp-Source: APXvYqwDjns9p9+7ApO+NuwmaHeLfuoPEXyoz6eN/fa7XFibku3FxruHDmf9wAq2FCwZ9nti9Q786Q==
X-Received: by 2002:a05:6000:cf:: with SMTP id q15mr3688303wrx.52.1559935790789;
        Fri, 07 Jun 2019 12:29:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z14sm4061108wre.96.2019.06.07.12.29.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 12:29:49 -0700 (PDT)
Message-ID: <5cfabb2d.1c69fb81.e6492.9059@mx.google.com>
Date:   Fri, 07 Jun 2019 12:29:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.7-86-g0765c25688d0
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
Subject: Re: [PATCH 5.1 00/85] 5.1.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 131 boots: 1 failed, 117 passed with 12 offline=
, 1 conflict (v5.1.7-86-g0765c25688d0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.7-86-g0765c25688d0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.7-86-g0765c25688d0/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.7-86-g0765c25688d0
Git Commit: 0765c25688d0a4d2e117d61e5771cea2fff45a98
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 23 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905x-khadas-vim:
              lab-baylibre-seattle: new failure (last pass: v5.1.7)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        meson-gxl-s905x-khadas-vim:
            lab-baylibre-seattle: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
