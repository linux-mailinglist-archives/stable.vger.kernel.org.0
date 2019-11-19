Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE435102372
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 12:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKSLmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 06:42:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35569 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKSLmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 06:42:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id s5so23452186wrw.2
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 03:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=OOyHNGhYPbszP/8mSnotR0PXb3SjUUMEabHp4ztAP6I=;
        b=bDUy7rKbtjb6NpkeAFRGodcB7dkbrHjpJsxRfk0aHVSrFoE+DCl6H6I3Kc9o1ZHn0W
         AyuGpf+gv2fMRJVaajRmdMjjS/6grmflXFTTsJARUx2lhzGwpa41aIfU5kCev9WlE3/a
         FmD/DT66q8pTC2IcGNjsRJfBV8oLejbcmUSpER6nfD/7mEL100n+L7habdjQGU6YxUkG
         BI3YcAJmhR2sH5OPIryLfrtuWuvxhb2bsEg8nVZfA/0AzELbYcfULVHXwA1+PDosC4T1
         J6MDikCO72wizzIVVsnhrFjlGJaIGoYBQGRsw/rVMxEe5L7ifwbky2HZI2f7uGQ8Gj/W
         lhYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=OOyHNGhYPbszP/8mSnotR0PXb3SjUUMEabHp4ztAP6I=;
        b=Y2VjM85UxcdWG5QluVT2N4lujrcC9+RLihY+w1LZUJVE/o1ktEWhC7BxoDcmJJDqS+
         uBX+JhxIWOWoqRR4H6gkqzPqHqJQnP+9kDxF0ogjidi6D+egoJ4zd57vEel5ZShCaCRv
         5ZYiY0Wq5NIIZBUZyK3Dws3r18dR/DZaGb3kAdPa5b0XcDufxOwkWiQTFgXqFZrb90I0
         paUUDcUJltYf0RbE071d85o/LF4yGW+3HZQbBhYNb2AWRNQ6Ht3Q/jh2hUlFgBTjqRbT
         jgnHZgbR7kfjnjZZafDr2K7WYlLto15xqH65dgNzaSwrbViXFukYan2U4Cs0+huOtGDT
         fGdg==
X-Gm-Message-State: APjAAAW13mIiiszV5/WacCAr+hF4gvVO/59R3MuCmCAsUuQqimHQaHB8
        Sw0gCs3EYmP4NSJr09Ydd292fg==
X-Google-Smtp-Source: APXvYqzZywequrqvYbutTtA8C6sH4Cqaze2jel3AuBlQqZj7i+42V1CSFgF0EG1wuu3Wy7K4iqz5Jg==
X-Received: by 2002:a5d:4585:: with SMTP id p5mr18671988wrq.134.1574163728828;
        Tue, 19 Nov 2019 03:42:08 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y2sm2959327wmy.2.2019.11.19.03.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 03:42:08 -0800 (PST)
Message-ID: <5dd3d510.1c69fb81.33d46.e295@mx.google.com>
Date:   Tue, 19 Nov 2019 03:42:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.11-49-g0a89ac54e7d5
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
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

stable-rc/linux-5.3.y boot: 116 boots: 2 failed, 99 passed with 14 offline,=
 1 untried/unknown (v5.3.11-49-g0a89ac54e7d5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.11-49-g0a89ac54e7d5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.11-49-g0a89ac54e7d5/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.11-49-g0a89ac54e7d5
Git Commit: 0a89ac54e7d5ea976ee9de1725c056faa5ba526f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 23 SoC families, 17 builds out of 208

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v5.3.11)

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.3.11)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4ek:
              lab-baylibre-seattle: new failure (last pass: v5.3.11)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v5.3.11)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            juno-r2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
