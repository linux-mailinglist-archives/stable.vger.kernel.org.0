Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050A964A534
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 17:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiLLQoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 11:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbiLLQnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 11:43:55 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0F315FC8
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 08:41:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id w23so12618851ply.12
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 08:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rs/EVv/c5APQUCDZwVj3xq0TnSHlQzxJ70i6r7LzEb8=;
        b=4SX9Wr5U+Bz7o8fLDona34725FcKVrnTE7CnYWDYpGh+rBW8hrFHscELtQCO1Zc7r6
         C6n2CB78+1PEo9EVXMpkpi1B4qlUf7tI1IVCshJYTnMmMHGicxEI/wA0BKGvO+tJfp73
         1SuIfgsVfEsyei6MPdvwRuKnI23XXaKyMNW1vspiOxCBgl3fY/GP+PRUvHqeLjjo/7xi
         gJ7ewHLfwbzzqMeeDvOav+U9KSs3TFTVjvDwgeEYzhxGqV0JeVVvH/L7BiVrj0SfrToK
         9UCf0F3pg7E5XezYzB4a5qXgO20CjjY2Hde7CoqzAMipcVDimkniqaXrxFuXQfybLln/
         Z/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rs/EVv/c5APQUCDZwVj3xq0TnSHlQzxJ70i6r7LzEb8=;
        b=rXRZig7VbiF3dgoR0CdjG1/O2A5UbR4j11vpMreu7u4T2Vbr9hO4OIvxu2KOKkY5JG
         eTcXLSKYrlh0UQyPIv9HutjzDfQJEXMp1rxRTn3lh9wvqKIXZ6F/WLTLUX/j0ZyfMqak
         g/nDAvLtFhwI9fHhfI0OdP4e/LXfk8cx/vhfF4ppUsuJoo6H8U/H1gklgJ9W/l/De9yY
         XlnDNjKzJbpB2qNlt/uddJgJ94v0iMp+DcYi+VSDPvVz2n0WL018H+h/7QTL8zJ6ROhP
         YRH9ct1FFBnEumbvZG02ZJHKTrgFE0nVWrYqEdbsjzUuMAYEm3ZOy3bmT0yY9YlZrVni
         WI+g==
X-Gm-Message-State: ANoB5pmPflgCx1FWavqk/lUfAZwvON6ab7xMUabz5gidFbXtLGgBQvS8
        lD6OXD50+N6I8AVEYF0OlsrbdthSMImypoaCxU/icA==
X-Google-Smtp-Source: AA0mqf6mz76yOX4souD2cNnpLJTYU5kbmeNuo98YXRzp/KbdIDud6CD7IV6Mn+hL+NUyCc65XaOnVA==
X-Received: by 2002:a17:90a:de86:b0:219:ffc6:4040 with SMTP id n6-20020a17090ade8600b00219ffc64040mr19210709pjv.38.1670863260650;
        Mon, 12 Dec 2022 08:41:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15-20020a17090a4f4f00b00218fb3bec27sm5569362pjl.56.2022.12.12.08.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 08:41:00 -0800 (PST)
Message-ID: <6397599c.170a0220.c9a9f.9bb4@mx.google.com>
Date:   Mon, 12 Dec 2022 08:41:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.158-107-g6b6a42c25ed4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 165 runs,
 1 regressions (v5.10.158-107-g6b6a42c25ed4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 165 runs, 1 regressions (v5.10.158-107-g6b=
6a42c25ed4)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.158-107-g6b6a42c25ed4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.158-107-g6b6a42c25ed4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b6a42c25ed47c8b5d0c1662b5b933180edb6201 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/639727df777fe33b0a2abd03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
58-107-g6b6a42c25ed4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-=
bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
58-107-g6b6a42c25ed4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-=
bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639727df777fe33b0a2ab=
d04
        new failure (last pass: v5.10.158) =

 =20
