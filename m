Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30FA4DBE0A
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 06:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiCQFRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 01:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCQFRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 01:17:36 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8478419611F
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:02:15 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso6588015pjb.0
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 22:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v5bxic8wGKPPJSz1LdvXnilGxQt3XWfbT3xGTYSRKNM=;
        b=M2a7gF4L79+1a4q0YlqK0cjkWKqAQGUMfMN8/bX3jnWgj1b63Wgw2vP/bJV7cU6pmg
         rqgjotou/M1USp1bs3uPN3UhgSyKZKuGVb7KOOPNGg40hXie/kVAkicZ5j2ubBDtY+By
         C2cjgHRTgFXbaFX3NUkF2x6TK3l8gNOc9gI3MrGT/YX9ESk3+30XfqJa/Sg1A2aUn5qz
         jwDHrHapZoJbGSrPamHQphx2rK38OvOYN7e8MX0FZWcdRWs1q6eHnewnQg63wWc2LWxd
         V4OnO7D5JHcy/LDfADQQHxorYWzTZJ0f89aqLcqEUxJl405ba1mELsKOxcZ7U9jRBqrW
         YUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v5bxic8wGKPPJSz1LdvXnilGxQt3XWfbT3xGTYSRKNM=;
        b=26b5OUlOytIDNhKGwhB6KE2WV5kFC5fkCb9MTpGo6nzYOAufxSozCo7T02RmZFg9jE
         bNBCctwz53YhNcQhZfbbEu/nc1StKFG/QQ7A0Xw0CRiMm2hudlstjZPRRJHDDSiBriIB
         wxFa8ztT5V5tdbemabZRd61vFZv7RITXYQIPJiPpFCSjeTmS6vcbHUJL8aZDIPCr270g
         6KqC3cAeQHOvrxCiguY7oCUJ+fTL0nmP5wNufErQVTWL4E8CcQRCwTCXqK1RPRr1AtbJ
         K/5J6vgOKqun936CvXw3FVDBoHN885w7wg9g7rBsANIk9EkFaREnNaeTCTRyNeVDniJu
         MukQ==
X-Gm-Message-State: AOAM5336MsHCVZKllOMLQfpabn8fnK9QHHe3z2oMYwa2triDfWW7g3l0
        FW5xQZPoPr/otkl2X26FrZCyWZinqvp9xaY6MrE=
X-Google-Smtp-Source: ABdhPJzW3aEVzKExm4vMJNLuwMlSVmLhUmDzYe9weh4lO/QwdRLu1IeBbo/gX8lneYBst6pmwKo4sg==
X-Received: by 2002:a05:6a00:a0f:b0:4e1:309:83c0 with SMTP id p15-20020a056a000a0f00b004e1030983c0mr2853370pfh.68.1647489164777;
        Wed, 16 Mar 2022 20:52:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6-20020a056a001a8600b004f78e446ff5sm5089029pfv.15.2022.03.16.20.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:52:44 -0700 (PDT)
Message-ID: <6232b08c.1c69fb81.cc23f.e2a7@mx.google.com>
Date:   Wed, 16 Mar 2022 20:52:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.272
Subject: stable-rc/linux-4.14.y baseline: 60 runs, 1 regressions (v4.14.272)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 60 runs, 1 regressions (v4.14.272)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.272/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.272
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb045674aab31aa55a4f9aec27cce36e3d946a21 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62327fb1bf130339e8c6297a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
72/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
72/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62327fb1bf130339e8c62=
97b
        failing since 30 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
