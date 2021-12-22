Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10AB47D9B3
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 00:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242892AbhLVXPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 18:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243028AbhLVXPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 18:15:19 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E815C06173F
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 15:15:19 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id w24so2931770ply.12
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 15:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oCTvFYWrzThBgXvudZJZ3a2ta5evCuGBBpWFkTMVUzQ=;
        b=Bz9ereQ9uJwIe9ZCGdtO70n6CQ482fW0GrC8q5Zql2clnT6i9Mbap6I3pm0Swbw0Ej
         gnGiiWn//VDybVih/3a5gyHq2G5XQtCtJNY4RWbf6w213lovlWgy4eqiEub8qiefObGZ
         uYLaG7zLqKqaWH+zVkYGJQ+mH2lcINmbwfpQAOgvAt+stYjUdwB3a6TFxR556raf9X+r
         YpeZO2fdlOS9f1cz6b0QWfPR6wXyoCgeqH63tzTmeMCCGzecN4GBGq5ynYMiLP2lzmWW
         sVz1QVOBTuFQqrjgyfSZgUWttjw5rJveI+s9RC1V3zZBdx/g3ZKv2fyXVrPRhzVy2FDo
         B7XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oCTvFYWrzThBgXvudZJZ3a2ta5evCuGBBpWFkTMVUzQ=;
        b=nBAu0JBgV83eyefI93HyFR1hrG/qcWfRLHGy1hhqDiaQqQoX0osvepljbTl2TiNy9h
         L2wLshkthyRzwD1fik2wOLjU6hlfUDvm6hrvHp6K2WWjE0mv6psITJ9CWh6SxDRvmjdN
         VLjxSM5yqfeFP69VHLvbiqJB/27Oxgy0t+u5C+4njsYJdOhm2u1xpSNwXZbAsHBx+mAl
         sXvYVvEQWz77wi5vNIwdLI59tubilFZzswYbcke9oou2EkRJ4w6tAanjwHU/Z3at/+82
         rsIHaVFGNUJW0qZm1mCKtUm4iCjaiLKgCvqaz98D0yhcKXADKZsfIsJaps9gX5vYLy8g
         LURQ==
X-Gm-Message-State: AOAM531z3zm3kQTfjfa/Y8qX4cBrh0YwPKiiwzCNs2GQhSKW+vjHSx7b
        CXn5llNIogje3hxvnin0nVhTlpn1NVSzw47wzuE=
X-Google-Smtp-Source: ABdhPJxPcONz+/dCAreb0e9wMqXmdH+wSWGr+mgmOWVUoqnED0BrW04CMjARDp7iDPKF9WnQa+hoaQ==
X-Received: by 2002:a17:902:9a8d:b0:149:2033:8812 with SMTP id w13-20020a1709029a8d00b0014920338812mr4398835plp.76.1640214918826;
        Wed, 22 Dec 2021 15:15:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p66sm3514594pfb.142.2021.12.22.15.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 15:15:18 -0800 (PST)
Message-ID: <61c3b186.1c69fb81.158e9.a806@mx.google.com>
Date:   Wed, 22 Dec 2021 15:15:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.11-10-gdd26a1c213b5
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 202 runs,
 1 regressions (v5.15.11-10-gdd26a1c213b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 202 runs, 1 regressions (v5.15.11-10-gdd26a1=
c213b5)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.11-10-gdd26a1c213b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.11-10-gdd26a1c213b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd26a1c213b5ea4044fb1ab4ba2829127eba0506 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c3780ebf4fa349d839713f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.11-=
10-gdd26a1c213b5/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.11-=
10-gdd26a1c213b5/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c3780ebf4fa349d8397=
140
        new failure (last pass: v5.15.10-177-gaed9163d4cc5) =

 =20
