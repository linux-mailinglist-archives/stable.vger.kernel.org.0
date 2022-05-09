Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1158D51F958
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiEIKJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiEIKJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:09:32 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B79026605C
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:05:32 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x52so11811573pfu.11
        for <stable@vger.kernel.org>; Mon, 09 May 2022 03:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N9q5169FjOebCmq/jwTmX3Scl9Zg+6Vs3mVcDcw/lFk=;
        b=Mt4ceJ+iXPfs8xX04zp984fr4cIfNmQZX9y6G/gntg9q/wZBMJFvoCRCbIHVUC5FQE
         m5FgYaEnv4r/D34hf6jYTwSAKXVDhnly3iWsRaCM4ZxZAni1lBotxKpb/DU2WCzSY15f
         ++I67DmGsm6VyEtEibXMEaROUu4zNldUWnL5l88ZAatMjD3EpaaFip/xHPZWH3oOn+Xm
         VJ1KZHrezvmchnwB5pXpJaDo6DU/IlDwfWLsApX5e2tqS/Ipqa17uTaww6XODhVSSHSa
         U62BIJ349vG2n6/qnbHulz95oQfLoZXeeAvcQpCLKh3Aj0qp99x4L73u6dJppxcKN8uZ
         JTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N9q5169FjOebCmq/jwTmX3Scl9Zg+6Vs3mVcDcw/lFk=;
        b=iZ4fA20EcwTc1d2cQ2fISyfxvOx+Rmc486/CMJ3WHo7/EpGq/EDwM3DpWPB8qs34+A
         plaCWtBaVNKW1Dr8QgRGs40wjI4IpJ8e4KY9HBdc0UWrni062mLc8ogIhSX0aIjnZO60
         dzk+nPCDQsob7YsZNmAQ0FMSHVVnjT6ZGzFOSrFUp8qEP9TObYxfRvsl5sGCTsdfGAhZ
         qtV9uKUIpasvPDLEA+k8CrFNbUw9Hz0Hu/UV5EaLG6vVjaMSHcY41Fs1owaLKSaouUew
         RShSyov6sMi2iTwzJaIhPCpT95a3cuZMXs35KkRSXVpkl5j9XrYI6ptfmF1WrNeyzujx
         I6Pw==
X-Gm-Message-State: AOAM5320jjmsHwvUW9uz2tMqZEiX2rRz4cOpG3y9aWGGYTGF+wpwG8ms
        3s5aJ8WpJ6d/yoMqStwUWG9D5rcheVuvK1UL
X-Google-Smtp-Source: ABdhPJzecrw2nj0oETAbHczvCQ5idE5mP5HlNWdQyeBt9M5rKWpy6chXAhIjgGrtU5yFHDXbcQ86Fg==
X-Received: by 2002:a65:6942:0:b0:378:9365:5963 with SMTP id w2-20020a656942000000b0037893655963mr12536415pgq.142.1652090445237;
        Mon, 09 May 2022 03:00:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gf1-20020a17090ac7c100b001cd4989fedesm12053381pjb.42.2022.05.09.03.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 03:00:45 -0700 (PDT)
Message-ID: <6278e64d.1c69fb81.2b140.c9f9@mx.google.com>
Date:   Mon, 09 May 2022 03:00:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.277-54-gfa6de16ffc4e
Subject: stable-rc/queue/4.14 baseline: 42 runs,
 1 regressions (v4.14.277-54-gfa6de16ffc4e)
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

stable-rc/queue/4.14 baseline: 42 runs, 1 regressions (v4.14.277-54-gfa6de1=
6ffc4e)

Regressions Summary
-------------------

platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.277-54-gfa6de16ffc4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.277-54-gfa6de16ffc4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa6de16ffc4e8ee05984ca29cc11afaaed738a76 =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6278235d797fedd8888f571b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-54-gfa6de16ffc4e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-54-gfa6de16ffc4e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6278235d797fedd8888f5=
71c
        failing since 20 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fir=
st fail: v4.14.275-284-gdf8ec5b4383b9) =

 =20
