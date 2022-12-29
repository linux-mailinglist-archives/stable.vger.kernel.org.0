Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7081B65882C
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 01:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiL2AtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 19:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiL2AtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 19:49:02 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9D512D01
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:49:00 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j8-20020a17090a3e0800b00225fdd5007fso7904771pjc.2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOjizOS6KM8tnBAnwyqUT/3q6ulnEXGOVJ3sI2pLUDU=;
        b=nj22GFSmpuDDyzlUHFXuZfKw1yuuJfpZZmjsaA0G3uvGNo5UW3MaAqVPWcpQ2yTwIF
         LHf0ZDTw7l5YYWwQi8lt1TvJt+fzT6ar9phjtV0jmvEy/8s2XEHTDS9hhIz/v5h4NRQH
         deDKq7sZTwSmqj2XoEyD4OHM5/ny7nkPZ2YZOvA2tJsOwjwGQWvTv/GLMnpGM0GkNDAj
         2jeDoHl6Yvf7p63HrTCjkiSIQCLACu9wKXwVGGs4R0y52vQbWv2LxpV9mWeGpVg1/fI1
         n6aJ0UnHx0XWBTMg94tYDd3OV4Imha9yiSmQvF2hJ52BhtkVoqnYQMkEFY/whNsfRdfl
         vuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZOjizOS6KM8tnBAnwyqUT/3q6ulnEXGOVJ3sI2pLUDU=;
        b=Jp/WiDJILQ7s3xxX8ZWvPiczeorvUnZAk/L/mvZu6eWRQvfGmhy0qIHQ5z9QbI3pva
         hvwxqSyBI8neApGW8iEUen1jtSaF+Tz6qcGSj0kiABtD0qFz2Z9Y2ZX0p7sXA58KUqeZ
         xUcymBv8WqrKEqJF9gDK28THgyiTpg7/o5RIVTYUeZnU1EvgWrZhBG5lIvgZafvhxqnk
         VsqKt11Wq243O7x3bESukB04RAsRih2yl5t7G9InR9vBj2PuQzpfAvQZ4GdGOkMqixSD
         ZTUYLeBd1NF21q6Ozsx8anaxQ7bjPCJX3sz+xh7Xoa98CFwae0RW4uEMv6mwBmyFmnNo
         X3xA==
X-Gm-Message-State: AFqh2kpIBsRc5d1DYLdG15Hatj344UH8QSkp9BmPu1pGIq3dFgb2Vkv8
        byu2vCc8FqNRPT85gRtSvgDe4LD5kJ64jcfhm+Y=
X-Google-Smtp-Source: AMrXdXvIQDB2wm9GabJem4O6a2DbI51uTyNXrCVKc7xhE1ukYAGzH8ZogC4GdvHbDWTG4ZVt29xjHA==
X-Received: by 2002:a05:6a21:6d86:b0:a3:e346:2548 with SMTP id wl6-20020a056a216d8600b000a3e3462548mr42415343pzb.15.1672274939545;
        Wed, 28 Dec 2022 16:48:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p186-20020a625bc3000000b00581466232c1sm5050142pfb.69.2022.12.28.16.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 16:48:59 -0800 (PST)
Message-ID: <63ace3fb.620a0220.27ced.885b@mx.google.com>
Date:   Wed, 28 Dec 2022 16:48:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.85-732-ge81e28b1ed4c3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 121 runs,
 1 regressions (v5.15.85-732-ge81e28b1ed4c3)
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

stable-rc/queue/5.15 baseline: 121 runs, 1 regressions (v5.15.85-732-ge81e2=
8b1ed4c3)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.85-732-ge81e28b1ed4c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.85-732-ge81e28b1ed4c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e81e28b1ed4c3b7b79ff02379aa3ff62011a0a28 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63acb5865706ec8b3c4eee39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.85-=
732-ge81e28b1ed4c3/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.85-=
732-ge81e28b1ed4c3/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63acb5865706ec8b3c4ee=
e3a
        new failure (last pass: v5.15.85-731-g06a7f4801bf73) =

 =20
