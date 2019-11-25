Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4EC109071
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 15:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfKYOyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 09:54:25 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37308 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbfKYOyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 09:54:25 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so14910529wmf.2
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 06:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+d1esG+mUcQ+8pqjvub1KqYkpyGJV851yMmzk70cQbM=;
        b=c1MS4PJFDYYsH74uKaf3qwMD36j0EUfVG22JJ/nOsE73Ptndt73wfPN03Pi42Q5+F9
         KS2XeB9s+4g+5U9YRfQIWlMNM87JoIvcMZM3/qOIgytdrAzG0louNe/hITeDqzoMPRtp
         olwi/dbKXMr9t1QGRUKy7cqg8O7KxtI+s0qWzRVB76+XVu6ADojCUf6QFvMROUjcoyKX
         0l+SgE4Z2VhcEjxPUMtwcgCj4mjPUNgSWh5SNbpz8c432FvcwgNwMO1DyaVCY0Pids9U
         Tsu83Knr0CoonNa1S8GXhpb0IHiGj6RgtmT23ijRnR8Rmu5J5BxFDhFB7YKDba+csoHr
         UHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+d1esG+mUcQ+8pqjvub1KqYkpyGJV851yMmzk70cQbM=;
        b=SzSg0buScd84kAcnS9QH2/rv4itd85g63hCHnAQd9L8bsNPh3u2iSZtWisAoGVZT1V
         4sZQ6mbEADZ7KPzQmWzwLKSFc+xweEaC9VDtDLNKpoVvoIBv8fNYnUf6DzZR411sRpv7
         GK7h1NdydytsrRCu+LKRrTj+7Q/kKLMumrj7e5X0yXhROlhTJZzywLCd2TTe09zc0lST
         Tn3gxF6esmnuN+UCpkkl4gGmlPr39SPMoogaIRrAfJd+cVOFzTxFqv826bx75IyQjqEQ
         AqUtJnwhed4IlmiY0pliPRaObkzhCwdox4fRyq0P40ejwfpb62mhpshz6EbNmTlWl6Ee
         O6eQ==
X-Gm-Message-State: APjAAAWJ5NqVNWveaDCSI+5etNuGA+l3N8mhBlzULCwWrXHxHsC4wTFS
        UzMzR7kaqIyYmfDo5+28EIhSht3AA2DEXQ==
X-Google-Smtp-Source: APXvYqzVLDhRyZvSiAvU/5EjYlRkmpL5ljv0R1gg+sh/GJzAbGeSJT75e3WJwyMaV6des+oez4CpTA==
X-Received: by 2002:a1c:ed05:: with SMTP id l5mr12113415wmh.161.1574693662780;
        Mon, 25 Nov 2019 06:54:22 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t12sm10348578wrx.93.2019.11.25.06.54.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 06:54:22 -0800 (PST)
Message-ID: <5ddbeb1e.1c69fb81.1adaf.3cdc@mx.google.com>
Date:   Mon, 25 Nov 2019 06:54:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.3.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.3.y boot: 141 boots: 2 failed,
 131 passed with 7 offline, 1 untried/unknown (v5.3.13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 141 boots: 2 failed, 131 passed with 7 offline,=
 1 untried/unknown (v5.3.13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.13/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.13/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.13
Git Commit: 42adce4180734a883f2d9b6cec24446d49c5c8eb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 86 unique boards, 26 SoC families, 17 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v5.3.12)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6q-wandboard: 1 offline lab

---
For more info write to <info@kernelci.org>
