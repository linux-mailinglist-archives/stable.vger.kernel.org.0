Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A0BAFFC8
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 17:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfIKPTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 11:19:31 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:38604 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfIKPTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 11:19:31 -0400
Received: by mail-wr1-f53.google.com with SMTP id l11so25009390wrx.5
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 08:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oGmpf7f74Ew4mYaSnOa+J/fzEvedDE06oirnSY3g08k=;
        b=pfflz4+u9hwMb3DAKKpGAtenDbPWlHauKL2wBcPIVgZzeYYk/YU8eqvLTpcMzt3rYP
         mqkhj43pZlvjGlyM3aJd71C0NURCy6KNe/SZqJxmiyzN9U0qoxu+LrPFGA9t6Dv2yfaQ
         b8rvJRe5iN7ggA0tFwNejtGN6jM9hS0K92J6SfGdNEr6HfP7lSIebKdpCWhFqMiAYnvD
         kQdtlYz0HwIfYiXti1inXPZXPau8fGGwCuiFtho3sjhZ6kSuNljMBv7bajVyonbAQj6B
         PmJLOmd4WbfFQJmQS0zkicvbqwGFnI5nrnZ4jZwmCOPBMncbGavq9fX4nxSiM9/PJ/ME
         m7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oGmpf7f74Ew4mYaSnOa+J/fzEvedDE06oirnSY3g08k=;
        b=BesiVDJhAnWyIBw/JhHYKo7WpJ7lbhKB2esDyCMGZ1iOGhvrkwUZRwaPsiplvrcHy+
         9KZT6N8qbB4Mz9wiuh5ni/Ygw8NphlPAc9x+su2syxohWStinYbF3U4q6SrSkK+MLUQd
         4EpgbYRQSt+VJ9e1c+4nQ35irDHJBUxFjZCFGWfQQTZujapdiZug8S1CITunQhY/JyQz
         cU62rLHSgQ+lTwrFUE78NCxm4xdMfdOu2+dyx6E5RFCHY1/djWUlrOYgmGwK/o/iFQJq
         luPqs9BpptIOqvHx/7+ispgvPl9cBZ9VTNZ4p9VKeEWoO+PaaKLYV/v5V5lPJFqHb8QI
         +/bw==
X-Gm-Message-State: APjAAAW5W+CK5Xebz+2eCAPs7L5nDECsX1Vqi9rRVDCbDL4euwWWJHpA
        NdNzmbGl3g4kF4u2lYqxELdspioOAPfDww==
X-Google-Smtp-Source: APXvYqxajD0BTY2zIocgbbaFxI7kKTxumxDZLeNsGXF8uAlZFEWP03A6PLrpNKbsUgUiaJ7hjNePKg==
X-Received: by 2002:adf:f2cd:: with SMTP id d13mr30194242wrp.143.1568215169338;
        Wed, 11 Sep 2019 08:19:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm27241740wrg.67.2019.09.11.08.19.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:19:28 -0700 (PDT)
Message-ID: <5d791080.1c69fb81.9a75d.35f6@mx.google.com>
Date:   Wed, 11 Sep 2019 08:19:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.192-13-g16ee77790651
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 108 boots: 0 failed,
 100 passed with 8 offline (v4.9.192-13-g16ee77790651)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 108 boots: 0 failed, 100 passed with 8 offline =
(v4.9.192-13-g16ee77790651)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.192-13-g16ee77790651/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.192-13-g16ee77790651/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.192-13-g16ee77790651
Git Commit: 16ee777906517071e80ccaf459debe0f51ba75e7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 55 unique boards, 22 SoC families, 14 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
