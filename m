Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45794EDAAF
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiCaNlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 09:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiCaNlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 09:41:19 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB6C65485
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 06:39:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q19so20015884pgm.6
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 06:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0cBjlSSNXveXyy3hYMe6lht/y1TD4+gYBe0E2qmB/vY=;
        b=vYsPYI1PCytOYNGca99ALID+jnASuxoo3Iu2HzPSOSrKkpB8mytSAcsA4jpAAYEGTN
         JdE4hQvFLc5ioaNwDLGP5NdL8h+lkX/CNe84UUpqYfcjbtLMC5tmb4ZJFFVNROXvbFwJ
         Bje4XNIfDN23ayIOd14wqHa2Wbz8WtPVEvM3ehFonE5rJ+1myIae4phrQh/4s+bMXpaa
         AO0LRY6xz9gZaefn1+Z3Hi9QYJ2+SE9NCT5GGjL75vdtUUBb7p7PwW09XhfTA5Om965s
         hLuu32FC38i++tnx2YJ+GtJ6HmabnMC05lWUuZWH6FyOgiO0jIXWJCRylb4Qv8/4osqb
         mMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0cBjlSSNXveXyy3hYMe6lht/y1TD4+gYBe0E2qmB/vY=;
        b=Y4xdceqHyGx6BmtQWXydBKmbwqtNIVhQUPPKYSjh0RFwFDAbMwcktZVlT9VUdvTVmr
         jCSmjHquLR+cDcDLUpTZ12XAiRpIYFGUCjod2IsyianqJ3HRzQrepI9Gh5TiZs4KrtaL
         BR3FXLLKGJqYSMVrD2WRhinfAGML3bW859on0J8iouY0HLjoeV5G7szmaY50+cPwwTPJ
         m/xUPVRKxKJqmGm2ZlTSiqeYBO8MnwlKedhHjl57cCeCalozedvdEae/7pNDOrNWFomh
         5VVUJV04ZvapAQVC3Jri0V42p3YfzwjmlKqKveJ5KzQD6krt2Yc2N3sFABm74YZJ+2iH
         Agbg==
X-Gm-Message-State: AOAM531xgVfNuKIuVrWWe4r2A526+hx6bIaz120diKVpmUCQldOeWDkX
        LC4P8tuX3C3cy42bzkwNNlX0pl1+oxtSNKU3Ixc=
X-Google-Smtp-Source: ABdhPJzmjN5Bts67wCLnIdwjtBbUGSwS/suMd1aQxgHQe1pEiiYCE3e8Dpu431E20/PomgVHcBK/pg==
X-Received: by 2002:a63:b747:0:b0:398:a2b7:be6 with SMTP id w7-20020a63b747000000b00398a2b70be6mr8288504pgt.214.1648733970950;
        Thu, 31 Mar 2022 06:39:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6-20020a056a001a8600b004fac74c8382sm27901103pfv.47.2022.03.31.06.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 06:39:30 -0700 (PDT)
Message-ID: <6245af12.1c69fb81.f18ba.6be5@mx.google.com>
Date:   Thu, 31 Mar 2022 06:39:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.274-13-g6dee166cc70c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 82 runs,
 1 regressions (v4.14.274-13-g6dee166cc70c)
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

stable-rc/queue/4.14 baseline: 82 runs, 1 regressions (v4.14.274-13-g6dee16=
6cc70c)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.274-13-g6dee166cc70c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.274-13-g6dee166cc70c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6dee166cc70c4aebf00417863ef16af24cfec192 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62457e753dcde175ecae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.274=
-13-g6dee166cc70c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.274=
-13-g6dee166cc70c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62457e753dcde175ecae0=
67d
        failing since 46 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
