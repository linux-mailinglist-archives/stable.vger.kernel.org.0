Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96984D3E31
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 01:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiCJAeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 19:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiCJAef (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 19:34:35 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842CB46168
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 16:33:35 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e2so3408870pls.10
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 16:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/iW0pNDp9S68rOIurNU13yQGtka03dPkOWyMlBxjTYc=;
        b=dkMC12cdpKOAsokzv+syXkqxT2Nn3T4FxxkgablHXhPvucmITnLWFvbJlnAw6XemCa
         CxxcxU7XlfCd7lctM/3z6ZP6cBT8lK/ieBWIsevdBwfSSPoo3TDHkkCwEVbvRyokbPzw
         VAo9SXXwj4gVAje0osHGwCcmYC12LEqiFRTH173zFG2lMwf2UyvF8iPyoM8+utnFV2DQ
         qgsnW0l3qeWUXuQxG4fnHC9hN/hywhSn1/34Jb2D8K3Ru/obghk1qddJT9bBQi1OEIuD
         qmUsBCzdC3JhxPu5PCTeO/tLts9AU7DSPzSB66ZLoylaS8zXW+tv5tMp3/F2Gws4Kq+l
         W1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/iW0pNDp9S68rOIurNU13yQGtka03dPkOWyMlBxjTYc=;
        b=E4gotDn/HwdCv0iFdGm/7z6HwpUo7oDPnDkhohTvPbYpI7KDlDp7EIds3Si0DJbNBl
         Fh3JCEyYXktlA/K/g9wuYbgeG+7437JpWjbVAuLrKPnpK2Ruc49x1rDv/f9akYzSSaRq
         HW72uSmd5r7kTAoyd4VJous7NACtPLDADUoGIF7l5VWELdRAQ49nFMPkpvkJf4S/Ogfj
         S9d0mUmgSaAqZKzKVa0zbdU8FZ4VFZ6ybm6HmErjUJzXufIA3xSReGOZYAI3dpykiog7
         4WwVrROCC/t+RQ8eHmNZ76EjEdo2MOMVo+N1YFfnYnx0KLebPcmNeZmQqmwrouiBbtfs
         j9+A==
X-Gm-Message-State: AOAM531iz5DHNdp+483W8ERu9SZ6AZsriAbmyxPB4wwDKq1xQm0RtEe7
        uzQO7aGKq96vs9BF6ToauM4I3S87KTG8S63Ig1k=
X-Google-Smtp-Source: ABdhPJwCzYNfmcdD82NQvlCxj9eLqLEBA9jajS2XQGfPxE+84xtbWHlAGT2CgDM07Y7XOUxfE151hA==
X-Received: by 2002:a17:90b:4d05:b0:1bf:7d65:f1f7 with SMTP id mw5-20020a17090b4d0500b001bf7d65f1f7mr2241963pjb.108.1646872414899;
        Wed, 09 Mar 2022 16:33:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f9-20020a056a00228900b004f3ba7d177csm4739957pfe.54.2022.03.09.16.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:33:34 -0800 (PST)
Message-ID: <6229475e.1c69fb81.5e8b3.c381@mx.google.com>
Date:   Wed, 09 Mar 2022 16:33:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.104-44-g948492e30880
Subject: stable-rc/linux-5.10.y baseline: 59 runs,
 1 regressions (v5.10.104-44-g948492e30880)
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

stable-rc/linux-5.10.y baseline: 59 runs, 1 regressions (v5.10.104-44-g9484=
92e30880)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.104-44-g948492e30880/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.104-44-g948492e30880
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      948492e30880804fcbdaf8003d281d4b813cb445 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/622914f16f6b3abb0ec62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
04-44-g948492e30880/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx=
6q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
04-44-g948492e30880/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx=
6q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622914f16f6b3abb0ec62=
976
        new failure (last pass: v5.10.103-106-g79bd6348914c) =

 =20
