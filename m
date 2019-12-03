Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9FD1105E2
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 21:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfLCUUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 15:20:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35474 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfLCUUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 15:20:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id g17so5454591wro.2
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 12:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8UXWrM4q6HFC1rm6TrNMSFG8fovh+x3u2949ui+yShI=;
        b=f/+gQZvaqlfE8mFHhwVFPAJYNWfYbunmomNuSi03fuF28LLmP9jkjCj5HAwvMRESiU
         DY/SZqHnT6MgVykYes/CpSdJ8tlUK3WqAT2BGh0jzNxDuHA7FrwDxJWZvPjWEKOEjov7
         bDtsqUHHUeGmThRLFFR5gH+LhSnYiZD6APxMToyePhk7pHpB/5YDTlw+oSYdK8qnu5Yk
         HEbEzumGs3Gc/ytn3TZ28YZ7BW3Q3FuA/kiJ3EGuFagrH/+4zeyloyB4jP1jywG5aWat
         Uxq6+BAi6d2t1Tt2Io9kUFFzAxUc5AlnyLcPlW6NWFCDIhxgtVB0LdbpwthW2a+8hIuN
         Bvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8UXWrM4q6HFC1rm6TrNMSFG8fovh+x3u2949ui+yShI=;
        b=e/Vbd//jNWvUe4JHgbaNAcnGDHCo9KnTqp0DsWKBTMbM3eJTX9wLAfVViVil+tEDyC
         lIKQKJQM/S05wVzYzwKnn8j+CFBJaw66w06h90FYwqMMlpoTq9o3yUMwMErwL03Nh/uR
         SyohRHb6JM/MvnrjaYUnXJzd0aqMZWxvOAfntz0iCiroT95MEdV+uKzQY8wDIeVv20Kd
         QYqqg6orFqSfJHcXZ3yaipEGbJ+VurbxVhZlw6ecGtbQFB+GhTQ7E4XvPNmfOdajtilb
         P+rfRqLyWqDEI20VLf6cKqH/s7VvblM8jy/0CvcphuY5rszRFBYjX0/M++dDwkSd6Q3X
         5AiQ==
X-Gm-Message-State: APjAAAW1J9JIjgE8Ee6vwvoJVH4L6xNh4VUV0oM9Qcwye9pYfdoR9TkS
        1Lus45gh69LYAVunT5hM2l/JOEivsNanaw==
X-Google-Smtp-Source: APXvYqzEEOCcFtUWUC1Jy4a5FGxLa4Lu46ZzidF3vQg2rcWPBK8sDFZ6tWDW9604sAgkQx8YxSZXUA==
X-Received: by 2002:adf:e312:: with SMTP id b18mr7637600wrj.203.1575404430243;
        Tue, 03 Dec 2019 12:20:30 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i10sm5171986wru.16.2019.12.03.12.20.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 12:20:29 -0800 (PST)
Message-ID: <5de6c38d.1c69fb81.f5cc9.ad06@mx.google.com>
Date:   Tue, 03 Dec 2019 12:20:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.205-122-gb1edc48ebb5f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 110 boots: 0 failed,
 103 passed with 5 offline, 1 untried/unknown,
 1 conflict (v4.9.205-122-gb1edc48ebb5f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 110 boots: 0 failed, 103 passed with 5 offline,=
 1 untried/unknown, 1 conflict (v4.9.205-122-gb1edc48ebb5f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.205-122-gb1edc48ebb5f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.205-122-gb1edc48ebb5f/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.205-122-gb1edc48ebb5f
Git Commit: b1edc48ebb5fc9fdd1984994fa538e8bb24188e1
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
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
