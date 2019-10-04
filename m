Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D319DCB3F2
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 06:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfJDEji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 00:39:38 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:32824 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfJDEji (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 00:39:38 -0400
Received: by mail-wm1-f50.google.com with SMTP id r17so8643225wme.0
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 21:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hlV9gyn1l1BJjzUazFbswkx6yrwk42H2umpTvmZjh7Q=;
        b=QQXKMyFmn3w7ZxMZefE5wEjGnm6y1AoaQhdRQbilaAPYFcMg18s5HtF3YLauEUVVwE
         f1X7QTs0WHW/8RJJXvHoBllBu1MbkVZLTeyHr+ju2/azo9dQmi6fRjpViy3S7FZrJ0R3
         T6xcMop29wQzKF/w0StbHo10MyQJAxPPFsWtJlthUazYfI/wu1nSiqJ4oGVuIMXN0xcF
         wIN0FuIXl0wo82GmssyDBTgALrFr7FfMO57GURxE/oYvZzGn8gJW0a0HBxBI04o4T0ev
         0SFQoHMlbgr96Vptb5twyXWw0k+VT2rbr54i/qgVgSHcAMphtjUs8xcu7o20RBBUUH94
         /CwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hlV9gyn1l1BJjzUazFbswkx6yrwk42H2umpTvmZjh7Q=;
        b=BDMjVQvrD+U5uYbjPvukG9FnoaoBuOQK/3g9EUtQ9diNooJtb3erskzpbqvP+skO/p
         JzUzenKzXeb9IAunElqrhztcW8oEPV43t1/ilSkICliLPLhEaRjy1zigdPWj7UQzBqPx
         G+/lfLSgm+hfGKFUmha+fG1qhgScqCVG3z37m4njNx9HHHJb1yKuane57r+MxHZhAMqw
         HOk8yNupDau7A3NhzdkTySTjAx1OL+1MrMUvHYPCXdO98fF1zNeiJ85hienEW7bbByCV
         hLRDDxlDJDpgWi+dS6Wtbn5Z51U1jLm8/RnHZlESn1g/ZiofD7RM6J1QcKCzgeatnh2g
         LZEw==
X-Gm-Message-State: APjAAAW7j23rtX1mDx+Z8Pt89BvByRb81vkNkGFnoaZgDB+YKdDvKab1
        lCfNN8BfXKSPZ74HAf3ySmrzZv9HO1Gx4g==
X-Google-Smtp-Source: APXvYqxoE67cZItANBjcwGR4KPJpFlT09Z+bNRbk1ki+uj4t4QCw4bSqSXfZuzJEcJhgwTi3QuJl3A==
X-Received: by 2002:a05:600c:2057:: with SMTP id p23mr8969669wmg.17.1570163976772;
        Thu, 03 Oct 2019 21:39:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o9sm10215643wrh.46.2019.10.03.21.39.35
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 21:39:36 -0700 (PDT)
Message-ID: <5d96cd08.1c69fb81.8b8d.f393@mx.google.com>
Date:   Thu, 03 Oct 2019 21:39:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.76-211-g45830aebf3fc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 119 boots: 0 failed,
 110 passed with 9 offline (v4.19.76-211-g45830aebf3fc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 119 boots: 0 failed, 110 passed with 9 offline=
 (v4.19.76-211-g45830aebf3fc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.76-211-g45830aebf3fc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.76-211-g45830aebf3fc/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.76-211-g45830aebf3fc
Git Commit: 45830aebf3fc94937285ed325fdb97043f6b6108
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            mt7623n-bananapi-bpi-r2: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
