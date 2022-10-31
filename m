Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49773613BEE
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 18:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiJaRKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 13:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiJaRKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 13:10:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEA012D0E
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 10:10:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so12936478pjh.1
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 10:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iOAJBjyyVHR6d2OLS0INXDiBDHn/NTnPDiUdYy+3inw=;
        b=qZjCBe/2jYphCDulpwjj60gr/aYL55/GNzCLGJYxw1mf6PyNpy/S9d1H0tdFpchjrv
         SCmYJKTwdeW/eDhnbI9arjMafQIM7UUdPj8Gy22K5ylnW7BtA8tzul2vIDrC/i3t6kYd
         AxNdRrLKv9pR47Gio9YIDddU2MSsJxvgWtq1NLp3Yre0UA7EXEGdXHfCb9RKlbP+LIRj
         aAYKmPIcsGOeOZRzlvz4vhbqPcndluPm8vsGHvTbY0GVqMxkv0Qgw06lkih7n+V7ZsXF
         qaIrrhPoKfuNTwijz+4DNUQtQ86Rk3OtZaZrxr8DNmNAlWOm/iYZc++OV8xeZg8ZvsO7
         PesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iOAJBjyyVHR6d2OLS0INXDiBDHn/NTnPDiUdYy+3inw=;
        b=tQz9bAkwaprmeAA6ERkXM/ngSOFmDLvP+rg2DqlGJghVlQnlAsI/8Y5r1vFJmDeJp/
         JsOhOA6b3ISSoHnIxdG48fOUugoYjM+yhhlSOgGDTlSxMYENVt55R4QcL2K0D3xnk2Na
         asvIJ6w68j8PwNUzGB0C2SGn6S3weGNT34SQLoJCI91sySHcYFVq8wblM6TWsPyirTEI
         rjV/pbPtsdBQRDlFA7EJFIorhoMmGfPyIZBXgUy0XV0t7Aj7xEyyttIpym2qrrNLbW71
         RKlc4FOXmpTWMULrIgc9n2WITurQ/xK0w0tfPWwOufP6lRMq0WmSZpSUX5t3ccdnfOj4
         MTyw==
X-Gm-Message-State: ACrzQf0ZKPDZpIseOoqGNQTFUiQmeHVLq1WgsI781OYVKkpyqgAO3HhF
        P/T+1O7IpXmSmjyPBVhn7jTYNh+0FkOKeKYM
X-Google-Smtp-Source: AMsMyM4MKp/2zT6vAHpvpUdvIlVgFzuSJ9c0ZWcO9XhNQshEoMePrsISn1kkTc6AKk7yyyDqrXNQ6A==
X-Received: by 2002:a17:903:41cf:b0:186:ac4b:21b7 with SMTP id u15-20020a17090341cf00b00186ac4b21b7mr15346231ple.123.1667236234592;
        Mon, 31 Oct 2022 10:10:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b21-20020a62a115000000b00565cbad9616sm4835714pff.6.2022.10.31.10.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 10:10:34 -0700 (PDT)
Message-ID: <6360018a.620a0220.2a0a7.81a6@mx.google.com>
Date:   Mon, 31 Oct 2022 10:10:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.76-127-g1abef673fdb0
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 136 runs,
 1 regressions (v5.15.76-127-g1abef673fdb0)
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

stable-rc/linux-5.15.y baseline: 136 runs, 1 regressions (v5.15.76-127-g1ab=
ef673fdb0)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.76-127-g1abef673fdb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.76-127-g1abef673fdb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1abef673fdb026211374142fc46de2888299265c =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/635fcfe9313a2d87fee7dbbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
6-127-g1abef673fdb0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
6-127-g1abef673fdb0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635fcfe9313a2d87fee7d=
bbc
        new failure (last pass: v5.15.76) =

 =20
