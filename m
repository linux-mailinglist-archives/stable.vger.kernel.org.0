Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5944C54E8B3
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 19:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiFPRgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 13:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiFPRgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 13:36:51 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4F42D1DF
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 10:36:51 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id m14so1816923plg.5
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 10:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5Udr9DCr6Ytws2m50HoIYG52v9qCEqxBe4Ri+nmOR+Y=;
        b=vUw8Y/EZ4BKi/tulgcRJgvH4HLsLKvOfkqM9Ttr70I1WnUhzYBvVt5wLobx0v4VuM0
         GVGQd9WDeif6xvfq9I0cXJUqawFfiD2APVjEnoBt7Hscj9j2HTE7AzAAqC6uQaC9ZKi7
         +kbs07XV7g9y0lFBtXXFuKc30tfkSyWQhCLRX66pyrymAY8CYKmRz6KrYUSuuiOLNxYk
         s6Zm8dAKc6uGgg4KnvI7QAymkYZmmky5caDq2xLPONO56dTrgkGYIPPMNaVEiTWHkxqt
         wjLpzgz/xUMDwq7c7IRuLKcVGpPluNw0cZmyxwZ7lmM5Vshd/+CM4no+8ZiS+9wcywCv
         n5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5Udr9DCr6Ytws2m50HoIYG52v9qCEqxBe4Ri+nmOR+Y=;
        b=ajOVReSexmrZ7dYkBbEpYVDH40YPHSBeeyK/qvixkfca/LqfE8bgbZxADMMG3TyPc3
         E6VmRfX8nryW+gmhdkR+DysgfkSA0ESbIeQRiXb/qJU5KNqTF+fkvBy3G0Glh//A6PQG
         ZGAhk2iG/gQK+MOf2I+YnNBmUf/0GeANEZROUpupoJJdT6txXtwo+i+ghRalHGUEXGNv
         xOsy+B4I1x+icJ6q55wz+oT+4WBbuIDOvEiq4jG8k118fcQ/Ky6aLkTM5JoCYeXwkxsh
         yMvQtmNdLi/M67k7m1ZbD+Xa3XQnScxf9EF93g5JVtrVj2GuRF9mwE6cddSLiYUPK+OS
         AOuw==
X-Gm-Message-State: AJIora8j+7jNQGQsg3yxbSIUpsBnPe/e3+Kog+TzCtB+Aj82nLMchw/3
        NRej5E/tm69MjfWP0E891uhTOnsPv3s0Kmvqk8o=
X-Google-Smtp-Source: AGRyM1tmuwJv7uX0cNfPszlJjctW/oq5AH10C1rbYnKa/I1to330nU95aEqB8Dt8qy1+XNWu0rzcZQ==
X-Received: by 2002:a17:90a:e7d2:b0:1e8:97ac:da0b with SMTP id kb18-20020a17090ae7d200b001e897acda0bmr16907295pjb.242.1655401010235;
        Thu, 16 Jun 2022 10:36:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i64-20020a62c143000000b00522c365225csm2100346pfg.3.2022.06.16.10.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 10:36:48 -0700 (PDT)
Message-ID: <62ab6a30.1c69fb81.0270.2f52@mx.google.com>
Date:   Thu, 16 Jun 2022 10:36:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.48
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 163 runs, 2 regressions (v5.15.48)
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

stable/linux-5.15.y baseline: 163 runs, 2 regressions (v5.15.48)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.48/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.48
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e1dd58c995daf8b632344b61df9d3cbed26454dc =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab35186ef78548e5a39c0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.48/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.48/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab35186ef78548e5a39=
c0e
        new failure (last pass: v5.15.44) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ab36f5636dee6c59a39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.48/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.48/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab36f5636dee6c59a39=
bec
        failing since 22 days (last pass: v5.15.39, first fail: v5.15.42) =

 =20
