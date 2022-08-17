Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B075975AD
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiHQS03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbiHQS02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:26:28 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D019AF98
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:26:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w11-20020a17090a380b00b001f73f75a1feso2594407pjb.2
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=wm8fBFaUAiv6OjQIeCr/ujroz0WiB2a+/RPeiVJMiDU=;
        b=PQC2lWIJ/LovQKqXggOdzZvfZiEKe3Zj50V4XSUTeTq85cfEISmRNRapjdgQEUv/T9
         NIzg8WYrmIWX1oPAFwengY3DMYUm+IdI/aVa19QUlV+Zv4UN79UeI59jp8OuRGaO6Wba
         nWwxBqsIlT0kOQ4E25cocMYVigNlKfPNa+e1rH99E/5FAMMpUoi6ZI2lcoArx95tEfTS
         Lr4ay1K6/0GsFJbKJQ5sDeHBkFJ372gTK9dk6Ef3zoUerXrDDDiGxMQV/U9ipVSVifXb
         OsF9l7+sg0R2aP37VuGZ1FMCwwKdRH9bcwME5hHmcdJMX0UOYy8Na6ScFKCUSWx6rF2s
         lJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=wm8fBFaUAiv6OjQIeCr/ujroz0WiB2a+/RPeiVJMiDU=;
        b=BS/60aGJ58MFipVKdZqg1lvy/y55vaWHohvvDxL6db/XD1d6d1cfI/eZhB0WvWQK7S
         4ixcIAmWGgUEBJKWUwl5GXDeEcSxtzPctPFhE8x2vh3w2RRfmvTYqLuo4yy1nuc3V5Qx
         qyfJHdkGUHvQ+EZsVNbC+xX6ftslpVwrY46WPMPSAMmvHT8IYnUuzuGY70xBvLKEejiC
         Xq3VkwDVMzAV/CMva7aOTFM4dZMvUYY5yiIdyqPZtwxYfgDqbS9XWK4/V5gOBubV0Tqs
         K6v7/muWJ4DT5U9CGyLuplHTaBKMdlMVmjt8gh9xkLGnvZtk9YPwqA+u8UBZQyVnuU2I
         FS6w==
X-Gm-Message-State: ACgBeo1Ou7vX+zm+85hXY5WaXajG8rIgKtRwYXhIcXWaWxe1hh9yKxnA
        w8W5nPnpzi+6LE8WFRUq9e9zvmXKi7dlpUGz
X-Google-Smtp-Source: AA6agR4NKwO2Yqxr2X+RTgkXXmD2lPkLvqaZZO6rSEf28w3OD7J5kFWnor4AyE/aUnZ3+1i/aT6FRw==
X-Received: by 2002:a17:90b:1c0c:b0:1f5:494a:304b with SMTP id oc12-20020a17090b1c0c00b001f5494a304bmr5089595pjb.157.1660760786736;
        Wed, 17 Aug 2022 11:26:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9-20020a056a00000900b0052dee21fecdsm10838620pfk.77.2022.08.17.11.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 11:26:26 -0700 (PDT)
Message-ID: <62fd32d2.050a0220.61a81.25b5@mx.google.com>
Date:   Wed, 17 Aug 2022 11:26:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.61
Subject: stable/linux-5.15.y baseline: 132 runs, 2 regressions (v5.15.61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 132 runs, 2 regressions (v5.15.61)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie  | gcc-10   | bcm2835_defconfig  | =
1          =

panda              | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.61/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      374bf3fc1f53c6611c4ad98d11863344d375e2be =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie  | gcc-10   | bcm2835_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/62fcfca5fd35b2dfd035566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.61/a=
rm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.61/a=
rm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fcfca5fd35b2dfd0355=
66c
        new failure (last pass: v5.15.59) =

 =



platform           | arch | lab          | compiler | defconfig          | =
regressions
-------------------+------+--------------+----------+--------------------+-=
-----------
panda              | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62fd02e27ce5fbf4cf355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.61/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.61/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd02e27ce5fbf4cf355=
653
        new failure (last pass: v5.15.59) =

 =20
