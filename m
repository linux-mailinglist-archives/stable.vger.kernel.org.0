Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4AC825C7
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfHET5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 15:57:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34825 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbfHET5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 15:57:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so74122637wmg.0
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 12:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IHPAEEljQTrBAzV5tT7poCk+fna9a+Mxyp1XW9pMxD4=;
        b=xem1YJ4gLaLUBsMsYU70M0MeJ77uSg7GILlxdFkKf1MZxT3veGvRLr/jqA4XW6IgG/
         q81bnZtuD3xACBtjWpQ/OSjehY91ZyyUvVy+zngRF7zZavqPyrLRW4SKGcKUmueDsPU4
         dnWTtronBbqvzlGhd8mCIuo3OsKlC+gaYv/9iC+YIQSSSaUyYf8Uqv6bHrEe/ZPOnA7U
         sQLNkXK+9+t5prAPNdnsHN/QNxoHU/ude9/43iw4m+isfHrkMDM0bhZdbThhBgSP/hR3
         6B6oT55MNkJnAFrkH0W0bH6+IlfeCydBoOdgRho8VznERCa3GgTe7SkajW9yu8KfKzAn
         byfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IHPAEEljQTrBAzV5tT7poCk+fna9a+Mxyp1XW9pMxD4=;
        b=AQnK7nhvlPpTMQ4LEH9c6G/7vo6XqxmuPcQXCDkp9T2xtNM+c+SOklqrR5GW3m7sdR
         gyqHGtCUfTJM0ygZbFDdeB/4HeiM1ZWzyBDJ+Ay+2aOJvKgw85T88sUBfkNP1R44uzUG
         6/+KSx3aC4sAuE6i6+nHjXt1+GN4XTwjjuMbVah4xVfiw1YNmwdQ9n3wNU84DVvIvLAQ
         BOm9LQdpopC3RbYESVTWkyVETAJXlLMQDL92pJ5RQ8mX0qo4JfiBeFFFurHn61Gh3f+j
         bCpxrHvKP/cBRWkRoBYDtEa4ntHVl9XbiZxgjApVs0hVZmVDbIEvCZn0x4zi72G1i+W7
         xmPQ==
X-Gm-Message-State: APjAAAU7qCewY3ceKDXLrFnBGJqm3ZCTwG7NOMsOFIN0XfGgE0X/c7zu
        cGwQANvrE2EbM8XzDrhH0h74JsdC+RU0hw==
X-Google-Smtp-Source: APXvYqwxVj4JSD/J2KdsGTDI+MZW0JABs/Qrdji//aEhy4M8s+I9tZkYUx3yEDO7GY6DSVvkzcIlyg==
X-Received: by 2002:a1c:e009:: with SMTP id x9mr59544wmg.5.1565035039118;
        Mon, 05 Aug 2019 12:57:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v29sm29811172wrv.74.2019.08.05.12.57.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 12:57:18 -0700 (PDT)
Message-ID: <5d488a1e.1c69fb81.cc400.c594@mx.google.com>
Date:   Mon, 05 Aug 2019 12:57:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.187-23-g462a4b2bd3bf
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 93 boots: 2 failed,
 90 passed with 1 conflict (v4.4.187-23-g462a4b2bd3bf)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 93 boots: 2 failed, 90 passed with 1 conflict (=
v4.4.187-23-g462a4b2bd3bf)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.187-23-g462a4b2bd3bf/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.187-23-g462a4b2bd3bf/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.187-23-g462a4b2bd3bf
Git Commit: 462a4b2bd3bfaa6e11d1e8180bc95324efc96390
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
