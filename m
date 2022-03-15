Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CBB4D9247
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 02:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243515AbiCOBbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 21:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237244AbiCOBbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 21:31:53 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DFF3BF88
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:30:38 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a5so17075703pfv.2
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 18:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qtMKMRrKUpYnGWLvcHSGXh8bAcM5p3SI0Uld9D3SpyE=;
        b=HsW14AgwS+bvVz/dG7Q78J366MhpVwBdnAs1VfcNUySGIbTORI07UUdERAxPUIVIgP
         a6MM61aXkCmp+70c07w0AN+wLXtY798FpEEg0cRfiilEifKe6W/CcMq7OZkkgeEI3Lgp
         Cjj53hLfyIEHiRov3hIRfSOhffgod3nMCc9Nmun9ajarQ33RfvJmG0c5mT2pEZQ6Y2Gr
         ZJCmzKplyCMIUgc0N/cEQSTB0AaIBwG0FN6hnESrGYiqweKDWUw/70P1ddcnXn8gBCxy
         IpqY3KXOBCHTUHKayQ9gBO7/3GMPTWZjwPy8sQ4AXOSoiWqvM7VPc3Ug1Gn5DsTPris0
         Dt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qtMKMRrKUpYnGWLvcHSGXh8bAcM5p3SI0Uld9D3SpyE=;
        b=ZXq+UaLS7QBeI+V2oTNCAhi/Y3tqgBzAGo7D0kwvukvhIMVYtnGcUwwlzoHi11cPVM
         DVC8XQgBbxM6hHF15KxeoppRWOirosvWWU8eZEByixrZmGYgXVtF198mk3VwD2KW3Ige
         mp8bANz+P7FpHuHJAPyyjuTPAdvZw3kusWVhRZg8+APauooyZVlKWsMY70kfy/xpCp6A
         NTOHtcTGtJF1pnrTDB1F5gIIPZYf22RqRqtCN37HaiCh6C2m0vGQcEpesV5kRMG3ff5Y
         9sDdif20yfVLkI/kgSHcsLLY+zbtMg3rockN5+q/G3KlO7SHDrX9uCJD3qG0DX/nkJjf
         p21g==
X-Gm-Message-State: AOAM53389YulAnusN1OxllSlx1HXO0hgrxCVL6Lv2ZItAEWCyAjKKlQf
        TQBNGK2KTQVFFkBw4cTizbPevjq51pMykLTvLx4=
X-Google-Smtp-Source: ABdhPJyCCeFHORLt9+ybtbD5hIHChBWTAU1BR7KkzBnwlpikX0t2TFyMZ4EHYrFVAJy8r5W7FWOh7A==
X-Received: by 2002:a63:db4e:0:b0:377:16e2:f8d with SMTP id x14-20020a63db4e000000b0037716e20f8dmr22911233pgi.110.1647307837784;
        Mon, 14 Mar 2022 18:30:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11-20020a056a001d8b00b004f74f8268cbsm18809449pfw.85.2022.03.14.18.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 18:30:37 -0700 (PDT)
Message-ID: <622fec3d.1c69fb81.25995.2333@mx.google.com>
Date:   Mon, 14 Mar 2022 18:30:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.271-22-g90f2cf90af72
Subject: stable-rc/queue/4.14 baseline: 51 runs,
 1 regressions (v4.14.271-22-g90f2cf90af72)
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

stable-rc/queue/4.14 baseline: 51 runs, 1 regressions (v4.14.271-22-g90f2cf=
90af72)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.271-22-g90f2cf90af72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.271-22-g90f2cf90af72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90f2cf90af72ef6e9205e7999f5922c0122733e7 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/622fb4ea237509cb60c62989

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.271=
-22-g90f2cf90af72/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.271=
-22-g90f2cf90af72/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622fb4ea237509cb60c62=
98a
        failing since 29 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
