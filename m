Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDBA579326
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 08:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbiGSG2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 02:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiGSG2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 02:28:52 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4C329823
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 23:28:51 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f11so12624599pgj.7
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 23:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tjlwRfBCuyDw8iFauJUgIPZ8a8legajsrbqcMzuhYZA=;
        b=lgmeDzf0ySebJrmKDmI8sJxXLAeZvuli0G2fPrOwl7ITQaed0mAduIiuWxAElkeJd5
         joL1O+geZ6BXvnwnmV10thBJqItY70q4xTmnpsUhPuCXwSyz/Fjv6K2DNislkSe+lYa1
         BpGpgGr1eeew+PzfwIG45+Y1+TVZ2uzdZONRQji9YuySUApgSx7YWOWgZwBJfLdyqHQp
         r7UDBmiqh/UPkAh/ha2kWt3vyYiK3Nf3kzCWTINfInIv0hC1vhL6/9aMMZcEB1SKOrQx
         NM6QNQCuka1OTA2C6408fXv4jCHaqDw+sj0IWVd14IIQmtKW6lTBG8kiaXxjhG193Qox
         oBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tjlwRfBCuyDw8iFauJUgIPZ8a8legajsrbqcMzuhYZA=;
        b=0DXwRi8HhOSzbxmya/h+V4LcPmgd7lLrTKpnHgmwN4h9/6URQnR8QX7NBQcSPHz9WR
         Jha1WonB+ghLQGyOAcnhr9i3s9oPXnnUx2PB7AJmlrJSNlZagg5WNIherVKCWzL7CyZy
         Xalf5pM2RinKEUgLJ84G7s6e/Q7vbxEB0lp1gLA8zf78q0kgdgspvbU7Xh8pZ8CNq0sB
         Pc5jKaTh6lDqZvcrccZvPx1nsX2TJn/WnE9cTD6JW7ONkpwZEcAXBf1ZZRMIeI5ROqwu
         HN+p5N94Z9GdHttzSSw1knAHIJarJ/HG3Gc9oFg5Ss7eafCvJhR7uKnfv6TP/N5DkU56
         GcHg==
X-Gm-Message-State: AJIora8eo0t3reaGrl3XCJjUrWZ5jOR4qenasesiNA7eG5yjFFk4H3B5
        nl7hB/5f6S6CKovM5eno9JO+18fIcaHiGbH/
X-Google-Smtp-Source: AGRyM1t7Ap9ir+EIVc3jd/auH3KxJ7Ca/yu+mjzamKDTgEUMQgjV9nXCYskMTlsmKlD9p+2aqtPFZQ==
X-Received: by 2002:a62:1509:0:b0:528:98a1:1f7e with SMTP id 9-20020a621509000000b0052898a11f7emr32376788pfv.11.1658212130984;
        Mon, 18 Jul 2022 23:28:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10-20020aa79e8a000000b005289c9a46aesm10459084pfq.80.2022.07.18.23.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:28:50 -0700 (PDT)
Message-ID: <62d64f22.1c69fb81.da30d.f7f2@mx.google.com>
Date:   Mon, 18 Jul 2022 23:28:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.55-168-g9cec26c76053
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 94 runs,
 1 regressions (v5.15.55-168-g9cec26c76053)
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

stable-rc/linux-5.15.y baseline: 94 runs, 1 regressions (v5.15.55-168-g9cec=
26c76053)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.55-168-g9cec26c76053/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.55-168-g9cec26c76053
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9cec26c76053e9d6d922a6e47aa58627dfb64556 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62d61e6e5619192739a39c0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5-168-g9cec26c76053/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
5-168-g9cec26c76053/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d61e6e5619192739a39=
c0e
        failing since 67 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =20
