Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666AA502F94
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 22:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343730AbiDOUNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 16:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240248AbiDOUNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 16:13:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD12CD32D
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 13:11:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so12516075pjb.4
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 13:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1guTTY+yxfvjElfbjepls1DKrKukXqImK2ocS1EkDLI=;
        b=bwd1jAAqav+qbxagD44VhNOgVk+aYYOt0vIPf7ReD9M/9Iiui4zMqSCmkm+XOvrFgV
         Rx8quSbHQWFzZZXGNlRGv3kgJ0EvME1IZ+j27LQ7x2D3AIQ7bY8XFXzv7t8QQnv0S4wK
         29+i15JCzsBfADkhf2I+un1J5fHcIuzSlNu7nlj2BZcOYfALF1OY88Rlwo6KJDZcPR+y
         woSY+zARm2BY7C1rjipB9wYyKPK9C0xBXObxxA0wSGl5DSs2Yot3YWuCniEuyjJKRtIq
         oRSV5ctOCE46nEEqqlGyPqRe+/MDJ3SmYMtigOnZ2QXi38s02Guaud3jxYsFI+st+vf2
         eXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1guTTY+yxfvjElfbjepls1DKrKukXqImK2ocS1EkDLI=;
        b=7ikfiKVkOBT+5rZ2ENaKFhz8835OrxtF5CevoDCb12v99sAEgHl59/8h2cQKM3LF66
         njlre/3blH/rgPj1plJJjmjEYUVIpfs599uzgx8zSyhOYtLewt5U0HpyU5okikNo3YYn
         rB/I095fqPpiaIRoqLsDinrXnataEn29S4b5KxWFeFoTqRwBSBf2266RxW7+1B+OcWr2
         HZ+GGXupmuDaXEqnUN+t3yOI5aRnw3IRf8lewkPoUhGx2NxPCpWy6KuUlg7h8SiRQSxd
         o+bR1Q7f/R52Ct7U5CNxM92xnCRgSnquvQIQRET4OXfxf+3E9yHqT2dJNqEsT2xr0N5r
         6ZQw==
X-Gm-Message-State: AOAM5332ehJaZ5DeW/A726ulli+MFmE/eCa/kMyeL7NZB08vZmHLGsRW
        2ed9PC8iwc0fETi4MFntMu1JcGXympVB5zty
X-Google-Smtp-Source: ABdhPJzXfg9fjVbL7gwknZc6SYYoZ0lvu4N74jEm/VPaDobJOz+xQZxW9m0cgeffciLJSepSu+ZIgw==
X-Received: by 2002:a17:902:c104:b0:158:8b31:781b with SMTP id 4-20020a170902c10400b001588b31781bmr632275pli.67.1650053473785;
        Fri, 15 Apr 2022 13:11:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u22-20020a17090adb5600b001ce08729657sm5315244pjx.30.2022.04.15.13.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:11:13 -0700 (PDT)
Message-ID: <6259d161.1c69fb81.d3782.ddcc@mx.google.com>
Date:   Fri, 15 Apr 2022 13:11:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.3-57-ga0cf6ca054642
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 102 runs,
 2 regressions (v5.17.3-57-ga0cf6ca054642)
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

stable-rc/queue/5.17 baseline: 102 runs, 2 regressions (v5.17.3-57-ga0cf6ca=
054642)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =

at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.3-57-ga0cf6ca054642/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.3-57-ga0cf6ca054642
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0cf6ca05464247e59c4fa08d60effea9b1d3a5b =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62599e02848dc942adae06a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-5=
7-ga0cf6ca054642/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-5=
7-ga0cf6ca054642/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62599e02848dc942adae0=
6a2
        failing since 1 day (last pass: v5.17.2-343-g74625fba2cc43, first f=
ail: v5.17.3-7-g214113ee8b920) =

 =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/62599f7ef68da7e233ae068b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-5=
7-ga0cf6ca054642/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-5=
7-ga0cf6ca054642/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62599f7ef68da7e233ae0=
68c
        failing since 1 day (last pass: v5.17.2-339-g22fa848c25c53, first f=
ail: v5.17.3-7-g214113ee8b920) =

 =20
