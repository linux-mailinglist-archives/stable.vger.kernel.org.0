Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B854536B2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 17:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238705AbhKPQGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 11:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238745AbhKPQGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 11:06:13 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFA2C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 08:03:16 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id o14so17813647plg.5
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 08:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HYf3f6TIs0+/XQu5EBfEvHoPQ+nreIAGvTwDmdngTr8=;
        b=279kViojozLIjQpKQocV+riKZWhjiSXycqo6EWPYV3U1LMe4fDTrN5p1EFHnA3fSB7
         yudYe5YOm1/GD0Je7P+erkBSN0W/8Y6lA/Oy8YEzjPkh0rYKVhEdste9WWbEJUAfOgiS
         NJ4V5rccfPldGm7FdzT56nwX4DGaaIz0je2KI1oA897q+5oMvokTlWKQ3IFtmE/EIqTL
         poDdoFEYLAf3gY69fNmNKcNe9uAT5imFpgqByukvC0e1+5J/ZLoyKn1JG8guL+LXoi82
         zupq/Btssn5zZrUvefGreKNGD0mwMv3+rddUhhFm9ZU3uKWxyRy4ctUNOBq5WBxlSuMQ
         fDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HYf3f6TIs0+/XQu5EBfEvHoPQ+nreIAGvTwDmdngTr8=;
        b=Ymg73L2wha/gyy1tC9tx2ImgM9u1YEURcKJ20ocM1PbJkwmLUceEN5FFfhIWJCu3UK
         MbDe4B1POfdizc/WwOlw2BluAPbwueoahbLIDEaEjFv1dj1/A/6inD3Dho0poskPl7MD
         uDI0oHyhPJK82K1miK/mPWJ95DIKrLjALEobhkMDKRjZksDfYBes+SeP5Ka2QUGqpUCJ
         YfP09Cjzm03SAtz59Zh5X1V2irsvkNJE2S21QZj5YN0IDIBAll2Oh3RAhStRpcRl1jF5
         ucFSG+66wgEfmLGKJsnGbVLmKZhEtiF/iIVf83c2r1fisJuJ/wO70dSh9b38+spp63hB
         +WKw==
X-Gm-Message-State: AOAM533bZISl7kOG3ykXokiihe6ta4xx29IuRKXlZ1t6FAe33kBQWDn8
        ftLRSn1cABMTHJejUc/arQw8k0ZMxhEnKEm4
X-Google-Smtp-Source: ABdhPJyZSAb99nP/4IAzhopYYoFhmOKncrUGwqhVM0dDnVDQpgxA9S0VemrNVo4cwKEiR2xiFQk51g==
X-Received: by 2002:a17:902:b615:b0:143:bbf0:aad0 with SMTP id b21-20020a170902b61500b00143bbf0aad0mr29509965pls.12.1637078595518;
        Tue, 16 Nov 2021 08:03:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id on5sm3158434pjb.23.2021.11.16.08.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:03:15 -0800 (PST)
Message-ID: <6193d643.1c69fb81.837ed.88e1@mx.google.com>
Date:   Tue, 16 Nov 2021 08:03:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.159-353-g55e04396681e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 101 runs,
 1 regressions (v5.4.159-353-g55e04396681e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 101 runs, 1 regressions (v5.4.159-353-g55e043=
96681e)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.159-353-g55e04396681e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.159-353-g55e04396681e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55e04396681e9dd1feaff0b65bea3c737c3b4896 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6193a58f37ded4939c3358fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.159-3=
53-g55e04396681e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.159-3=
53-g55e04396681e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193a58f37ded4939c335=
8ff
        new failure (last pass: v5.4.159-353-g4c8ce7e9712a) =

 =20
