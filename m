Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9AA457A53
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 02:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhKTBFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 20:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKTBFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 20:05:34 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3774C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 17:02:31 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id m24so9385269pls.10
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 17:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qdUCU77f19Lfq1ZpSVmXYXJRLPO3z7pd/S/vKlEPUso=;
        b=UPVi717yvqs8h8geqqjQHkCsPjoJcSUrb5LATZFgjQEiBTAxHjA9NXmJUJeQTWwfgI
         ouH26WuoicYmGskGP1hELZXt+/21Vcxl9fYnYf5slQuVxI5l1pOzYFrBji4FjYkVRnYf
         mIYfsMtd3RVVDsgjk4ZJUpIxzBMD1a+D4n1fwCx0Vvzhp/WClqUv2GM80XSxCvgxQAlC
         f0Wr9Us1YbExSAE5sVOQmEmd7YXGod+0+DwmJRD2Wf4bbedvxTPYHb3JrJcAmobd8+o0
         YribgB2i+nsTVTPP2ZibdaagEFsm04Xhct7EGeq08YUIlNMPARI99GGDHIkrQnwm/PK7
         ydxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qdUCU77f19Lfq1ZpSVmXYXJRLPO3z7pd/S/vKlEPUso=;
        b=5WZVo3H+KAf5BR80M92Xpqp+wKz6HHoK9jK0X0SwtnhQ145/i9SDZbLGtCpXQK8XC9
         df8ZXfRWmOiFBntMWYNkinSCd1o4ebffG1oOhwHZ9cfja1LfhoRIVY48XimkZkqv7yhv
         iBQRRvSP/f2EYVe78OAerM308qGS5lYm3ikgcOLbkGBhSKSYO/3YocYOocWwNws5ogqk
         0wSNVARWdDYKgjyFM3XwuvNeTpGHKvN+ebSPafIEaFIOO7lmCs6VbV5RP5/oBb3Fx2l6
         HLeE29ah76MKNNq4ZD4pMxzjY3MyQMDQMJ4TLYLV7NBPKEvbA8dmHBYHm/v/8zxD8dJq
         52+g==
X-Gm-Message-State: AOAM531psEeE3N/iZIC2AKxk27aVuw83GYVmALI77qijPC6O9L0hLR8a
        jLevGYymZ5Pid5Pdf6GbWqJEEwLSdnTI6Ifa
X-Google-Smtp-Source: ABdhPJx/uFVGYZXGGZqBlrW2z59OAqYt+2Xjij82vsRWtGc8kamZlpTCfH1yxPh7iDTRBdStm0/I5g==
X-Received: by 2002:a17:903:2283:b0:141:f858:f9af with SMTP id b3-20020a170903228300b00141f858f9afmr83123001plh.80.1637370151365;
        Fri, 19 Nov 2021 17:02:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3sm761030pfm.177.2021.11.19.17.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 17:02:31 -0800 (PST)
Message-ID: <61984927.1c69fb81.d547e.37f3@mx.google.com>
Date:   Fri, 19 Nov 2021 17:02:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.3-20-ge311298d5b74b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 136 runs,
 1 regressions (v5.15.3-20-ge311298d5b74b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 136 runs, 1 regressions (v5.15.3-20-ge311298=
d5b74b)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.3-20-ge311298d5b74b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.3-20-ge311298d5b74b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e311298d5b74b5602b888d8a3a2511eefeb12139 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
 | regressions
-----------------------------+-------+---------------+----------+----------=
-+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/619813fe949b974fc7e551ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.3-2=
0-ge311298d5b74b/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kukui=
-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.3-2=
0-ge311298d5b74b/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kukui=
-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619813fe949b974fc7e55=
1ef
        new failure (last pass: v5.15.2-920-g25e7f1ed493c) =

 =20
