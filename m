Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882551564D5
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 15:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBHOt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 09:49:27 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54808 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbgBHOt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 09:49:27 -0500
Received: by mail-wm1-f66.google.com with SMTP id g1so5357139wmh.4
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 06:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ttKw+ZocEqHl8mxcwZ1Vo2wTFMlO1TdpCHugal9D4ps=;
        b=sPUsXoWIz4wM5nVAOEwPY5BDq6ZmUIoWSRp90fQSrXre31AI/SACSr4cOYMXOh7Mr8
         6AhKCAqpJsqdwHFmvObZNMgyffmsu7biz2y+ID435ShRxUnbBsAfUPM8wBvqYOEaVeIM
         wG9Na0LfXL27asX2qAGVbhMl2m8wUQxxQ7TbwF5VeQEnkvnM9tBSS9jTRS02JVmNxSOv
         NitLeVscOc6/JLjaqmOgc6Zda7UGFYJC+PbRkDUXT/jLMoopHsZriROMWOnp1qe5SUql
         TtF5kki8WaiJmnRFpptQp1DLlan65Fh8xAkR8rFWDN4LVMfiI3HO1FcQVmLnApj3Ms3A
         AG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ttKw+ZocEqHl8mxcwZ1Vo2wTFMlO1TdpCHugal9D4ps=;
        b=PJ0So9wXffWq3jtMe8TmIWNhRbeHoUdUqUa1RAiXUb33G9ne8+kj4jwKZ6BGrCTs+I
         iO5ev4tVFjCOf2nMMkDyvtwIswbW96SuolkEQqOjbwv9SJnTJd3C1K4EpahrJy6AgKDK
         PjnHZrcx/CDXm1qBQEeAadRil3SP6QUXHKzoi2CB2k6zAlfll5frg/zXcHaMBDckANCm
         GLw8jt9A0qW5JvrV9Q0Yw50PliNWZ9zg8O57++Ko0eiZPXE7GFpLDFnSty/9ReUuvPL+
         bY8F1iwLIM3ziKZMmEgV756UYJqIBRZWhqDpgfh8MlgxOKkxIpIhKGI6uUXeczKmDT6u
         T96Q==
X-Gm-Message-State: APjAAAVrrSHfAf4Zxiazl5XMQ4wim/S3SmEFh6Oo4TAfAmT7hFW381o/
        fxi4HXK9axJ483ep8KMudvS/uQi7ZPY=
X-Google-Smtp-Source: APXvYqzDm/7twXdXKdhsnmHyiUki55V0FsGnDzMO+mf7r68+8QYRi0qubVhXa6xK4O3ZUnZ6DlN+OQ==
X-Received: by 2002:a7b:c1da:: with SMTP id a26mr4941231wmj.155.1581173364732;
        Sat, 08 Feb 2020 06:49:24 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p26sm7432718wmc.24.2020.02.08.06.49.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 06:49:24 -0800 (PST)
Message-ID: <5e3eca74.1c69fb81.2f148.fd9e@mx.google.com>
Date:   Sat, 08 Feb 2020 06:49:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.170-62-gd6856e4a2c23
Subject: stable-rc/linux-4.14.y boot: 44 boots: 3 failed,
 39 passed with 2 offline (v4.14.170-62-gd6856e4a2c23)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 44 boots: 3 failed, 39 passed with 2 offline (=
v4.14.170-62-gd6856e4a2c23)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.170-62-gd6856e4a2c23/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.170-62-gd6856e4a2c23/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.170-62-gd6856e4a2c23
Git Commit: d6856e4a2c23a709eb0143be5096d095b814c594
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 15 SoC families, 13 builds out of 138

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.14.169-92-gb4137330c=
582)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.14.169-92-gb=
4137330c582)

arm64:

    defconfig:
        gcc-8:
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v4.14.170)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

---
For more info write to <info@kernelci.org>
