Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED74ED2C
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 01:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfD2XM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 19:12:27 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:40953 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbfD2XM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 19:12:27 -0400
Received: by mail-wm1-f50.google.com with SMTP id h11so1408884wmb.5
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 16:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NNRY3/7WHHx8Da3V5HMEo/YLAymhWnqrWbrDq51HPuU=;
        b=Y8gq6xtQtxm/j9E8Y13L7E1MYzg3fYE/HdsUcpshNQfYg5K7v0Gf5r3BQa+aKm98Qb
         Fnq+GSeHoPp++ozPzGzOV7sxxA3gfLUvgyKuJunnMC4V9AAjQlh6ZMIIJWh8l/DpBTga
         nK9sNL4SgosaIuNZFyQ0AIQiD+BubydXwXgza2Mt2gkyAMHEfyfWblG6z/IpEezmYOKo
         3syMZVFu/oVIzUC6xG5wqNI8cVm4PvFmtvYHIoBQ/oYpQyZaZ3Zaft39fMafxgIhI3Fh
         8Ax4AeG8L3MkTwIfTP1zsSUfaqbdbTuqvTOB6snuegAu0kC1hUedpOvFvtxcvvlUMV1H
         G8JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NNRY3/7WHHx8Da3V5HMEo/YLAymhWnqrWbrDq51HPuU=;
        b=eTBitl457Srg+MVI/npO8scjcou/9NWMGe2FOOWRuRKOOdgQ1b8RqZgJOIzU/MShoF
         mi477/nSnHdsfpmbA9nqIZcbo8iZytzufu+NExvjOvEVAXp6Bgux8DwxUP6KA9PpFah7
         3YKGQ72ObjiqqROqaXLckQOUs9uoKUuSERJ2dxd3kSa9ZGlAT6StB8uwLVYGU4xeu6mS
         +N4G7MEe0L91yheEDwnANjDnySJiosJzEAiNB2jRWqTBoHydrK2WJubhWC+21TR55nhD
         vN8z1gF0Z91CYQ+tD6vtKepR6Nh5I1yUJVjc4c8tthb/X0lXqCz+hwc9E46K2LFjh2aJ
         icxQ==
X-Gm-Message-State: APjAAAXK5DrweUbvoemPNPQeusvSgm6/WuKFQ7p04Q0wUB+Al/wPcnJI
        Qhb5bBMLEt6PP2GkpnUtwNR5sXOgLkDIeQ==
X-Google-Smtp-Source: APXvYqy/S9Yq8sgDq4ebsuHZRgtfW0OHZ9ar70WfO8ALNhLg9hu5mVsFpyMIgq9Wt5euVtJRlXmn5A==
X-Received: by 2002:a7b:cc01:: with SMTP id f1mr898914wmh.78.1556579546009;
        Mon, 29 Apr 2019 16:12:26 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b12sm11426961wrf.21.2019.04.29.16.12.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 16:12:25 -0700 (PDT)
Message-ID: <5cc784d9.1c69fb81.994f.e497@mx.google.com>
Date:   Mon, 29 Apr 2019 16:12:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.114-44-g8da3ae647284
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 116 boots: 0 failed,
 113 passed with 3 offline (v4.14.114-44-g8da3ae647284)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 113 passed with 3 offline=
 (v4.14.114-44-g8da3ae647284)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.114-44-g8da3ae647284/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.114-44-g8da3ae647284/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.114-44-g8da3ae647284
Git Commit: 8da3ae647284c0482ca7f8d52cf9869b904fa8dc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 201

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-7
            tegra20-iris-512: 1 offline lab

arm64:

    defconfig:
        gcc-7
            rk3399-firefly: 1 offline lab

---
For more info write to <info@kernelci.org>
