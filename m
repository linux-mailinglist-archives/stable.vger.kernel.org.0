Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB606518107
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 11:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiECJc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 05:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiECJc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 05:32:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E48136318
        for <stable@vger.kernel.org>; Tue,  3 May 2022 02:28:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id w17-20020a17090a529100b001db302efed6so1533409pjh.4
        for <stable@vger.kernel.org>; Tue, 03 May 2022 02:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KrFJ6qliNBLhdmZp+YWA7SbW1rW9R7K9Am6wTNJVrEQ=;
        b=WNdk61iPBSZblreba/B/3/IY7uTeu+n2kwvavm3QWzDqspkvq6I1bKA5qfbNHYoM9c
         ocdr3lVRxaRHrsRtiVqDuPdpnpdPMbUbOYNP1JLSYwL1xeKnC+uYuU50X2Uepv8QDDHx
         aPYVQavDx1LByCvtLejFjF8eo4ObKwHnOfyvoDEvTzlJvSekpcOjwBF3CoPM3adfS7pr
         D8wMbl+06LiM+z38qh0S00G68hYL9KLkG3OczVSkyX+QcAT0pqikhVQvbH1yqELGUlIe
         v8owPVJFr5SpNLaxRoCUIIML/3wgKEAbDtaOUwnqUcpnPQ8wMUECnec6+rAx94dDEeF4
         kisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KrFJ6qliNBLhdmZp+YWA7SbW1rW9R7K9Am6wTNJVrEQ=;
        b=U6AnDqL65sT+fnfO5k43B6KEY34jFvVFLYXlswHrEu6A6VBB1Ro0EKLm9IN5C2Jgzr
         YHtIAm2sPUQ+bD9EC9fjcJ9tN8y/2akKl2gRH0fW/g0ooDYwYguoev8qILpJSSGjMS88
         GaocLgJKW1cROC7bcZsUNu2NOKE9LgAGLW/Rq5Mq0PrfkHASTtmoeO6FbHsXR+B7q8PQ
         Fgjk9f80nFMBpvhiJk2ARZr7ovEj2bRiViPU2R4XK83MSXDIylakbjGdbe0qLjJR0h/o
         gB0aEIG05r1dm0T6NemqbVA2DiiUjxD1mXgpi2qUDsQA5kXdKY6XpVMgQzPkPKHFXRks
         GJEg==
X-Gm-Message-State: AOAM533mdl5jOvdfJ6mo+xUKX3/yiBFzsLxoPEmbc4eH/3JMo4wZX6ti
        XfIZPhVgmrtz/hrpfKHPgOP3/xD1m6ZrP8BSa8Q=
X-Google-Smtp-Source: ABdhPJzdYmfA5bDt5wGndUYoUXX9CL+8nGI7gNLMOuNrvpA1NU/rgxPnwndd0faKXcZrCB5IXBfhaQ==
X-Received: by 2002:a17:903:1c1:b0:15e:8cd0:46c9 with SMTP id e1-20020a17090301c100b0015e8cd046c9mr14955646plh.72.1651570136453;
        Tue, 03 May 2022 02:28:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i24-20020aa78b58000000b0050dc762818esm5933249pfd.104.2022.05.03.02.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 02:28:56 -0700 (PDT)
Message-ID: <6270f5d8.1c69fb81.5cea9.ecdb@mx.google.com>
Date:   Tue, 03 May 2022 02:28:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.312-38-g16e3f3f4add3b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 75 runs,
 1 regressions (v4.9.312-38-g16e3f3f4add3b)
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

stable-rc/queue/4.9 baseline: 75 runs, 1 regressions (v4.9.312-38-g16e3f3f4=
add3b)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.312-38-g16e3f3f4add3b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.312-38-g16e3f3f4add3b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      16e3f3f4add3ba6d76f1a9c42f064ebfe58d0f97 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6270c3652476d8e7b1dc7b24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.312-3=
8-g16e3f3f4add3b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.312-3=
8-g16e3f3f4add3b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6270c3652476d8e7b1dc7=
b25
        new failure (last pass: v4.9.312-35-g87deb3ca1e95) =

 =20
