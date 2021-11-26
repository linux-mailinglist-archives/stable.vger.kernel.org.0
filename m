Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA9745F658
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 22:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhKZVaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 16:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbhKZV2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 16:28:10 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C44C06173E
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 13:24:57 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so10631943pja.1
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 13:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bmTVOKSp753M156f5iye5K8OW9EvLpf8Njg7OFXa+UI=;
        b=I30BqCAPOfMgroLXbq2bXPeSuYESuswFo5WFA+yo7Kxt1TIympYOW4hv3DDDaFyETK
         NQagnMGXYLvJECZT4Hjeq+DaKnp27aTiFn6eX6TKZjQnCEzA8fHs1lcS1hiJU1mRHD7X
         +xNvIu+6s5W0jkAQpivw5kG0YV25uLuwPwDnQN7p1YProJa440P1u3Kj7lfKqL/1+hdu
         +dQdTK5yl0GseSx/v9jMkiO+svboN1J1LSUojJiz/WLfZ83dwCQZ5A26gsSpsIqvKWIN
         zryJDqmaxut9aWV9GSsbtzkyiYLccEHedds4Euwn6bDkVdvGUi9A7f7fqedoC2YwEkKs
         rpAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bmTVOKSp753M156f5iye5K8OW9EvLpf8Njg7OFXa+UI=;
        b=2jpHnyXUOj4w6UQ1LbCe1/Jn0dLsAmw0cc4x4gxgYRXnrNbT40LOXw1wPiVXDoMiiB
         KQrGu7ZHNAOBMavb4RyyGpok/0auFchSeyOdEvbTD44hYCso3e6vgesVasrpH0m0SN2n
         VF0tssF59bAIE/D6sK/8t27eRQ44mayc8VSvc+D1zzTmB/2amqhcgGUCKICHnfvp2IsW
         wSmJramNqpetZtIL9A+Rko9rAwEYHxh9kLhXiy5ppP5rUYz3UsVDv4xJzBvEQiPO1OEI
         fB6RJPzolBXuN+NQ2lHdsNIvzGC1Ng4vekdhbnkgoIHtSjA8xP7WkgIXBIMwOvsg1aSi
         LE4Q==
X-Gm-Message-State: AOAM532RXCvNY3OJoFy2oUYyAaIHOZSxsDUIBy+lnNzduXW89x/T4y3S
        DD8NQEuKGVFojGAaYHgWIeal6NbkYnSk1G/b
X-Google-Smtp-Source: ABdhPJy/sx8XhP3IVapekupqFO+cnm8uXdhchBJjXmxjoCcE9jDrnhd3uVMeTT9Te61AKnlQueqwHA==
X-Received: by 2002:a17:90b:350d:: with SMTP id ls13mr18666349pjb.175.1637961896347;
        Fri, 26 Nov 2021 13:24:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f8sm8812019pfv.135.2021.11.26.13.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 13:24:56 -0800 (PST)
Message-ID: <61a150a8.1c69fb81.d7992.835b@mx.google.com>
Date:   Fri, 26 Nov 2021 13:24:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.162
Subject: stable/linux-5.4.y baseline: 159 runs, 1 regressions (v5.4.162)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 159 runs, 1 regressions (v5.4.162)

Regressions Summary
-------------------

platform    | arch | lab        | compiler | defconfig      | regressions
------------+------+------------+----------+----------------+------------
i945gsex-qs | i386 | lab-clabbe | gcc-10   | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.162/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.162
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9334f48f567334f54101223012ec9d3b4628bed8 =



Test Regressions
---------------- =



platform    | arch | lab        | compiler | defconfig      | regressions
------------+------+------------+----------+----------------+------------
i945gsex-qs | i386 | lab-clabbe | gcc-10   | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a11785e187f1b16518f6f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.162/i3=
86/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.162/i3=
86/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a11785e187f1b16518f=
6f8
        new failure (last pass: v5.4.159) =

 =20
