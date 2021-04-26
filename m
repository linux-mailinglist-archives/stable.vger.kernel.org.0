Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9478536ACBE
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhDZHPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbhDZHPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 03:15:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C591C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 00:14:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id md17so1043252pjb.0
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 00:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g4/XZv4TwrUM+RairqvHUK6EK6paWPc4HAFfejtOVKU=;
        b=RZVsorp1VqviTJuF99YGE6rjJ0aeVzfuy0FkoGb/jqCti9CJX+C4hiYR0Wh4meyMF0
         Pghgy0+XXWXJu3zWhOTrgizWZihqdEYG1QDppohUmZ06b91HumUYjV5+kMUouZcikbJm
         nQ3t0nYKHYz7VbpdenUfvfwZRjt/iS7fWkNT99A9ya6Qvg4FcMsc7xfjvTepzzUB9UmG
         LW+U2zD6CRBOZmUMHBP4FRMiZntE4eZar2Ll41CAPY2h4oMfgeORscxbLmptPbxhcvT+
         sOEHUf0eQ4i2QTZsQv9JRyZhUVTGA0h/0t30Gr6GG7v8+wZ/TDsD+7WFr1HCg+GvD9wb
         2qaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g4/XZv4TwrUM+RairqvHUK6EK6paWPc4HAFfejtOVKU=;
        b=Ehe8RNDSyuYGlMh9R3L7nA2CiJDrJ4ULQh7bbfN4JoKwRvmtP7Kbgwq9SXY1nncLIU
         uau3JNaGAiHvLdFNGyyaK+rfn1jQRKIbRShpWN2fHw7IpSE6lyCWxqin3PMic7Ha+Yyl
         gj5TytnbrauFHtzLtkMcCLsfm4ifBJdsOyCAq3veWCrQwsmXWApwtc7a5NPyMvSKdGjR
         V5791V5RDCWfupPm8qX6hfvIoCWsaaaQpOdiHFtdsovnSIJGtbGT/g43LFu/8xQb+Lhc
         PuM7Kv5YhOViA7bSku17rb90JwOVodzHmUUtU5cXzlj2g236yysbl8F1JCtoAYo+eKKd
         RpHQ==
X-Gm-Message-State: AOAM532Trh8nXPIR2LBSrkSGq35X4399Y/pwLhIMlmcKEeRO6I8EnD8k
        Ikn/L8wOoE7UzcetK+r1+YXOPk5y4aTAHxsT
X-Google-Smtp-Source: ABdhPJxdlT1OWKQrrWLYozN4lMI7FJn0uJOXMMXYJzg54cbguEZZCxdo1Ack9ePUeOSwg/uNUTZTRQ==
X-Received: by 2002:a17:90a:e512:: with SMTP id t18mr19847533pjy.34.1619421297756;
        Mon, 26 Apr 2021 00:14:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q3sm10154460pfh.43.2021.04.26.00.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 00:14:57 -0700 (PDT)
Message-ID: <60866871.1c69fb81.670b7.e409@mx.google.com>
Date:   Mon, 26 Apr 2021 00:14:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114-19-g418f75ba54e71
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 157 runs,
 1 regressions (v5.4.114-19-g418f75ba54e71)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 157 runs, 1 regressions (v5.4.114-19-g418f75b=
a54e71)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.114-19-g418f75ba54e71/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.114-19-g418f75ba54e71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      418f75ba54e7142ae4aff2575f6be49fc874af9f =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60863844848928f9e09b77a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-1=
9-g418f75ba54e71/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-b=
lack.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-1=
9-g418f75ba54e71/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-b=
lack.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60863844848928f9e09b7=
7a7
        new failure (last pass: v5.4.114-4-g891d34abde42) =

 =20
