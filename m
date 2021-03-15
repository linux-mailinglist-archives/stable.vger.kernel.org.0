Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6472D33BF31
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbhCOOz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbhCOOy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 10:54:58 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F21C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 07:54:58 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c16so15454301ply.0
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 07:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zcFqMPXqkOUbzKTmRyqFDG4eZJYz/+JziJwANmUIL5E=;
        b=PqeOnGhvquYzZbRbsSMy8TktNT+jjAR8CZzIli7sj22uxt8S9NuonlBzsCXNMTsQsu
         VHNU0ptYMy63F9c+eFrZA1Dd6PWxUgY6FkQIGRneIk5ASW1Y4JN4lHUCojBTOJul/iTm
         MlRZc3hivmLgBEUCsQooY0go7HPWJ1S36gUjme0Q1KWcbR+FeBXc70rEzi3QpKdE+/sk
         VA7QeLEs8is4vVTHXXMEokCL7RI33kRdL5Ru5CYEYTKNe9f75TO3ve2X50oTtE24aAKw
         3aswItkDAWCIVNsp3vZjJw+2NcRa9q2VtjDviv+9Gh71tK45EyJPJOVIhFrtYXlqpf2g
         zaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zcFqMPXqkOUbzKTmRyqFDG4eZJYz/+JziJwANmUIL5E=;
        b=JLs7t1DFUKuWjhy+BcWxQiR9EmY7DoIRC20G7T0k4yQw/3N79MInO+Rt+B5NwngG4Z
         dVmDBNsm9KzmGwGcFM8SWBtjcyRsBOme+7LyH7rgiV4zf/yg3Alz9py0rE0iRSQ1xe8K
         gF+/A225iivY9XXaxbiYdvhCCH+R5Ts1JXm9RJcJAgN5IN3fg/myhYFERIaAQLlOyRUl
         xdhHZaRSX+cyT1FK7iJtPQp+xlhhGTltenMNsEtwNaMzbidGB+I+R+KlG9jPh8xcJ4vN
         IWH6jHClxZDn/qiyEhCIr0QCxbjj8JVc21tdNylpVpAxwjotqji3MpcryPW13+DGmVh+
         xA7Q==
X-Gm-Message-State: AOAM530rIwEXnzlADRMHiRRZdqnxqe03SqeVXDezukye5rOMy0kFQ0ha
        oLNJDmhnA6mDBqZWeR6itDK8jKy3Dj4LSA==
X-Google-Smtp-Source: ABdhPJyrHYI1CLrkhEqpZujD0VG9WVTJdMBezazPaNhoCSWPdqWYMv/Y1n0n67VXSKKF+OLEnwKNUw==
X-Received: by 2002:a17:903:208a:b029:e6:20c3:2300 with SMTP id d10-20020a170903208ab02900e620c32300mr12203986plc.47.1615820097621;
        Mon, 15 Mar 2021 07:54:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4sm13971624pfq.103.2021.03.15.07.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:54:57 -0700 (PDT)
Message-ID: <604f7541.1c69fb81.f6c5b.20eb@mx.google.com>
Date:   Mon, 15 Mar 2021 07:54:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105-164-gc5d575f3a9d9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 153 runs,
 1 regressions (v5.4.105-164-gc5d575f3a9d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 153 runs, 1 regressions (v5.4.105-164-gc5d575=
f3a9d9)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.105-164-gc5d575f3a9d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.105-164-gc5d575f3a9d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5d575f3a9d93bcfc8e2fab5b8d14669dfa5f959 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/604f418d97e455bcadaddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
64-gc5d575f3a9d9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.105-1=
64-gc5d575f3a9d9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f418d97e455bcadadd=
cc7
        failing since 115 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
