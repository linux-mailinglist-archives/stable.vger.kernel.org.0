Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50124D6D0B
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 07:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiCLGib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 01:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiCLGia (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 01:38:30 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11B812E76E
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 22:37:25 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id t187so9276265pgb.1
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 22:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4pEl6459uY1g2zK/hz6iKoP8AbCaQJs+5aVPY2mTWFs=;
        b=kGg0yVE8lzjB4/LKBrosFxxFr6C/oJHVOCmxBWSwv1PLAya649c7j2dTBTC3hfG7Qi
         4oKN9kIubk6IKdKMB25CSOue/iE6gfY5ZjyDQz0STCJiD/34a+/yA70tXqnv7kLPp18E
         w4zNV3JuKqzJaTWPMj8QtTAcHf3rOV9njL3xoTIMXRcCELO9lO2kLmqegELGP1m0s1Gz
         hGevkvjRb6yhX/QTs+uiuAafZgAJSrNYCRUTRl0p4O2diWDS/53suKAOhkpVldh2pi6w
         mUDxvwjKG/pJMtPfnX5enLV45G35gpLDinN+5kMh5mnWC++xBTk3XTnCgwqwiL51sc3S
         HgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4pEl6459uY1g2zK/hz6iKoP8AbCaQJs+5aVPY2mTWFs=;
        b=N9bVeMHe0S5GFHirvq9lAy2+jALkBHug8k8LEgCP+fzrCQkKEIra/rcRjp4mGU7/V+
         NqmQdo4eIvw9vOZ3JVYP6i55c1stDCQuqwWDpg0yfSLnoF8AAFmvSfGxPtedYhn13eHd
         +Gkfw7B6xyOnz7LiaEKIUnZdexwfFDNtuB7ixPvJdzkeD7sFK6FQf541H/UB71xjeaWu
         f0/6HTWKPrAZ0MzhNeMhOyD4huPMY2NIiL6OSORlIGb+RLCf7GQYmoch1YUxIjAue8Eb
         Fc50eQRWPMADiDbgHysglw5fKC/IoknkrbOWR6PEnmjnQ7wAZw5lA2I+kO+x3arSaQUb
         OIlw==
X-Gm-Message-State: AOAM530W23aLBLWKN7E/IbFLSuo58VIaqNmlwVxpZflmnCgxLcGqzLN5
        8BHNvuy8xGzeEa4OH7Z7QryS+DqXxKlMJTQ5uyE=
X-Google-Smtp-Source: ABdhPJzqY2EkD31Y+XgtMWRRY8QZGAmJB+st8HL1Vct8rzOsK92qaLWvZMZ/irjW4J3NL2fu7q8i/g==
X-Received: by 2002:a63:6c45:0:b0:37c:714a:4ffe with SMTP id h66-20020a636c45000000b0037c714a4ffemr11723952pgc.513.1647067045055;
        Fri, 11 Mar 2022 22:37:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f6519e61b7sm14215830pfh.21.2022.03.11.22.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 22:37:24 -0800 (PST)
Message-ID: <622c3fa4.1c69fb81.cb944.3e81@mx.google.com>
Date:   Fri, 11 Mar 2022 22:37:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.270-32-gf497d213f361
Subject: stable-rc/linux-4.14.y baseline: 65 runs,
 1 regressions (v4.14.270-32-gf497d213f361)
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

stable-rc/linux-4.14.y baseline: 65 runs, 1 regressions (v4.14.270-32-gf497=
d213f361)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.270-32-gf497d213f361/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.270-32-gf497d213f361
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f497d213f361b7d7eb4a85da0eda9c11136cd0b5 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/622c075a5e730914ddc6298c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
70-32-gf497d213f361/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
70-32-gf497d213f361/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622c075a5e730914ddc62=
98d
        failing since 25 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
