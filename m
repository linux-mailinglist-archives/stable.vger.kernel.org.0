Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307A54BBD23
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 17:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiBRQPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 11:15:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBRQPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 11:15:04 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186871FFC9E
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 08:14:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v4so9019603pjh.2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 08:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z88l2NbI3i/KDNsTlpFM5F0Z836sj2rsUANsyhKapzs=;
        b=4zF1mxpA/72Vc5LpK5Hei78RYfTi7rVfQj5uF2TePFtQXM4Y6i9KjCdnsuhRcO2h0v
         IdkAgw2kl+2Gt8GpaCi1HeG+A9UN86kPndi6H5QvbWnyMl1OLwDlzpDYPVXLcDdcjUhn
         nwcmyoh6yjkTDxbUr306JzzaLjsB93+aymVz4Hu/zHoXbe90MWk9gDF3hGy09XhPmpix
         /WM0YfnsDzbPg9BWSejeVOoS11dPbHSNphHAdLobM5Mdk8dGYjw+IbPCZsVHBlHTKd+Y
         at8/dbN4LqwjvhwgtdwWidGwk3XjWnZIyuQCuaOPoI9T1Cqyk3D3D1hc7bNjoZDB3cEA
         sdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z88l2NbI3i/KDNsTlpFM5F0Z836sj2rsUANsyhKapzs=;
        b=0VzAQ8jySSTH0zEM8yfAoKGsyaw/wFsSs2i40QxttpJxGRV8uP9rWhP+KpxFTcngnQ
         35+sz6gWHzzgug0EX3pK7GQCwXP7Q7wwTEIlx7vhAthAihnAob/U4wmh10Rpv0AK5lK8
         caj42vgHBxG9eaWQNvqYUjRbhtJ2RTPxFAbsviV/oeL/ossby5nfflOBcnUcVrki079u
         JjcvEROEiM+33PnSLi33VByvo3oQ9jaONiVqW97QQAOsD1KdoortoGHfDz5b4HKUIWB2
         +JJ4ym30ViTXO0xrtj1F3JxD2Vq7LEy2ovQ75BKt/1TYE76cQvDCHQRkXx/U4VDnhI9k
         0eEw==
X-Gm-Message-State: AOAM532KArZ9wrIz9MBZ9iD20bAnRvS7PleI9Gadfq37i9Nc2BCyyFWG
        Bp3KSk0RKqqK5UE/Ez56Niis09aXceSmhgRW
X-Google-Smtp-Source: ABdhPJxZMz0ZRylmJSLSM0pLRl841OYML4+pBcC/I9rl45pNiN7sXZ1LG9UbGbQFcUBk6s8M2Vghow==
X-Received: by 2002:a17:902:8bcc:b0:14f:2294:232e with SMTP id r12-20020a1709028bcc00b0014f2294232emr7970942plo.105.1645200886422;
        Fri, 18 Feb 2022 08:14:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g21sm3440109pfc.167.2022.02.18.08.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:14:46 -0800 (PST)
Message-ID: <620fc5f6.1c69fb81.5b8ad.9792@mx.google.com>
Date:   Fri, 18 Feb 2022 08:14:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.302-18-gd6fae7820a93
Subject: stable-rc/queue/4.9 baseline: 45 runs,
 1 regressions (v4.9.302-18-gd6fae7820a93)
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

stable-rc/queue/4.9 baseline: 45 runs, 1 regressions (v4.9.302-18-gd6fae782=
0a93)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.302-18-gd6fae7820a93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.302-18-gd6fae7820a93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6fae7820a93dcd80e9858921bd4b4b44d14a6c0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/620fa9440fdf845e17c6297d

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-1=
8-gd6fae7820a93/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-1=
8-gd6fae7820a93/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/620fa9440fdf845=
e17c62980
        failing since 4 days (last pass: v4.9.301-14-gb2fc517490ad, first f=
ail: v4.9.301-21-g8fd7747e1cb8)
        2 lines

    2022-02-18T14:11:58.933482  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2022-02-18T14:11:58.942616  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-18T14:11:58.955003  [   20.345825] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 52:50=
:27:71:7a:d3   =

 =20
