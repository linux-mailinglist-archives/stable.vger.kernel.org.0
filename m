Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C709C475243
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 06:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbhLOFsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 00:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhLOFsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 00:48:13 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C97C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 21:48:13 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id k64so19727475pfd.11
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 21:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mjmu8BIyF2ECk0UuaOWolEylTcGclYmnslMcaJ8N0PM=;
        b=xvMwArXMioZSSD5AVY+ufIMXWcrrDU5XyQB0ln1n6J0yMS3j150pGy8ou4Rnwgt85p
         UXqHNVjueRaruoJ//8U0ZqMsrBU41vitkg1ByIqGVJuuO+cRTWmWdcRAmw45L7P/sjtr
         TKvP+eQseHUYQ3wiqvAo0TRvqZszHU9PsnBb0w70Ht2/AWagdR3A1wVWs97ZAvGazGgi
         Hr3WQZORKr4eZRj+6WVUKnE0fPGAlZrXN+j09t8plfU8X42y3508J3N+AFMPhftshIDu
         KdBFlykCJupdJurywgOKPhCUqvW8I9hM27PR/bDG7wKlwxm7nHB8PHD2m9rA1UiESB36
         GFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mjmu8BIyF2ECk0UuaOWolEylTcGclYmnslMcaJ8N0PM=;
        b=1N2147WkwjdXE5Pi71X7grKd2QHq+FcIt96zpuk6sV9+mtF3nsWhppQ8pAqkhyHams
         MRfHuLSKjwRAuES9kc7JX18IZGXSmZd9bAc83MJmChQSZTZSSSNAzkMn5FLOiVdczD5M
         rj5f1MfexVm3/whq8CCD68V+klp028Ckoh9DbGH/Qxb8MK7i6Z79jU54+C/a5n5k2e1W
         cP4IC5cKmkd7Yx1ZiRoni/Jjo2v2vEukt8c+AWIRj9o/CfqwEnY87lJnWmAE1OICTfjN
         7et+HUPgo92zuy/KdJFnb9tnNT7LqICKpxkf6ywmV2XvESxWRcKGLlHpGImywP2DAZbG
         H/lg==
X-Gm-Message-State: AOAM532mfNAfh7oc/OtEf2cIrFVdmXiL6bmGmWumEgk1GgYbDtLXJo1L
        yEEtbi2waCiUx3ZLtDQIOS21Q1w7tZrvit4t
X-Google-Smtp-Source: ABdhPJw8np81RTH4dowXvk7INeadZZ83doYBSWV8fdHTIEModV6EcOPsurOVV3UBMEVRpWBnTLUUVw==
X-Received: by 2002:aa7:9a1a:0:b0:4b0:9ff9:9f69 with SMTP id w26-20020aa79a1a000000b004b09ff99f69mr7690261pfj.26.1639547292407;
        Tue, 14 Dec 2021 21:48:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o2sm928349pfu.206.2021.12.14.21.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 21:48:12 -0800 (PST)
Message-ID: <61b9819c.1c69fb81.c852f.349c@mx.google.com>
Date:   Tue, 14 Dec 2021 21:48:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-1-ge49d4500bf38
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 98 runs,
 1 regressions (v4.9.293-1-ge49d4500bf38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 98 runs, 1 regressions (v4.9.293-1-ge49d4500b=
f38)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-1-ge49d4500bf38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-1-ge49d4500bf38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e49d4500bf383906f9d4d94371b92fc49d4b3df2 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b949bb68b83be7d1397144

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
-ge49d4500bf38/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
-ge49d4500bf38/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b949bb68b83be7d1397=
145
        new failure (last pass: v4.9.292-42-g7b8a51e9ff81) =

 =20
