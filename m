Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E31E49B748
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbiAYPJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581480AbiAYPHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 10:07:38 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D93C06176A
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 07:07:35 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id v3so13219695pgc.1
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 07:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RtQPzV+BFysQu8d9hPgDyqvej9kh7ve0v5tK3qO/isw=;
        b=JwzYG42nUQwjNaeN6332zz1lMQsOxfuEyfAMBpkhbLcPgdhtoKxfz2iwF0BWOGeO4J
         +rV0PfF4Z0mGCLBXKVfqmqjXx6u/jCQead5o3ZM1zdVfrIrt9QdYsiSmcK/n/7FV1nb2
         7GrDPrG3BvhQEeH1994VqOescO8TBM3KGAHH3oQSaK4vpSb6rZXK/v+OTYQOtSbtmYjx
         nL3Zl+BznoYNbjSX7NbKVWoC5N0nl3uoXmm4Ow9d1hps+XSSS57mG7K6X3JdbfIHXMbJ
         8a8G79Pr2ym851FmqS5eND18YowJPiKxaU8BKiSR5+M/ir+eyRn8DOn6GtQUM4t2hyEC
         v+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RtQPzV+BFysQu8d9hPgDyqvej9kh7ve0v5tK3qO/isw=;
        b=YaLfBt/U2rVfaQZFlyZa1qwAcTSwIkzAGgNck/0R1HB8wv6ORHzBRNYQoZnTIFDVtT
         AtgWwuuHef1rHFqgQkcHve1GZ/Aj6C48g0mF6fyvYibZfC6eJeq35L3I14YQJwfqhJH0
         6MWPsBn1Al5Nb+RCyGnaIB/qGS7rpXIOLKsBU4FlvVf2J2QzkSofHSKMfGN3Lf0NzNx1
         2jbfmx0y7Xdga71mSOkyB7rDiOLv3K3yG5O0xx9XqBshVago4AvvuXTMiyqB97M0XcIW
         49mvdjdq6+dpv8sT8aOSHfnPL+CCyqAA+1EX7PIVPi2KOjbPlMMCcOgJyMT2fNqlcfKp
         qxIg==
X-Gm-Message-State: AOAM533UadkqpDnpZRjCVdUgwTX/AkQ88ZO774JptgCR3XTBFFTxADbx
        pnxp+jil7HCJxHimhnjNZ7yuMcxvHEN91M8S
X-Google-Smtp-Source: ABdhPJwIHIU1RfvY9207CbRJ6Zkkex5IWb6cRUk/DpNM6zgs8b+pOWmSxbl7LO+zIIYuvXXcTSA/aw==
X-Received: by 2002:a05:6a00:b55:b0:4c9:25c7:b522 with SMTP id p21-20020a056a000b5500b004c925c7b522mr9175888pfo.55.1643123254930;
        Tue, 25 Jan 2022 07:07:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16sm20315634pfu.9.2022.01.25.07.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 07:07:34 -0800 (PST)
Message-ID: <61f01236.1c69fb81.46a9a.5a9f@mx.google.com>
Date:   Tue, 25 Jan 2022 07:07:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-186-g48777098709c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 118 runs,
 1 regressions (v4.14.262-186-g48777098709c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 118 runs, 1 regressions (v4.14.262-186-g4877=
7098709c)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-186-g48777098709c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-186-g48777098709c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      48777098709ca5a2ed035adc76d51c02612a0115 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61efda0c14da994c04abbd32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-186-g48777098709c/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-186-g48777098709c/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61efda0c14da994c04abb=
d33
        failing since 0 day (last pass: v4.14.262-186-g8d362d8866d0, first =
fail: v4.14.262-186-g31305bc3efff) =

 =20
