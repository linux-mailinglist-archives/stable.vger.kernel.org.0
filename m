Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBD9661139
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 20:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjAGTQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 14:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGTQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 14:16:26 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D7F33D54
        for <stable@vger.kernel.org>; Sat,  7 Jan 2023 11:16:26 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o13so1259986pjg.2
        for <stable@vger.kernel.org>; Sat, 07 Jan 2023 11:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ccUk8Uhj8u5o4rLhdOkDzESlpsD3PD47CK2NMkB/DEs=;
        b=A443qqGAmb2PjlwjzuCNtRKwoS9CRXjJq+nTmhVMXmFL7boZxG77PjEB/IrXo/FoWo
         NSfH8W/IJXr4waT03U3bfWbDa8eYFwigypDykp9eJoksygeUbnai6VkRKtMhMXg6ayai
         P8LRECj/vMpOeAQbibJQSO/1/2DLEVvUiS/vqgupgQtWwt1spn3yhBs8hWJFWpC0LQCh
         kfX6YbTA1kofr00Zd7EgKqrGvWVQGuJZRstx/GHqPqvGse1zMgMpuU8VRZlWq1O1s7WA
         UhqCdkskQN85YS1NKOuiPvbIgNL2ZXRLaLAAO64F2ySB+ReJ02nXo6sovoQTOlYDou9n
         B6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ccUk8Uhj8u5o4rLhdOkDzESlpsD3PD47CK2NMkB/DEs=;
        b=FSbrz//FIQBceOYYgA7HzzkWIQfpozdV2bnJJnVGojf2768AsKDzB9F76P+jjcG160
         bhEwvj13xhwMpIiNQwQDn54WKf1DyZ8V2JWPYDO0cTWCN3g4XUF11NapMHv8dX3VgRfI
         txijU45vLM7lKJnyz9JBTCeg7Mzx9ebwZ9h84YZUSIyXI+hvbPUajareMgMfa7ZvsowC
         1h4cB/eVINnIsAKW4B70dYlsDHkr2Z6/2oi8mWYTAGy22nZqf0hsBAbhmId5LiUw/tC7
         br2LsNQ0w0RMVLjAzuU+mjkSuWW/YMjDprzCasbqL3wUiXGB7eiy9Yor8wfbOSW/cw4m
         /eWQ==
X-Gm-Message-State: AFqh2kpimOPtSIKxSzIQ/IsMKONcCLlFK5S76yvrSzjFS/EwPs0Vcsgz
        jTDPNgJExjroGp/TnsKlF7fX4V1hFyswS+Vp9blC8g==
X-Google-Smtp-Source: AMrXdXuB0ziHCxLAZ3uSet1ZJio6E2z7RmCiFCuuspCw++1ZKX0rMi+EeIhTjP9yAbVPEPJ2/kwV8g==
X-Received: by 2002:a17:90a:1588:b0:223:1a17:55c3 with SMTP id m8-20020a17090a158800b002231a1755c3mr63327216pja.41.1673118985549;
        Sat, 07 Jan 2023 11:16:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c5-20020a17090abf0500b001fb1de10a4dsm2714311pjs.33.2023.01.07.11.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 11:16:25 -0800 (PST)
Message-ID: <63b9c509.170a0220.72ccd.4291@mx.google.com>
Date:   Sat, 07 Jan 2023 11:16:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 148 runs, 1 regressions (v5.10.162)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 148 runs, 1 regressions (v5.10.162)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0fe4548663f7dc2c3b549ef54ce9bb6d40a235be =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63b5837fc1634ca0c84eef60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5837fc1634ca0c84ee=
f61
        failing since 6 days (last pass: v5.10.161-561-g6081b6cc6ce7, first=
 fail: v5.10.161-575-g2bd054a0af64) =

 =20
