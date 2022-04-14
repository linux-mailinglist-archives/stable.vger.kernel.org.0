Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8979F5019C5
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 19:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244300AbiDNROx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 13:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245288AbiDNRO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 13:14:27 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5149193
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:06:34 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q12so5259215pgj.13
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+19nkgyXx9bld/lLpW+PS48JNrHmFjQYJw8WWIMZ8NA=;
        b=hj7SAVvvswqsthXkvA8IgjcG1mSVF0msbAZGvQ/A89yJV98oXQ8aZ2BFK/fHmGxIDH
         7TbZvvCTrjy9jRyfGkaqrA5/0Fjq5fqJUG6Sobf4KVCmw6G2mJfQUSW1yBx1Vh8qbFL0
         lk13OQCSvkZVUh1itVePENq27zQhCrUg7P8vU6ZhICuR4nuepausqrYHLKUdewnVQNDz
         nSe/7DPE4dDRshD8H5ALYNuFa+QeAl4eUQYyzouPDEgmP+lrUxrjw5QUcp9i0l+rYz0a
         x6/kcQ3MehZA6nP9QXuEEE9CaQ3foFaJse4FBp/tPIXGR9e6vXpOOJaOarjeDCMKGzFm
         LoGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+19nkgyXx9bld/lLpW+PS48JNrHmFjQYJw8WWIMZ8NA=;
        b=T9TCrkplwy4oKbqq6XddhGiCC73q8iRYZVjYk+K0gjEUND9jukIu9iqjUhv1vw7uE9
         vkRKEgatIBhHecvjTt0OyJmsSECGr4ucuqwcWedWdRQaDDLxMmD3R25KW2X0Ioj+mM1R
         4nja+IsbFqk1REm6jFHIIoRpyvLl2/7sdryWzIRYLTPLb4GQo8tt6llu/xf+w6sodbps
         Ou4HjTtAmss5lNEUi4MvRquzL7ue+kJIgzoeuFO2guYmfh4irtEgettlzJi1Vviy2j+S
         sta1zpxOaJYU5umRGbsoYTUvTWGFRfzUDeV3oT47RZWlN33IA3v/o4tKJ5zldWpaXsYB
         qSxQ==
X-Gm-Message-State: AOAM532Amhvp8WsG01NkMqI8NiSzWKMiIbeYhuyQxlITXGnceopqKIpF
        uiWMhZ/eWjrrR8t7XZJ7zYuO6p4vwD/kRDDL
X-Google-Smtp-Source: ABdhPJwGXNrFIuhDgWt2JwrW3K5M96nsZMBY3TW7KPwLNWUdx25SN+PNBZy6jEDMjZtcd8GDQ7dzEg==
X-Received: by 2002:a63:6a88:0:b0:398:7866:5ce4 with SMTP id f130-20020a636a88000000b0039878665ce4mr3050003pgc.240.1649955993962;
        Thu, 14 Apr 2022 10:06:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9-20020a056a000c8900b004fb37ecc6bbsm452098pfv.65.2022.04.14.10.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:06:33 -0700 (PDT)
Message-ID: <62585499.1c69fb81.e7bc5.1b25@mx.google.com>
Date:   Thu, 14 Apr 2022 10:06:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.310-201-g648912430d4f4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 66 runs,
 1 regressions (v4.9.310-201-g648912430d4f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 66 runs, 1 regressions (v4.9.310-201-g6489124=
30d4f4)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.310-201-g648912430d4f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.310-201-g648912430d4f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      648912430d4f4972f32ea481b0a797d709a03503 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62582420ee77b2780cae0680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
01-g648912430d4f4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.310-2=
01-g648912430d4f4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62582420ee77b2780cae0=
681
        failing since 8 days (last pass: v4.9.306-19-g53cdf8047e71, first f=
ail: v4.9.307-10-g6fa56dc70baa) =

 =20
