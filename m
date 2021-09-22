Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14B2415020
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 20:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhIVSt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 14:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhIVSt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 14:49:27 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA41FC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 11:47:57 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 5so2392425plo.5
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 11:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=teGf3SLmpbkmRAHARnF2vAubnuNqb2r1wxJ0VjMJyTw=;
        b=san7ZMAdZcGsw4qGolbN6P2FQVw3RcZ/0FSV17EGHb7Ibp+rGjflPwJ5Dpd9W/3Fkw
         pl8klxyQpsZPH90WcQfVDD/11VPF/0QFDnFpFE4LB6JlnK/bNMFqmWK2Cbq1T+WtY5I2
         tZqZv0HZDik+BZ7WVe6uk6EAFtk+548EQHQNcqW1AyeFm/aCMvaSFRynAdWoMOKXNk49
         MY8cWQt84RDCXUq4S2qJBeGrrqUBUtT63CZM4HhNm1WRAg4SJSVmPRxNJa7n0pyLlyIo
         bZmELK0mP5ufvs6gsB3o1MKaaYzIjK4XC7C4/cPSyF6spqnJDlwvCzBERaj7Xl70gVzq
         RmUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=teGf3SLmpbkmRAHARnF2vAubnuNqb2r1wxJ0VjMJyTw=;
        b=UlLaX7HIQS7gISqfBwfVWvBlPKmH9pNE8MoBtF1X9aXAMMO38uG09F2XL9dsOQB+fH
         buFxAtpmz6sH7JPPbo9BSfZVLdS1ceROfvb1aII5rMmfiZXj0TrkJiFIenppkTYmirDF
         9txI77LCYEX3jaRVAo9Dgv78uAM3M9wcmm4S+K9773bmQK3cwbWXMafaimURPJM357Om
         zQhw3LwpD/HLb2zg93Y7dNxrjYbycGy+XpAm+DAoGw8n4LqS6MH+VTc3LTw/fgeKe6uR
         cc+PNASpnGTqfmziAITx9NsiK5TCWz5vpaUQ+NWmMttCzxsj1+bmuIXzOUmupKrXuoR5
         VmEA==
X-Gm-Message-State: AOAM532qvtE3vVRVsu14x6FStO1RmBFiMmJ6rSgGOxaIC/YB+9rGN9FA
        KlC4TnUmSkXOWgdsu8YGymew4VX3YmFHrAKj
X-Google-Smtp-Source: ABdhPJz92XL3CWQ0PhWrTab1SMqz2zZ3Wp45oMxQLXxMRa6GyuvNNOlk65RESA4X7iLyuPONJphzXw==
X-Received: by 2002:a17:902:c942:b0:13c:88f9:1af8 with SMTP id i2-20020a170902c94200b0013c88f91af8mr324027pla.3.1632336477009;
        Wed, 22 Sep 2021 11:47:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p48sm3210079pfw.160.2021.09.22.11.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 11:47:56 -0700 (PDT)
Message-ID: <614b7a5c.1c69fb81.59e3b.8b56@mx.google.com>
Date:   Wed, 22 Sep 2021 11:47:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 138 runs, 1 regressions (v5.10.68)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 138 runs, 1 regressions (v5.10.68)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.68/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4d8524048a35c03ff04c25ca1bcdf569f9aeb14a =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig | regressions
----------+-------+---------------+----------+-----------+------------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614b43fc883223e66d99a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.68/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.68/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b43fc883223e66d99a=
2ed
        new failure (last pass: v5.10.64) =

 =20
