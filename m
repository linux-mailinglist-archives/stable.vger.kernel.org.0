Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D88B115E3E
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 20:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfLGTgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Dec 2019 14:36:12 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:52131 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfLGTgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Dec 2019 14:36:11 -0500
Received: by mail-wm1-f52.google.com with SMTP id g206so11387757wme.1
        for <stable@vger.kernel.org>; Sat, 07 Dec 2019 11:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UvjQIivJEYK4SBOU/yK2tQr6joqKug2TPq6wAgwkygM=;
        b=TqZxrm3T5wd5NbT0vnXkSBgx7zvTY2Bp/OnFykywXSoMI2+Y4PdH1u9Cpdo4z82ypL
         f5RCAjRYUIf1P54Ml/zQPH8aEyuR9XdZpw1nYRSGfQbBo6HLYeArsJaUEvq1vBJyhiCu
         CJUT1W1G4NM5M3C4RQ1y45H1ds8JxefABN0Ikjnn8xTjzsVBNIut3DG8jGzDqx4CZeti
         vFKndbJsjfNO4B9oxgtkjY23D8aKFsnrwdYSeuSZXI1ZRU9RenoQVu6KaAoFdrx7b21I
         Q6QBGxxIKj1VtmoSXFpk+UvQ75QgTT9BsqGQlk4wXHNLkYHZDWfTibFTQFNpSJUse0eU
         XfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UvjQIivJEYK4SBOU/yK2tQr6joqKug2TPq6wAgwkygM=;
        b=Ny7593sXvjV84Tdwb35FYmCmaVHZ6EAa+2RwXJ3JCSQ51rJsW2ofOFDBhUsoJu2JrR
         CaBgtmLt0fkF2l/WElhpHwzGNd8V2Zg30tZqFWpr8kOhKjv5DhfbtUcasrmUh68C47hH
         DSjs2dKAFCAL4l1sUlnyN1/Pe1sf7k0a5NVlHonAXTEgng0FJsXo7ddImVdXX6iYeDUd
         P8Xu/hhi5Jtzd47j3DPqZOF1d5XveITrbC5IpWvkStL/IC6zM/mg1WldQrOSfn6BrD3U
         e2NU0iiqSWmyWrVByz8g/hFT94oSvJyjRAPjCiZytbgA0obJ6jiByfJYohXYP8DGZvqc
         tbow==
X-Gm-Message-State: APjAAAVR/iHsfFLlReYkoHfxebeiK9MB5dMmJzkeIxi5vQB/OtV8EL3P
        dfXcFpoMMXnpAfGH7yF3rA804frHh3Y=
X-Google-Smtp-Source: APXvYqzTFrboKk9spZuJnGE9J0wna0394sqeNxKGxVs8rHEviAS5Mq5srjmOwReWsm+0MwKJwN5buQ==
X-Received: by 2002:a7b:cb4a:: with SMTP id v10mr16703364wmj.106.1575747369558;
        Sat, 07 Dec 2019 11:36:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a5sm2025350wmb.37.2019.12.07.11.36.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2019 11:36:08 -0800 (PST)
Message-ID: <5debff28.1c69fb81.deb2c.01b6@mx.google.com>
Date:   Sat, 07 Dec 2019 11:36:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.206-76-gdd6cb1d9de70
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 59 boots: 0 failed,
 55 passed with 3 offline, 1 untried/unknown (v4.9.206-76-gdd6cb1d9de70)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 59 boots: 0 failed, 55 passed with 3 offline, 1=
 untried/unknown (v4.9.206-76-gdd6cb1d9de70)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.206-76-gdd6cb1d9de70/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.206-76-gdd6cb1d9de70/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.206-76-gdd6cb1d9de70
Git Commit: dd6cb1d9de70d0efaa3a3bba05a9c857226fcf3f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 15 SoC families, 15 builds out of 197

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

---
For more info write to <info@kernelci.org>
