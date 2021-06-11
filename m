Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51C63A4990
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 21:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFKTqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 15:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhFKTqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 15:46:44 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76435C061574
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 12:44:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e1so3339227plh.8
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 12:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c0WasrrCk7mXN785VGKjz5hfC5s68FoGJPodD0/Ds8A=;
        b=fvQIFvafn2CfO2QlRVkhl0s0YpxzLD5G7rg0bv7nNeAfbj7RXOkA7W9mtm6/eJCO+r
         +qH/+n9O0mGyuZfwPbYgRB+4wWo/4njUFdmiUADbW2yTlmhWXCnSQP/bxO+6/ULxwfYQ
         QlCKweruMO/PMKPA3hxiCxVuYKpfDOFTi/CYEERpMCPfTW32tBGDXmMbcPE4a4DWxjaH
         OjE9Hw2XGo53XXVHTOsY4rcFmTQtPy9K7Flo2SKXBPJ6u0/hkG5n8ZOCMkS6jOxaPKrm
         1g+2P3ZrbkljvIwAagecG1csG5H+EefqPkGkLCRzA0Iv3HdUXz+JflpMAML7XuCUtGEl
         e6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c0WasrrCk7mXN785VGKjz5hfC5s68FoGJPodD0/Ds8A=;
        b=AeEpKcVVUZGw5yeSGN25K5mXZIcyZbe4olDUNOwbYs552jwV9VPkVbnp6W+m5JaA5y
         0oSI4IMfetzgQntpzkS2kSltnnSwsn7hnm6ndraX4uAxRxm1DpjcFEi8+c1Zn7WgT6m6
         4dNqc3pQPIdI6kjpxx9q2sBE5ce3OvZ1eQFwUMWjNFD/GARZxfhwdzrr6sgy4NQxV86a
         OG9qtXeV7hA6ULeGlWDa2O+xe4lupj62XqAiF5o1yo8nCmbd64ovcF5AMcRQmbh6APig
         nJe4/jCQKODw5suHGtE8rN9EroROcqIfh4kSnmBzcqqitSYGy9Ptziet5L6/UB5whFIu
         FncQ==
X-Gm-Message-State: AOAM531KA4PmK/zgdm9zqa/aSkrC0ZiCia+AmIgS2ttlsApy/77CQht4
        euZro2giXO7HKnvm7BaRdjTxeowlOXiJPpXf
X-Google-Smtp-Source: ABdhPJyijuhgN9rjB2figCd7BfZ+CXN4mcH0GwtJlK2dARV05y0yNdKZjx5JA7qb6hJz55SN3FnWag==
X-Received: by 2002:a17:90a:f0d5:: with SMTP id fa21mr6183917pjb.4.1623440673728;
        Fri, 11 Jun 2021 12:44:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d131sm6100079pfd.176.2021.06.11.12.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:44:33 -0700 (PDT)
Message-ID: <60c3bd21.1c69fb81.183a0.2b3d@mx.google.com>
Date:   Fri, 11 Jun 2021 12:44:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.125-37-g7cda316475cf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 163 runs,
 2 regressions (v5.4.125-37-g7cda316475cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 163 runs, 2 regressions (v5.4.125-37-g7cda316=
475cf)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.125-37-g7cda316475cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.125-37-g7cda316475cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cda316475cf6857ff8e0b4083d08ebb4ce6f1c8 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/60c387912c48abf4600c0e05

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.125-3=
7-g7cda316475cf/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.125-3=
7-g7cda316475cf/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60c387912c48abf=
4600c0e09
        new failure (last pass: v5.4.125-36-g6136604c7b7c)
        4 lines

    2021-06-11 15:55:41.437000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000126
    2021-06-11 15:55:41.438000+00:00  <8>[   41.728282] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60c387912c48abf=
4600c0e0a
        new failure (last pass: v5.4.125-36-g6136604c7b7c)
        35 lines

    2021-06-11 15:55:41.442000+00:00  kern  :alert : [00000126] *pgd=3D0000=
0000
    2021-06-11 15:55:41.483000+00:00  kern  :emerg : Internal error: Oops: =
817 [#1] ARM
    2021-06-11 15:55:41.484000+00:00  kern  :emerg : Process kworker/0:1H (=
pid: 49, stack limit =3D 0<8>[   41.771728] <LAVA_SIGNAL_TESTCASE TEST_CASE=
_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D35>
    2021-06-11 15:55:41.485000+00:00  x6c2ac786)   =

 =20
