Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191F34CE083
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 00:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiCDXDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 18:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiCDXDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 18:03:10 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CEE23932E
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 15:02:22 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id e6so8683391pgn.2
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 15:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ueLcPhk1WPLV9Bb5IUnFz4VU5hTSqgRnr0DVWn3xIYY=;
        b=VMmhfN5v9aKMlSS3zKPyyow50/sghQEYxSpa1D/d/loVUBtEw5DP1dbfPuwfOdRNJP
         6I/MrfJtX8DX9qOgyqV8EjjMoj67btePoLyrx6aClZnpJqQ8vpr7TyqahTePlOLn8rEo
         tUlyJBmcVsKSU1+53fzrx6xsPP2bNawxA8vyrYrVFUvVvrmELlS6eHk6ZMkUfClYI48U
         n4uZdwSjUQsLjXxgVgdyc5XNOns3aKe8mraeMk7eynOK2qb2C5hOU4GGlQknj5AHl8me
         7PSVUwr6Nj+TzIh/tRoV+sYGiz5n35DDPs/mA3/fqLYVjWIUng3aOb3S3ZDTWdHrtCjK
         daCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ueLcPhk1WPLV9Bb5IUnFz4VU5hTSqgRnr0DVWn3xIYY=;
        b=eurpen1FohfqAL5v1LRfniLvsH4ey5+MvtLITt0I7OhGUklwTuUCDrQde4gqXMwFA7
         LGBUYfqx5dxMHbH0lMmIaDl3UaADHrCvTgkbHc1s9KXGruv7KRLcXl31KzgHOWZfJJlD
         nHOTWeb4gchyie9Tqc55N2u2rAOEPp0W4mEw6AJFxt60RY245bdR1mcVE2BGYPfcSIFr
         la82dD29nin0klRPw7KpQFN46+LemK+qJaoyK9UyRBz7K4s8d7GpnKr7L1wt85TJR1BQ
         EKA4aB6G2iz0nLiLz2KIiPag8dmBQbeeplnineMu3EI/zp9RX7I1vMg3mUe+7ta0A7Zd
         QpHQ==
X-Gm-Message-State: AOAM532gsD8QDyEdyx+rve3F0tPMm7p3epRWTLWtZ+jEmHHKuxy6rWVi
        JcektnDc28Ex52aJuS1/HXZl3hOfYeyq3J2gUyU=
X-Google-Smtp-Source: ABdhPJy8nprlgFVLDltjaXGpgVzpiVFuuF9LDKDhQfH2QMMEkxjtpG/ZidJNlAjRVyy21sCkcFYP5A==
X-Received: by 2002:a63:5f53:0:b0:37d:f237:b822 with SMTP id t80-20020a635f53000000b0037df237b822mr546315pgb.294.1646434941328;
        Fri, 04 Mar 2022 15:02:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s15-20020a63af4f000000b0037c8875108dsm3205909pgo.45.2022.03.04.15.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 15:02:21 -0800 (PST)
Message-ID: <62229a7d.1c69fb81.2ae85.9950@mx.google.com>
Date:   Fri, 04 Mar 2022 15:02:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.304-11-gf0453fd60a62
Subject: stable-rc/queue/4.9 baseline: 53 runs,
 1 regressions (v4.9.304-11-gf0453fd60a62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 53 runs, 1 regressions (v4.9.304-11-gf0453fd6=
0a62)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.304-11-gf0453fd60a62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.304-11-gf0453fd60a62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0453fd60a626049111743efb3b048a1a9300d58 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6222633ae68639be87c6298d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.304-1=
1-gf0453fd60a62/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.304-1=
1-gf0453fd60a62/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6222633ae68639be87c62=
98e
        new failure (last pass: v4.9.303-30-g443d6630b05c) =

 =20
