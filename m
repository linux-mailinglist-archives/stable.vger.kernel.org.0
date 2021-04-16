Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13A1361C97
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 11:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhDPI6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 04:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbhDPI6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 04:58:37 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D86BC061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 01:58:13 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so15979993pjb.4
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 01:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kChM0WU72QL8/jjRvPSowj0vlhv2c4cuGVKkPIZr0X0=;
        b=TmsuqqvewQkBBrVcU0mEsPjFtjaksdke44iBZB/1jEhSf6T7HtqOqV2tUnReGEVJwH
         0F1lk/RbHX6syrikaMtpY7mfalDOtM5KC7l6sRpnh7k4omh3vl2myM6c02QLbFQV36i2
         JzH8nEc7WUv7UPkTnB21muRrPkJzNqs1Kv70bbCZn+4rc/ECA/pEDFU6zI/vu1ek6cgH
         10PZA9+cVZCKKq+ye7X1EEltxI/eztEyx7mJQvDTa0hsYzLtvTAmR87ZULR6nOTOgtFy
         2WozR1BlJOYeg0Wuln+uij9TWqL9bw2hmY/X+YBeECUEEv30BE4GTOclIlo3N5k6hvlZ
         NTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kChM0WU72QL8/jjRvPSowj0vlhv2c4cuGVKkPIZr0X0=;
        b=AGD8OfnyaD71Ah4+wQEFQCw4XcICcbpmGhfsHk8cvDjVaNVXc7rfeHqj3NwPZpO+Pk
         X00U9BT0q0vN/mKtXqCokoW53YFC7ABUVxjY5oxZwcUX0cujHLqwqMK5P3FIT2oYzvGY
         m792ApzxcwZM5UmusbTwFVyr/s2cTdcqC6QAIRrod0knu/Kpy56Clc7B8zDLvHQxiQNy
         Tsbz9a+W8qSq5TZLNQBC67IpVo1iMUUcnlxcec7KMkriQCdsNMUPbLStWPUgPZWQx1T1
         RE1LmnlE7SOxrVl2JFLbV9uzK8nAjH/iBCPLNOFrxElKofHcDpD+hsGrszoP6jw65Q3H
         Hbrw==
X-Gm-Message-State: AOAM531G+blyFgrFjOdDB1TJQJk0Sr3E/anhMeoE1ggOrQZjnOYUoJw0
        FDnPaUpJ8CCzPshCr/B5EgcZOhwDasrGRgRr
X-Google-Smtp-Source: ABdhPJxTB0/PYedeKZLDuyQrced3/TlFmE8hFSGQyNO67QVjNWsJTqslEfEyj7kpNmujRwwJirYipw==
X-Received: by 2002:a17:90b:344f:: with SMTP id lj15mr8650184pjb.211.1618563492371;
        Fri, 16 Apr 2021 01:58:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1sm4462593pgf.20.2021.04.16.01.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 01:58:12 -0700 (PDT)
Message-ID: <607951a4.1c69fb81.c65e7.d45a@mx.google.com>
Date:   Fri, 16 Apr 2021 01:58:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.112-18-g135e49f438685
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 111 runs,
 1 regressions (v5.4.112-18-g135e49f438685)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 111 runs, 1 regressions (v5.4.112-18-g135e49f=
438685)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.112-18-g135e49f438685/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.112-18-g135e49f438685
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      135e49f438685aed7583812735dcc62e3c1d1638 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60791609f712b39e3adac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.112-1=
8-g135e49f438685/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.112-1=
8-g135e49f438685/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60791609f712b39e3adac=
6b2
        new failure (last pass: v5.4.112-18-g320071e1e0e1) =

 =20
