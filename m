Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFBF141FB
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 20:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfEES4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 14:56:01 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:44615 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEES4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 14:56:00 -0400
Received: by mail-wr1-f44.google.com with SMTP id c5so14420483wrs.11
        for <stable@vger.kernel.org>; Sun, 05 May 2019 11:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nNQJ0nRWcJjEMLMMb4rlsA9RFtse30GNWeJ1F2GibMs=;
        b=SbMdzF3wgINTKOT+Uf3GujF5PuykRyQvT2CsbhZ2v2myCnBoLEWV94sd+GirXGbpz7
         RqTJORGXyR85Kp/8sJOtPYTGWUefif8m2/B/f4mLMygyPxCne/Nxes6sUPxVCCvT8X2A
         7qT09JtnCzTIh/1YMpmKBZ9n6MncyaGTArVAqxyWsPCnkNRoa+OsGoIOpbGSrKaWgqXZ
         uOkZLpW2ylHFuw37dZTmCw4QN+adwJIKrzQyUrJ4CqYUM3p1ZBSdVje3vZnn7ZwTSN2V
         +BrSn7yR34RLpWaHBbjlwyPjx0wzkk9yM4QXNOuPA/N6SoEiZTZ2LHkM/gfi7ryhaeAL
         7gmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nNQJ0nRWcJjEMLMMb4rlsA9RFtse30GNWeJ1F2GibMs=;
        b=kKc9vOJ1sJ1B9lYOArvHeEgXFgBRrYox+v4Xi3Dqab2KKS+IxfLMVjHxdJZ+fDeJ4t
         JfLBLye/wfmwZqajHtke8nK9OSLiy+10m/5URKdWlfWzesVCWnwGEBliPp0CIuh2tfxE
         Lfh3a6nw0u3VcUmhxqaQJtM0yoegvVeDu/MKKif2vg3EHMUh6CsUFjvv6Bmh3JDe7xxh
         MY7+krSUJYkOGCdw3sKFqttzTcXxkg2HytPDOgY7av1NGiQry72VCtwJxt2hEy/J4zhD
         zouKXrPSHibzW3N3ortqCCJ8lssZrpXosG31m5izc1Uv5AZkjCnuc/7JtzBSd3T80O1P
         9fhw==
X-Gm-Message-State: APjAAAWg/ZtQoSYeBWkKy5hIgkL6g0IRPExmQ3r7flFbdifoA7Uey73n
        SbBdN5W9uvjnzpqM2q97IeTetA/geYY=
X-Google-Smtp-Source: APXvYqz9yuvRqcY4OrBUmWNZtqmBIz80KXXJ6g35jcKnGejRFXPlnTrXsadgOHNndIWOPtnluPBsYQ==
X-Received: by 2002:a5d:6341:: with SMTP id b1mr15348411wrw.28.1557082559091;
        Sun, 05 May 2019 11:55:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z140sm15941568wmc.27.2019.05.05.11.55.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 11:55:58 -0700 (PDT)
Message-ID: <5ccf31be.1c69fb81.8ab47.7e2c@mx.google.com>
Date:   Sun, 05 May 2019 11:55:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.40
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 127 boots: 0 failed,
 122 passed with 4 offline, 1 untried/unknown (v4.19.40)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 0 failed, 122 passed with 4 offline=
, 1 untried/unknown (v4.19.40)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.40/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.40/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.40
Git Commit: 1656b14572090df53ff096f158726c1d1355f5ca
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
