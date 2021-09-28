Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDBC41B188
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 16:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240898AbhI1OGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 10:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240488AbhI1OGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 10:06:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C631C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 07:04:34 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b68so1092419pfb.10
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 07:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qVfPI7nDYURY1PhyrsBP0G2+839Vx2Ycu7HEf0lxTQs=;
        b=Pso8hRotqtxVDvPg4cFt9kaH1XsXRr/sffpdBytv+K4YKh2E6j3frF4aRGQ0Jpmhor
         0UfhmGuGTotoYNPdgmzPYcAx6PwlwQwZlcAuVzRw2eq8mEQfjLVLD0n6shkilv2nu8Gn
         97mCQpPQvegjzbydmyGRIjDoOohS9t3FeHnqjsVeAyAro1ZEGj3eKp5J38/NJ1eANIpT
         uqbhmMHTP7fCFE700G+Fk6DrYHCGoMkb99NxXQNx3RJx5xg63KIav3WgG7NnoNi3xTia
         U9LvmhWRTcpYnSdNvnGNdilO/FnpDE25iCaykhUyjfAmvxFYbG07jgAzbVr2xixFfPVt
         HKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qVfPI7nDYURY1PhyrsBP0G2+839Vx2Ycu7HEf0lxTQs=;
        b=QhxL7UG/TwzInRueWia23qRk4uGj9hKzWAOHmq+2PB9uORzva0jC5RqriO5b8HLjc5
         ml3CVRmql+m8JrWgYTXYnZEOKWDTcZ5QvT8IOwUGEg0iUAkayUpsC7ioDJ0uj/qsuZcS
         0+kFJlqUpBLY6eFSg5iZvricyaRatXqEAAM5IV/J8+lGTV5uWmz91GUQWe39SrqKWvZp
         jSrtw03g7O0+pKGs51vAkulUL33NlGazxKCm/wJY5kIEzY2V8i3/JOBvW5X3U56ji2mw
         TpZB4RyQtdfDNDPHMC27pMEzIkESMKFzt6yxRXOHZXqTkULdhpLGTPn2gagTb6xegOuc
         EaOw==
X-Gm-Message-State: AOAM532IZ2K+tBmRGLOkxgs870hdzryBjQNoDBGG8iRUwW3z+8ojpZNh
        InHIt7KwsrPENL3KmhsRlBbdhnWdjuJdVnU1
X-Google-Smtp-Source: ABdhPJxHtCb1HteE6lZ6YBLrEg3PEzgzqAQbGZYVRneItmjYpI3HBnkmRzAdMgJzipS54xM0hvlmcQ==
X-Received: by 2002:a62:7543:0:b0:44b:b97a:d0db with SMTP id q64-20020a627543000000b0044bb97ad0dbmr1282352pfc.9.1632837873494;
        Tue, 28 Sep 2021 07:04:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fh3sm2885629pjb.8.2021.09.28.07.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:04:33 -0700 (PDT)
Message-ID: <615320f1.1c69fb81.1852d.8ba1@mx.google.com>
Date:   Tue, 28 Sep 2021 07:04:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.8-162-g6ee566ecf238
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 116 runs,
 1 regressions (v5.14.8-162-g6ee566ecf238)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 116 runs, 1 regressions (v5.14.8-162-g6ee5=
66ecf238)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.8-162-g6ee566ecf238/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.8-162-g6ee566ecf238
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ee566ecf2389b44c84362709162382d166f80c2 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/6152e56f9c6728f94c99a32e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.8=
-162-g6ee566ecf238/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.8=
-162-g6ee566ecf238/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152e56f9c6728f94c99a=
32f
        failing since 6 days (last pass: v5.14.6-169-g2f7b80d27451, first f=
ail: v5.14.6-171-gc25893599ebc) =

 =20
