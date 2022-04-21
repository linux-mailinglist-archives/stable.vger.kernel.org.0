Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6750A52E
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 18:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiDUQ1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 12:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiDUQT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 12:19:28 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AEC3B28A
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:16:38 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id j8so5309935pll.11
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dTBb09Cv6PtCKruIFRxV1Fjif+ZXDnDziiBshXet/po=;
        b=kP3ZQRDDFpwAbFtL44ZDbyxij0aPDxiUO3FgItwyVcFiOAfAlbXDHvt3Zd3u1y38md
         ahXjENyfd5oNhWjqXOPI1JEWo2+uqWf5nfD2gahq6KUMZcboK9STxslNFtB/FTfW6ahH
         3GAzXzsyKeHyZoiLAT21y9tixFyb9XAVRjt0RI0RnoCkNym/HB3GzsklMXUynIN530Hm
         HX1PSDy5wgK+d/vxK1krtUxBVGdVaRktsrOuSexAk9ABem0Ged1FMVORJFLv/tOXVcuB
         0I2Zw9Bx9j7UqnXhOiMArYERnRFgHrkdDIhMB/y7lC7fKBAVxxzs6Zq3XZiN0SqoYxLJ
         FYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dTBb09Cv6PtCKruIFRxV1Fjif+ZXDnDziiBshXet/po=;
        b=yNVSzvmIHF04S0dRkLvV3n1HOV9Tfk+c/ge//ijHRa0q3NtUm2uboCxWuNqdjJGHUw
         kDZpVqkm4Pkq77dp+oEDpF8bzbzstxhsNC+fyKbEjPqEUgvSvh1NFrPM8atTztT36Iai
         RTUqTLwxNZL4FpNkEwPN4WRfH0XgrUlJ8kLLPcWZThBuMTmloAnLh0SEYjOnelknCjdE
         61rPj7ZLaG50LAesOTPGbKAOn5ZX6Y5UDu6w6ddYdaFTJtNYPw2DNzesm9L8LCZVKGy5
         QypDJuZxvuqmD7JcQgyxpzCdnKmuRP2f5rhnXBkmfyXxK3Kdqjw/jK5Cm4HLCw3CB9Fy
         wbhw==
X-Gm-Message-State: AOAM531GUD+5/gz36D9V3EpaomBoh4iafyf+wXK2kG+wWJOkGIvlBMMt
        QTiEpuuqyoXiGAjrsXkWlACwEoGX7U7KNQ/cb40=
X-Google-Smtp-Source: ABdhPJygp1I6yw0mPW0aLaQtNUrYKhPELT4sIW8Qu5/AzwAhWPmAwgiSeYOoSdSPNIIcMWu0jIWNYg==
X-Received: by 2002:a17:903:20d3:b0:15b:151c:cadb with SMTP id i19-20020a17090320d300b0015b151ccadbmr289797plb.154.1650557797411;
        Thu, 21 Apr 2022 09:16:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k15-20020a63ab4f000000b00381eef69bfbsm23425279pgp.3.2022.04.21.09.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:16:37 -0700 (PDT)
Message-ID: <62618365.1c69fb81.b11e9.804f@mx.google.com>
Date:   Thu, 21 Apr 2022 09:16:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.276-5-gb4edc17f57d2a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 52 runs,
 1 regressions (v4.14.276-5-gb4edc17f57d2a)
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

stable-rc/queue/4.14 baseline: 52 runs, 1 regressions (v4.14.276-5-gb4edc17=
f57d2a)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.276-5-gb4edc17f57d2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.276-5-gb4edc17f57d2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b4edc17f57d2ad2fa6df1fc4eefed72e83741017 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62613721945cd4a6baff9459

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.276=
-5-gb4edc17f57d2a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.276=
-5-gb4edc17f57d2a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62613721945cd4a6baff9=
45a
        failing since 67 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
