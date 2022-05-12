Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83F4525609
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 21:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346132AbiELTtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 15:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358162AbiELTtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 15:49:09 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4326C0C7
        for <stable@vger.kernel.org>; Thu, 12 May 2022 12:49:05 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id a191so5524630pge.2
        for <stable@vger.kernel.org>; Thu, 12 May 2022 12:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AkBJo/5B4wrG/YBG/fuShOrrXpVfMZj4wB60u1R3Lbw=;
        b=TlwWXiKNkaz7ofoS2RAk33+fMShiah25SFgpgfBClFAdZgbFvlPtbl1o2fva4kuOel
         wze9Kph4AOAnDlIHL2a6imBiRFjr/joGzIUBv7k0qBeXkuGXt+jFml9eDbIlYNEkuS6R
         02sQo2xBpLXC9gB1YDH3bLf3Xk/rgN8UYVl2Us8WDv/SCM+m/QCPf9RdaseCnyonoWz4
         6dKwrOKK5ig9JD2TQQTjJZtEObAt7FX5Ga6RoNjdOIPPulasRt7oISuVqHfBQrM5i/Pn
         IaO77kHWga5d9SqFu9Vc/s7Ge9YtEmS/hpqB/WUEK15nWgXk4y5GDPqVal86ym7OBHBT
         fiDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AkBJo/5B4wrG/YBG/fuShOrrXpVfMZj4wB60u1R3Lbw=;
        b=75QIZeRtFLfVRH7eGY9QmTIBLdL8EHs0Trca5ZuSLSRJMw7bBxLrrtnp7AW3FCPB7i
         bkQjQ/5KrR/f0ITwYqWyLGaHIBaYuwRQt6dO2sCNfTf/NsRsUPr2/XUVnoBy4tW0TQoD
         g/Eh2nVaRcyzQWu4mZdA0kmk7XPnX+EMgUJIx0eR6Xnyyktjd2Q+2Ikwz19TLdToR+gU
         yjvPrKroraYXC8T5JjzVnj0Eu5hD5npypOU5I7xHr9mbaHO2NAgnBaBXQ84T1Qx/Hz3V
         em8VCneCgr0Nn1kl9myEmpvAldeOqNXJdYfDjP/14RalWwXQYsjkucZSZKRqnCwt3mI6
         QgpQ==
X-Gm-Message-State: AOAM532gB9xVCB6PXQnz0q3Q/tr0EM4MPWW5ct7DhPuApcy0LHFR5u+P
        4CAYtbUnsRejKiNIjhh9O55zPkswhcYemyatVJU=
X-Google-Smtp-Source: ABdhPJw211kUcaT9AfjhM7izc8FvFjOAb2TsA6QW0wk1RmMAhn5/lSwCPKs9nbGThA5egshQh1qOjg==
X-Received: by 2002:a05:6a00:2282:b0:50e:552:973a with SMTP id f2-20020a056a00228200b0050e0552973amr1228761pfe.79.1652384944703;
        Thu, 12 May 2022 12:49:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p6-20020a622906000000b0050dc76281ddsm187832pfp.183.2022.05.12.12.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 12:49:04 -0700 (PDT)
Message-ID: <627d64b0.1c69fb81.a3312.0aa8@mx.google.com>
Date:   Thu, 12 May 2022 12:49:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.39-11-gb2914308d4339
Subject: stable-rc/queue/5.15 baseline: 72 runs,
 1 regressions (v5.15.39-11-gb2914308d4339)
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

stable-rc/queue/5.15 baseline: 72 runs, 1 regressions (v5.15.39-11-gb291430=
8d4339)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.39-11-gb2914308d4339/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.39-11-gb2914308d4339
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2914308d4339eb918f570ffdbcbe0698a5e6411 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627d5442a843eb49c18f5727

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
11-gb2914308d4339/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
11-gb2914308d4339/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627d5442a843eb49c18f5747
        failing since 65 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-12T18:38:39.204683  /lava-6354763/1/../bin/lava-test-case   =

 =20
