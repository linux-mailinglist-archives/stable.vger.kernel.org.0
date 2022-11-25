Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1523639191
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 23:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiKYWkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 17:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKYWkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 17:40:15 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8463F51C31
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 14:40:14 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y4so5103266plb.2
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 14:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vicecIvMrsdMRctihRYJo0rXN51Zl+GtJGjqeQa3L04=;
        b=EKdCL+xO5sJRhP/M0JZHYvYiaOir4v9mB2w1jkCVoZn3GnQiIcLbn7xPqTzv97MNip
         8Uq6pECrcmnAa91uDFHM8RAdtyGeOKVPG8oS6k+DIvbW8U9Rn4yiFckdPMWU2EOKVO2Z
         DaWNywiHOy7qKKbqaiDLOEPLhwGgG2HYmERpdpPsTVg0mImRDcTybG0aMPoP4k/VZzOe
         P/u2JKdBB7uVkWTyW6IkeM7F9OCmTPqvSHatiWLhdHOGE2udpGzMyoKH0h7MPu8wYm1H
         8geVQ48KhXdpeUMa8y9h/2fDDmtX3/V/EGJSCf1gRKIqWhFbtlz3c1bE/UZlu7VYP7ZR
         WF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vicecIvMrsdMRctihRYJo0rXN51Zl+GtJGjqeQa3L04=;
        b=WlPBCdJnaCA2XrArWVKVVahTWU/k8IzPHhI/RlO1nkOZfoF9IRPgZoDXz83BUWKN95
         M3JLQ2CXzdszm5pMHkaXs2Yt/fe88Rge5iZEcBwDrIgkSXZfEh6GWv77DHVhzNSdDw9b
         h9nqMdxi6ljLiDOO9AzecpDI5tOaJdyg/peBzHwnoSMTyQh8wYR1qO07DWiDy1DxLrII
         mjOhToRp0ifoHAsxs1P6OeLfca8wU+pQrK5PlUE68SUCGSjYkbawqVuSCRsfh552d3VQ
         LOUnWfWshBOL/1GehIACl6n/wfC8YDUAXvhKt6r+8YEaN9gUjx2qD17og0/1fzEUx1xC
         C/4A==
X-Gm-Message-State: ANoB5pnXNbRDUaMcOmZgDk2w9bbwdhQYLKMLp5YATTaa6cJ/+9JM12Er
        PmAvSsCexRJYOcau2bomRl0jMAUI72y1kd5Qcqo=
X-Google-Smtp-Source: AA0mqf5n44IPA1NKh9QpIEdV0A2EApYsnpHCf5YZpb3phdKey7nMT/NNPiBEZBUcWLXN1/R4GfP27w==
X-Received: by 2002:a17:90b:2810:b0:213:ecb6:b690 with SMTP id qb16-20020a17090b281000b00213ecb6b690mr49362085pjb.244.1669416013750;
        Fri, 25 Nov 2022 14:40:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902b58f00b0016c50179b1esm3904879pls.152.2022.11.25.14.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:40:13 -0800 (PST)
Message-ID: <6381444d.170a0220.29c65.5448@mx.google.com>
Date:   Fri, 25 Nov 2022 14:40:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.156
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 39 runs, 1 regressions (v5.10.156)
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

stable/linux-5.10.y baseline: 39 runs, 1 regressions (v5.10.156)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.156/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.156
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6d46ef50b123f2da3871690e619f5169eb97af92 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/638112d4633e3a4d022abcfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.156/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.156/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638112d4633e3a4d022ab=
cfd
        new failure (last pass: v5.10.155) =

 =20
