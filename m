Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED218517F46
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 09:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiECIB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiECIBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 04:01:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1766A2B254
        for <stable@vger.kernel.org>; Tue,  3 May 2022 00:58:23 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so1233152pjb.1
        for <stable@vger.kernel.org>; Tue, 03 May 2022 00:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l9NV3RVMD9ixClkn4GSWLZUGhLV6uLwpxbBKVsnygjY=;
        b=VNGrdT++BzopxMUuxkrafM6/lEhYV9WEwKUm1nVf6fD1ngknC81OQPWhVMAjPIPITN
         v0SejEH+ikzJ4GiRHuc+byjrHmR3n1NWykX15yj7z80jc58KsMoGQU1qEAmGLbWCFlrw
         VCQRcN0KmtA8TZutwLFHeEGUdaP93jktrk0vbnPLrCkmVkAOtvnfrvm/In88zJcODgXX
         KsHQMYhoWjsDJBxIIACNx0+z+jb45R+6M18wW6FNKVhH60ght3itXFQHl6rFX0aCyhgS
         eMwjAzBzNSSYdIhpG3lt4H2/t+1B+kipUBOfJEf9VrgUBhsz2yVuqfo3zNoOR/dhzCby
         oTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l9NV3RVMD9ixClkn4GSWLZUGhLV6uLwpxbBKVsnygjY=;
        b=kLD0nVgjcXjXdQF99P0QQJzhnzlljmINa0Hkiti3I93XB1Sf3EW4PfkJTniE7y+qim
         PT73aZ/1GWSPKIh73EgK+0URoI4orx14C+/rUeegcjVB6rl1fDwHegMbkkqZqEbC7E3S
         /qSK2W2WxSAg8G3zAvbZ0EaI22iXGXYrPi8HZRYBB2s+4cOjX24PxgfEIdiR44wUXJ+R
         g92sEas0Z5I2ZWt9CBrAIP5bgM38dcgyTcooksdbdxtF/uczmn9AUcqErzQP3IlbFNYb
         jOQ/f8T49PTE4XPpDKvarDCHpgD0Dfrwxr/WuW69hn3vlhTSE04Rn32pQMkcuWqT+tA6
         LaCg==
X-Gm-Message-State: AOAM533lZ3dCWNLhm5yJBqG3SuQzkF762y/CXwMFt4MN/NTyXtp8AaA0
        JTuB0qvAUUTpub5xC78jtd0EFh6JHn7m8vgaDjU=
X-Google-Smtp-Source: ABdhPJw6XEyPzBkAtJNpQjU76Rt1V4s0zfNKApA4nuEYf/MzTBsgfqUx6gIo6GlgjL3Q8G2Ng3Ch4g==
X-Received: by 2002:a17:902:8d8e:b0:159:4f6:c4aa with SMTP id v14-20020a1709028d8e00b0015904f6c4aamr15570098plo.115.1651564702449;
        Tue, 03 May 2022 00:58:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6-20020aa78046000000b0050dc76281c9sm5812804pfm.163.2022.05.03.00.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 00:58:22 -0700 (PDT)
Message-ID: <6270e09e.1c69fb81.85efe.e9b2@mx.google.com>
Date:   Tue, 03 May 2022 00:58:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.17.5
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.17.y baseline: 124 runs, 1 regressions (v5.17.5)
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

stable-rc/linux-5.17.y baseline: 124 runs, 1 regressions (v5.17.5)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2731bd17017d4a0e2180a1917ab22d7820a07330 =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/62702facc0a516c6dfdc7b22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.5=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-am57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.5=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-am57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62702facc0a516c6dfdc7=
b23
        new failure (last pass: v5.17.3) =

 =20
