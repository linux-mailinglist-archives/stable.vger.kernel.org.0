Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B895765871D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 22:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiL1Vhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 16:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiL1Vha (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 16:37:30 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B11E15827
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:37:29 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id m4so17171757pls.4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TLr580XCj9zcRD09smDOlQRHeVoljJGrFQKgD8yERRg=;
        b=Xv0YCyKn4wDhRmMiff478g9XMUEHDl9tBduJ4vDRNA4JtAF7ByYul3BAGKQAwfyBlE
         79gI39XOLAhg3D15SQX9djxxfdinyWxAD6HB+vXiCjvVzXP0FJ55TxnrjEG7D5NesZA4
         edw0Qex7btJ5QZ8/cVlq3SNz2U+yxIgO1vBsQFGlIl9yt80aYTa9SkprbRASWDAvqGAH
         /zNpzc97gezz0aQjyL4Ei4LScpy/d6AX49s2euaNWvlPvxL5h6De36FjbDrIPFn++M+x
         kIoqLGFne2aORiTqLctCAsbLqDdbw0YsrGGWsazikmLzUAekW7/z+LGsbIreyUvAQ8+y
         Ukgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TLr580XCj9zcRD09smDOlQRHeVoljJGrFQKgD8yERRg=;
        b=OgfhCIAY3euO2RcJFW+yn+iQ0yTZ+YADB/gDsxYA8Wo7MYmMEgifvJ9tZjE9jimNv2
         GxSFDj5kOhCHH9Zy5Mfu346kikKaZwmJRWnECxefkAW/mUlCNHiGiqAnLxLV4uX18vkQ
         h6WVxg8XrqGR0PDG4J+uZS5GYBexvsNv4xvFrYKaVN+PsBug1vcVfis252I6kQgByYbz
         RIXw7SP8rIF30Qg9XzVQRuWBKS/TZAzYXfhUvGo3iv2x84YbsF/vp9gJ/C7kxzO+/+v4
         Lt98zscvq2wIRRjfnSob4vusu8vsjZD35q4PDxQmsXKF33rSJ7e/WvczLq75ACpES9pe
         Uwtg==
X-Gm-Message-State: AFqh2kpEobkhDrnY2tWmxgHL8NF13u+0IIgOs5A5JesL5UIGohFZiFna
        p9C9mX5X/1O/YFNxoM0hZUzVJA51ujJWQYiDJuo=
X-Google-Smtp-Source: AMrXdXtk4U0z9osfb1oF1HX4GPFwsvwN+TK6TVH7LXo/Nf9qbqxAlQX/Ytmw/V+hNdo+tfs4Xf/wag==
X-Received: by 2002:a17:90a:c213:b0:224:5f8a:52e4 with SMTP id e19-20020a17090ac21300b002245f8a52e4mr29098645pjt.9.1672263448737;
        Wed, 28 Dec 2022 13:37:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10-20020a17090a2dca00b0020087d7e778sm8670086pjm.37.2022.12.28.13.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 13:37:28 -0800 (PST)
Message-ID: <63acb718.170a0220.150e0.e011@mx.google.com>
Date:   Wed, 28 Dec 2022 13:37:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.161-575-g2bd054a0af64
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 132 runs,
 1 regressions (v5.10.161-575-g2bd054a0af64)
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

stable-rc/linux-5.10.y baseline: 132 runs, 1 regressions (v5.10.161-575-g2b=
d054a0af64)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.161-575-g2bd054a0af64/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.161-575-g2bd054a0af64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2bd054a0af648b531055e7c76a8484a497ffb74d =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63ac82b48922247e8a4eef25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61-575-g2bd054a0af64/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
61-575-g2bd054a0af64/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ac82b48922247e8a4ee=
f26
        new failure (last pass: v5.10.161-561-g6081b6cc6ce7) =

 =20
