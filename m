Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24544CC1EC
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 16:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiCCPtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 10:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiCCPts (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 10:49:48 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244FEE02D2
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 07:49:01 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id t187so593949pgb.1
        for <stable@vger.kernel.org>; Thu, 03 Mar 2022 07:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KZupWSf9EcHjrSdAI+W8X4rTYkULwIFKKzzd6I9PGnQ=;
        b=bxAhtMkH1Ibf1HXe1pQ7qQsenXM3R5qkBGTwTY9E4uTE89qruoQfebWk5Ugrpcuarc
         aZcC21WnArhz2HhD7nnLJP0F6/Q6p7xPu6lo+tBt0uGv53poTvi98Xu6N9CjoBOdfEAZ
         SsVuYC7BFuZWTBcaV17/WvQUpQpnV6f7Q66apfo6zv6WH8ScC9qrxlBBEeYY0ETHgXs9
         e6wi1yvBDshGtNYxk/AhsKHIbdsX8TlqBPElbleKD2nf36lANASP2u7IEDYgm1VVj9Kf
         kZqXtjSq4ubxJ4OeN96rp1Gm7B83UMGO9ytUFtP/xV3OZ/Za61k3rPbbUsVJ0zW7BRJP
         UhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KZupWSf9EcHjrSdAI+W8X4rTYkULwIFKKzzd6I9PGnQ=;
        b=bZs9x8RHD0wk5JA5oXGb6MIxFOZBI3TTTzHB/B8jLZEFxMWo405uoZ5eru7hU+9XdP
         AsKgd1yk4T3V3xXBO2l+LC16a8lYAy8ckEvDwi5vEQoBb+TcO1Xk32qR7bRiBsxxpMYf
         3hQX/vPgPHBAzDetomsHY56spKkmiRkNol5YyaVeIBxataURPd1JZL45DfrwTHtrHjDt
         aLWQsGEyde157iLB3Tpi/734uMJILwTcHGBvP0PKbETGjj3en14Q3uXBtRO7bY6sdGs2
         aENORB6tBU7jayfde/96IzV9MNeDaQ+NP2m6kRjEI9lpFZ4DHuC3BRwzWvHCUuZ+75f2
         zZww==
X-Gm-Message-State: AOAM530hhF18rjgyD6Z3a417rSHLF8tP/8QTtspk9BtthSKWs8MJuo6c
        f6IJ+qCzUyurZABJxnapUnhLeRJ8Bw6IxlHHFIA=
X-Google-Smtp-Source: ABdhPJzARTR1RcdVCeVpouRQ81R0AXKEr2Qv4jXSPTAFXLHM5VhvJ6EZO2u6pzA18fdswvGRhlVZgw==
X-Received: by 2002:a62:7697:0:b0:4df:34dc:d6c5 with SMTP id r145-20020a627697000000b004df34dcd6c5mr16203518pfc.9.1646322540480;
        Thu, 03 Mar 2022 07:49:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pj12-20020a17090b4f4c00b001bc97c5b255sm2454041pjb.44.2022.03.03.07.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 07:49:00 -0800 (PST)
Message-ID: <6220e36c.1c69fb81.5243f.5fc3@mx.google.com>
Date:   Thu, 03 Mar 2022 07:49:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.268-32-ge853993d29aa
Subject: stable-rc/queue/4.14 baseline: 52 runs,
 1 regressions (v4.14.268-32-ge853993d29aa)
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

stable-rc/queue/4.14 baseline: 52 runs, 1 regressions (v4.14.268-32-ge85399=
3d29aa)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.268-32-ge853993d29aa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.268-32-ge853993d29aa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e853993d29aa42ac4b3c2912db975a0a66d7a5b0 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6220b0d89269f790b8c62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-32-ge853993d29aa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-32-ge853993d29aa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6220b0d89269f790b8c62=
976
        failing since 18 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
