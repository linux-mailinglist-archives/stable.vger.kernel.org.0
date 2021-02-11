Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAEA319547
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 22:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBKVnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 16:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhBKVna (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 16:43:30 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD5C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 13:42:50 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w18so4537779pfu.9
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 13:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WbtoAqtAnyxpng3g+9Y7jS0AVh0WnXSXsIUuqiQW0/E=;
        b=nmmlK/vZW7bCwxpM8aPB6abOvvtwoUtA/uccm4jGzplgTG96/lFNuOkwrmMhIZRC+G
         vsHjNo7TXNfWcdJ8ntEfmyLW/GVsbfXE06efPQk6B1dZSEXJ+/4yvApXuoKcHn7BgQA+
         oNd48JKWNxFiRnQpHLaRMtPv6Gz4maH/BOBqsmtxvLYlq96m4m+So8DnwPRtAbAw8HJH
         2LbZS76GPE+W+iJ4i/oElrC3dwxoZunVTkCcxbpVh/i2jm0kT9qwcssGZtJzFivG7qUK
         fT7QPBsfjs5j/jrw3hNcgSeAe/JGuJJMXZfuwSBbVgGSzyjxZPa91CdlHZcQehIFhkOi
         RGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WbtoAqtAnyxpng3g+9Y7jS0AVh0WnXSXsIUuqiQW0/E=;
        b=jZnRX26T6iEfluap4mh1G9q3LyPCtn5J8QpedqaT34tKnRVm1B6VwKfqtBXd50DbCk
         plLOhmvqWTwTZzfYGwE3hKwS5w2hf4b/8rBO/71Fn4m1cIlgSJIVD25qDc87EEpjdWMd
         lhXeew3ooYwI4iyRQ8VtvylRLcwnwrDh6qhIFLCbjZ9x5qcoAKJ6LJ4fKaed/lZr28dN
         +D/Pu7Nkzwh2P3PNF2AEbToA2YyKNonSiDeafsk7HLshQgR7bmcnplSCChHjXUZ+BkCE
         7iSbUQl5+65ylboy1zmL1x5SjsDgEB3v0UQ+c+dFY8OzLtE3OHZfnVIT0hcB9D0FKPKS
         iuDw==
X-Gm-Message-State: AOAM532EXAGF5YlVS06pcaldj8sQElwhHbY/lo2k3gtQz/8gTZ7UR/N8
        nZEAm+zHH8f/zIv13RXDv20KqLCD4HvUaA==
X-Google-Smtp-Source: ABdhPJwblZv+7qfiCC40bsm6vNbmQ6j3tJwecfXchaySStK6cS51tMkiluolukd2P/gaEiLcrqEvlQ==
X-Received: by 2002:a63:e108:: with SMTP id z8mr111777pgh.363.1613079768509;
        Thu, 11 Feb 2021 13:42:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f13sm8193254pjj.1.2021.02.11.13.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:42:48 -0800 (PST)
Message-ID: <6025a4d8.1c69fb81.e05b.40f2@mx.google.com>
Date:   Thu, 11 Feb 2021 13:42:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.97-24-g67f6acde4514
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 100 runs,
 1 regressions (v5.4.97-24-g67f6acde4514)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 100 runs, 1 regressions (v5.4.97-24-g67f6acde=
4514)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.97-24-g67f6acde4514/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.97-24-g67f6acde4514
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67f6acde4514d447f46de4e793a96d05cf458d90 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602569bd1e0dffddbd3abe70

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.97-24=
-g67f6acde4514/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.97-24=
-g67f6acde4514/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602569bd1e0dffddbd3ab=
e71
        failing since 83 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20
