Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33444D0070
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 14:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238031AbiCGNvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 08:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237571AbiCGNve (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 08:51:34 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5FC8BF55
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 05:50:39 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id bc27so13614983pgb.4
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 05:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wsuzyce8CAW5lltmM4g7NZ0LpjLf4pAEjcAtvpVx4dg=;
        b=mVIFCAaP2RoEbt+E6qYATWjptlgip+8BeD08qZIRPhxpIhBPNXC9tuBsm0i/+2unN2
         J79iwrLG0JOeq644hrBvJMHWaBgu/M1wgpwJA3Vxeu4u7fHzpqcFlsskdraVLPXRb2Am
         rgy+uL+44VhPBRbdd3vvRfBKyuCqEEQ5M+ZbIxuZKtcju7N/deJbVn5cUzztxz5i34va
         eeX7Uvxd5/FMSmCTxiSRP3XDyBYEZiYD/Vft8ilsR8mN1x9god6kwm88Cg0NQP06cDwy
         EwQSLd+WHcO7WgpchAV2YkYxjSofNFzr4BE+A8VdtqqvFFoTU2q/T0scziz37Pjw4nEC
         h8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wsuzyce8CAW5lltmM4g7NZ0LpjLf4pAEjcAtvpVx4dg=;
        b=L1qydoRAC1oMD7BVEpRaevc94ZOhACNhiE9XvKPlq/iCbVR9mrguoPbW+XfZWCkCc1
         uBsCsSfycKF3fN35R937s87bpJQHpeLRih1Cgnxc9AW5I9yRh1GgpMVdCQDAYS+77CF5
         9lAofSIkSm+Kw0Jf5KPy6oXf0eYGTk1484sXBaMDgYbL4pKb6WSPrGyq6L6vsapJHN53
         Hd0esXZsGGbnii7H2kFrRDnLkJF9kNAYNnc+ZreEEyXL+rQKvu0FoMnT8CC5LzMk/4lK
         MewxXhkP6DWkN244SvH3JLGyrPFKTSBybVDzkPQwJI55YILQ9sA4rTeoEVMqC+l3ZdfS
         aCPw==
X-Gm-Message-State: AOAM531+8Un8t8JHbT3wuk/p8PzV3QM8B4miMGWimaTRlRxhnF1OzO1Y
        +jHqn/5ferH+5D2GWVNs6L6Us3ACxdw9/bfx3EA=
X-Google-Smtp-Source: ABdhPJwW+897XI2f0/aYLbhJmlcDX7g8DX6JdC/62y53ull9+iQFNB/8G+nQ+tZZYEFnbYouL0HBzQ==
X-Received: by 2002:a65:6a46:0:b0:37f:ef34:7b8e with SMTP id o6-20020a656a46000000b0037fef347b8emr9788103pgu.503.1646661039335;
        Mon, 07 Mar 2022 05:50:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22-20020a056a000c9600b004f10137a096sm16998310pfv.50.2022.03.07.05.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 05:50:39 -0800 (PST)
Message-ID: <62260daf.1c69fb81.51711.a074@mx.google.com>
Date:   Mon, 07 Mar 2022 05:50:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.269-43-ga1eb78ce1bf6
Subject: stable-rc/linux-4.14.y baseline: 41 runs,
 1 regressions (v4.14.269-43-ga1eb78ce1bf6)
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

stable-rc/linux-4.14.y baseline: 41 runs, 1 regressions (v4.14.269-43-ga1eb=
78ce1bf6)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.269-43-ga1eb78ce1bf6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.269-43-ga1eb78ce1bf6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1eb78ce1bf6ba801e76033760945bfc97f8d9d9 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6225d6b787c4646049c6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
69-43-ga1eb78ce1bf6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
69-43-ga1eb78ce1bf6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6225d6b787c4646049c62=
96b
        failing since 20 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
