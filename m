Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818D44D298E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 08:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiCIHiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 02:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiCIHiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 02:38:12 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCAE1637D0
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 23:37:11 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id n2so1248636plf.4
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 23:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y31fdhJqWv7VFfQKxaSCUES0KePUfr1IrqQTLzSzdjg=;
        b=6qZyZW6EgwYRUWDCxuSMnCFuzHXDa77t40XDujmMeoLTKWUwVVIizXmyLDpeYtmTww
         KBZxp+wD7r4uC6gSnZAwbb2Od5Pr9VUb8yY+WViAGBLzC2sKUAaEA4WlY5cAlc4exvsg
         c9a5TtXNoYfwrdX6/WDBbr2kWQYf08LcHc9HyE+ZZk42uwbVejZJt2uhD8r+IObOj6+Z
         wi1ek7ihx0j9I3eJd19ccTA+no+kOls5DhPPuNY67ssqDnBDjLhkozGcSM9BFUeTju3D
         HP/jlj+CI16V98qMLS1KFmvfpBO1P3e8/1jikQLiRlnE22d2BuZcgLCk/1hcl8xoA5SC
         oWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y31fdhJqWv7VFfQKxaSCUES0KePUfr1IrqQTLzSzdjg=;
        b=N619TE0/TokhomJ2IVukNmBch5zFiClBtvgj1yJ9HFrlglNLaYOHFxCaaBFpLc9Tmc
         TAdlr39US87AoPLX9r6mluLbo2gYJ4xime4vHxh+7vnWs5Ji43bkf99G76u2irk7uqDp
         6MKe7rl1WshVIl7PaZVkNQuruMpUH7m34YY7VCpypPdLjIuh307e+Oewx9w1Fe/IMPqk
         8AZXbwU+crhmJPtwLwgpzqyPFuf3PBYE0NsBNSMVvjPK0hDlHUOoFvVuFrFoLROCzlD/
         M1PKwFe9xoBx1xZ9O4pJlW5Dos5Mgo7ChG+BWBJpk7yvzbfdasKAg347GsmC38BaeBma
         zDmw==
X-Gm-Message-State: AOAM530pVJ2sWDYs9hFzALoigu3opEmqRq4NkM9QEdWeP4DP2Ou+YWpD
        mcLuhX+Rz3/fwqU3eHoHkCa2LYyt2NKY/cmzlUo=
X-Google-Smtp-Source: ABdhPJwPNPasZLhpWFB4EK4osbAybCm5aRr9AI/R6FcfQpEg7ZFCP3LWUWjtuiPZ/Hu0vtLrY7wdfQ==
X-Received: by 2002:a17:902:b202:b0:151:4f64:e516 with SMTP id t2-20020a170902b20200b001514f64e516mr21785443plr.16.1646811430343;
        Tue, 08 Mar 2022 23:37:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z2-20020aa79902000000b004f75842c97csm1462418pff.209.2022.03.08.23.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:37:09 -0800 (PST)
Message-ID: <62285925.1c69fb81.5f7d1.3429@mx.google.com>
Date:   Tue, 08 Mar 2022 23:37:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.27-41-g5ad72e40dcac
Subject: stable-rc/linux-5.15.y baseline: 68 runs,
 1 regressions (v5.15.27-41-g5ad72e40dcac)
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

stable-rc/linux-5.15.y baseline: 68 runs, 1 regressions (v5.15.27-41-g5ad72=
e40dcac)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.27-41-g5ad72e40dcac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.27-41-g5ad72e40dcac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ad72e40dcac0cb04181911a748786e78a9d37ec =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228254a98f32b90e2c6297a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
7-41-g5ad72e40dcac/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
7-41-g5ad72e40dcac/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228254b98f32b90e2c629a0
        failing since 1 day (last pass: v5.15.26, first fail: v5.15.26-258-=
g7b9aacd770fa)

    2022-03-09T03:55:39.085205  <8>[   32.604578] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T03:55:40.111737  /lava-5843062/1/../bin/lava-test-case
    2022-03-09T03:55:40.122555  <8>[   33.643371] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
