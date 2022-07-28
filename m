Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0CB584741
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 22:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiG1UtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 16:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiG1UtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 16:49:04 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923AD3A49A
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 13:49:00 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso3342162pjd.3
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 13:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bdlbvLy+6oN5OjIIH95qXoW8bGughrgNeXSyGq2dBIg=;
        b=r7SwpE06d6NOJcR78eJysGpDxrHgv6TyMBfh81OF4kVWO8QuV2LwxUqSpH+wC/1QxE
         iXwGIOKMsGxn+IT5bcbhEiXzsm4cvt5Zi5oJhIpvFviUG3gC0qERiL25K7PSDNahIvfK
         aQpQcIEqVQcq1sJueo4DsofK95x0EU1uKtmRZ+8v/3a5be+TOybieBgn2MUZVn7MFEMo
         oSD/CClLCF3SQUk4TBmak3kJWh0dfkq8c/X6rnbUbCBOujW24B4sjhsJBt+gnIyCxvjf
         ZvPBYY+dIPQkyopRvBT2Dph1VczzruokVQIAxqXxoEm7IiqJNyDlIBWS7cXLG2AG2uHP
         gkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bdlbvLy+6oN5OjIIH95qXoW8bGughrgNeXSyGq2dBIg=;
        b=evi6pt5lmKXdv4Y2b8/sGwfg2S5I/ASfq1upNjtVGUXlf+G0hfOogcFMo9iVD6+CUc
         1yJ25zVSZuldwVMB3UybPS+Ulyh8XWAs9IlRCa/Bugy5oum+xdC9MHi+aIGLhadz1yYb
         QHIbQWV2TQNzddAGedJsmaGqYUaIEXm/aj+k8qNEB0SWYi88Jc5TiSZtvFH9JCdc4YGi
         kFlOCFP5kf5Qh8Sx6v7gEdKyiNxzxPSYISNxgaV7iDm0hLSyeIaJExaGVBJiVkXIc/tE
         DeBJOdmQpeTyhAnwtipcesMhPUpz7Py1pOOagyKidN0Ni/sYYoRGfqMPqnybMiW9wfJg
         Womw==
X-Gm-Message-State: ACgBeo3KnxyRVPnjiVsZJ902lwfUvCziTp5qF4oUm9rZhoxgOGqu2jUL
        6As6e6ZHRX8CD1GIQg/L2n6HprLlVqIHhmx6
X-Google-Smtp-Source: AA6agR5U0xbPUhh11HwJzReOpiongJc7ZBqu0TvKfeRFbHaISDeMPmBLzoWmaBdxUf/UkrDtxkXpIw==
X-Received: by 2002:a17:902:f64f:b0:16c:23c2:e2dd with SMTP id m15-20020a170902f64f00b0016c23c2e2ddmr597220plg.3.1659041339871;
        Thu, 28 Jul 2022 13:48:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u68-20020a626047000000b00528c149fe97sm1202771pfb.89.2022.07.28.13.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 13:48:59 -0700 (PDT)
Message-ID: <62e2f63b.620a0220.355e4.2056@mx.google.com>
Date:   Thu, 28 Jul 2022 13:48:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-158-g3182404666adc
Subject: stable-rc/queue/5.18 baseline: 88 runs,
 1 regressions (v5.18.14-158-g3182404666adc)
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

stable-rc/queue/5.18 baseline: 88 runs, 1 regressions (v5.18.14-158-g318240=
4666adc)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-158-g3182404666adc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-158-g3182404666adc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3182404666adcc17412b658987ddef22353d90ea =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c7c21806e2682fdaf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-g3182404666adc/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
158-g3182404666adc/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c7c21806e2682fdaf=
059
        failing since 22 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
