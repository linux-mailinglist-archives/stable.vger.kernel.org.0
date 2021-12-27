Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB2A480469
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhL0Tgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhL0Tgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:36:49 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F208C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 11:36:49 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id j13so12035296plx.4
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 11:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZkD3kJAmNMpT8D/8syTQxrzp4KRS8lOtsDbEewJjrLU=;
        b=mDM3Hcu372x9TFl6WnHkhmsz76XZC/nnkiuMfjZOW553YORxALQgR1lEYPkEvcOjVR
         PykSIyLR1uZpVhbXyo5cYoczwnGcEndkakMI8MVMSgJGb0pPlkI5VuwgWMPviMYwU3F3
         cLnRF4FrYjZ5LW0PQUBNDyeQy6QI3uv/rOid03L8YaPnLrZjYb76NgT/Jbn843eA4Ozl
         DIcMEg6c2+5pzp4I33SxiKHsetk5g3rZGxpbiNWiD7j6tohJ9XAe3IqB4LnyRraFEcKp
         H/a2zQT4KTUHZzdcIRENPfhWQcFV888DLZNDyZS1oo8KbEy3VYfFjHY48nIFVJUA6lml
         KFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZkD3kJAmNMpT8D/8syTQxrzp4KRS8lOtsDbEewJjrLU=;
        b=7eMkQdZoxBto5HXPhOEm52zBC5PU+wFKAX7ygtrjQjypvQ4fkAOHJemdUYHDoQf7nu
         L/dGyh9sNBdDq3GdqjXpei2MI8GxcCsAHNBXRYTuIB4x4Y96asz7+mFDgvKcG+fcH7AO
         Qil5T+TWW93GVA1ASNFGFyLKg6+RRXsR5W6DCI52ShBbKFarI0gN9y2mFf2O9x4DWDJF
         xcGd6ztlZXljtaoaqAeCTONHKGabDj/z0H3qQDvNlI0FX6isCG9fEBSDonj5qFj76ZHv
         TSMxNqRvCWhHu4P8XU4FhzkHCd9nxQaVcuY5+p0p5hi/7iAmeCyXAWKbLuvFurBm9vTk
         Z1Wg==
X-Gm-Message-State: AOAM5334Vu428+8oDOgiGzeC5ZHUU41rT557rMbpwMMqGf2O6M698Ak1
        YNNrcAFRJwpl6SSDaevRgE/cY7GOcBy+JaoQ
X-Google-Smtp-Source: ABdhPJzKagsHgwV7oFT/M2uWohro16wte7VfLKRHBcxxghHrs916bnbWgq8N4xw4JMmuk3JwwRQ7Rg==
X-Received: by 2002:a17:90b:783:: with SMTP id l3mr22426156pjz.104.1640633808949;
        Mon, 27 Dec 2021 11:36:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gk13sm20061591pjb.43.2021.12.27.11.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 11:36:48 -0800 (PST)
Message-ID: <61ca15d0.1c69fb81.7b405.a07a@mx.google.com>
Date:   Mon, 27 Dec 2021 11:36:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.222
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 221 runs, 1 regressions (v4.19.222)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 221 runs, 1 regressions (v4.19.222)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.222/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.222
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      508a321e02f2cc9dfb1f226f7b10dd889887d249 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c352562a22f657bd39711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
22/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot=
-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
22/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot=
-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c352562a22f657bd397=
11f
        new failure (last pass: v4.19.221-10-g1d60913d545c) =

 =20
