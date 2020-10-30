Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41622A0940
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgJ3PIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgJ3PIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 11:08:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137BEC0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:08:07 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id x13so5446669pgp.7
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SN0/a8IvFEJOFUfXNTNy2J75RGeitGNuzVFGvjy+6nE=;
        b=YQSQKLDFws2bsWXPrIw/HmTpfxy4IhIQ5Ir3OeYRn/quxaVPtc5Zwhn7qzvJcpObCU
         do+8X1ojuArxsgxXWnYPoTqD03vN1xhrTde42XzXK2u7O8L+qwH+PJzOrNVo+cnitW5k
         GUEzwj2kYnh9Z88QvVQJYUq+LdDNLfMjT2wnA0iETw8xmEWBQXN881Crrc6TgdobEz8v
         5x+4Rj9Tvy4QEtIdto5jBTA/GlpLd6s0pYTr3DdmW83S6suMJ4tL/NZhMSwpCLJWRQG9
         r5DlTIAfEYW6qc2fpCxrK5zO+TqA98Hwh7ejlnlabw0hLUgNPMbQW7HAu9oTdLb7qjMY
         RYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SN0/a8IvFEJOFUfXNTNy2J75RGeitGNuzVFGvjy+6nE=;
        b=FWD5lfwCS/nC8I1yBYdrmzWC8kevl11+p1tqk63c6cF10sn9eM/ei0oBiuYYG+rCoV
         SuQS/CBAHhbmvPwX5OItKLWWPTlXyqNZ5trDfHYYt+InQKxV+bkBTjJjUX41EEBjT3qD
         HBQpDgcLBVInoqFr1e+Yz3XlC8Elgqx2mW9oZKFjuarW6F4w9/rxsShHq0ob7KqEO4NH
         pFMUeu0ZaKHA3tOzCo1ysVGjGIasd98sa71xQTyHbTQTc7UNFkx/rg89jpwx1t9u+QUi
         bP2y7EzDYQOtUn27U8B2Pe36KqEz78qvubSGZlj474OS/KJWn6WcxfUPWk+3PPpTFz4a
         2BOw==
X-Gm-Message-State: AOAM530P1sGawXH5tnfPpgPAeh8pbwRv4gQaNAqfsZ4FewlffJJA2C2b
        OInSo0aMsjldTi9efUAexS01UJttJm9TJA==
X-Google-Smtp-Source: ABdhPJyr39kouYdWgvriSohLBMYklUTRorWEBmvanFD2PD5jhivEigis1qObYDF/pz3TDm9ERNvjRg==
X-Received: by 2002:a17:90a:4897:: with SMTP id b23mr3346767pjh.12.1604070486230;
        Fri, 30 Oct 2020 08:08:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c140sm6234439pfb.124.2020.10.30.08.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 08:08:05 -0700 (PDT)
Message-ID: <5f9c2c55.1c69fb81.f165a.ec30@mx.google.com>
Date:   Fri, 30 Oct 2020 08:08:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-4-ga5b62fb44d07
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 123 runs,
 4 regressions (v4.4.241-4-ga5b62fb44d07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 123 runs, 4 regressions (v4.4.241-4-ga5b62fb4=
4d07)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
beagle-xm        | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2          =

qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-4-ga5b62fb44d07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-4-ga5b62fb44d07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5b62fb44d07b6e24748fcbc0bf4d657d9023c8a =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
beagle-xm        | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2          =


  Details:     https://kernelci.org/test/plan/id/5f9bfac1be2fa0dd6d381026

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-ga5b62fb44d07/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-ga5b62fb44d07/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9bfac1be2fa0dd=
6d38102b
        failing since 0 day (last pass: v4.4.241-2-g0b3b9f46127e, first fai=
l: v4.4.241-4-g71c7677aa3c2)
        1 lines

    2020-10-30 11:34:42.422000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-10-30 11:34:42.423000+00:00  (user:) is already connected
    2020-10-30 11:34:42.423000+00:00  (user:) is already connected
    2020-10-30 11:34:42.423000+00:00  (user:) is already connected
    2020-10-30 11:34:42.423000+00:00  (user:) is already connected
    2020-10-30 11:34:42.423000+00:00  (user:) is already connected
    2020-10-30 11:34:42.424000+00:00  (user:) is already connected
    2020-10-30 11:34:42.424000+00:00  (user:) is already connected
    2020-10-30 11:34:42.424000+00:00  (user:) is already connected
    2020-10-30 11:34:42.424000+00:00  (user:) is already connected =

    ... (495 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9bfac1be2fa0d=
d6d38102d
        failing since 0 day (last pass: v4.4.241-2-g0b3b9f46127e, first fai=
l: v4.4.241-4-g71c7677aa3c2)
        28 lines

    2020-10-30 11:36:28.470000+00:00  kern  :emerg : Stack: (0xcb979d10 to =
0xcb97a000)
    2020-10-30 11:36:28.480000+00:00  kern  :emerg : 9d00:                 =
                    bf02b8fc bf010b84 cb8f5010 bf02b988
    2020-10-30 11:36:28.487000+00:00  kern  :emerg : 9d20: cb8f5010 bf2010a=
8 00000002 cbc47010 cb8f5010 bf24bb54 cbc726f0 cbc726f0
    2020-10-30 11:36:28.495000+00:00  kern  :emerg : 9d40: 00000000 0000000=
0 ce228930 c01fb3d8 ce228930 ce228930 c0857e88 00000001
    2020-10-30 11:36:28.504000+00:00  kern  :emerg : 9d60: ce228930 cbc726f=
0 cbc727b0 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-10-30 11:36:28.512000+00:00  kern  :emerg : 9d80: ffffffed bf24fff=
4 fffffdfb 00000027 00000001 c00ce2f4 bf250188 c04070c8
    2020-10-30 11:36:28.520000+00:00  kern  :emerg : 9da0: c09612c0 c120da3=
0 bf24fff4 00000000 00000027 c040559c c09612c0 c09612f4
    2020-10-30 11:36:28.528000+00:00  kern  :emerg : 9dc0: bf24fff4 0000000=
0 00000000 c0405744 00000000 bf24fff4 c04056b8 c0403a68
    2020-10-30 11:36:28.536000+00:00  kern  :emerg : 9de0: ce0b08a4 ce22191=
0 bf24fff4 cbc2b540 c09dd3a8 c0404bb4 bf24eb6c c095e460
    2020-10-30 11:36:28.544000+00:00  kern  :emerg : 9e00: cbba5f40 bf24fff=
4 c095e460 cbba5f40 bf253000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9bfb4eeae361e0aa38101c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-ga5b62fb44d07/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-ga5b62fb44d07/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9bfb4eeae361e0aa381=
01d
        failing since 0 day (last pass: v4.4.240-112-g1a1bb4139b4c, first f=
ail: v4.4.241-2-g0b3b9f46127e) =

 =



platform         | arch   | lab          | compiler | defconfig           |=
 regressions
-----------------+--------+--------------+----------+---------------------+=
------------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9bfb66eae361e0aa381040

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-ga5b62fb44d07/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-4=
-ga5b62fb44d07/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9bfb66eae361e0aa381=
041
        new failure (last pass: v4.4.241-4-g71c7677aa3c2) =

 =20
