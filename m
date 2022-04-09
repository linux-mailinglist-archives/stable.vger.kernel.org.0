Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1318C4FA5F3
	for <lists+stable@lfdr.de>; Sat,  9 Apr 2022 10:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiDIIXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 04:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiDIIXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 04:23:50 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8F0167EE
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 01:21:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s8so10344950pfk.12
        for <stable@vger.kernel.org>; Sat, 09 Apr 2022 01:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vzixcY/ssyezrijwn0OFjrLvMLFJZWeCv4koFvBpbpo=;
        b=rhEw4qmKy2FxFfMBv+6CX9G1JgKBvesCSWH2Z9luylGPgIh/01TJhmEM8pe8or/jr9
         JkCoWVBzn+gep7i+v2B3oyNRaQbdOu+KHOxFQpe7c/s9fzs/R6iUEQXzM00S8oipkRG6
         QbTzN+fPVOvg8atb8Ynqzse3gNysou7yWDr2RV3MZwH+UNbc8m/x1cGRH2es9z05weyd
         gtJ61PwfQltbNIw18xOMGfWFUMgjlLLSsMhkHDs/XxSyoNNjjWUDaBM3JYfqb1BU6N5v
         cgsA7LDCFgJPFht9EgrnoIaAiqwsVFzE1ptDYD+6HpFkztcMLwbI7SSR0TJ6sdIZw7iH
         slQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vzixcY/ssyezrijwn0OFjrLvMLFJZWeCv4koFvBpbpo=;
        b=YxOnRv2SifPHGDwWTA4Hl2zPZMFtV8NKyKSQZxrtdc5cNttkMI00I2Ld8gpVczL3Q+
         3lLRerZ15J64GiH0U3oSgasK1p/Xcsu9tou9JJPtPS5ccDwNX/O4ccIx7q5tli8q30ay
         mACvdH/kELe8l3zfGK7gxlXZ2lWI3b6hI8FPzDp4oytuNlG4YdPKauwRriHQorVsv224
         qL5s13/knA2VzyjDz+CQsTzDAOzyWaAKx+bg5zYQExuJoJNlf/jf0U6Bo531P75/Flt6
         s5jtFXTKVn6bamfaPHDuKIhS0DZTyQQ+AprI4JADZyRMgzRHfiAtTATJC/WeiVGALg48
         Kbjw==
X-Gm-Message-State: AOAM531fiQik/o2LfnYF+05u/AC6KX492HR3H1XllydRscBquBQMl/eN
        lih99i1fWON3bqA0B5G1PXmAQh760zW1ZDWb
X-Google-Smtp-Source: ABdhPJxfzIae9aD3eq+Z+EX+xEoNC4WlkkZJOFelJkciR1d9bF81FezxqeLSupdFPAHj3f97VRfBAQ==
X-Received: by 2002:a05:6a00:1589:b0:505:90d4:c708 with SMTP id u9-20020a056a00158900b0050590d4c708mr5316061pfk.44.1649492503695;
        Sat, 09 Apr 2022 01:21:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79a45000000b00504a1c8b75asm9751501pfj.165.2022.04.09.01.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 01:21:43 -0700 (PDT)
Message-ID: <62514217.1c69fb81.dab84.a8b1@mx.google.com>
Date:   Sat, 09 Apr 2022 01:21:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.1-1123-g044bf1bba79b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 120 runs,
 1 regressions (v5.17.1-1123-g044bf1bba79b)
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

stable-rc/queue/5.17 baseline: 120 runs, 1 regressions (v5.17.1-1123-g044bf=
1bba79b)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.1-1123-g044bf1bba79b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.1-1123-g044bf1bba79b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      044bf1bba79b63f8f35aa1c5221a48687f24ef80 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625110a4ee1228bacdae06a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.1-1=
123-g044bf1bba79b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.1-1=
123-g044bf1bba79b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625110a4ee1228bacdae0=
6a5
        new failure (last pass: v5.17.1-1125-gf6acde7a5d96) =

 =20
