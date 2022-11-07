Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D562261F777
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiKGPU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiKGPU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:20:58 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8103B1EC6F
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:20:57 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id h193so10705207pgc.10
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 07:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=15h4ZwKOk5/e7FyA1mYdxtiM2rhfk2Y6doKXLvUd8As=;
        b=4pm89ehd53RAgPDMkC4mvjqLvSrE6tFSCv/CovbKAoV0vMn30IpymwIYqgFIpVur/G
         S4lUN9sA/g6ppXvqngfBWPSJgIMgvJUNH0EaDrNypdWDIs9QdzHMVweaTTXUH+asHwOG
         Wedy17Chh0pX3xd6VYmY0gUiZ/KUKeUrBdhsd8Z6YiMXRTMAENqLL5DXmBOQ6M27rsaH
         uLSWZq/wJHzCbS/vOzAJDt659+bpXJcZ2gP3VRNgGFBZkscRZhJrIuDuPan+SK7DlOe8
         iWE2OO9cQDke6s+1vS3Z3t/kbzEWSvzHAZ/lhxU+mFsIKyW1Gk0t8+Q69o4FlIB3g9hT
         TJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15h4ZwKOk5/e7FyA1mYdxtiM2rhfk2Y6doKXLvUd8As=;
        b=yVIjjAdT63U1X99PKYbLhIq1qYNguasnJ1AECIT6IILnkWiBfUCFWYMhI1SRxbgPqm
         MBZYy9rzOadXAa+rTb1shTlYiwV/ET0gsxINbMR6bKY8lDOE6r3afWilwo/qgfr+3bZW
         XzlOZxWNt+nAtKtecoT+5J7GDJwZqdj5mN27TlBibaBgvuxib7hmEd2/d8rIbOYI1Fgy
         BFNzvCtDzaCUpMbzdCTV0xZBCqv1+ek+D4rHqxQwyjeF8QNBXb1Lk5ioWwuzKNYgdLcD
         fdEQ9Ai0dZp8o+NVZahi3boAiiekqoUafCs045qQglodam7nbbJOOTETcAf+Z6SilVT4
         /XfQ==
X-Gm-Message-State: ACrzQf020uiOGMY3AMxZOuFJRjvcw+RxmTtbpTOqd80kQFQ8eVsRXjdw
        KVCafeaD0qYsmNy8T+rEXnHMPmwTcx8pdg==
X-Google-Smtp-Source: AMsMyM50FBgKbTshk7MF2zXMQksak/7QcMqbDa6yfNCi58ehZt4W4SjRap0bdBqprVzDUlZORNU3AQ==
X-Received: by 2002:a05:6a00:1f06:b0:56c:ee8a:29f7 with SMTP id be6-20020a056a001f0600b0056cee8a29f7mr51235112pfb.44.1667834456940;
        Mon, 07 Nov 2022 07:20:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d1-20020a63f241000000b0043ae1797e2bsm4244813pgk.63.2022.11.07.07.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 07:20:56 -0800 (PST)
Message-ID: <63692258.630a0220.df604.63eb@mx.google.com>
Date:   Mon, 07 Nov 2022 07:20:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.153-77-g2aa7181e4115
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 76 runs,
 1 regressions (v5.10.153-77-g2aa7181e4115)
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

stable-rc/linux-5.10.y baseline: 76 runs, 1 regressions (v5.10.153-77-g2aa7=
181e4115)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.153-77-g2aa7181e4115/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.153-77-g2aa7181e4115
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2aa7181e411574a3638f16ad3dddf545e61a36ff =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6368da68381a666b37e7db52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
53-77-g2aa7181e4115/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
53-77-g2aa7181e4115/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6368da68381a666b37e7d=
b53
        failing since 7 days (last pass: v5.10.150-80-g04a0124fa82b5, first=
 fail: v5.10.152) =

 =20
