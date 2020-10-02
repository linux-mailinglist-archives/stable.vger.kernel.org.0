Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D42F280C8C
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 05:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgJBDu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 23:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBDu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 23:50:59 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0B0C0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 20:50:59 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b17so65652pji.1
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 20:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yuQaiHWZMQ2EiRZWZQ8urXU93P+8mPbDArJs6vaedaQ=;
        b=yfws7Q3ugfd0YdVQ+wE9HkY+KS00g41SzspqXuk97u1WtrFpkLK/Zto4hQjaxarp++
         /g+UZlJTahDi7cRWssEJwjusByXINq9MJNgY4EcvAoOyZ6C6sKIGcxr1vXthCNBjwRrt
         QA5rrJAPZinMKK5uH6ymDqt69J8Ztsox+o7solmLC6OHEfeTZwnGAN/VvxQFqCaf4lAp
         PpDxiRgNazSzBJ/SpspHvUHK+OQiQZNnYG0DrsmgeFbhweSDAMXJHjTsIcTGFVQeDB8B
         q4MxFqu6ajB57aLVO4o9jYf/ptLAtzqHmztn43Zq5w8hNdlugQyL8946gTU/kYAlIqGP
         w5pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yuQaiHWZMQ2EiRZWZQ8urXU93P+8mPbDArJs6vaedaQ=;
        b=F8hQKbfdP80mZYBd69exhaYguNlnrd3TXnncm9ORIWZMNpvYBkfoTJACshtfE3cv/0
         ES8n+I+mfWCMw+aqO0/uA2DjKJgmFu+SdwH7zdD1fnAuH3f1jm/jKle2YIV+Mr8Mx8cC
         fuvnsLIzZ3ZWoab5169dhV8cR8DPqOKPtsGfXK5nCdFx9oPayPFiEy2OTY8KDElidusG
         A7OKzAuNLPTBJI5dijaC1zXVz99J8yNzbKrJqmHZnFvt+8gpHXj6+MurNE3krcffpnrK
         dcYiFnoe+3p++TEEIBh0bvx+z9H+5PmiM1Ya5n5zILnLYvVLx39ZcPeaMZDbJnDQ4/zY
         Ayjg==
X-Gm-Message-State: AOAM53011NHlxSkH3C4odwu9P5CzHjMdvT1M+a0iB4Rj08xGVO5QH7j4
        zcRthxutbGTuPjdi6RGcwLrpIfAT7fHglA==
X-Google-Smtp-Source: ABdhPJyz0J74D6/JcsQG00o64dhXdTccJiCs6NzL6oLfliCagc68O/XibCR4L6pwlZ3ERrGvjjsf6g==
X-Received: by 2002:a17:90a:f407:: with SMTP id ch7mr591229pjb.142.1601610658545;
        Thu, 01 Oct 2020 20:50:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f19sm103833pfj.25.2020.10.01.20.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 20:50:57 -0700 (PDT)
Message-ID: <5f76a3a1.1c69fb81.522a0.04f0@mx.google.com>
Date:   Thu, 01 Oct 2020 20:50:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 100 runs, 2 regressions (v4.4.238)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 100 runs, 2 regressions (v4.4.238)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.238/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.238
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18f617d6f398c264e3172532a5d3c656f17cecfa =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f7671523875673386877169

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f76715238756733=
8687716d
      new failure (last pass: v4.4.237)
      1 lines

    2020-10-02 00:14:27.445000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-02 00:14:27.445000  (user:khilman) is already connected
    2020-10-02 00:14:27.445000  (user:) is already connected
    2020-10-02 00:14:39.327000  =00
    2020-10-02 00:14:39.334000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-10-02 00:14:39.338000  Trying to boot from MMC1
    2020-10-02 00:14:39.527000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-10-02 00:14:39.768000  =

    2020-10-02 00:14:39.768000  =

    2020-10-02 00:14:39.775000  U-Boot 2018.09-rc2-00001-ge6aa9785acb2 (Aug=
 15 2018 - 09:41:52 -0700)
    ... (447 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7671523875=
67338687716f
      new failure (last pass: v4.4.237)
      28 lines

    2020-10-02 00:16:13.505000  kern  :emerg : Stack: (0xcb97dd10 to 0xcb97=
e000)
    2020-10-02 00:16:13.513000  kern  :emerg : dd00:                       =
              bf0388fc bf01db84 cb939210 bf038988
    2020-10-02 00:16:13.521000  kern  :emerg : dd20: cb939210 bf2430a8 0000=
0002 cbc48010 cb939210 bf28ab54 cbcbc270 cbcbc270
    2020-10-02 00:16:13.530000  kern  :emerg : dd40: 00000000 00000000 ce22=
8930 c01fb3f0 ce228930 ce228930 c0859648 00000001
    2020-10-02 00:16:13.538000  kern  :emerg : dd60: ce228930 cbcbc270 cbcb=
c330 00000000 ce228930 c0859648 00000001 c09632c0
    2020-10-02 00:16:13.546000  kern  :emerg : dd80: ffffffed bf28eff4 ffff=
fdfb 00000025 00000001 c00ce2e4 bf28f188 c0407090
    2020-10-02 00:16:13.554000  kern  :emerg : dda0: c09632c0 c120ea30 bf28=
eff4 00000000 00000025 c0405564 c09632c0 c09632f4
    2020-10-02 00:16:13.563000  kern  :emerg : ddc0: bf28eff4 00000000 0000=
0000 c040570c 00000000 bf28eff4 c0405680 c0403a30
    2020-10-02 00:16:13.571000  kern  :emerg : dde0: ce0b08a4 ce221910 bf28=
eff4 cbce4b40 c09ddba8 c0404b7c bf28db6c c0960460
    2020-10-02 00:16:13.579000  kern  :emerg : de00: cbcc3900 bf28eff4 c096=
0460 cbcc3900 bf292000 c0406144 c0960460 c0960460
    ... (16 line(s) more)
      =20
