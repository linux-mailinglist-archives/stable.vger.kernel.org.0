Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3736B52770
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 11:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbfFYJDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 05:03:53 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:34534 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730986AbfFYJDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 05:03:53 -0400
Received: by mail-wr1-f47.google.com with SMTP id k11so16946151wrl.1
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 02:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tzUh97URpgYFpwRQTlqmgCp5TksNhs0a93M8cne5YlM=;
        b=CXs3EL+1vj1ZbwQ2wsRwsvW1q4PJAkR7pe/9fgE4l1BGbYfOhqlhCjQiRuoBz2oWUJ
         EA5Layl9FmF6aGct10pOYIawxH7TmQfVEhRO8d64bfj5eSuyEy3dpOhxGFIhyeUEIOno
         iCmxU5QAfkoLpa7rIkABGtgTesf8/UMUNWt0qOTRksMswAv4eVviKwedii9vhD/ioTYJ
         pcwOD8TaVGvjgx2jhOgBHBWkYFNnseeln9c33iNIzChXgt/yIZXpHrk7/pqne2fWp0N9
         hS79gme0am3xP+/OXoJW0Efl7U9jw89/Y3ZcydRvT5xshbsjkUiU6GA2kFYDh+4x7vg0
         DGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tzUh97URpgYFpwRQTlqmgCp5TksNhs0a93M8cne5YlM=;
        b=HPHZ4JRbnwWBmkhOHp6RJDWsvp4YRU6TiszmevmqzuSb1iqSVkjYu2m93JxuhPBSnv
         cgpA0h1TAo6dvNUrIsq6Mux+Cnf5ynm6uRJVY8cjIftTD95tQeFbdJImeoTOUk4NepLv
         xoRku5NyjVVuYd0Kb27qboog5kzUvXSWEepszoXhTZwo2ilqUkWrUOaI3vOyzKs8qT+p
         j3Rto3HsKd9lTR1oaq8K96e+ftbqXnsvka8RFSWOn0VcMQQfDjVjb7DCUZwRHuF8sI0z
         07+NP8MfAMNSa3n9humfahKNW/i65+meItBBUy+rxvVY94pxR9RsQa5WtgHnPw2vbZ3a
         fB9w==
X-Gm-Message-State: APjAAAVO78PMjDBHNCAcgcrThZVClhTzq5azpl9VxDSoHSuQgm/O7RZd
        3EUIKhvHX8K15hHAFVtW5u9fOf+3M5pBtA==
X-Google-Smtp-Source: APXvYqyf47visVJDPI8+EUFZC7cIdeKSHn1wZLhUwHemNLb2VTqPpoM5mzYzT8qrpTe7GVvBvTrrGA==
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr23541512wru.288.1561453431334;
        Tue, 25 Jun 2019 02:03:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t12sm14290088wrw.53.2019.06.25.02.03.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 02:03:50 -0700 (PDT)
Message-ID: <5d11e376.1c69fb81.a06a3.d3d5@mx.google.com>
Date:   Tue, 25 Jun 2019 02:03:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.15
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 144 boots: 3 failed,
 140 passed with 1 untried/unknown (v5.1.15)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 144 boots: 3 failed, 140 passed with 1 untried/=
unknown (v5.1.15)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.15/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.15/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.15
Git Commit: f0fae702de30331a8ce913cdb87ac0bdf990d85f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 25 SoC families, 16 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v5.1.14-122-g81=
5c105311e8)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v5.1.14-122-g81=
5c105311e8)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
