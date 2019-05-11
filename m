Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFBB1A7EA
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfEKNVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 09:21:06 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:43598 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfEKNVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 May 2019 09:21:06 -0400
Received: by mail-wr1-f43.google.com with SMTP id r4so10545078wro.10
        for <stable@vger.kernel.org>; Sat, 11 May 2019 06:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LU07f7N8j34vDYIV8+3k2KHb6ArBE7seJADZ5U2lXQY=;
        b=sOw2v97ZBrvVgjW6Svzx7xWSFGaNFYOcHTVFeLT/uNT/Jn6AonXCiGLCXt3hPnZ0FK
         l06BbqAaoiB0TWqM/fkInkF6NDu1RrSQ26rRUErwQd6yMpbDhy3yDnegsQgyW0VclcHI
         Lom+RQjv/CAB9BkPt0+5MQhZDX3OUiGXBBTaJIgDciv8V1dHw70LOYoeh1bjWhT8gWZr
         g98xw+b6saUSaWE9SFb4lpDUEYWjaJ/PRZfyzq6lmMcP25ShW4jNm8cNAfLNWiJb/yiL
         fDJIiAWz5d3OLSa1ZUzVSRlK/R9WV4lAIfV1epYUMtUVIGadzpPiZ9Knnmx0j5yARjqv
         Ka7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LU07f7N8j34vDYIV8+3k2KHb6ArBE7seJADZ5U2lXQY=;
        b=JxCiO8bMzirg0f06WEGxOQUG+fo7dXq4XJgUbpj6hB76v4DuNm6kaoESgT2YSd0WBS
         SJbJhaKn6ICpeusaRkWk6IRTja3h4ihmDJXRPtyNnUZfFxQvMt0+zxLqUkERn7km9WsZ
         /5TM7rdefLEwfH6o+yoZFXGas+9yNATv00u9veyBRSV+43Ab9RcVDG75KyQdhoM8ESw+
         1CiCH1zetRPUbkRO9KYjmzT1QlFNiyuZzV7zBXY4/BVuOXnwVlogR22Hm7gPbldzpfWl
         fXXZLcXCS+bBZoxUvcPvyqeOZ5cr/IC9poWAgdWMu7RFSqQMbmSdwWuvBcWeN/kY29Ta
         uTFA==
X-Gm-Message-State: APjAAAXdedmVKbvt2bBamq3UxlUZloLG5/S8V4NuvZJA5Q65mejfVdYG
        eHj6NOUbDpmBJutaqdAZDKPlnO8NBTS88A==
X-Google-Smtp-Source: APXvYqz2C7bzw8K00UDAC/1RD/yCSiTJiLQPVXZbLdWQxMuxQCXIB5PEV5BhefGOgYpDluTwTu5zKQ==
X-Received: by 2002:adf:aa0a:: with SMTP id p10mr2481394wrd.125.1557580864080;
        Sat, 11 May 2019 06:21:04 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v17sm5458279wmc.30.2019.05.11.06.21.03
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 06:21:03 -0700 (PDT)
Message-ID: <5cd6cc3f.1c69fb81.e34d6.adc8@mx.google.com>
Date:   Sat, 11 May 2019 06:21:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.118
Subject: stable-rc/linux-4.14.y boot: 128 boots: 1 failed,
 123 passed with 2 offline, 2 conflicts (v4.14.118)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 128 boots: 1 failed, 123 passed with 2 offline=
, 2 conflicts (v4.14.118)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.118/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.118/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.118
Git Commit: d929572d7da91169d3a22dfb75ede8bdced541c2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 23 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.117-43-gfd7dbc6d8=
090)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
