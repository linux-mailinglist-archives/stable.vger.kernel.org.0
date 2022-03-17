Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F854DBBCD
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 01:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbiCQAdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 20:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351417AbiCQAcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 20:32:50 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5139F1CB08
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:31:35 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q19so1404736pgm.6
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NM++BH3ZvwxYunuYTvxs1kVlzm4thK29A4eLh9P3PLk=;
        b=cDTH0pcN/WCpfvya+7HTWHDIFjGplTGbJ4HvKNaGADeuIPNRIMauN3CFIgV/Y3b4+s
         mtu7mR2WU2Uq6ygcr/ewfej72R9zUbxX8fMvCymoTYVXwbT99y7uV48zk6FDvtJF89B3
         hMxBC5WuUGoWmSjUb0zKaCfvZSb4ejEEV6MdEIEfgAup0c8Z1m+xExwKoxTKcaZp7BOL
         8OXX9ulB/kJcN4dsj0ZxK8yYHeUBmmo7VozDKXa6UBREwOLhdYKS5bTZFJPHBuvirWD1
         PKlFcOenEAXEn/nuathYkTnY7Nbtb5/l7QWgIhn1baprlvJ8PO2D64vf9JK/+2VTGQOk
         uuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NM++BH3ZvwxYunuYTvxs1kVlzm4thK29A4eLh9P3PLk=;
        b=7nso72q6dVvvMYJT/WHYQoIKh1Wmus1el3PS9YS85XObUufUAgB2tRwHUE+aPk9jut
         S+Pyj1o8+FdtavguxjVWwCtwcGdro4t06dLq5OL3AXZxh4KgcyEWU4lC/PjXwfZGaNQs
         lcQvpVL/XIeuOIBez0cW3XWWmqw5hGAU6oVzuUNs6AiTsC+PvE/1eTtk/54nB7+1tKDn
         w/zapO74G44rxRtKg4wj8ACIhIasQe/izUMmqzixb2RLsiR2uTaU9ZMKu3qaVNY5OR22
         Lv0WpFg4Te9k+W/yJI1/MnD+ebg0w7X1oWYGSZxLvTSAwurQ3m/3EBEar6bWdJ6OMKkt
         yxdQ==
X-Gm-Message-State: AOAM530NLDoRGo2+GodTs9+IGORj24YISOZRw83Tdepkj7HSHSoVqDzu
        yt/s3x2WnkEovxDsI6kbuvSUT25/Qq+kZngtz1I=
X-Google-Smtp-Source: ABdhPJytZ8/ezY6o6kOvDx7HxyhSEsqFGAgz37dgLnL4VpvzJmJuAS5uWrwpBJjvhd1TwNsN0XTiBw==
X-Received: by 2002:a63:6809:0:b0:37c:68d3:1224 with SMTP id d9-20020a636809000000b0037c68d31224mr1575551pgc.287.1647477094671;
        Wed, 16 Mar 2022 17:31:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18-20020a17090a001200b001c6320f8581sm3719265pja.31.2022.03.16.17.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 17:31:34 -0700 (PDT)
Message-ID: <62328166.1c69fb81.2ffb4.a06d@mx.google.com>
Date:   Wed, 16 Mar 2022 17:31:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.15-27-g644f2bed149d
Subject: stable-rc/queue/5.16 baseline: 102 runs,
 2 regressions (v5.16.15-27-g644f2bed149d)
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

stable-rc/queue/5.16 baseline: 102 runs, 2 regressions (v5.16.15-27-g644f2b=
ed149d)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.15-27-g644f2bed149d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.15-27-g644f2bed149d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      644f2bed149d76dd35397846cc1391b2c81bae18 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/62324e1667769deef0c6296f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.15-=
27-g644f2bed149d/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.15-=
27-g644f2bed149d/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62324e1667769deef0c62=
970
        new failure (last pass: v5.16.14-124-g185a62c72e45) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62325073a1e857f470c6296c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.15-=
27-g644f2bed149d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.15-=
27-g644f2bed149d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62325074a1e857f470c62992
        failing since 9 days (last pass: v5.16.12-85-g060a81f57a12, first f=
ail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-16T21:02:17.039507  <8>[   32.500939] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T21:02:18.069594  /lava-5893572/1/../bin/lava-test-case   =

 =20
