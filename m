Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643255387A5
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 21:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbiE3TGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 15:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbiE3TGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 15:06:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D509D4E1
        for <stable@vger.kernel.org>; Mon, 30 May 2022 12:06:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso115294pjl.3
        for <stable@vger.kernel.org>; Mon, 30 May 2022 12:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FOZ0/Ff2HRsnmwZBZWV/GqJIpBaoPIS8hl7dJNecIEw=;
        b=TVWPRyjXYKWKAFRIYwCfWpjMBlJYtft/22qPallYZJxr9BtqxkmXy0Ikgn2fswAt5O
         TYEhonVHBLePJVSRiqG5QPbItFDmVfZWwOypaq0SAIQmY0C+DQfSuA1qRUobiADvn/ph
         prkUAf8dMRbecRY2hAP27jrdcLJp0IRiPTOO4/rFYERkmaa+gZct4B9FHb+R/+aYJkvi
         lpGok4DSp4wfP8DzRUqOhxtEGDvrf2Cu7wu65XjwBg69CSTfx79R93zdpskxJNlXkVMq
         oJutWKFVl73C4JrvMxwCKtavL3J0lxgNw7h9qZEu7wN2re0CcAn6FFJT35SBzxiHBlG6
         Tn2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FOZ0/Ff2HRsnmwZBZWV/GqJIpBaoPIS8hl7dJNecIEw=;
        b=Fz98Pj/9mZeSRfCIjZqfjkPDexilpd6cTE3++8/DZfMZ1CowRXSNPwRk6W5/jG4Yly
         sFcdXfR6bytyX6cjDDO1+8vUjIUpAlySfUd77ujgSkTSkYqMwtICauF9YSsxiU4QWpKa
         60esBVPYf2piOU+FNZDJ0BnksTZxUjweYKX+Uj6tniXiivqTZSruVMl2izh6n/iGwG9D
         zFQwG0MXBCokEb3gBv0w+JzuKJjxRwvqQfgSHecDMo6sWpBKZ8ciGGsrkQoZcPjEN0Q1
         HBr2shy4Kb9z1bHy0vI+aEJpPeMNyuGFmoLflha3W3V9XIPAqI/tfzSWbx/TJ/N+tOY/
         El6A==
X-Gm-Message-State: AOAM532siGcvTrD9rMfwJpGkWf7wO3z4i89vb1lE8yAynA3fDG432FQH
        tBcXvHXo+FmarTMns3ONAzaJOF8XiLRt1U5KO8U=
X-Google-Smtp-Source: ABdhPJxi8a85DRGHVeJkU5aWtiD/Bma4C4s4OVYnqQLqnzErtQRqP25BROx1umTxz6fnd0fFFdTNwA==
X-Received: by 2002:a17:90a:4a0b:b0:1df:7168:9888 with SMTP id e11-20020a17090a4a0b00b001df71689888mr24687964pjh.16.1653937592691;
        Mon, 30 May 2022 12:06:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cm24-20020a056a00339800b00518142f8c37sm9395531pfb.171.2022.05.30.12.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 12:06:32 -0700 (PDT)
Message-ID: <629515b8.1c69fb81.93136.4a73@mx.google.com>
Date:   Mon, 30 May 2022 12:06:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11-11-g79941e95964af
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 148 runs,
 1 regressions (v5.17.11-11-g79941e95964af)
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

stable-rc/queue/5.17 baseline: 148 runs, 1 regressions (v5.17.11-11-g79941e=
95964af)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.11-11-g79941e95964af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.11-11-g79941e95964af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      79941e95964af65b97a026eed43b7d58ed65d721 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6294e9d31fcfb7f7b1a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
11-g79941e95964af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.11-=
11-g79941e95964af/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6294e9d31fcfb7f7b1a39=
bd0
        failing since 3 days (last pass: v5.17.11-2-ge8ea2b4363353, first f=
ail: v5.17.11-110-g77c86f3d903a) =

 =20
