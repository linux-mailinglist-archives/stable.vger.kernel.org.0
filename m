Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99C268A5FE
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 23:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjBCWSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 17:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbjBCWSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 17:18:04 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC0F15CB1
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 14:17:42 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w20so4735374pfn.4
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 14:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WWtTASYtZUAHOUf1GIgA0bW+Zsp7Xh+c0Mabftf/xc0=;
        b=YsCWD0Gxi9lMi2Pi1KU25QL3V4nhmDHqpQQdM9ufIuhC1YrC/9hSxhiPU2buk9Gx4q
         Bsi/eH/igLDeIk9kfuf42uvje5wkt36NwcQKMisAC1Ylb9RwG9p0vSDNcvsCgFFgrWhB
         CZHrM6++i8Jg/JetjF34P8Xm69jycoJ9ai30t6xiJZgQg8pMz7oCeEH8zgsHEf4qVf01
         N2SjoU7he89ieEnxwmREK8JmgN/ZE6SoA6ZhtXgKFzI5Y4QQshMaZFt7i2fZtBjVZ1f1
         PwouVXFEPO4Qs1SfXBK2sxm8aJN1u6vtG5Dk9C34Ah2FB6jkRcc5llyHFvZv6L/PWmgf
         sJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WWtTASYtZUAHOUf1GIgA0bW+Zsp7Xh+c0Mabftf/xc0=;
        b=1Zz1/zjEeeKF0M27MFBK4ar+C51vAm8hsL8ZzIdYajgF+BZypODWvLFZ7WLyMKW6be
         SVXS3+6OsuoIWw31Yot8jmPUocxDnRcBvvdyOoPLmnmFjnXCslhp11z5nV3CggdiXl6D
         EB/YsCOdZ3WU90QhaymSsSmYNOrZjazfGXLEXNLozlNSa6LyB5eUAUOAJHOY+YPdcSal
         XrvXRWxsBlCWymmIFzydN7CCiNEyzCmcqblgIwEHj0nlpf5eAUNy7bZ/3lqnscsqNjOA
         kmIbWFHZzGl4KWZRWt/Q8TPtIOCsYqahE37Sl6oLTdYE/i7OJ+XMSyKajMT3FSJ/TMWT
         VlMg==
X-Gm-Message-State: AO0yUKWDRfE8uXVhdmeDV9WD5t+zKAF02qs5FmqIEEOzipCZ0PNP+UGy
        ysTN3/f6UdOCSiEDi7Z1XLT+Uuth3NFU34Xkv+gMJA==
X-Google-Smtp-Source: AK7set9FDlGeHCTcXxRi2FSWHA8dNw0BhsYgH/9u2SLvpi/YbYiITUjNhaqnmD7uUqr3KPou+fXZMQ==
X-Received: by 2002:aa7:90d7:0:b0:593:9265:3963 with SMTP id k23-20020aa790d7000000b0059392653963mr11071487pfk.31.1675462661242;
        Fri, 03 Feb 2023 14:17:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17-20020aa78691000000b0058d99337381sm2414803pfo.172.2023.02.03.14.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:17:40 -0800 (PST)
Message-ID: <63dd8804.a70a0220.1c5d3.4ba7@mx.google.com>
Date:   Fri, 03 Feb 2023 14:17:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.166-9-g22bf353b5be5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 132 runs,
 1 regressions (v5.10.166-9-g22bf353b5be5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 132 runs, 1 regressions (v5.10.166-9-g22bf35=
3b5be5)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.166-9-g22bf353b5be5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.166-9-g22bf353b5be5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22bf353b5be554b594e0a5636ed5db7cfe65c17b =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63dd56daec1679e7ce915ec4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-g22bf353b5be5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-9-g22bf353b5be5/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63dd56daec1679e7ce915=
ec5
        new failure (last pass: v5.10.166-9-gcc82e3773cad) =

 =20
