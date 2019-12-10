Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA08117E0B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 04:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfLJDGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 22:06:13 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36512 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfLJDGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 22:06:12 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so18359309wru.3
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 19:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=clRKpPnLLqgy05Inl5cT8jcN7tay2J0HGNa8IitfR1g=;
        b=hOUcKM+sOTrBCQ4yMndIKvjoikOiDGbnyPN1bS7LXq/GqNfZHl9Tf+HVp42N/fJLFu
         Ra489fp8sJTa1JLwWEIimpgNVKh/+dzSR8S+6rXzvzgoZJanE7WJWE93EJRGrcY2GH0t
         auHxWrH98H2196wMIT8GWy9fZt9gxtK2/Ie3CakB3tGbeWlrm1co6mchoWpYxvNl5SJN
         cEZVVlLToCItU5DiCU3Dk2FbatjrulkP5SZZ7ksbfblDDYI3dX8y7QltfcQ8UXscoUVh
         dEzv2E6rtT4oqDxHoCOT8AnAVomJVTcmeLCRj/69ZLM9wEXMaReDbmdJCSu54pmkCaBB
         lPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=clRKpPnLLqgy05Inl5cT8jcN7tay2J0HGNa8IitfR1g=;
        b=kfJvoZLkwASSgQaewxy3OkzSNSVKwKDOl1WH0Ey6Kj82pvj9D8NbqaMRerb+epicBb
         GWtGsu4C9A9oYZA5aH3EUmAx4Wn3HQXVja7ZD8SecjNXc5M/CkW25Kuw9ZTZFATOFqJl
         Y69U4Zazk+1k1rsV9yZvnlvubnPvyFihJpDFlUSKjWo4OJPmHeE9MRzU//d5D81iExK9
         rLJtod6x3aSzi4tHPLf77AZZ04stmXYR4LjzDHlLrewxlSqpyejpytJvzqvCIb7i0HOj
         Avkxc9NCYR6NiqPQCt7qHsw1h2kU/mbOIZ9serI/Nmk0oW68yMd0LI/1BBuBcudlcADm
         OSng==
X-Gm-Message-State: APjAAAWcuKCmW25wAxfspjO6y8tYIIlgkEgHEx+ykfzov4DWXVX3bUKg
        hBt4kvfLbzFuECnbORUP1FTPVESAP7QSQQ==
X-Google-Smtp-Source: APXvYqwlOPinkNBFC4zxrk1b0IzaBWs+LrenjXiFWgPljzt8ggy9oWvXEpLp9LYdf8b0H2AdrWTbsA==
X-Received: by 2002:a5d:6708:: with SMTP id o8mr248170wru.296.1575947170467;
        Mon, 09 Dec 2019 19:06:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i5sm1557458wrv.34.2019.12.09.19.06.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 19:06:09 -0800 (PST)
Message-ID: <5def0ba1.1c69fb81.80e3e.7b8d@mx.google.com>
Date:   Mon, 09 Dec 2019 19:06:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-91-gfcce4e2ef50f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 107 boots: 0 failed,
 100 passed with 5 offline, 1 untried/unknown,
 1 conflict (v4.9.206-91-gfcce4e2ef50f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 107 boots: 0 failed, 100 passed with 5 offline,=
 1 untried/unknown, 1 conflict (v4.9.206-91-gfcce4e2ef50f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-91-gfcce4e2ef50f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-91-gfcce4e2ef50f/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-91-gfcce4e2ef50f
Git Commit: fcce4e2ef50facc12c163a573e5723f22cbcf194
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 19 SoC families, 16 builds out of 197

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
