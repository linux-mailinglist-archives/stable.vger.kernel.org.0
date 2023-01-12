Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E50668480
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 21:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240734AbjALUyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 15:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240503AbjALUxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 15:53:30 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ECB62C4
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:34:22 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id h7so10459341pfq.4
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TPkxvdQtMa7S3QGUxFZq3TJPr9zZYTdIupNeYxCvTuk=;
        b=Q+wPM8zaSRw457nu+FpH886TQjPcaVwMWAVjogKVHENz8JAbj56xm/pfhld28jPNkg
         zRt6U9XkdZGQG10DspxNpZUn9G/nc6ziUFkdM1rpqlZb+CPAJEeMG1M+058A3JrGGOn7
         ba12jl6A/YCbqNATHBtjLQPc+vs98WAadTFRfjOh3hljf1QmQ59VYV57kXAMVPEbETUl
         wQCmW/U0fIgjC8S4a+L70Ek3d7pp4MvI46hfa0Or1igcM+lYT/lbRicXbHQMiG+ibAgM
         /xU/Q3/bI6RH2jj4Vl6SOcJ7lWWNOKDKWxLXn5RPZtmUXetaRXE/Li6SifftD2MiqxEG
         2ljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TPkxvdQtMa7S3QGUxFZq3TJPr9zZYTdIupNeYxCvTuk=;
        b=EfBzOR3HAmcOZY6JbMZtmdM5pPfbEJYeoZffTlLH7ndiEJjjBsV5SnfUHeVCAHDML1
         zC7tKhp+8beuFZ0Yv0ReCvU4MJQvCe6PP/JWp1LmCSCJ/WEuvAVm/doxPBXBYDoU5XAZ
         UvB5DNRCUe+OJE53tsMxZVOBnK6lXoljAEuzXw7NDzwfhbl855MmVqAD25E2esq1L2F3
         QO+7zTclpxqEQ8WcpnUSspfaFDVbREReBIuGb1B1fXyBTGroNG5rvB+hXlhCMKSBWid4
         O4q1r9nr6c6wNtwzUzysMM093TOryYbFzTmqaeaWK/NZvbiBjl31dY6X9cksN+UuJcHX
         FXmA==
X-Gm-Message-State: AFqh2krrbhjChxGIPffSTB3bc5JX2IRbbrWdN3eZSAjAshpaXqfGGRyp
        +qpFp6VKIRhO+ejUclibNJTWzbZrE83r+1KYrvbPmQ==
X-Google-Smtp-Source: AMrXdXtUTYPYrWesRGLRs8puSQ1vI5uaGIfuq8n9/k216/qXh5lCuqPOJHA8FdjMncfwnaJXVPGbwQ==
X-Received: by 2002:a05:6a00:1f09:b0:58b:48f5:ea28 with SMTP id be9-20020a056a001f0900b0058b48f5ea28mr8237040pfb.27.1673555661841;
        Thu, 12 Jan 2023 12:34:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z67-20020a623346000000b005809a3c1b6asm12246859pfz.201.2023.01.12.12.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 12:34:21 -0800 (PST)
Message-ID: <63c06ecd.620a0220.e663f.4007@mx.google.com>
Date:   Thu, 12 Jan 2023 12:34:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162-784-gd33d55703c78
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 109 runs,
 1 regressions (v5.10.162-784-gd33d55703c78)
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

stable-rc/linux-5.10.y baseline: 109 runs, 1 regressions (v5.10.162-784-gd3=
3d55703c78)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162-784-gd33d55703c78/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162-784-gd33d55703c78
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d33d55703c7895c3dd8793cbad6046db91df21db =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63c03ae2d234253c371d39d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-784-gd33d55703c78/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-784-gd33d55703c78/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c03ae2d234253c371d3=
9d5
        failing since 14 days (last pass: v5.10.161-561-g6081b6cc6ce7, firs=
t fail: v5.10.161-575-g2bd054a0af64) =

 =20
