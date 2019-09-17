Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15FAB457A
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 04:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732031AbfIQCVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 22:21:07 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:32981 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfIQCVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 22:21:07 -0400
Received: by mail-wr1-f42.google.com with SMTP id b9so1409409wrs.0
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 19:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LhcW9/TKB6XyLAhVTn9rMkMBjXlRKkKTpbOg+EWwWRs=;
        b=hgNsVRpIQXF8kdltiRBngjviMk6cTRsHxv1YFOtyGtYFNNvu3YHshQ1Z+6Ptw6RdfG
         htpj6rRYVy5xfaZbfOqc/Da5Urzav3q7rSfwSOXeW/vru4xRhiYkD4tLmjNVek0i6+Wr
         YSCinSHpjYUCU2TaD0tROjLLPz1KwaxZdxdDXYFe8EjdGZ8qW/1n5Gqtyt3SJfabf1Dj
         k80hDVSPabLi73NFFRIQ4DmV4MQwYhDZvAAdv6DwB67Mue29ZKQaRIXU+US6D7X9+cjI
         TNvyPk3FyzdD2wu8DHj/xE+rHKI1O48TemYJKJCG30CNMP3mgb1fY1XskAHdlqz+rkdw
         iQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LhcW9/TKB6XyLAhVTn9rMkMBjXlRKkKTpbOg+EWwWRs=;
        b=s9pDxf8Y8q1kGcSAkNyzvzcc1zuEziC+30AdmG6jTgH2+Q6HXj/MKvFKzoxX41GMB0
         d8FSCQqtcO3/6Osjo1bhA+x5zFgPrH+nyd0CS7KUxDbTw5951IzEOnD4aSqYpA36haYN
         zWG0WulsRGdAPOgItKDPOiJApxWjFOCDfY14qYi2KfE8pINnYBdYx5nRDJiz/2xFTVPP
         tSefcwr+FXXEA4Qv9JKQXZHkRptQwijHWTXFHBhVfW3SSIhiAQ+rYaMkLTD/Uix6qhDq
         S4pdqxYlmprfZh4fa2idA6rIHW1hp7oaQ1YBq/UhKrrg4TwXDRVv43OJDk077BQn76w2
         XWeg==
X-Gm-Message-State: APjAAAXd8qhWIWEwKLOHpmXxdAf2wq0DQz7zczO9mU9qIDx7Txz0Ad/8
        zFVyLieglmKAVhAJMWKDjOzVSTn7246QvQ==
X-Google-Smtp-Source: APXvYqyyyYwbLmdEA0Qm3OmTBNkeQmkjuxsR7s60Yj2RXCbtDeiPnQF4C6aNzFMIaQYRe2La7phw3g==
X-Received: by 2002:a5d:4646:: with SMTP id j6mr888471wrs.173.1568686865079;
        Mon, 16 Sep 2019 19:21:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q15sm950910wrg.65.2019.09.16.19.21.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 19:21:04 -0700 (PDT)
Message-ID: <5d804310.1c69fb81.ab172.3e37@mx.google.com>
Date:   Mon, 16 Sep 2019 19:21:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.144-25-g3b0b9274c371
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 129 boots: 0 failed,
 118 passed with 11 offline (v4.14.144-25-g3b0b9274c371)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 0 failed, 118 passed with 11 offlin=
e (v4.14.144-25-g3b0b9274c371)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.144-25-g3b0b9274c371/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.144-25-g3b0b9274c371/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.144-25-g3b0b9274c371
Git Commit: 3b0b9274c37144cd94043acf4e29a55bf535dce9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 13 builds out of 201

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
