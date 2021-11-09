Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AC244B451
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 21:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243334AbhKIU4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 15:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241538AbhKIU4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 15:56:02 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B498C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 12:53:16 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b68so497753pfg.11
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 12:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C0q/gONsB7oSIPxLMQps1uwp4+esGAZmUgn1vc0hcno=;
        b=G/xc1itt4Ayaq1p9uTIqmcJRBEf6QxSi3rWttfC/4zSgQQ9/xIgCu17AhG1biR9DFI
         fmIfq+C+01i1MoaPNCOXAMVAxMGqN/0q8XjLZ7mdMI1q4Dh9tUyHzPHN199wojYs9bBk
         IJ9JenqmbJvDNXQJ5gip+ZEspncZSajDHbcY3D5IIfXnl/q78s4QVFeX5ytn1OStjlcc
         MtMLh+GOYfVJCUN2yceNgxMROS1bot9J/FtEtAvL/A/yZbANI2x4EcWOxzOhkdqOftSC
         44wmnoKUskcKWU7Q3bRk46ArOzptjREavu6AAxjNguivkLsMaD2F1YJef6e6FF2F/m7K
         L4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C0q/gONsB7oSIPxLMQps1uwp4+esGAZmUgn1vc0hcno=;
        b=FrGv2focRMsxxFl7vyDiJmIRCURb4DxmLpXw0GF9W7Cow2dgjOhJ37H/FPcyPk6ZTW
         2kg/f2whSGv8je5dpUSXTlAd220USAFVvyJsyrnklw5kspSA0wXbS4DdfiAWrHiKppzy
         QdTSHrhBt6wJ/n0OzBhyDAIiBkf6lnOZYjxy8uRX+mznHgPBf8Dk5eNd7zq6RiSKlL2N
         OOz/8cFK2vtoTy5suzoUdXKq2YTsYA/QsIu/BPgGFOY/sAEsqtMT4EWhC4Sw1ZoCJGxo
         J3o95+AhJNdTSXne4S7vvDDLRNgwPhHeWkMKGXMM8D6yo7HgMR2ukfGeqpucs0uS1lhX
         gRNw==
X-Gm-Message-State: AOAM532lb469CS8WWKs4QNv1h/RdrMcYfYV1hvdh90ClgbMvegV6keSV
        6vijNn6jkgJU5UhFzX9AR6326iu+8ghsvD/C
X-Google-Smtp-Source: ABdhPJw3ghHAogNeS1thWlbL9E4StndiuYZNrQZQt8J20lfuZuJflC5Us/Gq4lRqQapbJrFitbi71A==
X-Received: by 2002:a63:3c4c:: with SMTP id i12mr8125089pgn.447.1636491195908;
        Tue, 09 Nov 2021 12:53:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ls14sm3590457pjb.49.2021.11.09.12.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 12:53:15 -0800 (PST)
Message-ID: <618adfbb.1c69fb81.f00f6.b2e5@mx.google.com>
Date:   Tue, 09 Nov 2021 12:53:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-8-g748a6d994abf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 137 runs,
 2 regressions (v4.4.291-8-g748a6d994abf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 137 runs, 2 regressions (v4.4.291-8-g748a6d99=
4abf)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-8-g748a6d994abf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-8-g748a6d994abf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      748a6d994abf5788e87fdd01daf8b2f6d0f9484f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/618aa79e4195f4d0e03358ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-8=
-g748a6d994abf/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-8=
-g748a6d994abf/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618aa79e4195f4d0e0335=
8eb
        new failure (last pass: v4.4.291-7-gc8615621e022) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618aa95f1fa5763e203358f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-8=
-g748a6d994abf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-8=
-g748a6d994abf/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618aa95f1fa5763e20335=
8f2
        new failure (last pass: v4.4.291-7-gf3d4ec0d5ea8) =

 =20
