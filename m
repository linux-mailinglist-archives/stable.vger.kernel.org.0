Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B31A534128
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 18:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241058AbiEYQO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 12:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiEYQOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 12:14:25 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C4EB82D2
        for <stable@vger.kernel.org>; Wed, 25 May 2022 09:14:24 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so18973665plg.5
        for <stable@vger.kernel.org>; Wed, 25 May 2022 09:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VPnE+Zf1RLxiIvOqhs5XOlGN1ljr+ARTWl1T8jMW99U=;
        b=0zdhykrRuF2HTLjnjMkTTohuAiWKaliJBMIzxCoJ61/EFm9W8JWEAjriX+2uPgWL60
         yNt2yGdaNkfLn9pKVc+GWdRCRu6QlLIENpcwqICuLOK5xmJgatSUbQCttDwfmbNN8nby
         VD1TJMSW5gKTHojQeZ1gfGN8ie9RZsB0DsX8Fe1IYn2rf7Lic0MCzEtTqVtFTGbxfvDQ
         WdoCzkb9CFi2IG0rLyYqsmwsY+FWotaRsFQQeEofPxWpH3GoXv9irMHvp+XmME6a7em2
         4tb1lcn2iGSn+p9NOuOIPLEErUdhgGpTkBb3W+Hi7v5nwwrM+zU/u0QQ4Oo05THV32SW
         fdtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VPnE+Zf1RLxiIvOqhs5XOlGN1ljr+ARTWl1T8jMW99U=;
        b=MGssgeGccmMwuIUQih7nBJJjQ90j8eXSyeT9pNIDc8F5RL0yjVgwBvSUICcsNiFVlb
         FzLTukOI4NsE51+csaoXggAzoCKww7e31Rx95ShHpHbp0T2OsCVo2T+7wqh9+eBmGbZ1
         GJ2LxvXvzx86nd9re/lf+V+TKybc/H6qb9WCZT5PEqwDnaFOjphcobQRXwsTkA8Ppy22
         BniNv/zDBppnoW9MOuHftI4L0ZSL7Sde1NoMf5rOY71rQYIF+DmfdIOZd4dSzucWBfXA
         vVDe9Gath8lU5hMvxNLLJ8JHJf8wxwqWVR8KIUpO04SUGiTz1indWHmzqGkmMC7dAbJN
         cz/A==
X-Gm-Message-State: AOAM533F3g2S16zX8rb6cupjXhLCBsNxeVLlFAOzdV0b30yQd3LSP6y2
        QxTMcTD9E8vHyWqzj1Lo4EHZdqXP5ICIFdtjyHM=
X-Google-Smtp-Source: ABdhPJwn/FM4qBmSwzb9ZeLD4vNEG1AAg+zfnQVUF+/Lh3tcTipZQ5rcVMNOti2/MQpuaePlRGC1jA==
X-Received: by 2002:a17:902:bb10:b0:163:6f61:fd46 with SMTP id im16-20020a170902bb1000b001636f61fd46mr274509plb.78.1653495263721;
        Wed, 25 May 2022 09:14:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v62-20020a622f41000000b0051835ccc008sm11447441pfv.115.2022.05.25.09.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 09:14:23 -0700 (PDT)
Message-ID: <628e55df.1c69fb81.b4dc.b707@mx.google.com>
Date:   Wed, 25 May 2022 09:14:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.118
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 61 runs, 1 regressions (v5.10.118)
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

stable-rc/linux-5.10.y baseline: 61 runs, 1 regressions (v5.10.118)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.118/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.118
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c204ee3350ebbc4e2ab108cbce7afc0cac1c407d =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628e27bcb25a4e1975a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e27bcb25a4e1975a39=
bce
        new failure (last pass: v5.10.116) =

 =20
