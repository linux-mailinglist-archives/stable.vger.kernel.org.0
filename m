Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B652105998
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 19:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKUSdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 13:33:15 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46664 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUSdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 13:33:15 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so2259161wrl.13
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 10:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LHYtqgJReqi5AMPtBpDUdsHGFliKXRAhQSsOuZKrVDg=;
        b=JB5ep7AEzk2ubUfKyIfU3/AxnK8eqhgp87mYFwk2jZ+5UrKZLkA9C1II6ZCFE+cde7
         Q67zO77q5Snd3/VoXgIUqs4B7sziQ7Q8+YbqdWRMqQCIROGK/Kfs+FAkGBxObzHEf1zV
         NOkq5+AfvOxW6IjQic+q+tTzrHlX5Gt30YMCLE88h3m2wVrzDbaOpGAcglCBnb14rNdR
         ZMMCMbkh9So/ugA6W29IhKqNPFzqIqXmXTT7a20Nh8fhMiCdsLh1YSpKrsJ9S0AUfDr5
         y9KXTqzppxGr8xRCl9/oHqyo7KtE+oUq68HFYSumWUWWuGGmlR8izFRVXupOTUTPlW4n
         EPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LHYtqgJReqi5AMPtBpDUdsHGFliKXRAhQSsOuZKrVDg=;
        b=etVWAABfkCtp7CtGy3o1ik3rQiEhTF8Xu8xERGFcGGgdhkFk/1Y6P/Yxbh7/XJ7vfH
         il7P9nDlYpd8JqwnZrtiahPLikr6StnHatz9q9XcGQ4ln82ylVAs3pBZQcmyO+G1nLs3
         ID/9f6Es/8USCWbCl8BmEYmjPbdahcRzbH2Af3hSUmNWU6LFMDxVWYCpz3EWsj5pzlmP
         NZroIPlyh5NWKIeHPGb6arD4LI6uWqHO2kK9OHP/Rgts2MrWOI9YaBs3DDr9RDJdF7g6
         +Tzdg+q0B4EbEbh1ba8U5F0nwbm1M5u/JwSoveYJiURpq6rBaQS6pNaHQD9MjcsW/aJz
         UXTA==
X-Gm-Message-State: APjAAAW/JjyoBrpuCsJcunsRsvqrWVRH33jjn435zYsfCSNKBx5YhtdD
        OBhTC3ob6JotmJuTRy29ZtAlxUDkfEvpjw==
X-Google-Smtp-Source: APXvYqwKy6wLAuyj0JsqbiFvl4iSE6oWT5iolEwbhpnk8gnJUMEhdqWc2iSbvfsGOKbz2P1VZ6kLew==
X-Received: by 2002:a5d:51c9:: with SMTP id n9mr13377787wrv.6.1574361193043;
        Thu, 21 Nov 2019 10:33:13 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m3sm4171945wrw.20.2019.11.21.10.33.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 10:33:12 -0800 (PST)
Message-ID: <5dd6d868.1c69fb81.7ee5f.51ae@mx.google.com>
Date:   Thu, 21 Nov 2019 10:33:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.85
Subject: stable-rc/linux-4.19.y boot: 136 boots: 3 failed,
 128 passed with 5 offline (v4.19.85)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 136 boots: 3 failed, 128 passed with 5 offline=
 (v4.19.85)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.85/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.85/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.85
Git Commit: c63ee2939dc1c6eee6c544af1b4ab441490bfe6e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 78 unique boards, 24 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 2 days (last pass: v4.19.84 - fi=
rst fail: v4.19.84-423-g1b1960cc7ceb)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
