Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAAB60E06
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 00:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfGEW5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 18:57:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37912 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGEW5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 18:57:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so1139730wrr.5
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 15:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QVEn7KrV4MC4d5DwoWtu/eGlJHtDsAb3dCFvkXzWhjU=;
        b=14LMAmSl1gQoI9wtSEXEUoyoPuFgrAM3h945vz9K+QYQgcCgGZADkmXllR6Nxm4Ujz
         9SSL3msJBLkiXYmGz5/DZ+ukSZzZvfHcoYlbQOIbq270XVgezWgXpuSkKFhjGvpWmCDC
         M8c6cHH6P02HNjNmQIqmyrm0QwC7k/b9x70dckYAxBBSS7s6uZftCCuzQcSWGhqEr7JU
         Q5s/34MmRknbV+zkSjX3eE100UZ9c7xEsrAiWARUVV6BajWjf6U5skJSweaeumVQkhTw
         cDXNc4W0CFHOayDdtAbvQE0YPtMS/eUGmJFlAyUXC6sJWrnHpDxeKakUFUVDXQY2Yr68
         YDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QVEn7KrV4MC4d5DwoWtu/eGlJHtDsAb3dCFvkXzWhjU=;
        b=IEkzlAiKm4jDlfvrN7jmWV4bFPwGOeQOtpgi+LlT/pkMgB0hPuwcbpazX574flTshu
         qvjtAiogXy1jz4RshHHts0Phgzve9mqoBg+6qOKDKaGRKLq5JYPaUhHJjZ8p/i5vxPf2
         pyg0w7A5/6aPU6JKNduLVihOEN5+T46quTAY4n736RMjYuClhCOwMEEEwJPLPIbWaS/A
         cZ5shv+tztCOElASflwkvajy5mf2GOO3KJ2JVOvOnFysZHvB75EgdOydzPnrIANMJBXz
         9r4tkqMx8UYo1RtNsIvxtcHmnqBYjOeiIjRrVkOuAoGSBSEqmFk70qP4m088fg76u+vk
         K/bA==
X-Gm-Message-State: APjAAAUh8LzMeh/zKnHN/ePiq0AectEl4EevTVVH8hK8Ln1DtVFN0Ff8
        XQ/oevZ5n+4pEQkFLo7To7gTx2Or89+E5w==
X-Google-Smtp-Source: APXvYqzli2xGG+zqlCnj6zqpn4rt+1rYJEd5AXRbIwq1D8CfYPwDUhno1zXVHLQsl+IPqSjkqvsniw==
X-Received: by 2002:a5d:4ec1:: with SMTP id s1mr5135461wrv.19.1562367431203;
        Fri, 05 Jul 2019 15:57:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x17sm7375591wrq.64.2019.07.05.15.57.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 15:57:10 -0700 (PDT)
Message-ID: <5d1fd5c6.1c69fb81.24769.90d5@mx.google.com>
Date:   Fri, 05 Jul 2019 15:57:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-71-gfe65e20604f8
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 100 boots: 3 failed,
 95 passed with 1 offline, 1 conflict (v4.4.184-71-gfe65e20604f8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 3 failed, 95 passed with 1 offline, =
1 conflict (v4.4.184-71-gfe65e20604f8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-71-gfe65e20604f8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-71-gfe65e20604f8/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-71-gfe65e20604f8
Git Commit: fe65e20604f825a6d7cc52db328a767e959727b2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
