Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2FC51B6EF
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 06:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbiEEETS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 00:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiEEETQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 00:19:16 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D3710FC7
        for <stable@vger.kernel.org>; Wed,  4 May 2022 21:15:37 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p12so2736437pfn.0
        for <stable@vger.kernel.org>; Wed, 04 May 2022 21:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GSw74Dwgeh+/xHVEsIfuhA7sIrGzhwmkDY1serekHBY=;
        b=a0Crg2JnPmX4GOWdTe8jcyp9NyrMnnEXQyLEUWQ3/65mQCv5WCQn08G9zgFzVl03mA
         yjHxg3iuS/Tapkq/fTeWaJMV4S8ejfT0GNzJmWSv2M9b26gOKxWFlxgBULxD4841jkXv
         5oZN/kxoxzIXXWOINDsUyKm0X3SU2VsH2W5I4w+6tb9kELKdaPo5KgvpuU3bXrTchykL
         V8nf33W0Q7RgGSoCCdXfQ0N7eqF2rQIykZAOATp3mCdZTGpX0fvhNH2ybwpjKCJEz5WR
         ealNF3nLZ2+qFptMV1FkzmigCPWbsOQcxiv0qunDFSI65saHjZ1D/ReoXGCavcSEVA+P
         FQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GSw74Dwgeh+/xHVEsIfuhA7sIrGzhwmkDY1serekHBY=;
        b=t7zczOYvhlpacy6JM0XjU6cwTB+u7CsCjPu8z7wefpFoRE+PPb5idMfFLGYjZYe2e4
         VN2JVR4cqxswFSL0Pvnx8R5irGnDESHHMq28wBTdzxxQlw6ouJ7uu7wcVzIQL+MPBfZ0
         2qy4Sd/qvEEA8zkoOg0+i5uzlJvdTcEjKjrD8IwL3nmLFE4zjkE47cVGypV3H4OyPUXZ
         aHzhxXOadj4kjL/806fiYy2Fxfl31s9lj648mUfR1HaGqIECGi/0rlydTwXzicTT92oq
         96Px13HjCc+qSD7zmOwlL3+Z0nqqUsBIIR6o7N2aumlQeJMufFZwPwA92zGTzyilWU/R
         XOog==
X-Gm-Message-State: AOAM530VNF7yjlqDFd92ZybcOPLTatV3LmGfPeWSiTZA/ScvHItdrYoe
        m4GA3mCtRxpfQDp+GifPmMt5SyHcESTEs3CXheo=
X-Google-Smtp-Source: ABdhPJxAhobEz2Xw1rU5siUUF/FQ9CBTRcHAjtcFVoE6yaodpYC28SqKlhLDlfxqC0I1sdSPP9e5yw==
X-Received: by 2002:a05:6a00:1352:b0:510:4c0e:d230 with SMTP id k18-20020a056a00135200b005104c0ed230mr4578776pfu.79.1651724137295;
        Wed, 04 May 2022 21:15:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q78-20020a632a51000000b003c2648d2b06sm199968pgq.90.2022.05.04.21.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 21:15:36 -0700 (PDT)
Message-ID: <62734f68.1c69fb81.2aeae.0958@mx.google.com>
Date:   Wed, 04 May 2022 21:15:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.277-55-gfb8b8dfe0168
Subject: stable-rc/linux-4.14.y baseline: 97 runs,
 1 regressions (v4.14.277-55-gfb8b8dfe0168)
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

stable-rc/linux-4.14.y baseline: 97 runs, 1 regressions (v4.14.277-55-gfb8b=
8dfe0168)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.277-55-gfb8b8dfe0168/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.277-55-gfb8b8dfe0168
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb8b8dfe0168889243c0e5538c0739bec057b1e3 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/62731ec7d6ac76891e8f571b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
77-55-gfb8b8dfe0168/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
77-55-gfb8b8dfe0168/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-mes=
on8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62731ec7d6ac76891e8f5=
71c
        failing since 79 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
