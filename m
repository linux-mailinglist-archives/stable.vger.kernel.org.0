Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3994E340C
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiCUXQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiCUXQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:16:09 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600DD4424A8
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:04:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mz9-20020a17090b378900b001c657559290so772147pjb.2
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=A7zSjgmCI3ksSoFnWFlgQkPxHy72pHTPEKNR7dDxiak=;
        b=nNMOnZZ/gBnOjLUGo6OHXYX8fZM3o1O1z1JdguQQWXaH9+HZY2Km0k2pHS2n/85qp9
         retac1xmwg0f/tNfYPmoUPI4pSNO9H4hWWD3IZtl/vHwiu2RSSVgM8zKNc63fsU8p5sp
         kcjtInrAoFKB8hIcGoP2B+9lSN83UQhudtwo5WWPAiy1oz9G6kdyMLKd7WAQxoa9/1Ly
         KKFzM3BXnmRAdx7HiAskItDDtN9lonXMRoL86QSps0lMBAA99yKejk5Z/SBQ0YwdgoMI
         aCbuENRq6JFuU39/h/aVuoAooNFbPt4RJTV6vMxvEnMbtT8b4zOYyMu8UdRYGI4N7oUI
         o0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=A7zSjgmCI3ksSoFnWFlgQkPxHy72pHTPEKNR7dDxiak=;
        b=64is+aMFZ1xhWRotSWXUxEBPvA7H2RP1T0gnlP8yHk7M5aj43i3gnCGnj3MaJ6qJOG
         gE8RSxdoUqdrxWQTvffzvBiRIWtTl9rs38TRLDsiESC24zBYrDCXcH46Tdi0SKDHl4T2
         itZgm2XlFfU8GoSpXtMwZPxu7M7CqZ8RasGHHSo8Odrkg6BSZwuWZ/jER0Ha1QbecpDx
         bg99YIQZILDRdnUGiRxHMFlL/j99OVaTm8TQK6fFqNiUhNraIL+p5q/34k74JDpm23xM
         Gmkm6qG+TlhPH6MiUSgPVDL7RuNkvAS3p9uhkdgTLWgbS/nxfJjcnbRRKdZFyWG8PjN+
         xYBw==
X-Gm-Message-State: AOAM532kXkXFQNw1ZsFFsAB4iTOrU65vw1vnXMRoivjbtrZGkklJtAt4
        CLnaqOGrdguHWR8eqfK8IHgWGn/TZaHy2MqCG98=
X-Google-Smtp-Source: ABdhPJwTVpsFsihCbNSY40t2pOjGY9QUAnmI/DykD+npjLP6E8greqdrTtTIvAaRhMON97p1dLG38g==
X-Received: by 2002:a17:902:d4c8:b0:154:2416:218b with SMTP id o8-20020a170902d4c800b001542416218bmr15270740plg.139.1647903291958;
        Mon, 21 Mar 2022 15:54:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm22091959pfl.44.2022.03.21.15.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:54:51 -0700 (PDT)
Message-ID: <6239023b.1c69fb81.739c9.b4b8@mx.google.com>
Date:   Mon, 21 Mar 2022 15:54:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.272-23-g7d28b4c6f4588
Subject: stable-rc/linux-4.14.y baseline: 63 runs,
 1 regressions (v4.14.272-23-g7d28b4c6f4588)
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

stable-rc/linux-4.14.y baseline: 63 runs, 1 regressions (v4.14.272-23-g7d28=
b4c6f4588)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.272-23-g7d28b4c6f4588/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.272-23-g7d28b4c6f4588
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d28b4c6f4588cfdd8cd0d45f9183570fae70ffb =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6238cc2cf40dc82eef2172c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
72-23-g7d28b4c6f4588/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-me=
son8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
72-23-g7d28b4c6f4588/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-me=
son8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238cc2cf40dc82eef217=
2c6
        failing since 35 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
