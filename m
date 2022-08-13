Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE88591C06
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 18:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbiHMQe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 12:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbiHMQe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 12:34:26 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75CE140B6
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 09:34:25 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c24so3196028pgg.11
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 09:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=t1AAeOjPCBeGCc6rkBUPKsdtHwoYnJphJmctpASXfIQ=;
        b=2Ts5ZyT5FPKV8XK3hCiOeiSyPQBpQRtT1DqlV2sY3llJbFo8hCb6bqwazBd9sCH6wr
         q4u/5BgwcEc7oazZU+8/PWxw+n8PP4P1llETRy/Go5aF9bdbKqzlf4KI+XeXZ+lQrsWg
         46MB8qwoVH5QrzZsu8xYFht90O6LMrJtfdBopCQSzSmTrUxQJkMi1Aujn+lXapg+WaSN
         HRMwhuxx5uMX0odgm0EbX4n+dizDpsK1DuLjLh79tutgV19REINttX5xEET+Npbrrb4m
         5jzs7bGtEUZWpJSGoJkNYQAqEXpkD8zmcB81LDm7Ozjh5NoiLZw6awWQsXNvPnxM8+iy
         Qh9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=t1AAeOjPCBeGCc6rkBUPKsdtHwoYnJphJmctpASXfIQ=;
        b=rV997qtGP8GAA8kU5UNKOzzra24p1Vc1jYfzAK5ZMOStudXGHrIejXNjp0POZ2GOHn
         B15PylCdHUMCGcF8B8xhYlsm+DMNGU/3mVvvFtOZ5l+13y1Xtk5EXvLRfbfuYhUqC20c
         mvwZqlKioKOnzUv0XEygTuZ31du204FYzKB1JxESnwexC9p7uaEiMvWru9X7eGc0RIv5
         UmC3niWrTCuedywz+cGJ9CYiJNSf/H6td+a/e47YDh+xmbNFdJnieJBdO5kVdLiZi251
         nVZ1hykXpqApOmcIuDYQLuBKufYLn2rZv29cDK+2m3MQWxiMpIN1HibwVw9JrmhFrUO3
         Rgxg==
X-Gm-Message-State: ACgBeo2fes+NWj2w5GwUgSXKWmKNmHkuu5XzF8etjt+xrksVlRClLZRW
        pr84E7huw7qPyuDDEauBW4fvIhdjzSyQmxHA
X-Google-Smtp-Source: AA6agR5ZO4a/w5RTcEvGFRxvNFWs4RD8zOGaBXPChZn1C1BH+3PU5QAcwqgXFF77nxJs9fTBeixd8w==
X-Received: by 2002:a05:6a00:b4e:b0:52f:59dc:70 with SMTP id p14-20020a056a000b4e00b0052f59dc0070mr9024694pfo.2.1660408465035;
        Sat, 13 Aug 2022 09:34:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x36-20020a631724000000b0041b67615584sm3130739pgl.68.2022.08.13.09.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 09:34:24 -0700 (PDT)
Message-ID: <62f7d290.630a0220.12e1c.51d7@mx.google.com>
Date:   Sat, 13 Aug 2022 09:34:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-55-g185ae35b285f0
Subject: stable-rc/queue/5.18 baseline: 143 runs,
 1 regressions (v5.18.17-55-g185ae35b285f0)
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

stable-rc/queue/5.18 baseline: 143 runs, 1 regressions (v5.18.17-55-g185ae3=
5b285f0)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.17-55-g185ae35b285f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.17-55-g185ae35b285f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      185ae35b285f056f84404d47991252678b5ccd52 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62f79f7e3ad129900cdaf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
55-g185ae35b285f0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.17-=
55-g185ae35b285f0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f79f7e3ad129900cdaf=
077
        failing since 38 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
