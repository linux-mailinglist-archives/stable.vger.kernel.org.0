Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992824FC7A9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 00:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241428AbiDKW2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 18:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbiDKW2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 18:28:09 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B505D1EC77
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:25:54 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q142so15363949pgq.9
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 15:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dx7EkQ2Uk9YA/xItoQ0nlqHwRI9vVf6yRRtuxI9QPWA=;
        b=GLJwoiqydNRdTF4emXFT0lWwYvrtCb4jMJmSu40AuGm21NInxdZnEGRAFEMhNQznIM
         KnSfbXtwS42AQXC4fBSqXtxGWhWbkZM4UFoWZ/xyf1P4peaK43H1rE95XrFrYpfJ6qZb
         QWKxDvlHFU0JPW2VeWGCIcK82QFx/JFDbxt7L5nyupT+aSI1DNDzokWm9wPmFxX+A/vz
         Gb0AZA3PPKDm0ZEUkJpB0z0A+XITkeIEkgCZEbcvqwZD4IuKTIU2W2rPklGSn/cOXxF/
         UL9LRUp6T9/wlcv6dShzsHq7bsYE1gb5X1V/gQ6FCJ0M+gegL3I1pfdAVjelIFpjn8k9
         6IsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dx7EkQ2Uk9YA/xItoQ0nlqHwRI9vVf6yRRtuxI9QPWA=;
        b=Cq78aRxUivPH58kFnQBEMTIrunNQJ+VI6125zh2ypG2rEBTKkG0SIEhV2zkrB9sL0B
         2NePX90t7nyMeZijwG2cRqi1DKX5Bh+9bQ2CudVKIZIy2SZ9U8A45Bc/BQqtobryr6wY
         rMTtkxNb4G7y1GqI0ZFuUJveGaNiq09qnLLITZy96UMiYxElVHOapx02424qJsYj7dda
         S3pEybazDgBv+KAl+jdg7NnKUeW2dx9jmdmni85LpWutnmE2C2/WmZDRuGGAuTV0EHKK
         f9B/J/zAgVzh5+0XkSvcozjDEM5GIVfTDhE8ddCZUKWqr7a8Bb8LHhx3nMCidfUkF+59
         63Sg==
X-Gm-Message-State: AOAM533rAlsyMNFL4tOoYwPWCVq6r7frTY8gGNy0e7OuX3XKihvNYRq6
        2t4DWEs4nXCEr99hX5+an1tFalsHahYLjQga
X-Google-Smtp-Source: ABdhPJyfeZQN+oABLqK5czFFlYC5A0trtb1W3RVICxQ9W23gv236BI6JxdtCcUlBX6AhAvVkbnLS7w==
X-Received: by 2002:a63:ce0e:0:b0:39d:2648:289 with SMTP id y14-20020a63ce0e000000b0039d26480289mr9829581pgf.278.1649715954067;
        Mon, 11 Apr 2022 15:25:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oo17-20020a17090b1c9100b001bf0ccc59c2sm481968pjb.16.2022.04.11.15.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 15:25:53 -0700 (PDT)
Message-ID: <6254aaf1.1c69fb81.ec03d.1c71@mx.google.com>
Date:   Mon, 11 Apr 2022 15:25:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.2-339-g22fa848c25c53
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 140 runs,
 1 regressions (v5.17.2-339-g22fa848c25c53)
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

stable-rc/queue/5.17 baseline: 140 runs, 1 regressions (v5.17.2-339-g22fa84=
8c25c53)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.2-339-g22fa848c25c53/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.2-339-g22fa848c25c53
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22fa848c25c536c9ec7b151d56caa65b3e5b8b68 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6254788929626c8eb4ae068f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.2-3=
39-g22fa848c25c53/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.2-3=
39-g22fa848c25c53/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6254788929626c8eb4ae0=
690
        failing since 2 days (last pass: v5.17.1-1125-gf6acde7a5d96, first =
fail: v5.17.1-1123-g044bf1bba79b) =

 =20
