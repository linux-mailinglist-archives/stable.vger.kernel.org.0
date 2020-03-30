Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D091987D6
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 01:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgC3XIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 19:08:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40429 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbgC3XIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 19:08:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id t24so9413868pgj.7
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 16:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AJnyvU5vgFhd//Rh2Qpqwxo11q8mWM0eDj9pJ8nwtZ0=;
        b=Zvm/bIGc71KnFuTj/dQtYZA761763yWTY1mlKkkIV5xaJMR9re7WCDrCM9Lt+HxP3C
         JUdmZseU5sSbAy4tSxpZN3RRGb9tN4+/A5/fhsUPPmXi0k6DJjdqdMNUe7cwTs3qMgmZ
         UDzmwarLSO8plz2P1GCX4E639S30pXxTmrrSkvnr4y3RdpoM94bGQ2c2mM0eX/y+48s8
         yvTd9ZOB9jTBwwjV8Pjy8eKhewBhqhEr3WK01kZnC4BJj9CdgAWIN7qGW7zC2A3d/uZE
         TroFMgRHPQqnLPrKZvYU2N8lsPc3fsH5/9+PQ5+9KsYg5jSibYG5rGHLLKSOC9Oamgnz
         45mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AJnyvU5vgFhd//Rh2Qpqwxo11q8mWM0eDj9pJ8nwtZ0=;
        b=JsNe2hZoF3zCO8hSZ98IvNZ3pbJV/YLpT8+gd9o7Gxw0HpljNwbW2RDaEmg/nJIZyk
         C/8xPm9at/wq9u1/l4badwkiX/Qn7CFmg8B/E5rDehTR3tUSolJs0kj1kKUmy0mHtcSC
         Ozb8vIHTXBJNF6w8NrBpbDR4bdKy17lWhy1yTm2rN/VR0mo/sQPfceRFEBwInmZcmJur
         3yQXMe6v0vAmV4mhQ8cXQwMmXw8K3xrMe8UMm7iknF2yQsmX2T+J7g56/P+X/glQSByU
         f5P6q4IjuryV7DqJwfhEOlB8SN5JgQdxEhE0q6xiXsCvwqNvw1RMLZiXmezH1vCpJb+x
         735Q==
X-Gm-Message-State: AGi0PuaMBpcF60kMoLv/pH9QTIoCZ0hYCRTex1m/tonXm5jQzHgrZtxg
        4cslF1a8syorgxJGAVOrKuFlJ+6mlJo=
X-Google-Smtp-Source: APiQypK9UqhvqKekiGRqNatGTfvK8BLImvKgM/AiQaDIG5YwI/5DjpSIRlGKhNJLhLG7G8xEic6R0Q==
X-Received: by 2002:a62:1946:: with SMTP id 67mr1622347pfz.0.1585609695881;
        Mon, 30 Mar 2020 16:08:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm10942702pfh.147.2020.03.30.16.08.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 16:08:15 -0700 (PDT)
Message-ID: <5e827bdf.1c69fb81.d0a2e.20d8@mx.google.com>
Date:   Mon, 30 Mar 2020 16:08:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.174-112-g7d4e98ddeffc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 126 boots: 2 failed,
 117 passed with 2 offline, 5 untried/unknown (v4.14.174-112-g7d4e98ddeffc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 2 failed, 117 passed with 2 offline=
, 5 untried/unknown (v4.14.174-112-g7d4e98ddeffc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.174-112-g7d4e98ddeffc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.174-112-g7d4e98ddeffc/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.174-112-g7d4e98ddeffc
Git Commit: 7d4e98ddeffca219e71f08142a7100e7c16efef8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 51 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 39 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
