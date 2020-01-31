Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697AB14EFF7
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 16:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAaPoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 10:44:08 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41831 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728846AbgAaPoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 10:44:08 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so9130805wrw.8
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 07:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b7XkPcN1RWwjzC2sEn8CAtI8f+AXbmAh5oa+G4pW7z8=;
        b=L+DG1S+HkclxaQd1yqHVz0Nlrpp0eMPpedb/HBXNc8gLlSJcFLlZErDJ2Xt9SydspI
         4CFqAvyEwvxNnsgnMvJxe/10DnArN5hi81/vNlmjCRW/rJUOb8gNr9aF5sdD0PkLPIS4
         yb14GqjD4+fBS9RikVxDAHxk2rhLbZyWMiSfehd4z67gAXOdA0s3y+TlU4pCa/g/peni
         xldK7gI5dw5LExQN9XFsGe9twuhu8ZjK/l5k3SoZnyt/P2jwr11neP7fAczNsSZ0sDp8
         JekimW3KgrzVt/8sr1ymz8Dy39vG3n9ubpQ8rTQhGhH/mrR10L0/fX0vui6hB9wzd4l5
         5eaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b7XkPcN1RWwjzC2sEn8CAtI8f+AXbmAh5oa+G4pW7z8=;
        b=cXl2b8eQ4Q5LesGXPvKAXqG7Cq0npCSS48p/K117k2tprIdrbUPx9T3ExyiKMtOybF
         PeEK3qRtSI2d14YI2De5X7r4tMz0bjkbgy4rD7bZNaScCLrV1rSWPg01eMX9QnMJ9E9H
         Lf6bo+utQ6Jhn9b4c4RxxPGjrZNRS45v4Q2yK2WRcz57TpXdjxwNS0AMiQpjqoInt70F
         8TIMuUQs6+k3LUiN+xDrb/1R049h+/BePffaq7EJrPj2gNVp//ga8b1xaY5kL3Dhd/1k
         tMdGNGYZGvA02pyWFHild3kdx4V2a1hBVPYa9jdV23LiZ8p5tUv6GWQg1pLq+hRy95nG
         iiTw==
X-Gm-Message-State: APjAAAX1g6Dj3LrnmAcnWYvmXC/l9mph46hmjKFczN/w2yE6jGu6Z+38
        /6AX+fuLewK5PqcHkQuWWn8vGWWAfmTsfw==
X-Google-Smtp-Source: APXvYqzoF6eD5NXmNhuzLW9yPOwNw0k4hweFyF5k9GXEgaj+DWStfV94l76EipBbWb0M1ADi24QGpw==
X-Received: by 2002:adf:f64b:: with SMTP id x11mr12593236wrp.355.1580485445827;
        Fri, 31 Jan 2020 07:44:05 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i8sm12669743wro.47.2020.01.31.07.44.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 07:44:05 -0800 (PST)
Message-ID: <5e344b45.1c69fb81.29e7e.8b51@mx.google.com>
Date:   Fri, 31 Jan 2020 07:44:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.212-23-g986b37ed163d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 53 boots: 1 failed,
 47 passed with 5 offline (v4.4.212-23-g986b37ed163d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 53 boots: 1 failed, 47 passed with 5 offline (v=
4.4.212-23-g986b37ed163d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.212-23-g986b37ed163d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.212-23-g986b37ed163d/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.212-23-g986b37ed163d
Git Commit: 986b37ed163d3c83afeaf1b1886e07178e590d26
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 34 unique boards, 13 SoC families, 12 builds out of 134

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.211-184-g4=
75d90ca735c)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

---
For more info write to <info@kernelci.org>
