Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBA350892D
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356684AbiDTN1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 09:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347982AbiDTN1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 09:27:00 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BB942A27
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 06:24:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o5so1957261pjr.0
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 06:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d7Ag5yPPtpHHYUsyxFzNKk6KlzrhxegTq2Rc5t6z2bQ=;
        b=3J38LZIEaZPKDZ0hWs6kWpenAeFUZuDz5JBz5nolv24SBRTcpuoW1utOKpAuV3jq/4
         9XyTYlsw6gYIjf1mIyvlo/s4S4GJErQb7MggMY2UmysyH4Qa1ejE+GUVQxxF7JQ7mZo1
         mpJ5H3PQejxCJFWzedro9+CYIKwY6XeqnERUowKli86zEcF3AF6lJpbvFKyFRd8y2+ie
         vrtBLDfz92Ozf6pBFCzdflY9vQVv9d7hUn9cFOWXdZUzh8QtAe3/feVJ26ZAN5E6bB/h
         uN4GPKcA1iZQfriPGqCb+WzDo8bzjFFrf2ZzeRjhMbzjqwb5ciV+kxJ3cXKagdJOZvdI
         F4+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d7Ag5yPPtpHHYUsyxFzNKk6KlzrhxegTq2Rc5t6z2bQ=;
        b=uE9GNJSC6hzhFJ3T7oL5YGqggTxIUCgNaqF7YH8p+4NDF7I2XD0bL2VUS4FMLbQsGt
         rfeMVYJ9HdAvTWi0TLqhj87N88dlJItVDvqeyWYmi/RAQRdB1oyjM/Qt//Q+j7z6FOmd
         WJA4NlkajdbKE9xEG7KDEnr3af7q3NoDYgpEJJD0tq4zFRRzzXmW8hslTWYY9p7JWo/w
         0znH1IfHeWBMw2IlcuL2T9qsEALuzW7uoDrE8VvsCzKwLnnnwpKqI034H6qh1xOSV8pq
         b47BR9djGCEnEQLqJkpwl9tdcKyOJr++q5tzUsPa5dpAFFVDWokSrUMhoiKRB09PWM6S
         BWqQ==
X-Gm-Message-State: AOAM533emyrWI+q9lXoBdJ79PXUtFx+R33EGygxxTwmj/Gg9ApaIJMFW
        WbXbq/xDiZfofv6UGp8AKU8otMnYYJR7fjZF
X-Google-Smtp-Source: ABdhPJzrbrAUIVB+YS2zB9pY+WOIIO+Qe5BYwxHQwZR5LIwK6/D7qIMTM+GGLih2vOL+bSADMwavUQ==
X-Received: by 2002:a17:902:7684:b0:156:25b3:ef6b with SMTP id m4-20020a170902768400b0015625b3ef6bmr20488099pll.39.1650461053886;
        Wed, 20 Apr 2022 06:24:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q15-20020a056a00084f00b0050ab60bf37fsm4545122pfk.22.2022.04.20.06.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 06:24:13 -0700 (PDT)
Message-ID: <6260097d.1c69fb81.83a0b.b094@mx.google.com>
Date:   Wed, 20 Apr 2022 06:24:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.111-104-gd83214d1ed70b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 79 runs,
 1 regressions (v5.10.111-104-gd83214d1ed70b)
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

stable-rc/queue/5.10 baseline: 79 runs, 1 regressions (v5.10.111-104-gd8321=
4d1ed70b)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.111-104-gd83214d1ed70b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.111-104-gd83214d1ed70b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d83214d1ed70b563027c7c242e4ed5b8f95ff182 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625fdb3ba686075143ae069a

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-104-gd83214d1ed70b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-104-gd83214d1ed70b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625fdb3ba686075143ae06bc
        failing since 43 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-20T10:06:34.977984  <8>[   33.436456] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-20T10:06:35.999988  /lava-6130017/1/../bin/lava-test-case   =

 =20
