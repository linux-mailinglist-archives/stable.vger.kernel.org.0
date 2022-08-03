Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643655891CC
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 19:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiHCRw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 13:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiHCRw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 13:52:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37F13D594
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 10:52:57 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id h28so10778842pfq.11
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 10:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ntFSmNxsSS7CIMPn5z0axjv5yLETbCk+XJxTaghu3FY=;
        b=LknJnqWzZBeCMzJfLqUEe8+1GyPD1l9fMPn+AbmCY/Psd/fAOtAQqiwuyu1wA7XNH5
         MTM1U4hLqSBoy2sisJKwWovXFyak0oFBZ067W38try5mmnDb23JR5uGVAgn+VShz9hIp
         tFeBMR25PJBSrFepC1Ly6HcTxmlv9PzElzDb1F9AXNYMfjuSkrDQ537WkWsJG/tm6+kd
         R3SRnXmON9Qv/jXjw+HlboFsyAYfufrH3yR7ieYkb4/A4biGHopnSzlujRXbTrhVau5H
         O/2EJ52veWDEUe80rHSJW2HFSXDYTBTGPNeVHmRKjZB9F1sw81jmAfRbnngnlZvcAHY4
         /2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ntFSmNxsSS7CIMPn5z0axjv5yLETbCk+XJxTaghu3FY=;
        b=kZHgo++fVeebsx6BX3ly6si6DaK8pT6riG/pRtfDsUhao9J2X5Q1JbSsJUIM1CdbLi
         RU2+dZS6ATEMJ7YrX4mPGakwkM0F5Krtgb5Pa4B/65/TxUdN0k/m9ELY3KUzHl5h4tbW
         njrmaU3Yn0jiX7I0iKcZ5G6chSlDaWgRCO5Y8vGnlaTluasc24jtCXPoDZkQPwewRjKd
         OE+8AaYGqtxysHW86ABf/WdPxJ7CxOLYWJzCfZ4RN8SXrgJlXkglfNoITS2YItprN3IH
         PfG0gIt48oQE7pTIM86D0F6ehOVRNYOSg0TacTyFyYYRZlln+/G0bimVlAQpzOAAphxX
         RBag==
X-Gm-Message-State: AJIora9z+uSpAXyDFq7CPJV6tyKDS35S5yr2ceSj52F74G8Zxol28SaH
        oyh/RfrT+OVGqnIXzU2bhOxR6t3ivSy8cSi+IhY=
X-Google-Smtp-Source: AGRyM1tGW2p6i1AnCF3a9RrekI7raYq4FvhG0bgdbrX9OTxOSTqLuZ2ayosARFBPXu+kItJuUmNDQw==
X-Received: by 2002:a63:2dc6:0:b0:419:f2d0:4777 with SMTP id t189-20020a632dc6000000b00419f2d04777mr21561121pgt.203.1659549177022;
        Wed, 03 Aug 2022 10:52:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14-20020a056a0000ce00b0052e0bc3ca3asm2609073pfj.173.2022.08.03.10.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 10:52:56 -0700 (PDT)
Message-ID: <62eab5f8.050a0220.b028e.4952@mx.google.com>
Date:   Wed, 03 Aug 2022 10:52:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.16
Subject: stable-rc/linux-5.18.y baseline: 52 runs, 1 regressions (v5.18.16)
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

stable-rc/linux-5.18.y baseline: 52 runs, 1 regressions (v5.18.16)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8843bf1f0737ecea456d2bbd19d4263d49f2d110 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea811a9f4cbe982edaf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbi=
t.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbi=
t.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea811a9f4cbe982edaf=
068
        failing since 1 day (last pass: v5.18.14, first fail: v5.18.14-248-=
g7e8a7b1c98057) =

 =20
