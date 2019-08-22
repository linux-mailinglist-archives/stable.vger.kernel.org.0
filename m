Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5DB9A014
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 21:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732926AbfHVTah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 15:30:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38444 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388582AbfHVTah (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Aug 2019 15:30:37 -0400
Received: by mail-wm1-f68.google.com with SMTP id m125so6860276wmm.3
        for <stable@vger.kernel.org>; Thu, 22 Aug 2019 12:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UmTogWn38PLJ5RM1djif2R8zdP7JFcbbHNWFqC/y604=;
        b=Fd6LX2u/L0HQSVXcEsA5mel7SOsKhJh9WrPcHOfl7qhmziKOLlpSck4hRYlRS4hu5Q
         0Y7nhqNuZibaVBjdCaqlpbu57IwJiNHgaXkVjjc96F7GXTfEQ39W0jQouE0HntIUyr6t
         mzNnbL0YlMVWuWWIMNqBxatL8d43qqvrkzyLc+sUIGpN14wXq4v80aw7km4TejdX6hw7
         kB2IpNyD6ve7lW0HkZkY9zjYHdgDcmjZYggX7+/YnAYO+bnBw11VnCqa/9TMjolAcOWn
         Tntt4wuxc/HDibRMPvgQdg4sbXpkqerSaonro0A5n/h4cC1y4PHXTFqDgmcJy+YaVici
         z1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UmTogWn38PLJ5RM1djif2R8zdP7JFcbbHNWFqC/y604=;
        b=Qo/TAOMr+9i1PJ1bjb7dzl+NzSoLNsjOYEU/rzLfdHhBMGot9pcnJ96bdahAN4NJNV
         Co2oLZmR+YSL01LX/Lkf1ZWs+I4+GpW4pmUsR6xtyXSHJjKB3Zzd2sYJKD3QGiRLkoyt
         UnRzFWz/LKv0r8g+8SxfB4j24COrUm5g7/JXhXloGKiwNAjL1FXGPpMC8FwJpbW0BmYc
         x/uXNNs2hf+BXQiH+mGlQuLSduf2PjJMi7ytXr+LCDYN6Af4wBWbOdljvSO4MvM6bfmp
         Zn3d3oIGKixPXNoYdHD4gqDvavKHUzbdWxE3YhFQUK0vvXl7uLq2PLpLJ1XFATHynIHo
         Lexw==
X-Gm-Message-State: APjAAAVVE51/8GgxHLZBUG6Hl8bt8HM1HVZvECOCu+cLVJCsivMkP/rD
        2i3vICzs6XmtTw42fhQXSiaS3MGbAlStUA==
X-Google-Smtp-Source: APXvYqyhuPmj+5drX7WiEu/LuHOYNJtlQwWFIPUMQ8tQqzPkDS5f6MtFq87kswKHpKkWl4AwlA3x/g==
X-Received: by 2002:a1c:6504:: with SMTP id z4mr734857wmb.172.1566502235216;
        Thu, 22 Aug 2019 12:30:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e11sm1432993wrc.4.2019.08.22.12.30.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 12:30:34 -0700 (PDT)
Message-ID: <5d5eed5a.1c69fb81.84751.72e7@mx.google.com>
Date:   Thu, 22 Aug 2019 12:30:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.67-86-gd0621113bbe3
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 127 boots: 0 failed,
 110 passed with 16 offline, 1 untried/unknown (v4.19.67-86-gd0621113bbe3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 0 failed, 110 passed with 16 offlin=
e, 1 untried/unknown (v4.19.67-86-gd0621113bbe3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.67-86-gd0621113bbe3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.67-86-gd0621113bbe3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.67-86-gd0621113bbe3
Git Commit: d0621113bbe36c937bc611248f8f7946f68fe7af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 7 days (last pass: v4.19.=
66 - first fail: v4.19.66-92-gf777613d3df0)

Offline Platforms:

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
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
