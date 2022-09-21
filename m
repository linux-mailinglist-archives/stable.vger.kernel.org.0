Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B405C0405
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiIUQYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiIUQYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:24:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F042B0B35
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:07:15 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so6347717pjh.3
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 09:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=bxNCiZLqEvXwoJkPGjN/DbBeQGNhmz3HvRtOAeWQl9U=;
        b=aG0WeZ5nEB0q8W3q7aC89wYSR9uRZdSp88sOjQcFnZso3aRMDE4LaRI7yuOTeVQ8gr
         xFubAp3wDB2rCkzXI64AoycHfvSaoQUOgkdNf6D3UjiSg3gN8kqZy+OSXY49ztL1pHsl
         y8647YzLpP1u7r6+YzwgGPC8haqhmzABZmk4+W8vJ+1Zc4CN7ZoeAmIIGMVGvG2ydJ4K
         SAFIA9TejKezU7QYplV+9k5zeoXcf/+JbwskBEhrZNE94iFGtw30n6fqx5ZSKHZ2K/SE
         9ugM/1bX7nniC9qa51U1E5RzAZTE3Le+HFXvXh3n68VE5Y2tcNtXW9ebruiGBWedtO+s
         gsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=bxNCiZLqEvXwoJkPGjN/DbBeQGNhmz3HvRtOAeWQl9U=;
        b=obYbu9M6FN/Msm+8XuQfpCDg1hSTXF1DbczM++kg2EBAS3kkFDeFByntjiISPTLMnm
         g1jXCexHS4xFWIDIyI53NneJZjXxVROJRA1RF+QPM6vEDa4Ht3giBkkjyLaDIzRC7A0y
         lXM/M0eAYQYgBLuYJeA5V9jQoiALrqLT0whvXeZphpr1fpZUVHorsXuVPvbqwNuzuYLt
         hEBmhS9t85rp8oP1DyQY3rlsZ+Qzssd70ZHUkXzaUJ/32OgWdMcKK6HarKG7m3svAyON
         7fOukLbm1ivAd7uw0xjBU87pZOvKsdOHf+4psnWpVYP9f0uMStFRl/kxO9EslIoH+faa
         S0iQ==
X-Gm-Message-State: ACrzQf0kJokxxEPY7m0yAqTNJ6zMn3wROA0Pkl+LarxMLozUALKNZRym
        ZU/23tRHnqzkLUBr9toOZFlNrIk4wYt6C5+KMbA=
X-Google-Smtp-Source: AMsMyM5M9SqEcfNKFJTW9I/GBBUR0Y+GnDRDCEJYFYj7VxME5l3Pp/PdB2r/ZiYcpoSdj1FOPXvWkQ==
X-Received: by 2002:a17:903:189:b0:178:3df7:f32e with SMTP id z9-20020a170903018900b001783df7f32emr5422102plg.47.1663776388350;
        Wed, 21 Sep 2022 09:06:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7842a000000b00546d8c2185dsm2439787pfn.170.2022.09.21.09.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:06:27 -0700 (PDT)
Message-ID: <632b3683.a70a0220.e762e.4fc9@mx.google.com>
Date:   Wed, 21 Sep 2022 09:06:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.10-36-g00099e2e5131
Subject: stable-rc/queue/5.19 baseline: 154 runs,
 1 regressions (v5.19.10-36-g00099e2e5131)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 154 runs, 1 regressions (v5.19.10-36-g00099e=
2e5131)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.10-36-g00099e2e5131/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.10-36-g00099e2e5131
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      00099e2e5131207ca27f8e6705f29256152be9d3 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632b079d2fa7ce7f06355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
36-g00099e2e5131/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
36-g00099e2e5131/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b079d2fa7ce7f06355=
662
        failing since 2 days (last pass: v5.19.9-55-g7dbe36eefdad, first fa=
il: v5.19.9-56-g29b6ff678b0e) =

 =20
