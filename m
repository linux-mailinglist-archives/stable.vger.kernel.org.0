Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FF5145A22
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 17:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAVQqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 11:46:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40071 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729075AbgAVQql (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 11:46:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so8043800wrn.7
        for <stable@vger.kernel.org>; Wed, 22 Jan 2020 08:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FE8hokDn1ACjLB7MDWj7eZCiQU3VA9lb943mLt50rLY=;
        b=WN0ItCScts97q7cRmmxH45jJKbJOMKkoW6oE3J0ky8o95CjoZ+Vofa765bPPF1lZcB
         Y9bk5dtWYhC6RUIuXeh54N7V2gJUZ5WHv/p+/buK7OGOa5Vh1yNiTGw0eWMtGZf5Jozj
         EVgwHfYOIebecp/Wh3Q+DDn6hzbIZw0Z5UZ4M722Lokfy9OQWvscXzGP/qCMCVLwKj7z
         wMahx8C6lnER1Ox7xOxY+WV+xodZBhi3LD6OKDGJBEN64HWkz1uidAbzOAAUhkn5XpEy
         USQrmZ+10vT12GHsSRVWFTtTqn5l1FHcOWfU/Vy+40vWz2d4gaAtfbrSCNP1Z6iMKboc
         mnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FE8hokDn1ACjLB7MDWj7eZCiQU3VA9lb943mLt50rLY=;
        b=XQF6eFw9pYjYItW8sjgou7LAKsbjW8x+khDUCPODR3WrROweRxEqwAmIasNkwqI9Tr
         9rkHCq049Sx+gxJOmm+ymt0U5OTb4YdIkgmf+fBIND+j5HjwGDKDgzIj53glYA0dKGuf
         0YvQTnaLbr+1Z1dmpRRpoxdF/BYMlVQQNgOgVtKPMm/ID+PuwNBVrEWFuuDOZdLXzFCP
         Vq5+rcRcpX2UEzbIO022MF9Cyyv9mARPX/9es+zRRkyL4ENig5MsQbmFyV1y1s7XecQF
         H3iPr2hBsQc8UOydyS4C8GSXLcjpS4esHH6iYR1fVqkZZBy+YvKorJIY/w+FLFZK/Jqh
         Ifjw==
X-Gm-Message-State: APjAAAUOYRcWtoRND1+VrWrPdAwDpG0Dgpb3MhHJRPnlJCzV9APaI21Y
        cVKjCqpPF302MgO8T5qh0cNtpQ4jAMkfvg==
X-Google-Smtp-Source: APXvYqyoWrYuNtxktdjoHWtk5zzlLyAnl8+cBAy6GQeTDJjF6uBhbtlPsXmTJmLZ9Ns64uW5UB63Bw==
X-Received: by 2002:adf:fd07:: with SMTP id e7mr12094425wrr.21.1579711599751;
        Wed, 22 Jan 2020 08:46:39 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f1sm58626943wru.6.2020.01.22.08.46.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:46:39 -0800 (PST)
Message-ID: <5e287c6f.1c69fb81.77708.a2be@mx.google.com>
Date:   Wed, 22 Jan 2020 08:46:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.210-77-g14fe1f1189f5
Subject: stable-rc/linux-4.4.y boot: 83 boots: 2 failed,
 74 passed with 7 offline (v4.4.210-77-g14fe1f1189f5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 83 boots: 2 failed, 74 passed with 7 offline (v=
4.4.210-77-g14fe1f1189f5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.210-77-g14fe1f1189f5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.210-77-g14fe1f1189f5/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.210-77-g14fe1f1189f5
Git Commit: 14fe1f1189f56887f53ae61e2e3218be16f0c2db
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 15 SoC families, 14 builds out of 180

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.210-70-ga4=
3a787c971a)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.4.210-70-ga4=
3a787c971a)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
