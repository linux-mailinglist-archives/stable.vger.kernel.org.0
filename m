Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B339D32331B
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhBWVPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhBWVNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 16:13:47 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472F3C06178C
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:12:16 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t11so13198421pgu.8
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BU4CLd1IaJ7N8lsgwQgfxGr9H2B6Wvepi3za7lPJ1dU=;
        b=g/RQywASJUR05sE9d34hEioGICWvfZKMs0afBIbtv70v+lsAsa3NTfX5i5Et8LxEye
         sZv5CqkB8GSn9hIy2qnh6nSyxhr+4Du3Da5v2DcduN/xjsXbAA211wy6G2WHes4UslhC
         4deUhGvE5XNg/XEX+QAxBJvhb6JLICBMbnbawAESC4xywsM8Rm4cv+1XTdlHyXpnl/89
         +elluEPloG2EuImdngkq9hm0az+5G6ym519KT7wrxzFA5HiuTgc3FPzj+9YPc4pBZfeM
         6UjbMB6nScUqJQ1EtZ7OVRgu4TOsbVZgsRlut1Qtimo47ObEWP7d33G0nOJiXzUNq+Tf
         BmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BU4CLd1IaJ7N8lsgwQgfxGr9H2B6Wvepi3za7lPJ1dU=;
        b=oZkSRWk9RHWN9ZTn8DEN7XyOQEGOq2zIVX2x2aLzCGPVJgETqqjhESBSyNjpH8Y1eF
         fYGZso4eAjIz/VYaZIAHMPdmwXnNSCcckTJtN1rd/0Je8DA9rpRuchT2oXIhjHJT1BMR
         iMsQZDQ+s0QDMS3wv9FkVTs/iJZYPnpJ2fga1yHearPAJctvNHVQdYd/dT8PHKgmTjAw
         Oat62ZTxD4+yq0jyhPUM7EktF+ns9MRDSo1RV74Ntdnu1BLylR4RIz/BYKtFu/GDA+rQ
         9Nx0tbUe7H3Oau/93kaoWu6O34jB5wF5SoLMcOPVh39Fa1adoeTXnGw/PXQyJjkSNjf0
         p4lA==
X-Gm-Message-State: AOAM532WEWPTJUZrmaV35g1lRxff9QIfbUMqbchdaDJLpDWL9d0JhXjQ
        6cparNdJQZuR8QC972amKA+N+2v1CccRFQ==
X-Google-Smtp-Source: ABdhPJwH8s387tpa+qaVONQ9uA9iotmQbUc+nxTXfQZOZ6Ebo3oiFWV6EWPeUEW7cQu5OrmlJd8WTA==
X-Received: by 2002:a63:1c19:: with SMTP id c25mr5935917pgc.374.1614114735589;
        Tue, 23 Feb 2021 13:12:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm23165574pgr.53.2021.02.23.13.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 13:12:15 -0800 (PST)
Message-ID: <60356faf.1c69fb81.b6f45.1782@mx.google.com>
Date:   Tue, 23 Feb 2021 13:12:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 89 runs, 2 regressions (v4.19.177)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 89 runs, 2 regressions (v4.19.177)

Regressions Summary
-------------------

platform                  | arch | lab          | compiler | defconfig     =
     | regressions
--------------------------+------+--------------+----------+---------------=
-----+------------
sun8i-h3-bananapi-m2-plus | arm  | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.177/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.177
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2d19be4653f5e74ed95560b69f94eb6791d49af3 =



Test Regressions
---------------- =



platform                  | arch | lab          | compiler | defconfig     =
     | regressions
--------------------------+------+--------------+----------+---------------=
-----+------------
sun8i-h3-bananapi-m2-plus | arm  | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60353f9fe90c38b7c4addd6d

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.177/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-bananapi-m2-plu=
s.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.177/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-bananapi-m2-plu=
s.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60353f9fe90c38b=
7c4addd71
        new failure (last pass: v4.19.176)
        3 lines

    2021-02-23 17:46:30.526000+00:00  kern  :alert : raw: 00000000 00000100=
 00000200 00000000 00000000<8>[   10.688900] <LAVA_SIGNAL_TESTCASE TEST_CAS=
E_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60353f9fe90c38b=
7c4addd72
        new failure (last pass: v4.19.176)
        2 lines

    2021-02-23 17:46:30.528000+00:00  kern  :alert : page dumped because: n=
onzero _count
    2021-02-23 17:46:30.568000+00:00  kern  :emerg : page:ef8762a0 count:32=
 mapcount:0 mapping:00000000 index:0x0
    2021-02-23 17:46:30.568000+00:00  kern  :emerg : flags: 0x0()
    2021-02-23 17:46:30.568000+00:00  <8>[   10.728112] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-02-23 17:46:30.569000+00:00  + set +x   =

 =20
