Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7A5603A4A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 09:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJSHGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 03:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJSHF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 03:05:59 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B506474DE1
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:05:58 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 3so16397362pfw.4
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 00:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dAQTJjmAd9SRRPdvTi+90+FeDAqPSBr4/pn/0qeUcmQ=;
        b=18N99/APfcWbANhUPNhjv7A3ORQBUvDSLu6lpCujiBvgZaqQirPV2WXSsePuNcB8fl
         M17xb34otR/X4Y05hR+j6kD2MlAqAJM5Rk+toHhsv4og2aBWuKo56Z6603UAEd0hhVxy
         68lfReW6HNqwFozQDLrkMnvsGlFDv+VMTlr5qOCZp0gcVmODdT0pzVFXeL3U70hAD4EJ
         1eGizc6Y8/gF74P4HR3v99H7ala8ZfGMsC2DY5RLp3NAXCLuITzFyBHMMVHs/ATefTMt
         Xe0A08lvTUlwDuD0FDs6KRRD6H17dyYbQJuYufsImR/QzPPnoTJPYMWjD+UnE/+90NrW
         nfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dAQTJjmAd9SRRPdvTi+90+FeDAqPSBr4/pn/0qeUcmQ=;
        b=5kH5JBnvBa1riwoeMPOI8YFuhnEWCGl25K4lPqy2sb98VKzjLhU3gp46Rwqi0PVtBv
         DH3aCsAJSsmwHt8bjj/4JinLo0CaB61DHWi61MW1rRjCtQslZd0OIlf3s+gUCBGpmvyd
         bcmq+rUczJHT8ws0s89UA+gxgPQto2cSg66aEcdp+o4EPWbkho3HlY+URrUIXpCuEhj1
         /PNw3lA6s02cNoUc19dhXAh9eYP3Ut/Qnmp82OuCanaUosz3BCzABmC6IyATVnTDi0dL
         ReniiYKKOv76JepdELCj/hi0maOm+21Lga7FLpJmLbDP0b8ApJVXTKUlyEB0p4/QqnHN
         nX3w==
X-Gm-Message-State: ACrzQf1v/7XEuPX6dPY9aF8Iu8P214nCZ193QqaNSGJb3gU5QmTcic8+
        /htdGi0JEc1Zew6RHM6m66IZnU9lEW0daKCI
X-Google-Smtp-Source: AMsMyM4pA5oVQFVV2QD8/IZ6jTmnBfQ28frLMheLHW1/8NmwFml68UZlhI9Jmt3d0/olDx2lHddbEg==
X-Received: by 2002:a63:5a61:0:b0:41b:b021:f916 with SMTP id k33-20020a635a61000000b0041bb021f916mr5906568pgm.387.1666163157985;
        Wed, 19 Oct 2022 00:05:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1-20020a620601000000b005626a1c77c8sm10444068pfg.80.2022.10.19.00.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 00:05:57 -0700 (PDT)
Message-ID: <634fa1d5.620a0220.f7744.3820@mx.google.com>
Date:   Wed, 19 Oct 2022 00:05:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.16-802-ga330f8d5a97cd
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.19
Subject: stable-rc/queue/5.19 baseline: 89 runs,
 1 regressions (v5.19.16-802-ga330f8d5a97cd)
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

stable-rc/queue/5.19 baseline: 89 runs, 1 regressions (v5.19.16-802-ga330f8=
d5a97cd)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.16-802-ga330f8d5a97cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.16-802-ga330f8d5a97cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a330f8d5a97cdfddf8bfd301c0730afdc0ffa75f =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/634f19ed7eeb0718965cf33a

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.16-=
802-ga330f8d5a97cd/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.16-=
802-ga330f8d5a97cd/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/634f19ed7eeb071=
8965cf342
        new failure (last pass: v5.19.16-838-g83e6994f1f57)
        1 lines

    2022-10-18T21:25:50.759350  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 17402018, epc =3D=3D 802006d8, ra =3D=
=3D 802033b0
    2022-10-18T21:25:50.791830  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
