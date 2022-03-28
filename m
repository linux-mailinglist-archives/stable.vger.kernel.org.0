Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FEA4E9FD8
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiC1TkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiC1TkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:40:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6FA12ACC
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:38:35 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso277220pjb.0
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 12:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f3mi3NgEEVdUKStm6OzExCruYUpzE9xgaie0Mpa39lM=;
        b=GqfxUOWACrnYqh9hjXC4AirY25Y+J7EQkS042e4N8PSH3IYQ5L0smXD7Dz/WNi173F
         o+lLeKxiWkVhYoATatuHoqt2yRN25Fs2/BpfMN3elLPZdVqm1OD+FN/onqk7+tnRVBWr
         rZKhJklQgdYHnpAZczu1jFPFoAkkOD2RBvbhB6mCp13E6h2wHwZ8wXpGV4fJPCpvvW1U
         FtFeL3FB+sIFQXLUnFAc+w2gdDExKsA3eDmGVrXvOvcjUlRVYhxfYmkrftP9xBd/n1jz
         jwbPeSIukXICD5d3wWJjpStS4Z8/kKAyXiR0W4YSTFdWiVlNd837Oa+xvvZcHP/nnHJh
         msJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f3mi3NgEEVdUKStm6OzExCruYUpzE9xgaie0Mpa39lM=;
        b=SAHvnSl9tIecpNAJ94XiGny57BdXBr0VXKFoZnrUiky5iDnhPhgiiI52s1b5IBr6eB
         ypUqsvdXOQRD6Y4BQZb3C7wbrlchogJ5M6IsFy0EZpZWnhygwWWQBvKkgzsGeUaW6vjm
         vC2orqRytzDy6ObemwcO2SK8oULynTbFiAASq2Eg8aefVJOQ1wwX67W1CK6jVuBJPHqv
         SZD4mn64ccJWM0D3O6aQtix0clvI9oXR+mynrFJbOVmon003JON3zAfTWGpWGf2sZTCC
         O43n899KZFEvxnTVwk2Kxqx4oWFJSCMwn5Q1d16cCFAVvoRVZCyzmmH+QXFr3i6I9h54
         JQdg==
X-Gm-Message-State: AOAM533i/3e3Bwg4AzCfhuscUFUJZYLY5UzrfDtUDiWyONZHulKOq4Oc
        msPpenRP4afvs5zvj36FusdAfGgRpW6lsRdIVwE=
X-Google-Smtp-Source: ABdhPJzhWvW0xCzL5U9iwjgQsc/cXXA6e/BaRjaJBBhk9XkwGDZTW7sXqS1F6ioOl+y3bOIewZkcVA==
X-Received: by 2002:a17:902:e80b:b0:155:c75a:42f with SMTP id u11-20020a170902e80b00b00155c75a042fmr22057305plg.67.1648496314522;
        Mon, 28 Mar 2022 12:38:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f15-20020a056a001acf00b004fb2ad05521sm9180132pfv.215.2022.03.28.12.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 12:38:34 -0700 (PDT)
Message-ID: <62420eba.1c69fb81.81adc.6aa7@mx.google.com>
Date:   Mon, 28 Mar 2022 12:38:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.18-6-gf2dce803af00
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.16 baseline: 118 runs,
 1 regressions (v5.16.18-6-gf2dce803af00)
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

stable-rc/queue/5.16 baseline: 118 runs, 1 regressions (v5.16.18-6-gf2dce80=
3af00)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.18-6-gf2dce803af00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.18-6-gf2dce803af00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2dce803af00067a267eb53806b5511a5e2e681e =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6241d982820bd59643ae0681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
6-gf2dce803af00/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
6-gf2dce803af00/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241d982820bd59643ae0=
682
        failing since 3 days (last pass: v5.16.17-3-g38c8070eb777, first fa=
il: v5.16.17-34-g92d627424f3c) =

 =20
