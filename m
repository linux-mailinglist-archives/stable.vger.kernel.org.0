Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD38BCA78
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfIXOoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 10:44:14 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:34508 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfIXOoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 10:44:14 -0400
Received: by mail-wr1-f49.google.com with SMTP id a11so2295446wrx.1
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 07:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QjYR0VrIeX40jwmaewnyllu/PvowUL7u1RFxbTjm7GE=;
        b=thPA1iE/ct9Us9z/ptJO6d2oDQ5eKgTtCRryQ5OnWuGtbdHUjP9ZtSEIeKB6PjhP03
         1qgQny6xgSxpNcVvzjgp03G1xVwo46VwEpk0wPPSGZWjat6yI3lCTPXTdxVifMUeXne+
         Y7EXrflrLA1VicZeh06IZf3SNje/kQ03f2Gs7bJ8Q6TT2IVwqnrZz746KqA4Ng0T7YDU
         zlPQzqXJpL3CLzdTc9a+OQhE7yg8/ZTUmYVDKwwNdd4perZWpUBhE4mE7oul407/C6+k
         rvFVw04WoVLngG9mZx3F957puCZU2ziP5yWh6nicyI5mYAU+a9+0I6rNs7nJsR7VMIVn
         NHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QjYR0VrIeX40jwmaewnyllu/PvowUL7u1RFxbTjm7GE=;
        b=Vps4CB4v5lMOs6PZGAbQOyffmPMHekX4JJsrMoLNH7KuCKjC+AZGk44197Erw+LYRJ
         h9BbYzaz9UY89Vn2CsOW2E4qoVTTmWq7OHH1kV2kBa8v8lKetm5A9xg/bQRmSlCN/pug
         5wx5fqzMscJYUepIJ/o4UfPR4Ac/Jema0kEb7VFgnjAneh6PceOj3RatxS1urZFlDQ00
         uTKFh/FiaXH/mPfRiBYIzLjjsThvuTO+FmwJ1pnCKpNRUOyVBWHaCMqdtk3lasxV0LSZ
         NIqGsfMUWYNoYkAfWRZTRUlCReUCmKrAlscZC5LgspvO04K695BvtzZKPdd5QBUXPCw5
         9Iqg==
X-Gm-Message-State: APjAAAVQTmmhfBMD1TU0Kr6w0B2W1tsa6nAElX8wEd/Gbv/eNw4uBbFx
        UDEVbaZV2ZD9+kbtjecdeA0WhxsafmVfhQ==
X-Google-Smtp-Source: APXvYqzXO7T+R68wxyYmbO22S7wUAkZOd1WRk7t5fOjy92N6/g4HoKcP84vyYDgvsanyNHDoOafsDQ==
X-Received: by 2002:a5d:46c4:: with SMTP id g4mr2937742wrs.189.1569336250329;
        Tue, 24 Sep 2019 07:44:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b15sm330121wmb.28.2019.09.24.07.44.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:44:09 -0700 (PDT)
Message-ID: <5d8a2bb9.1c69fb81.2d440.1b59@mx.google.com>
Date:   Tue, 24 Sep 2019 07:44:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.75-13-g98afa0de4567
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 128 boots: 0 failed,
 119 passed with 9 offline (v4.19.75-13-g98afa0de4567)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 128 boots: 0 failed, 119 passed with 9 offline=
 (v4.19.75-13-g98afa0de4567)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.75-13-g98afa0de4567/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.75-13-g98afa0de4567/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.75-13-g98afa0de4567
Git Commit: 98afa0de4567ef3ee35e66ce508afce5f51908f5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 16 builds out of 205

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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
