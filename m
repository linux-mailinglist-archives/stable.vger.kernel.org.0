Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B57C4E5488
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 15:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbiCWOuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 10:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiCWOuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 10:50:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE657D01E
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 07:48:47 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id jx9so1868300pjb.5
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 07:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3J6yagJrmMEiOX2aVtfgGiUljSZO4W+Mg30GgJwo+mk=;
        b=ynJph687mhxRzX+2xS1dS0QR7FsMke5KNEisq5bJeHY5PTiY2IlG3Iejjd2Z4r3u5D
         DKiBcoIuOTjnpOmvm7PPGHj99NvU1xvgxIugOE7g5y426d7CCx5Ddwn104m92NLamP/F
         FTvlKTjlKmzrDt0KsPRGHpnTBjht9qQX4Li/zQEbrXWuG7IvfcMx0ubaXnkFN/dfcen9
         0ySGbv9yjyDqpydQmRSBmMi72msMISbxh4vDQ0ncVuivWspsu9YeyRrPdH1evutlLjcG
         NJ4NruGp6fpRfwY0lMUvu40Qrf8AQY2Ql2CjAs3oi6Euj4WcNfyTD8UXR7S/A13+IhNJ
         J1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3J6yagJrmMEiOX2aVtfgGiUljSZO4W+Mg30GgJwo+mk=;
        b=sCFrNCLES9aksMdD8i/BNPVZyrCTwZcypNU958/lkhGHJ/tbaMhUcBngUYuIgjJJSQ
         KnJs0AARtslXpm1LPGoy8WSt4osnpjlFSvrZ5plIfXvVfpfuov17Qb8rv1LiCQ8XdPeN
         GQkCrEDMaNNDU7KB/iXYRX/h4ijGdwvqraSr7hns+6dYO5A2sOOvVhGx6VSbOGFWNnDx
         K7R4+ZU4QEyrnHTNLDu5Brx/gZoec+HAq3WJwAGbJvgcgq5MgSlg+lMry8Ry4Z5ntGo9
         i1oIhzhtvgY+HaTlqwK5UJWYKmfbSySBzlNGYvDFLhpRDV9d8LM70MlArNy6rdF43zc1
         9Svw==
X-Gm-Message-State: AOAM530/mZxI/TjT6obsxAUY3d9rIzHIOQlkpyVONnZjsRSBcYkiVRra
        ES2tX2+USMxbRqpwRvj9bTXr8sI5KF1ipHhjPtc=
X-Google-Smtp-Source: ABdhPJz50BvQBL5f6p9IOgRSb9TbTPUVqodE6kfUIgU7eyp2P+Wogi17isX1q6vKYgwHhbV09NCzXg==
X-Received: by 2002:a17:90b:1d82:b0:1c7:1d3:f4 with SMTP id pf2-20020a17090b1d8200b001c701d300f4mr12136256pjb.223.1648046926540;
        Wed, 23 Mar 2022 07:48:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21-20020a056a0022d500b004f7a420c330sm239932pfj.12.2022.03.23.07.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 07:48:46 -0700 (PDT)
Message-ID: <623b334e.1c69fb81.af291.0a00@mx.google.com>
Date:   Wed, 23 Mar 2022 07:48:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.272-22-g254de0257dc6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 53 runs,
 1 regressions (v4.14.272-22-g254de0257dc6)
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

stable-rc/queue/4.14 baseline: 53 runs, 1 regressions (v4.14.272-22-g254de0=
257dc6)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.272-22-g254de0257dc6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.272-22-g254de0257dc6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      254de0257dc6715b6b901ca74226acee3fa6331d =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/623b02699e6419e60ebd919d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.272=
-22-g254de0257dc6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.272=
-22-g254de0257dc6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623b02699e6419e60ebd9=
19e
        failing since 38 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
