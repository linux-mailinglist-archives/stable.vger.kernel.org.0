Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876D64D5211
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245451AbiCJSXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 13:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244160AbiCJSXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 13:23:09 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A8B14F28A
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 10:22:06 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so8947666pjb.4
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 10:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d1lMHbLpJ1kGUeez04aIfe3XzqaUip1uEG0RBrJMSe8=;
        b=jUDNEafwiPboxgZVVHfmzp1W1E/mg32SDawRgEpr+uT/i3ZjR3UaQu+k6i9coyOrHI
         9FoeiiXqgES/YSks/sPjfUzcDxuT/0gB8VnE2EvY+rchMPpgkwr5WibtFB1srS+ujOvq
         +w7jURg56suw/PJlWa6bTHSePmshIIyjT53dsQMOGazNig0L8mC9emcttHeYOoK+i7/t
         pW26es6XoWeRveul+NHUwrcE3KNLPKSnS9GDhjHycmdBzosrDShj/A3sd15RC1X2RKKd
         uAh4Ur9AAD+VmbygoMPVSzgENFq+t9Zp37HAccTLK0zpewFcdcUeWs8t7Y/8SBBx6lgw
         KXkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d1lMHbLpJ1kGUeez04aIfe3XzqaUip1uEG0RBrJMSe8=;
        b=AKcYut0SCDQvxGzMwIM82g5u/1mUCBJxQVRc6Fdawv6AwQpuDMwzBVK1NwUR0aySqE
         TJWpQGBmQZxLPlCyMTjJhuhjLCUwW+Q2jZyi6Nkp9PYfQjhAAm1/5kEcl+h0LaW1bKOg
         +kZuLrl5z59CJyjWcSCoj7KXG28AbuG66DCo6OpokxxMb9RvwMKLDL1TVlnmTGNbCTzu
         KyRWtNetzRjuvsgK015ZR83ZysNPUMp8EL9sWruGDgU4xoYBbPdhoExGibdFSpW/zk4D
         IT/E3bDwJmtnf9o7T0LYN8Su3xUoT5xuHe94T2w5PYRXHLDQH5RamfBKl3JizGh/Fag5
         eVug==
X-Gm-Message-State: AOAM533hy5BT2GnSrMeGvEUNpalK+fc8GVeo7TocLNpCl4ClHYm9UcNP
        aK2jfoVMapWKqK+ev3UvADDvfqMjJu1vXxXIgHE=
X-Google-Smtp-Source: ABdhPJziyZUzN2jsfDTnt5iBsCvgbTunW1NPf5ShFMGAlLjPfau9s+ynpyc6YXnwOXuzUOTwQ4tuZQ==
X-Received: by 2002:a17:902:b694:b0:153:1d9a:11a5 with SMTP id c20-20020a170902b69400b001531d9a11a5mr4430476pls.151.1646936525955;
        Thu, 10 Mar 2022 10:22:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f31-20020a631f1f000000b003742e45f7d7sm6105791pgf.32.2022.03.10.10.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 10:22:05 -0800 (PST)
Message-ID: <622a41cd.1c69fb81.d40f8.f9ac@mx.google.com>
Date:   Thu, 10 Mar 2022 10:22:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.233-33-g003aa7f04490
Subject: stable-rc/queue/4.19 baseline: 48 runs,
 1 regressions (v4.19.233-33-g003aa7f04490)
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

stable-rc/queue/4.19 baseline: 48 runs, 1 regressions (v4.19.233-33-g003aa7=
f04490)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.233-33-g003aa7f04490/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.233-33-g003aa7f04490
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      003aa7f04490e041cf12e3fd17283988b5af9f48 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622a08cb4ebb1d782fc62984

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-33-g003aa7f04490/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.233=
-33-g003aa7f04490/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622a08cb4ebb1d782fc629aa
        failing since 4 days (last pass: v4.19.232-31-g5cf846953aa2, first =
fail: v4.19.232-44-gfd65e02206f4)

    2022-03-10T14:18:37.581409  <8>[   35.814569] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-10T14:18:38.597032  /lava-5852106/1/../bin/lava-test-case   =

 =20
