Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A138A3DBFC6
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 22:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhG3UZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 16:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbhG3UZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 16:25:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CFCC0613CF
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 13:25:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nh14so5120305pjb.2
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 13:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vry7rYnUiHvjtjNxv7wAaEvFudLRFDP4cjdqW0w6CSc=;
        b=N74r18CbM8NkSP68Bmdll3vnFs7D+uertjQ8aSbgXJa6gHYnJGLdshUb71P+vEqG3Z
         TLDjBumiF6glJ1MgHMsTDuGemx/mtYOuDol71azzZcHsIAaW8izheoAxieLj27rIaG1Y
         egECCdOMfP6qJs7EF2qlailBXPj1OaI/oLqoycgoKxRSmBKT6UM+HtRVCTjKR2zE3rTF
         cGEOjpzWQrvh3sEC/fHLfSPpRkac5PA10HDkSX4Gdm/aXy3uTb7LgRoumPFQ1z5lwEvb
         CIxSeitIcMOto5YUq7Lh/ltBcwzQOAGjXGza2Wum3QX7xaIwo4aeSiiYRcvGafT8m8aI
         sHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vry7rYnUiHvjtjNxv7wAaEvFudLRFDP4cjdqW0w6CSc=;
        b=WjaUZ7seqDarUxrXOFJpGDR9cqbfDPT1b532Qm7OJ2n9qhCEOJ0JDivdI7yydJGEva
         MjR2BitqezxS3VZFE1jITAB2LlFVjn9DTTciMA5TFKufu6C2VzfcAtUJqMN2CTqp56OB
         pePd5zE3vpLM5OznU1W57DnBx6QxfplHt3tCQPX/l6qYXQKkbLtp9w1yjiJ1dA+yz79y
         TvdTdxQ6n381FW9z1X4VRnveKTF/yE8zNJ7GDcjZrOo0JtboKFEVK9qfGejEgfTwADzH
         1/9SyNf9Cafm/IVRIFu3sapHDHDjktBfpgL8kRr/Via8dJRza1Rb+zHTTcEIDCCnBetg
         S8rA==
X-Gm-Message-State: AOAM5330Nd+liHoB4nA0QiUjXaUNZBC3Zfzf6eSl01P/N3Nx7I3fMJJC
        jskqInu71TpjM9DzmPY6/aaguvjmn5SD31pT
X-Google-Smtp-Source: ABdhPJxyf+po+fH8kguOnj+DODWNVi71iiC6APRf3nRwgoLKWN5r5+2UOjgmzYHY7Ts+9Ue0ECT32g==
X-Received: by 2002:aa7:8298:0:b029:338:340:a085 with SMTP id s24-20020aa782980000b02903380340a085mr4506264pfm.46.1627676714444;
        Fri, 30 Jul 2021 13:25:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f3sm3241178pfe.123.2021.07.30.13.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 13:25:14 -0700 (PDT)
Message-ID: <6104602a.1c69fb81.34fbb.9113@mx.google.com>
Date:   Fri, 30 Jul 2021 13:25:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.54-1-g413d16971b6e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 3 regressions (v5.10.54-1-g413d16971b6e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 171 runs, 3 regressions (v5.10.54-1-g413d169=
71b6e)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig |=
 2          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig         |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.54-1-g413d16971b6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.54-1-g413d16971b6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      413d16971b6efe8d9f0653d9651f6e4ca590ebc4 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig |=
 2          =


  Details:     https://kernelci.org/test/plan/id/6104283581cd88365185f45e

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g413d16971b6e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g413d16971b6e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6104283581cd883=
65185f465
        failing since 0 day (last pass: v5.10.54-2-geb01b613f84f, first fai=
l: v5.10.54-24-gcf47f1842d05)
        4 lines

    2021-07-30T16:26:16.116075  kern  :alert : 8<--- cut here ---
    2021-07-30T16:26:16.152157  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 54555551
    2021-07-30T16:26:16.153473  ke<8>[   42.826131] <LAVA_SIGNAL_TESTCASE T=
EST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6104283581cd883=
65185f466
        failing since 0 day (last pass: v5.10.54-2-geb01b613f84f, first fai=
l: v5.10.54-24-gcf47f1842d05)
        105 lines

    2021-07-30T16:26:16.157127  rn  :alert : pgd =3D 0fd80534
    2021-07-30T16:26:16.157848  kern  :alert : [54555551] *pgd=3D00000000
    2021-07-30T16:26:16.202274  kern  :emerg : Internal error: Oops: 5 [#1]=
 ARM
    2021-07-30T16:26:16.203883  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xe8d25c06)
    2021-07-30T16:26:16.204698  kern  :emerg : Stack: (0xc424da40 to 0xc424=
e000)
    2021-07-30T16:26:16.205724  kern  :emerg : da40: c0e04248 c424da9c c051=
31a0 00000000 00000001 00000000 c424da94 c424da68
    2021-07-30T16:26:16.206870  kern  :emerg : da60: c0510940 c0428040 c421=
8610 c1415f5c 00000000 94d5ac84 c4218610 c0f25d40
    2021-07-30T16:26:16.207583  kern  :emerg : da80: c0e04248 c4218654 c424=
dacc c424da98 c0512dd0 c05108e8 c424daec c4218610
    2021-07-30T16:26:16.245937  kern  :emerg : daa0: 00000001 94d5ac84 0000=
0cc0 c4218610 c0f25d40 c4218610 c0e04248 c157a610
    2021-07-30T16:26:16.247540  kern  :emerg : dac0: c424dadc c424dad0 c051=
32b0 c0512d08 c424dafc c424dae0 c0511884 c05132a0 =

    ... (84 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6104318da5367b5a2785f525

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g413d16971b6e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.54-=
1-g413d16971b6e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104318da5367b5a2785f=
526
        failing since 29 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =20
