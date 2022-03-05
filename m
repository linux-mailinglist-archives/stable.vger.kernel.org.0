Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA9F4CE5A0
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 16:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiCEPwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 10:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiCEPwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 10:52:01 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDCF5A081
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 07:51:07 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 132so9987982pga.5
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 07:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RWYRK5OUyt7oSqonZkvmWrf9YOyu10edXauSBmXtt+g=;
        b=U0Z/MtVCBgiPS8SWyiY3pmXN5SEyPG37+4XkYDJ5b/KeAxNIHfpo5+Ha2ellN+TxmO
         Sm4OEjGy2ovHuppx1fhWm5kB71QbCsld0kiXaDPBJxYXQo35t4K/tZAWbVIpT6yJb+iS
         xMnggIPXvyuUZsIVLOIyQG6GgSnKoq1rphc6ygkGKrT5j9em42vkAIusjj0gvr+q++8z
         mP9ocjNvhSQJj79gac/7uPlBtxZo8SYEZapOHR92LZaNJ++xGT7DlXxsOvKvDtby1Zc0
         k605QkOAuQ1zsozrHT4j1guvyWhsRk54GkX5hS2EXPWF4PjA5HSxhwbJqNJY7rP2odUX
         /z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RWYRK5OUyt7oSqonZkvmWrf9YOyu10edXauSBmXtt+g=;
        b=pThwfGql/J1lPWdBmCV/WN9Y+Xnqtv0dQ4DdFUrs0cVjaN/f27p9UBrIhs73NSODT7
         ceUCgWV5aYvRTzIPwvSSDHptAIxsnuQ8zIhugl+o9UyY/Lp8cJLZPnBWvvCwypoWVnKZ
         RFeers7+/aNNgPf8GIKWE5ORLsFlXjFGP4Y22kbZJvv+XVntuSqVDwP3PPH0SxDh4rIX
         YqbMIHiwQPLnCymdoO1ZxOpZ5UgKc+u27Z+0puwu2v3ejT1RnR2kDvan9nC7fqHXouXn
         8b4lYSj9xTUaG9qRhtwIld2PRrX254owUro2R8iUzeSnd/lgAbd06wCFrUK91Jf2pswg
         3ySg==
X-Gm-Message-State: AOAM533ACJZy/55GGAbDGK6nMzhWUwL2rBtXzaUojD/iYawz/dJAZW4k
        9bdOSlTTqO9ixCZfbmRmiu+y+GZaPSC4tsVhr8Y=
X-Google-Smtp-Source: ABdhPJx/2EmG9DpJb3gcPzvAuKhK0t52pA/vaYYIWfiAO3jIeTslHsi92jzIDCQ60qoxRWfQTe2P7w==
X-Received: by 2002:a63:4b09:0:b0:372:c793:ab50 with SMTP id y9-20020a634b09000000b00372c793ab50mr3167261pga.495.1646495466456;
        Sat, 05 Mar 2022 07:51:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f15-20020a63380f000000b0037ff640933esm2149686pga.67.2022.03.05.07.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 07:51:06 -0800 (PST)
Message-ID: <622386ea.1c69fb81.2daec.4e30@mx.google.com>
Date:   Sat, 05 Mar 2022 07:51:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.304-11-gd4fd570efb81
Subject: stable-rc/queue/4.9 baseline: 60 runs,
 1 regressions (v4.9.304-11-gd4fd570efb81)
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

stable-rc/queue/4.9 baseline: 60 runs, 1 regressions (v4.9.304-11-gd4fd570e=
fb81)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.304-11-gd4fd570efb81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.304-11-gd4fd570efb81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4fd570efb81c256572c067d0827012cf27749a7 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62235fb1f4370d1719c6297d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.304-1=
1-gd4fd570efb81/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.304-1=
1-gd4fd570efb81/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62235fb1f4370d1719c62=
97e
        new failure (last pass: v4.9.304-11-g53562a91f920) =

 =20
