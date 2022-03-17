Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAEF4DBBD5
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 01:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbiCQAga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 20:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiCQAg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 20:36:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72CE12607
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:35:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so6500240pjb.3
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OT8kOThqh06Le6R9GrSu31hXf4AplLxwEfJu/ZKmbjw=;
        b=QyckF6qydik1ynBs+Pbo31J8V0pMLr55srxxLmoK47FE0YnDbBMJ9KCKw2qPwJfL2j
         w92DDGgLhk7w8Ka270iJlvrWfYYQgbWH60ZiKAA6XJrtfMCWIbuALUw8UHmM+kvah+mJ
         MRci06usuPXnKNZY8XanHtJ2p3SR72dOkV3HDeBaR/G4SimU8/LxDwg+R4abg6ybx/OY
         Kv46X7095KAqFk40h7FFhKdDs3izFvaY45HwAeJ9p68ZRPhzlOcWt0ZA4BkG0d6Yi1v8
         sFt8i1AnWIIR+bhNvu2WWOcp0ROXuwlbbQYU48wnMAkvADixTwhYq+8+jlvmhykMu8pU
         naRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OT8kOThqh06Le6R9GrSu31hXf4AplLxwEfJu/ZKmbjw=;
        b=yMDZgU+TgYQE+tqSkj2l94LvuzvdCLP+3mQX1okugXgtHpI0rtWApy+Wew66fgjGh1
         eRc3CYxD+d7jsuNVJhaHUmjYbFJWAAXgdzHfSVvqzSVDsZYACSsavDYl9A17hU0EQsLW
         eV7X+LWdNFfHqkmwtc+44LcxP3TWC1exKizirrofdTIztOvmC04U9H0e34yI61dtvzjz
         qjImBvvoz/ZA4YgW2lZC+vja/ERypklb7XgJAMnfoC9DG0frBROh+hdMURtAvzJuBpMS
         B8q8WjdonaXMr3wG1Zp6YkycDtWQ/u594No1/2Y/KKfpaaajoPK+xEo4ztiaDLra1QDW
         eXMw==
X-Gm-Message-State: AOAM533+29/x3rZHt9QOzGdF2iMau2W+lA6Pxfe7P7+eL/GJUuc5wLE3
        OqdVhaI8ePSaApWXNVrT2jv789fVbXb2oIlVH7Y=
X-Google-Smtp-Source: ABdhPJxZ+e3OXqD8aHlv7p50cC5OlXuwpeKWt0CrJ/5ZDEtEZxujqGpbFWDdWyJgLrl29WobFj8SjA==
X-Received: by 2002:a17:902:f70c:b0:14e:f1a4:d894 with SMTP id h12-20020a170902f70c00b0014ef1a4d894mr2465217plo.65.1647477314064;
        Wed, 16 Mar 2022 17:35:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oo16-20020a17090b1c9000b001b89e05e2b2sm3942021pjb.34.2022.03.16.17.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 17:35:13 -0700 (PDT)
Message-ID: <62328241.1c69fb81.d8ae3.a0d8@mx.google.com>
Date:   Wed, 16 Mar 2022 17:35:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.235-17-gd92d6a84236d
Subject: stable-rc/queue/4.19 baseline: 74 runs,
 1 regressions (v4.19.235-17-gd92d6a84236d)
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

stable-rc/queue/4.19 baseline: 74 runs, 1 regressions (v4.19.235-17-gd92d6a=
84236d)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.235-17-gd92d6a84236d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.235-17-gd92d6a84236d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d92d6a84236da064e4eb44b09b09186983192a53 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62324c74495903a628c62996

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.235=
-17-gd92d6a84236d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.235=
-17-gd92d6a84236d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62324c75495903a628c629bc
        failing since 10 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-16T20:45:30.208072  /lava-5893465/1/../bin/lava-test-case
    2022-03-16T20:45:30.216305  <8>[   36.875049] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
