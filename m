Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F28D62C175
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 15:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiKPOyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 09:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiKPOyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 09:54:40 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE22A1176
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 06:54:39 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k22so17700307pfd.3
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 06:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Zhe//nJPIWah82/uNMLxBI/kx+NXMMT9QmJgHpPV8bk=;
        b=gdraA1zNWZiecC5JPqWMHjiKapSzVjIVOUDVuYE5TpimdJ8W0TX5t34zVbHEHyiiiv
         Gdr7wH/9rnE5v/RXod0MQciD2slOE8EPOjbynz1mqZSq95GhUyt30q6KzUO8K9kEmeF9
         oy+N77WaoE42ifKSiXRDM28GCccQZcL36+sMMObjO7vGmJ69jsmYipOML2Vz9R69huLS
         eGbGyjO1LazlIHAgJC64+BdaZ8OseyG6Lo3tQPgDqLTMZklh7JCv960KTMY5N/AdEuiP
         Y7wmk5nLFotZERQ6T5Q14MnY5Kf/mZt66TTr4ARVlqgMAbK1XwWl79CMJyoRUFh6BkOe
         roow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zhe//nJPIWah82/uNMLxBI/kx+NXMMT9QmJgHpPV8bk=;
        b=w3koOYbr+oEeh8zoUJw8p6JpeDTkDoUOUqUnbsdXYE5nnHOlbGtwr+bi+qQtHcaB3K
         8ACMN+zS/qX9qZ6DPQaHuv5sXTwtyqRVgoFJm63EZsqzSx3b5LnlRSEOqcUv7j77L288
         NClY8OywBSkXqKchocqDen4hiKS+D13wrwE1wYwOcnOhVmZOOwe7W00jkIHFANrHS8E3
         fGf1VMapoEI9D+9PkovQlqzb+ovuQUg9BuI/wQORAN3m9e55DEmXBFMr5+oMbEMhA6Py
         qsqaqw/FblzgR1hnc6qsvzqAb9ivk87Y75F5ZAgl7Ss6rl6jebagvsOZkentA9pjWcPb
         rdzQ==
X-Gm-Message-State: ANoB5pnmemuimJRP206miwKkMXmOCXRPQN9hS74VCWxKx1NDUcdQUuWR
        Fdlt/3shErShTl8PzEc+iA89bsdmF9+BXRLSzC8=
X-Google-Smtp-Source: AA0mqf5FayvhOeGrVBgVpw3Zp4tzh9voVjNvXvx8PMq/T704y8cR/wD3n4nAJonDJhuB8lwnK4lzyQ==
X-Received: by 2002:a65:564c:0:b0:476:df12:2a71 with SMTP id m12-20020a65564c000000b00476df122a71mr4254558pgs.563.1668610479273;
        Wed, 16 Nov 2022 06:54:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k17-20020a63d851000000b004411a054d2dsm9750837pgj.82.2022.11.16.06.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 06:54:39 -0800 (PST)
Message-ID: <6374f9af.630a0220.8b04a.e7ed@mx.google.com>
Date:   Wed, 16 Nov 2022 06:54:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.79
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 144 runs, 2 regressions (v5.15.79)
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

stable-rc/linux-5.15.y baseline: 144 runs, 2 regressions (v5.15.79)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3df0eeae4d9a547c0f19924952ccb8290582e5d0 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6374d0e653ac79e76a2abd78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374d0e653ac79e76a2ab=
d79
        failing since 50 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6374cf7c67bf8daccb2abcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6374cf7c67bf8daccb2ab=
cff
        failing since 50 days (last pass: v5.15.70, first fail: v5.15.70-14=
4-g0b09b5df445f9) =

 =20
