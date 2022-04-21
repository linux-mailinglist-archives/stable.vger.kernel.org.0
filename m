Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C8C50A531
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 18:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiDUQ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 12:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiDUQQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 12:16:02 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6412B241
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:13:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n18so5324716plg.5
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ABv7HJWiETT5ahg1I406zpBtj5Rvs+9Xd1KHlIh91HE=;
        b=kRC9GsOplTLQTVsb6pYk2Sj2N8smtJjsgxOvKIorntHmeqhPL8aGcremPk+Oep2gfn
         Sy05XcOFe6kVQW4BCTUo/zklpKSQn9RQ11CowNtAq8m7AP8zb88iGdb4BrO2bcMnL9rJ
         Yq1EKAYb7IBdA3XyZ1vdFfy4wJytI3lS+pt/oohMgtkS030Vg1VW5ateMLWDiqb4ZxIR
         Wwnm3iiiQLVN2HLTRLCtoPaZCJ1lzU8TW0nxmFOY1l61sO1svJLUMy3ttlfjzGanuPhr
         fps/5Gi5RF9gMxhGYGSvQUrEK7Kb+ulOLU+e7DppvvdXKYAZVohbjZ/ODelY2mfQluRn
         xIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ABv7HJWiETT5ahg1I406zpBtj5Rvs+9Xd1KHlIh91HE=;
        b=ERZ/7zOG3owrvSbv+dwixsz8RA6ye2VCxDDMyZ8bt37N7Gx41waNg+recq2qGYdZw6
         2L5kuoI5yIfUZUIp+HO/u5PsdAeNkXMyMh0zGLy1AXGcTeOtytAa2uEoI5kOSlka3rd0
         HrLrlZXC2X/yfV+RhGR71hiAKIzwRSZwi0weG/QIDI2YPbqA/+lwxtWzoaaPKo/3WXIL
         R76eJZ7Vsu2DZoJbh0vWUt8XLp7pja+uLizFP6Rie3ZMUSWnBBJf4/GqEveAuwIzq2DI
         EvDqvPLPW5XUliOkYRcrNRJZeO1FQ7Djr4VrqLJcHc/Pg2R7OQLzSQck/KDealruB0oo
         fT8g==
X-Gm-Message-State: AOAM5314O4wlOSpwyh7RJ8ewKoRcC3qsjlvpcmZYVl5h5fmUx9RnbElt
        cLMx+/0A+N1sK0rWd+PmoiMULuJrwvBr6X5H8mk=
X-Google-Smtp-Source: ABdhPJxih2vnQeVU81ImrtFT543j7f6JFYEshLtPDN3pWU1abTQZ4ZWj2Cp37s3ZCGiOF+J5XRjf6Q==
X-Received: by 2002:a17:90b:2685:b0:1cb:6521:dd78 with SMTP id pl5-20020a17090b268500b001cb6521dd78mr438614pjb.194.1650557592218;
        Thu, 21 Apr 2022 09:13:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm25136527pfj.55.2022.04.21.09.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:13:11 -0700 (PDT)
Message-ID: <62618297.1c69fb81.54aa1.ab9c@mx.google.com>
Date:   Thu, 21 Apr 2022 09:13:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.311-2-g933b72f0f6f0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 42 runs,
 1 regressions (v4.9.311-2-g933b72f0f6f0)
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

stable-rc/queue/4.9 baseline: 42 runs, 1 regressions (v4.9.311-2-g933b72f0f=
6f0)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.311-2-g933b72f0f6f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.311-2-g933b72f0f6f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      933b72f0f6f0092dbf6cb8f90552d4cc5d6d6d25 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/626149b44c3701329cff945e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.311-2=
-g933b72f0f6f0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.311-2=
-g933b72f0f6f0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/626149b44c3701329cff9=
45f
        failing since 15 days (last pass: v4.9.306-19-g53cdf8047e71, first =
fail: v4.9.307-10-g6fa56dc70baa) =

 =20
