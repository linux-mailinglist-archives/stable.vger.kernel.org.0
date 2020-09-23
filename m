Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95BD27591B
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 15:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIWNtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 09:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgIWNtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 09:49:25 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3ADC0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 06:49:25 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id u24so3610039pgi.1
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 06:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9iWQjb0sL+7B2EO7c2tjMuP2TACl7A4j3+ln53zaGnU=;
        b=k75tZY3a/9fDg0hI844vFtfoOFBbS9n6SF5oG7YhAorCoksOOVplL+G5SAFfodhUiS
         kQFFwyA9fBWBBy3Y9YFc+4EvuDJqgPqD5/tPTCax2dZ90fyKGgPaXudJiOstS/ZSE5g9
         I9sKNVYfi5i4UyImh7MWbaDqQB3EpwE6sUMVjDn7H+ve+SEcSzScvFxpZ1Y4C0O3s/x1
         V1GsX/y1nFGyNcV3k3NCdezp9vL0SJ2+nl2H7pMeFKBU67QWz4xgJxw3M+cmLQG2XfDv
         rzdoK468wg2bF0ntO3ZrMcWFxXAIDACgKcSew7zsTaFcRrHS0qXg85Rpo7gR5lHbjZW5
         dd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9iWQjb0sL+7B2EO7c2tjMuP2TACl7A4j3+ln53zaGnU=;
        b=kBRlbMDhFVziXkXLcrSJvHLjWdcJlDCmNlTxATHbnQav0tPKrLLNGicDqgSMVIT7q8
         jqgqo4szHfg96Ro3hffph3eYTUr42JiIisOoo8KGswaeDbQFJStBcVWvtuUmCXCvzEv9
         1yOhs8aq9Fxc19oOE60JaVBeEYOONcqSBCxXNT3R3lBdA/rTCbTwDW2+Qe7+3DRdMY75
         F4hsJK0gpKGWan/Yx6LwwX3kT+GOgaZmpAf1E3JGPYO1jlyU0WyzYrXq1flcyo+wCy1j
         m/KjCoPDOJYnwCCqe4034PLYBb8+0dCCSRAhGlnCfuMneYR1GO5o49S2mjxp8nAmr7Yz
         wFKA==
X-Gm-Message-State: AOAM53066IU6XRw7q0AzSMUINzEHD6PvZ4DdYfo/xMU2ZkTio9hvCq1d
        HZGEvqXHstDIScJFFHALto40b18Q+yaSXQ==
X-Google-Smtp-Source: ABdhPJzlBqbpn5Dx6CTpdd4/9NKatT0QsQydl0EEo2TtcD3Kf4lwIGbufKubC42khUOkL44MnWAMIQ==
X-Received: by 2002:a63:e645:: with SMTP id p5mr7823828pgj.276.1600868964797;
        Wed, 23 Sep 2020 06:49:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c186sm54627pga.61.2020.09.23.06.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 06:49:24 -0700 (PDT)
Message-ID: <5f6b5264.1c69fb81.cfac6.01f5@mx.google.com>
Date:   Wed, 23 Sep 2020 06:49:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.65-202-g2a8ec405043c
Subject: stable-rc/queue/5.4 baseline: 167 runs,
 2 regressions (v5.4.65-202-g2a8ec405043c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 167 runs, 2 regressions (v5.4.65-202-g2a8ec40=
5043c)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.65-202-g2a8ec405043c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.65-202-g2a8ec405043c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a8ec405043c7813a0a0a4f53beee53b34b5b62e =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:     https://kernelci.org/test/plan/id/5f6b173b749056ceb1bf9db3

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.65-20=
2-g2a8ec405043c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.65-20=
2-g2a8ec405043c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f6b173b749056c=
eb1bf9db8
      new failure (last pass: v5.4.65-202-gaa76a9717c96)
      4 lines

    2020-09-23 09:36:48.034000  kern  :alert : pgd =3D e3896899
    2020-09-23 09:36:48.034000  kern  :alert : [be57f500] *pgd=3D00000000
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f6b173b7490=
56ceb1bf9db9
      new failure (last pass: v5.4.65-202-gaa76a9717c96)
      48 lines

    2020-09-23 09:36:48.077000  kern  :emerg : Process kworker/0:1H (pid: 5=
1, stack limit =3D 0xdb211a4e)
    2020-09-23 09:36:48.077000  kern  :emerg : Stack: (0xeade5e58 to 0xeade=
6000)
    2020-09-23 09:36:48.078000  kern  :emerg : 5e40:                       =
                                ead39800 c0d04248
    2020-09-23 09:36:48.079000  kern  :emerg : 5e60: eade5e84 ead8c000 ead0=
1600 00000000 eade5eb4 eade5e80 c03a017c c03abc3c
    2020-09-23 09:36:48.080000  kern  :emerg : 5e80: ffffffff eade5e84 eade=
5e84 fc39b756 c013b970 ead39800 00000001 eade5ebc
    2020-09-23 09:36:48.119000  kern  :emerg : 5ea0: c0d04248 ead8c000 eade=
5eec eade5eb8 c03a07dc c03a00f4 c013b9b8 eade5ebc
    2020-09-23 09:36:48.120000  kern  :emerg : 5ec0: eade5ebc fc39b756 eade=
5eec ead39800 c0d04248 c0d0c698 ef0d8400 00000000
    2020-09-23 09:36:48.121000  kern  :emerg : 5ee0: eade5f0c eade5ef0 c039=
a21c c03a06e4 00000001 fc39b756 ec5af400 ead3980c
    2020-09-23 09:36:48.122000  kern  :emerg : 5f00: eade5f1c eade5f10 c039=
a288 c039a158 eade5f54 eade5f20 c0135508 c039a26c
    2020-09-23 09:36:48.123000  kern  :emerg : 5f20: c0135fe4 c013b118 eade=
5f54 ec5af400 ec5af414 c0d0c698 c0d13660 c0d0c23c
    ... (37 line(s) more)
      =20
