Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB35D58B885
	for <lists+stable@lfdr.de>; Sun,  7 Aug 2022 00:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiHFWEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Aug 2022 18:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiHFWET (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Aug 2022 18:04:19 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1892FBE0F
        for <stable@vger.kernel.org>; Sat,  6 Aug 2022 15:04:18 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id q14so2801968vke.9
        for <stable@vger.kernel.org>; Sat, 06 Aug 2022 15:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=3jlsjW5ygTaRot4S0Xg96GFWWBubXStD0UrA9oSNRRI=;
        b=WJ0f9IKNzF1KJ8JflKhV74+OIDZj03NiWf4CSIky2Rdd4+bEHHb8aG8zXWvccALltx
         7JNuIGCa1XLpJAAa9PCighxDRo29n/9py+VihsZh80HlUxHzzQlA3EnPCb/M8kNyyzZU
         hsxEhyMRiss2FKqlr0cLVX8ZBnGM0YoZl1DqWtC2q2H7UMXL2izg+aW4Wwv2qNKNzsMN
         8zx3sGe/kN6vdZIgEJqSbBIPYu1HDfLZk31YaGuO9qg8YMGe60Fqb2msiyv69Rn5HMOY
         L8nm11vG0Zjs5hCDZCT2KCkH6Z0ihvSnj83N9IjeaWgyN4rz18u9uPruO1O/3sSP7aV3
         ANAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=3jlsjW5ygTaRot4S0Xg96GFWWBubXStD0UrA9oSNRRI=;
        b=FF0ATdPbED7EaPxfUjuGfG3n07QuVas8AbLiq5BFPI/6CjDCIGyCVa9bVvSsVib/JM
         FxoXhZ725mio0BKy050dMM8wqpOrGLjqgR6yLpbVffc8mHiQiRE1QNhW4WTa47OQHff9
         Us/P66BLnWhjvQifDci+lZqnOMgxVKNg+T0yqag1961p9YtZb3gweYjRcjYxIb4IKUSk
         BycCg1q7UvbaBo7dBmwzofEVNciDPvEhlX30fZHm0k4XPuYxWtgE/GddsllDo1ZZTwMK
         sPuZYHtTRqDE67DsbdwbbFlNWYMK/WOIcwWfIFzrZuvBceigsYfvRCDFAaUvka8SVv67
         OsgA==
X-Gm-Message-State: ACgBeo2os3nRVOsTXBakYlMESjnQk2ivXHD8KowKywFlPc6E1YFI68us
        V4dKtT/sZRc2l9vfK1V8b2xEjBhv5Gs8YM3QJ34=
X-Google-Smtp-Source: AA6agR6yp4qx0/HXQJGyDYdzMudyN1vOXrdpj81TIHeqpg/z9EQe3jYbjpJ3ERvj5tn5uv44ayoR/w==
X-Received: by 2002:a17:902:d50a:b0:16e:e1c1:dfa7 with SMTP id b10-20020a170902d50a00b0016ee1c1dfa7mr12364316plg.160.1659823446444;
        Sat, 06 Aug 2022 15:04:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b0016b90620910sm5611622plg.71.2022.08.06.15.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 15:04:04 -0700 (PDT)
Message-ID: <62eee554.170a0220.cfbb6.9408@mx.google.com>
Date:   Sat, 06 Aug 2022 15:04:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.16-18-gce6949710875a
Subject: stable-rc/queue/5.18 baseline: 125 runs,
 1 regressions (v5.18.16-18-gce6949710875a)
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

stable-rc/queue/5.18 baseline: 125 runs, 1 regressions (v5.18.16-18-gce6949=
710875a)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.16-18-gce6949710875a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.16-18-gce6949710875a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce6949710875a4e819fae09c2ec14d35c8df8f27 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62eeaea45858f85945daf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
18-gce6949710875a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
18-gce6949710875a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62eeaea45858f85945daf=
063
        failing since 31 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
