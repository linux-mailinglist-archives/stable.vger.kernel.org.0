Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14515452A04
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 06:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhKPFvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 00:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhKPFuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 00:50:35 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467D7C07AF5E
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 20:08:34 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y8so10796076plg.1
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 20:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qkDSKsv6BSvOJkFy/5yEDruP87D9RVKIF/b2aFob3XA=;
        b=4Cq+TE53iDrKtKBd7Pjdt09m6oPjcda0+ywYU80wAoGTsX3n4IQ39Z3snMdjW8itq+
         HJ8h36rQJWw7u0Ee/CN65aIhwpGrAY7JIr+llnbgpzzAsihbALFVVR/BnpGjE7esBySG
         4JeCXLu/pXGR/T67s7M5Yrv/GU82DmECpfMqKiGncUrivOfOWB4QtU1ES/jV0kbUzJMS
         LNkifydUFXsDDb8Qa3yieDtqCpfXA4tHl+qUmT7LgFCofRZrsnGGpqISOqxFeIF+RTkl
         TpmQ5e8+t+WNGvP9RXfV9A5kDwjY44srKQQXfgaWQ64W94npZieNkFZ7gxGugjV/lnWj
         AW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qkDSKsv6BSvOJkFy/5yEDruP87D9RVKIF/b2aFob3XA=;
        b=zUa+D0XDnem2tqbST9wvr9Dy2TvUBsZ/3D8Gq/VRw04g/hNEYDb1j1rnOSi7t4fBD7
         8J4izwkSF3QO6vcJ508G+0rg3sNWcHwIr9WrqjnrM0qM+GT69Lc93QWnZ88F1o3EZymB
         D5/m8tntZqSqeYPjwyOHChlnDoO+hLxgXjFhhnEI/X1cLeU2V1vEPstxU09jETZQNEAB
         lHxAPM1MV+xTnru2tpNFVqIje/+lpV2GTD/X2ds6BjKJ6Hh+/kh5dPalhwO2uUrpSeof
         Q99M4R6X11Mog5xcYVzEUH8UCb17gkynOhKXOpnVWk9R7YxbraMpoE7D1uO1G/KLcB5b
         79Ag==
X-Gm-Message-State: AOAM530ZF3ZmkcLj1yF7+mGFaZTH9Ipta50RDumEUVPah21R+33AGVfV
        1ZdW1VW0+lNrpCmKLuKc8cBuibVXamD6MaQB
X-Google-Smtp-Source: ABdhPJyFmNdj4cfhwZWl6VuCwRYzJCje+BbqDsbfFvOzgaLCdTLK85bEhz804cR8DmbRXSbox+KDmA==
X-Received: by 2002:a17:90b:3144:: with SMTP id ip4mr73258607pjb.153.1637035713637;
        Mon, 15 Nov 2021 20:08:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10sm863904pjd.0.2021.11.15.20.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 20:08:33 -0800 (PST)
Message-ID: <61932ec1.1c69fb81.ffa3f.4243@mx.google.com>
Date:   Mon, 15 Nov 2021 20:08:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-253-g58c021f04873
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 134 runs,
 2 regressions (v4.19.217-253-g58c021f04873)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 134 runs, 2 regressions (v4.19.217-253-g58=
c021f04873)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217-253-g58c021f04873/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217-253-g58c021f04873
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      58c021f04873993621346aa9a6b57e87cde83668 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:     https://kernelci.org/test/plan/id/6192f442a851541286335909

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-253-g58c021f04873/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline=
-da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17-253-g58c021f04873/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline=
-da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6192f442a851541=
28633590d
        new failure (last pass: v4.19.217-70-g46d7612c5aae)
        3 lines

    2021-11-15T23:58:43.895287  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2021-11-15T23:58:43.895529  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2021-11-15T23:58:43.895671  kern  :alert : page dumped because: nonzero=
 mapcount
    2021-11-15T23:58:43.954031  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6192f442a851541=
28633590e
        new failure (last pass: v4.19.217-70-g46d7612c5aae)
        2 lines

    2021-11-15T23:58:44.090930  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2021-11-15T23:58:44.091198  kern  :emerg : flags: 0x0()
    2021-11-15T23:58:44.167010  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-11-15T23:58:44.167287  + set +x
    2021-11-15T23:58:44.167427  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1081334_1.5.=
2.4.1>   =

 =20
