Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3604FF96A
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 16:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbiDMOwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 10:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiDMOwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 10:52:21 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCCB1659E
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:49:59 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k14so2052017pga.0
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 07:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+tqwJ8Z+XBZQ/7vnZYqecRmcYdSNPcY22ThuyuoF0U8=;
        b=galsUVUN6TyXlglaVTeQ9Xsr/+gPmR195YYVZQIKxDYvx63/qVf7EeR/mtfr/LjLdl
         adGvRVRXEx2uOUt7xbk2ADpvuKj40EUxl6ZqP7m/2iXNJ16hU+5AGViNuo3rPmd0lgWo
         J3Z0OejMy1Y+J/yaBPATF2JKZWediZpUzcrdY/lc6T29Tuan/P98DZ02wwBONo3ag+y7
         NbAJAqTEf9sIp/yRjMFPC7fZizxJZQoSE3oedNVmA5j6Rhi3f1tM1/Et2AloKgI4iJQW
         pBY1GVsePS7jgIlSyRDMeQRbRdI2IRyivRncvy6qwOruycTEHOSbD1jS3cGC23b/iwHD
         qTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+tqwJ8Z+XBZQ/7vnZYqecRmcYdSNPcY22ThuyuoF0U8=;
        b=wNxvxGKHwRUwLALLwrFs2Hy9Ft2g1tr2qd9JGELRWA3ua7zTLFk2XRkPqRTToQaVWY
         gbyGx4vmwKyMwDqQ78fx1xlcmuvtvZDs0ArTrn1acccw1RyMCCaLyH0gUSkAhoTMUfBO
         nv/IyFs5Uhq1yixHm9fmYk8uOs/yKhz1rT4A3XtmAq7kWrosyzeom5sunElDYC1pnw16
         tklrKs/u+O9sNEXnGwbOZhQc1SEvSa4swio0TmQn/4SVBcIMtPwbUPJk/ou75o9ccg/u
         Imy1PoZ+NHs2so8RpTJi46jz6Kn8GobWi37zgskjX81dksOqeUsbpHXDyaH8uMpL3fv2
         kkDA==
X-Gm-Message-State: AOAM530jhBMfYILWuxA3Db9VCJYgR6+YJRLL/CulAgOWG5m7erzpin2M
        Rrz6HG46vatkQrkTrJ8LmHToFacRvFAczurB
X-Google-Smtp-Source: ABdhPJyuEJpNUKgF7iDAch1OvcLCLWgTgR6OvBLhkUDCv3216nNjcDjbQtrT7M2swr7Qrl8gX010pg==
X-Received: by 2002:a62:1548:0:b0:505:fd84:33f1 with SMTP id 69-20020a621548000000b00505fd8433f1mr8886651pfv.66.1649861398720;
        Wed, 13 Apr 2022 07:49:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00125200b004fb112ee9b7sm39154525pfi.75.2022.04.13.07.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 07:49:58 -0700 (PDT)
Message-ID: <6256e316.1c69fb81.12bee.81ce@mx.google.com>
Date:   Wed, 13 Apr 2022 07:49:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-259-g58bc45998f740
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 85 runs,
 1 regressions (v4.14.275-259-g58bc45998f740)
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

stable-rc/queue/4.14 baseline: 85 runs, 1 regressions (v4.14.275-259-g58bc4=
5998f740)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-259-g58bc45998f740/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-259-g58bc45998f740
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58bc45998f74014a4f41060280bb17f8c3ba7395 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6256b169509c507b94ae068b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-259-g58bc45998f740/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-259-g58bc45998f740/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6256b169509c507b94ae0=
68c
        failing since 7 days (last pass: v4.14.271-23-g28704797a540, first =
fail: v4.14.275-206-gfa920f352ff15) =

 =20
