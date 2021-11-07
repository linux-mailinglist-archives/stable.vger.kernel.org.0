Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53959447383
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 16:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhKGP1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 10:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbhKGP1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 10:27:51 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA46C061570
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 07:25:08 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m14so13651611pfc.9
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 07:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f8XRLFI79tYo9AYTmU6kJJ1g8evd9Kz6JpbsQi1Gqt0=;
        b=vsOH7BwLKUS1/xbnO0WQnUPcSpqDr1IYc8sMuW+RY35wc5crrqW4y3RvPWvTbrlq1v
         TH+TfisADqH1aSSFgAOQKt0MR+hhEnzQKynXoBJk7cUGHSULApCjM2DQ4MRgQWjGjlgi
         DeMZprMRQp84zMHYKA7mS5XPL9CzQZQ37kK31oroFc8uHuiTSsgbgFxegSx3MIOmC0Sa
         215/igWwspSNcwu744SoryaoaMQprTO2eHwgdhy02pi1VHAU6FfSBLHXeTLFKGmCNMIz
         Xuog3fxvPWlC2isyD19WHmWtKADe41gaEZWAOpBbRVTB41AkM171CcwyXAi2NFuLJLes
         La6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f8XRLFI79tYo9AYTmU6kJJ1g8evd9Kz6JpbsQi1Gqt0=;
        b=fYzXXTRqm7uz4JqtzMdrYF+0Kgirs0IlQW8rof7/9fQmJt3UnO450r1/6uqMDZX7BD
         KjpaB51WJMJPNkFo2cJW7vngZlLIK6i4eOl+trFfIqo4loduYdXvkbFMubJaOETL7LUo
         XR0Rw0MNt4VuAyocz/YafkVbSx2kgh+f8Wv0/DBMjrTTmdx7kanjjKkNqoQr1OJr7P6P
         kG/JLv9MLd5kVHhKOqINKGRvd9AW+8MxIR0PSo863b7BwfaFB8DDDQzlBrkp/oKqpZ3w
         0zD8TVdQjqTXCMba2qjKr2URXMy1ZwMl3wHmI/UJ+nKKLttOWdjRRtJvaPlnRBaF8/NZ
         uWZQ==
X-Gm-Message-State: AOAM53372o6uBsLnyWttKQMNhRqbRjRZaAdpDMSeCkFHH8A1ckiJvEIK
        5qlJNkasYw2MZ0DPVTD2toaaR8vDHo3pXPbq
X-Google-Smtp-Source: ABdhPJyc2BYHtqPcKBIs8rVMoPNwbqIvzCv1uLDUn1PR9anQT4HPyaAKW/KwGUV9uRwSQVbu71JBWg==
X-Received: by 2002:a63:f70a:: with SMTP id x10mr12352380pgh.12.1636298707980;
        Sun, 07 Nov 2021 07:25:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm74328pfm.127.2021.11.07.07.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 07:25:07 -0800 (PST)
Message-ID: <6187efd3.1c69fb81.f711f.02be@mx.google.com>
Date:   Sun, 07 Nov 2021 07:25:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.216
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 146 runs, 1 regressions (v4.19.216)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 146 runs, 1 regressions (v4.19.216)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.216/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.216
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3033e5726834e4c9c8c48cdb2273f33bd105f938 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6187b603a0cfc05ae83358de

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
16/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
16/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6187b603a0cfc05=
ae83358e1
        new failure (last pass: v4.19.215)
        2 lines

    2021-11-07T11:18:12.882156  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-07T11:18:12.891159  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
