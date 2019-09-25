Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D34BD5FB
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 03:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfIYBJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 21:09:47 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:51087 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729301AbfIYBJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 21:09:47 -0400
Received: by mail-wm1-f53.google.com with SMTP id 5so2559566wmg.0
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 18:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vQl/1cSABjst50a6xAP59f9hRDArHtHhRT/T3B73PvY=;
        b=Ti0cKtzicVFMdZrUFumP8KyTy0ZKeW5AuBUX+MhFsgkrD/fYuqxEreOGQlTLaail+F
         rlUTJtLlXLB32wT9hR5hDqzlehrI/Jxdk/E92P0CgwJcFZoEG4yuajMmryeYdYyYES3H
         0zPqODd7y1yQkaws8m8x6U0cF19vqFHCZJFIPoZkYKGnGg6DrBbgQFa6TZ54zgcjH/8n
         Sd561v2Ka+Ltdvj2J/9Pn+nCunIo+qlS7RwSQ5S54ubFHNrb0R0DBS32XyV2Gh0G7qMo
         VmkTVe8BGCnT0hThyCfC0IfaNrLtjp9t5wDoCbSif27xRGDmbuKbD14+AjV9ZhtEzEoe
         JZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vQl/1cSABjst50a6xAP59f9hRDArHtHhRT/T3B73PvY=;
        b=UPp/m3QmOv9puRicPNt43wYSvHSzGMxDuTo7iflfVHyrPEe4CcQ9ufeb2mnIYNE6lF
         1Err7ztxJq6hs5uUpPq55vizPQlP4vkvvVvYbnnlYqPxSqry1uwFn154J+UamfjlKpF6
         bvubsi8Jn4yIRyieFi4WbOFtpdFiGalveylUJ8zjFc3GYbMAw6s8tfd6WC/vuF1yB5lR
         a7RnH4vSHoRKBu0mDPpIWPgsKj9h4k5S8kcx68Gjtnef+2/1HU/2zQjiRGokt9a5+Pg0
         CPzMEx1JSYT26MW9GBNZ3HTs580/mMXuSaq2vLFmQTU8P7uRBYvGv95XRd8FQJg5ZNJ7
         +s2A==
X-Gm-Message-State: APjAAAWiPc/+dbDHJtnqd87fUpw15lIbbXGa0eKyWuxIHL/VXfWGB+Mu
        h5XstbtnfJK/6xX/i2+rSZCs6SOTZBgUmw==
X-Google-Smtp-Source: APXvYqxyzK+OlWCXfpSoKqrIeDxZHiW6ic6IOXucb2biokrNlORFkJa8x9/rytRkk1xjBtMkrN5ClQ==
X-Received: by 2002:a1c:7914:: with SMTP id l20mr3862389wme.155.1569373784097;
        Tue, 24 Sep 2019 18:09:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b16sm5376867wrh.5.2019.09.24.18.09.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 18:09:43 -0700 (PDT)
Message-ID: <5d8abe57.1c69fb81.b056d.acf1@mx.google.com>
Date:   Tue, 24 Sep 2019 18:09:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.75-27-g8ea7c3038cf9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 130 boots: 0 failed,
 121 passed with 9 offline (v4.19.75-27-g8ea7c3038cf9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 130 boots: 0 failed, 121 passed with 9 offline=
 (v4.19.75-27-g8ea7c3038cf9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.75-27-g8ea7c3038cf9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.75-27-g8ea7c3038cf9/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.75-27-g8ea7c3038cf9
Git Commit: 8ea7c3038cf9db88535d568c00db41402e5b2e7e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 24 SoC families, 16 builds out of 206

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
