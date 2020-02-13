Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE82515CDD8
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 23:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBMWK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 17:10:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41598 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgBMWK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 17:10:28 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so8649122wrw.8
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 14:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jea2sP8dGKdVajoaWKqLhJyEyySTIMYiO+2gtVhdfd8=;
        b=uKhvGS9J4Z/WdL9lBP2Qpc2fNXFCfXgpXkaXL5puTgGh6CvbZZCil75UrOa3f9eVJQ
         1gUCa8a+j6DwHW7ORsZu1Tu0FaI3vIQzhtWzzlUAM1PxPxLEhLtciVxxRDQ5Poiqv4cj
         hDyd8foiLj4refO42h3k0J984h2i2FCbFTeAoAaIZ+u9ll9bRyyiUiCz6BIhQCHKCmJw
         axnkxnhPxi1Gds/0jj3aiSe1ba7t9Hl9iqroH6RMIJd+3GjtSg6ugW+a3Dmx6bqhMmmc
         u+qe3tLudZv0RNiXjSuQ4MLzy4j4ySyKee8CIEbNuljo8LDCsn54aaPn3c1+BbJtQEsa
         gq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jea2sP8dGKdVajoaWKqLhJyEyySTIMYiO+2gtVhdfd8=;
        b=eMHTZ8gE8vPHJpG681yL/QUOIm2/bm55ri3HA8ERaSEBKVq9KP+T/acibwZqFp5cAf
         v6VgAJVeJhU9ghnPODZRPtb+MkLETIvlJtk+Bp7AhWVQJ8y4pj1BtfjinaZSo9oGeCaW
         o6zbm0bNv5mUvFP1XlYqDfMe6b5iKQ2Xbkag+eGC61qKxjCWk+tUnjf0jSwSwbIdAQrp
         unMMhIpzAyw9b7J58vdU0YP4DK/Q/sengGEGN5licCCYBjJeQudpb+tYHIpGC4vN7mBd
         C1dGuvfUzypEvpVBLoeiE/UoSwftjUrp4LMxkHFzhGo26QvgRAd7D8abSVYcDRNAqASW
         wOeg==
X-Gm-Message-State: APjAAAWZ80ngq8c10750urn4FD08rNCfCXmO1zL+qPGiWlCdeiNLUnA7
        YiG+auPOZnnIujNXeohwV25p7CP/H86W1Q==
X-Google-Smtp-Source: APXvYqxyWpLd3WoOkwkMlI35FGZEJ3mDd1JxQPfLicu+DACC4PYZZDSwOeVNECMS4bG/qpGZhyv0rQ==
X-Received: by 2002:adf:ee0b:: with SMTP id y11mr23457839wrn.62.1581631827015;
        Thu, 13 Feb 2020 14:10:27 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w13sm4654762wru.38.2020.02.13.14.10.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 14:10:26 -0800 (PST)
Message-ID: <5e45c952.1c69fb81.281e8.5111@mx.google.com>
Date:   Thu, 13 Feb 2020 14:10:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.19-98-gdfae536f94c2
Subject: stable-rc/linux-5.4.y boot: 140 boots: 2 failed,
 132 passed with 5 offline, 1 untried/unknown (v5.4.19-98-gdfae536f94c2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 140 boots: 2 failed, 132 passed with 5 offline,=
 1 untried/unknown (v5.4.19-98-gdfae536f94c2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.19-98-gdfae536f94c2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.19-98-gdfae536f94c2/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.19-98-gdfae536f94c2
Git Commit: dfae536f94c22d5fd109d5db73cd5ed7245a764c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 89 unique boards, 24 SoC families, 14 builds out of 135

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v5.4.18-310-ga28430b852=
9b)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v5.4.1=
7-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.19)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.4.19)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
