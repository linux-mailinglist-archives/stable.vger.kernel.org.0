Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4214039D3CD
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 06:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhFGEPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 00:15:02 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:55009 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhFGEPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 00:15:01 -0400
Received: by mail-pj1-f41.google.com with SMTP id g24so8998954pji.4
        for <stable@vger.kernel.org>; Sun, 06 Jun 2021 21:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hhtGWjnr7Ogqxud9MhzDaSJ2PHvMtDQXf4xywhurKrQ=;
        b=qtp0ZN+AUql/0Y9U61nnl5EhsoNG6D+Abw4I2Ncis3sxGOjVP2i1Z4ekJ8LBmVun34
         tAIOOOAT1onK5DK5H1oANloAPHul27Uh59VcOtDGwNl80ZGhdOZXp4JstS81jD7Go1XV
         MHiLpwadeG6WdlhR/vFkQFhAcPXoB7JHexTOK+uA7afqD4wcszOy58ocOoOnHHiDqJVm
         2LDBZS0w8aDo/JAnqomoqUGu5Ny/wGQd4jJ4gVDJOdJ/RJg03GqJOvrkGVbPaZfukLNV
         8ufpiBv2heKE8R5UsG21c+uNUPRPrixsZ0lPsAdqVLwlqp4S4B4Vsjcrt6hdwklSKOVU
         FcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hhtGWjnr7Ogqxud9MhzDaSJ2PHvMtDQXf4xywhurKrQ=;
        b=MLR5IasCmMt3ii10MfjGCknfyF8HID1HuLQPUcDILyt4iAiT9fWIh+FIRLmthwR7Q9
         gx7oBhmW58opwfXYDxGBEgHAtr3W2KMGSjIMKYB8HgjSZrqBqNIqElNgq0Lq6TFFlWMe
         yvtvP0uBDTcYRyiDeLOqris5rQd1uBU6TYaRZceXeXSbSIV8HBnlyMSDTZCvL7G6AAE/
         iyIVkjZh0WINqLf31Z4djw6MV14hcZjVMnOy7+Z7+0YpSFuaLpUtfO23dovp5+tQJyMn
         RIrsWE0CKkNugHT9uKv9W571i7+H1NUhTZ0P3RSWt+De7OJTEBqbkYLgJC/SCPKcTy3y
         KJUg==
X-Gm-Message-State: AOAM532SzjyR26LcFKtWtyWhTe+km0ft7NxQnWOD5/JXLwG1DoOOmcQr
        BhZypowWMBd4vg5NoAo31e/4skkwWzlUEC72
X-Google-Smtp-Source: ABdhPJwVFuNYwd7BdIa/lCCqywKx4ws+A2uGUKWfQhhdVkG0vUlzw5ggmg63nO3WIxnb5ygVqjOdkA==
X-Received: by 2002:a17:902:c407:b029:106:302e:534 with SMTP id k7-20020a170902c407b0290106302e0534mr15980273plk.17.1623039115326;
        Sun, 06 Jun 2021 21:11:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18sm10560817pje.22.2021.06.06.21.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 21:11:55 -0700 (PDT)
Message-ID: <60bd9c8b.1c69fb81.46d3e.1e63@mx.google.com>
Date:   Sun, 06 Jun 2021 21:11:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.9-78-g2209253d3ef3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 202 runs,
 1 regressions (v5.12.9-78-g2209253d3ef3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 202 runs, 1 regressions (v5.12.9-78-g2209253=
d3ef3)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.9-78-g2209253d3ef3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.9-78-g2209253d3ef3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2209253d3ef3c3d2696502a042422b4d96b0b177 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd67e16c728465550c0dfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-7=
8-g2209253d3ef3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-7=
8-g2209253d3ef3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd67e16c728465550c0=
dfc
        failing since 5 days (last pass: v5.12.7-304-g7ade597cd7c1, first f=
ail: v5.12.7-303-g89387db068ad) =

 =20
