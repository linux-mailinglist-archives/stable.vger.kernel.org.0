Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA032A6D75
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 20:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgKDTE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 14:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727098AbgKDTE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 14:04:57 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1F5C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 11:04:56 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g12so17362973pgm.8
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 11:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t93A+33lKlojbfcg3HbtGIjDpMO53sYhPRD37wTH3oM=;
        b=hMcj2EPH16VJbY5GaIeyvp+hRp8E3ITeIButF/ebP1QnE+U1g8N62dzKMUrKXjarDH
         8xahJ7WGrv0CNmzwJHZKiptNnnMd8WsWp33QjNOQjjGqluf2Cvo7Kj1LoQWiq01rLYyn
         z4m+TWEUwbdukWwFV0zYR1HJi/8+AvyHLGe/Mhrjx2EIdE7HN6Vrq/YCzB1QEQ3hJY2s
         shr6o2illWbokdS2EqtfknTbbKwHElR0GyrUv8W0tw9bK7UWQ+EpZqU8mVC7eVQXyDAV
         iIbu82LmDOWRDr6XnPXih/k5AQlcN2aXP7JLd2HzWrzyCNMDKPtX/qyPf+053NN2gV6P
         KFbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t93A+33lKlojbfcg3HbtGIjDpMO53sYhPRD37wTH3oM=;
        b=Yn0Ypj1x+E03ySb6+JMfifO5QqYywdPGyhA7RcViZXoDyaJN5cedl4rJw59YDTDz3I
         AHhhFhhgwvSpnBtnYxBjfenpihbPWuUi5jJPcxocC+QE3FtuhIqt4d1kFDJ7yMDa2OFU
         GtDYbmA1579AKSi012WhoyrLZRvo0k9ELVcnv0OAjMqEoBsZ9TNgvLTV36GxmQ8wob4T
         X/BkxochVvUsFXHdHEY2Nri6qJsNV3stQpiucdUW0qm6C9C8ejXJw/8oNSIxhoiNmYll
         siXIaZVGqAXn5xcF/EXofnkJMz4Vkgd2jcD2mm3aSGaGhCn8MRxTSP+iCwsq6K0yzbDA
         ac2Q==
X-Gm-Message-State: AOAM532Mc1G7fSt01Mik24fmGnmpAiPZQLL09qeuBbtbf50VXS5nF7MI
        NXAID0lsrSxJvoj6fHG/YveG53H0Yv5Y0A==
X-Google-Smtp-Source: ABdhPJynrzY71FEotOJjekXhmFBpSunN9bQmfaQBBO5dZOiaE+HpRw9cBkaslaHRQR+GOVVJmREZMA==
X-Received: by 2002:a62:7883:0:b029:18a:e054:edf1 with SMTP id t125-20020a6278830000b029018ae054edf1mr16496702pfc.70.1604516695837;
        Wed, 04 Nov 2020 11:04:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m3sm3361517pfd.217.2020.11.04.11.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 11:04:54 -0800 (PST)
Message-ID: <5fa2fb56.1c69fb81.f0d24.7e58@mx.google.com>
Date:   Wed, 04 Nov 2020 11:04:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.241-63-gee073a715a86
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 132 runs,
 2 regressions (v4.4.241-63-gee073a715a86)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 132 runs, 2 regressions (v4.4.241-63-gee073a7=
15a86)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.241-63-gee073a715a86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.241-63-gee073a715a86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee073a715a864e7a4a59417641dad0e672f83782 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa2cb37d608d1379bfb5317

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
3-gee073a715a86/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.241-6=
3-gee073a715a86/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa2cb37d608d137=
9bfb531c
        failing since 0 day (last pass: v4.4.241-66-gcf149e8ad82e, first fa=
il: v4.4.241-65-gef20a15d5af1)
        1 lines

    2020-11-04 15:37:39.826000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-04 15:37:39.827000+00:00  (user:) is already connected
    2020-11-04 15:37:39.827000+00:00  (user:khilman) is already connected
    2020-11-04 15:37:39.827000+00:00  (user:) is already connected
    2020-11-04 15:37:51.544000+00:00  =00
    2020-11-04 15:37:51.550000+00:00  U-Boot SPL 2018.09-rc2-00001-ge6aa978=
5acb2 (Aug 15 2018 - 09:41:52 -0700)
    2020-11-04 15:37:51.554000+00:00  Trying to boot from MMC1
    2020-11-04 15:37:51.744000+00:00  spl_load_image_fat_os: error reading =
image args, err - -2
    2020-11-04 15:37:51.984000+00:00  =

    2020-11-04 15:37:51.985000+00:00   =

    ... (447 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa2cb37d608d13=
79bfb531e
        failing since 0 day (last pass: v4.4.241-66-gcf149e8ad82e, first fa=
il: v4.4.241-65-gef20a15d5af1)
        28 lines

    2020-11-04 15:39:30.391000+00:00  kern  :emerg : Stack: (0xcb993d10 to =
0xcb994000)
    2020-11-04 15:39:30.399000+00:00  kern  :emerg : 3d00:                 =
                    bf02b8fc bf010b84 cb8dde10 bf02b988
    2020-11-04 15:39:30.407000+00:00  kern  :emerg : 3d20: cb8dde10 bf1fc0a=
8 00000002 ce33a010 cb8dde10 bf24bb54 cbca76f0 cbca76f0
    2020-11-04 15:39:30.415000+00:00  kern  :emerg : 3d40: 00000000 0000000=
0 ce226930 c01fb3a0 ce226930 ce226930 c0857e88 00000001
    2020-11-04 15:39:30.423000+00:00  kern  :emerg : 3d60: ce226930 cbca76f=
0 cbca77b0 00000000 ce226930 c0857e88 00000001 c09612c0
    2020-11-04 15:39:30.431000+00:00  kern  :emerg : 3d80: ffffffed bf24fff=
4 fffffdfb 00000027 00000001 c00ce2f4 bf250188 c0407034
    2020-11-04 15:39:30.440000+00:00  kern  :emerg : 3da0: c09612c0 c120da3=
0 bf24fff4 00000000 00000027 c0405508 c09612c0 c09612f4
    2020-11-04 15:39:30.448000+00:00  kern  :emerg : 3dc0: bf24fff4 0000000=
0 00000000 c04056b0 00000000 bf24fff4 c0405624 c04039d4
    2020-11-04 15:39:30.456000+00:00  kern  :emerg : 3de0: ce0c38a4 ce22091=
0 bf24fff4 cbc985c0 c09dd3a8 c0404b20 bf24eb6c c095e460
    2020-11-04 15:39:30.465000+00:00  kern  :emerg : 3e00: cbbd2bc0 bf24fff=
4 c095e460 cbbd2bc0 bf253000 c04060e8 c095e460 c095e460 =

    ... (16 line(s) more)  =

 =20
