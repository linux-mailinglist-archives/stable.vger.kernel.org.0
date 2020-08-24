Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE5024FF12
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 15:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgHXNkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 09:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgHXNiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 09:38:54 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746DAC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 06:38:53 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id v15so4570483pgh.6
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 06:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RLkxG7Ud8WyUkdgGs9Yj8WUesnAHETsz0+D/Q47gRWE=;
        b=ZQtFRN+HLKmHOpYfF5UouQT1HrkQR+6mPmPiJbqzA5O2k8mXCs3KJQglaUieR/npi3
         z9w8Y2Ghi7frHE8KL1ilOkOcWQVpX1ZtHeAkUW9vY4I73AteTmQAP48NaZxsReCt5z29
         wpN8fXuE1WX7nP25J7upXSm0+27Cd0+VSUZ+OLqY9rdPNdK+TdGgNLhcPc2l1bosW5Zv
         KeWg8enpnWuI1BbCy2ZCiTXtB8Fne/Ll1/TemPM9V+URFSdWB8/ZfucoAlEyfOmAFVBD
         w+SeOF4km6fbPS4sXAfGcthlYQEDWljaR0LWrwKku20oQB+RTdBSCt/7dveQ6ejmTbXo
         X0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RLkxG7Ud8WyUkdgGs9Yj8WUesnAHETsz0+D/Q47gRWE=;
        b=qoeffBmGlcxTXWrdUlMhNXZYWuA1BxwmbK7wSOGv0Id5mlLm3Q+WBedLjL7vgnYQEr
         RE68QggA8+0GeolCQbk9QowHXOpUYs0Q9adofWY7Oobv9BdF+8E672zm90U+AyPjlwUb
         5OSN1sytvE6UuIKutggkeoWnpgNv0qph0EyumCcwnoDAcn/AOkS+E74mXHhuyUPysKcj
         XyfQTkRjrya4732R+7HPloiVWdNoyWV+/JG9mz3Vhv32sV6TjK/gOYI8Srn1oLQKos3d
         KlnO35f7r/Uwmdv0LqmPAhqG1tz0Z292z2lfaiddopl9BMjzBjOUjwOThFwktuq603Xm
         cfqQ==
X-Gm-Message-State: AOAM532VpKes4EMQjh3khvFoA9AEpaE6FOKEkZh0hz2nAs8CnE4+VFIu
        OLVqnUvgNbdt/msCLmMj5yV80/Q8YtspCQ==
X-Google-Smtp-Source: ABdhPJxQ1QJFGpB5W3uDWI6ZrfL3okdY3XtgoBjWR2toakf6OGJbA35TisQ2qKdM9OnedGg6cS+/lg==
X-Received: by 2002:a63:4921:: with SMTP id w33mr3183705pga.199.1598276331906;
        Mon, 24 Aug 2020 06:38:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v128sm11446234pfc.14.2020.08.24.06.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 06:38:51 -0700 (PDT)
Message-ID: <5f43c2eb.1c69fb81.4381e.2174@mx.google.com>
Date:   Mon, 24 Aug 2020 06:38:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.60-108-g302fb8173830
Subject: stable-rc/linux-5.4.y baseline: 158 runs,
 3 regressions (v5.4.60-108-g302fb8173830)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 158 runs, 3 regressions (v5.4.60-108-g302fb=
8173830)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
| results
----------------------+------+--------------+----------+-------------------=
+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
| 0/1    =

bcm2837-rpi-3-b       | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 2/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.60-108-g302fb8173830/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.60-108-g302fb8173830
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      302fb8173830c9e1542d947f2d3250df1583efc6 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
| results
----------------------+------+--------------+----------+-------------------=
+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f43c1a5b776b2c89b9fb434

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60-=
108-g302fb8173830/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60-=
108-g302fb8173830/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f43c1a5b776b2c89b9fb=
435
      failing since 134 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch | lab          | compiler | defconfig         =
| results
----------------------+------+--------------+----------+-------------------=
+--------
bcm2837-rpi-3-b       | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f438eb38adcbfa8d39fb43d

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60-=
108-g302fb8173830/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.60-=
108-g302fb8173830/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f438eb38adcbfa=
8d39fb442
      new failure (last pass: v5.4.60-39-g6ba0cb3c0b4a)
      4 lines

    2020-08-24 09:55:51.993000  kern  :alert : pgd =3D 712e727a
    2020-08-24 09:55:51.994000  kern  :alert : [0000001c] *pgd=3D2ae7a835, =
*pte=3D00000000, *ppte=3D00000000
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f438eb38adc=
bfa8d39fb443
      new failure (last pass: v5.4.60-39-g6ba0cb3c0b4a)
      49 lines

    2020-08-24 09:55:51.997000  kern  :emerg : Process udevd (pid: 89, stac=
k limit =3D 0x67aa4a31)
    2020-08-24 09:55:51.998000  kern  :emerg : Stack: (0xeae63a60 to 0xeae6=
4000)
    2020-08-24 09:55:52.035000  kern  :emerg : 3a60: 00000001 c0d586fc c0d0=
e880 c057d1c4 eae6a000 eae52a30 c0d0e400 00000000
    2020-08-24 09:55:52.036000  kern  :emerg : 3a80: 00000000 00000001 eae6=
3ac4 eae63a98 c0148bcc c0147abc 00000000 eae52a30
    2020-08-24 09:55:52.037000  kern  :emerg : 3aa0: eae6a000 c0d0e400 0000=
0000 00000009 00000001 c014dd88 eae63aec eae63ac8
    2020-08-24 09:55:52.038000  kern  :emerg : 3ac0: c0148dd8 c0148b64 eae5=
2a00 00000009 c0d0e400 00000000 80000093 00000001
    2020-08-24 09:55:52.039000  kern  :emerg : 3ae0: eae63b0c eae63af0 c014=
2500 c0148d48 eae52a00 eae52a00 c0d04248 00000000
    2020-08-24 09:55:52.079000  kern  :emerg : 3b00: eae63b24 eae63b10 c014=
28f0 c01424d0 00000001 eae52a00 eae63b5c eae63b28
    2020-08-24 09:55:52.080000  kern  :emerg : 3b20: c0142b98 c01428b0 eae6=
3b64 eae63b38 c043a208 02813c19 eaeb3f50 ead56a00
    2020-08-24 09:55:52.081000  kern  :emerg : 3b40: 00000001 ead56a0c 0000=
0000 00000001 eae63b6c eae63b60 c0142cc8 c0142ab0
    ... (38 line(s) more)
      =20
