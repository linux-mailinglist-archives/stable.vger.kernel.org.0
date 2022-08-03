Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1D5588C88
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiHCM6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 08:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235594AbiHCM6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 08:58:00 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF94C2DC5
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 05:57:59 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s206so15052203pgs.3
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 05:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IqqOciYNfvDl3am8hOOeFrQBlDAgchIqw6I1Z9siI/Q=;
        b=3RzXDZovJzjBBC4XSaq+Ro+xQbs0EFKKMyLuAt5fC2Af3ZEGlFo5KBsmwWIIRIo3NA
         8PVdHbteO0+8FCHkTAZTNncWwGqrk47yQ6bXSOjqvkxJogB5y8NxKekytTFD48zTciSb
         CRQSRj7pobzY76fX5w2tAHCn1NVolrSNic1qXAgbaP3Xej90GoTy8kN4jKGDbW718jJs
         6WklXMKDZwYzV92i4l5nHEl60o/mCi4oDB83R65ZpEdj5m2gQAsXnVjEYlU6XDsYJ7oX
         jFY8ySz7Bmk3vwuW+TdxF9hc6HlpJiSbg3jjInIyNHwHNTf10H+E0qEwPOJGG9mOMd6n
         qDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IqqOciYNfvDl3am8hOOeFrQBlDAgchIqw6I1Z9siI/Q=;
        b=D7hvH8zs4/SXP46omAbdfFUTxvkdPNZlVqLmb7IimpHHyo6SM0mg20UdKP27ONr4gV
         Aeu+BQYcKiegmcWVXy/CbTPmuOeij5JmMaiK4ipfEU1eWUIxYZBQdC4ETvGnR/FJfqI0
         WnYx/9wcQI9Gf/FOjSZaeMpIC844nOtQpFfNLSbJeGlTMjGzqnpoufojfG++aFiIdDqO
         9J2GIdbWd7Zf4dmJhfsTGgzRCa06shr/Rz36E4MPE4OPZ3GpnaWVoeO4FOjbzvpd0eGC
         pUQs7EunFAdeN5BkM4xYQ+TZvfj1AGV+fSS9Yxqy2wVO13AhyBOLLtzYDqfk4RHLY5LF
         vr4g==
X-Gm-Message-State: AJIora/FJd7XXu0DRVX6sLYvizxfBc0n5bX01QRayP3UqmFGZ8aCqHYq
        Ho908Ns4ZuJum7uv67y/2Am/KN5TcjQO+QE6Iv8=
X-Google-Smtp-Source: AGRyM1s6GPupdkjiROe9kWz9wDDwdxIrA2g9tOgSz16f37FxMsmRYr7KOGLtQOufLAv0SvCZEgSZAA==
X-Received: by 2002:a63:1245:0:b0:41a:29a3:aa31 with SMTP id 5-20020a631245000000b0041a29a3aa31mr20271227pgs.583.1659531479092;
        Wed, 03 Aug 2022 05:57:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bb7-20020a170902bc8700b0016bee668a5asm1829048plb.161.2022.08.03.05.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 05:57:58 -0700 (PDT)
Message-ID: <62ea70d6.170a0220.998ba.301d@mx.google.com>
Date:   Wed, 03 Aug 2022 05:57:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57-272-gb470164cd8123
Subject: stable-rc/queue/5.15 baseline: 71 runs,
 1 regressions (v5.15.57-272-gb470164cd8123)
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

stable-rc/queue/5.15 baseline: 71 runs, 1 regressions (v5.15.57-272-gb47016=
4cd8123)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.57-272-gb470164cd8123/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.57-272-gb470164cd8123
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b470164cd8123775e6e57994bc1d8c2da0ee796a =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62ea3a32f39db2549edaf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
272-gb470164cd8123/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
272-gb470164cd8123/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea3a32f39db2549edaf=
07b
        new failure (last pass: v5.15.57-272-g5a71ddb7f7107) =

 =20
