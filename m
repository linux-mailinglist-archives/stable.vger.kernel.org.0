Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8AE4C7E68
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 00:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiB1Xaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 18:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiB1Xau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 18:30:50 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF2713F6E
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 15:30:10 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id w37so12885654pga.7
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 15:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ia5TTgD1FJsRFlDKUF0Bt4gxUBPJEDsyAL0t7DgrVZc=;
        b=bl3K4L++2ra5NKWpsOHq6T0ZXEkXtMhyEB5ilkmWIi71WNl0uneYQbt8vy6fSXgCsf
         NqNONztNT5RCO7GwTm8qs5uJxz+MXaKfJDYy65D+FgcGYhEN4avf9Uejj/tTiX+x8YQ9
         IeX9T1leO10OF8Vv1OB68ioy5d2jofsnAiHVENKtzgvZGXiwupvPfg4oazVmTTWwRQrT
         TGEYzxjtcVXdr+6egGGtS+StYGx+vC7AndG2ynnFHbB0GTtk2N1pV3/H+ZfSPRIzhVuS
         8ZL9DzDt/XV0ifnNMsWHtKbe09T2knUS2jYQrF31sktQyhZLZp6hpvO89Iu0JVmugJNG
         I7Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ia5TTgD1FJsRFlDKUF0Bt4gxUBPJEDsyAL0t7DgrVZc=;
        b=WTXLjxb8RYco9+tLmxnjkgxgS45D0NfCkrN2CUxqo3nZcNzQBzmmbaEdH71I5v0Egt
         LtZiDbzoP51q77gQdT5LmhaBBIGE02SnfxDjWGTbhUVE166bW3XxGA3mAl4HelWFrq75
         Kw9sYV+t3yF0+GzaTUkAZqQLqqt5XZw7zpLIiudXfnEXTj4P201NLb0UhpR0xT3mVOd5
         FbK4I1nLqRmtP8Bekk3AYSr2FsiODEwp/GZooQcNya/umt8dleS571aW3eozysIWquj0
         BEcFto7DHpRL2tvJQgg4C2KkySNoY2nPGPNmRCJHGkHVKvd5C9pK+5O1tF28b4OpnUHT
         vGOg==
X-Gm-Message-State: AOAM530qgoAWi2UiK9+QwKhXtrI5STOeWvT95YwvWif5SG2F9+bc3mYC
        wE5BLXnylwKs17Di8lXZCB/WRcYnR1USmNHPaNE=
X-Google-Smtp-Source: ABdhPJzYoCoVHb5OG2r4Lqzklt31/kdfdqXoHj9nGxfjgcmU1EuLOdtKPu8BmfHmVoQ9lzaqx1H+Wg==
X-Received: by 2002:a63:2c52:0:b0:378:b8a9:165c with SMTP id s79-20020a632c52000000b00378b8a9165cmr4735728pgs.610.1646091009619;
        Mon, 28 Feb 2022 15:30:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7-20020a056a00218700b004e0314bc83csm14509359pfi.139.2022.02.28.15.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 15:30:09 -0800 (PST)
Message-ID: <621d5b01.1c69fb81.cf340.485c@mx.google.com>
Date:   Mon, 28 Feb 2022 15:30:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.268-31-gfc3715b210a6
Subject: stable-rc/queue/4.14 baseline: 69 runs,
 1 regressions (v4.14.268-31-gfc3715b210a6)
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

stable-rc/queue/4.14 baseline: 69 runs, 1 regressions (v4.14.268-31-gfc3715=
b210a6)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.268-31-gfc3715b210a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.268-31-gfc3715b210a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc3715b210a629c89bec29d8894ef82388b3a42d =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/621d253d40ca93f823c6298f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-31-gfc3715b210a6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-31-gfc3715b210a6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/621d253d40ca93f823c62=
990
        failing since 15 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
