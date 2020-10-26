Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BD7299548
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 19:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789753AbgJZS1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 14:27:55 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39881 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1789752AbgJZS1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 14:27:55 -0400
Received: by mail-pl1-f170.google.com with SMTP id x23so16155plr.6
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 11:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+PY3ZbSnsMEpyHvcRkMn6ZVXNQDatFxHEQJ3jnenUfE=;
        b=SH9+ahCiz9xanxdJLMhEabAJWRWAmv73c/ctyn6rkoGgV1riiq/R2EaAxY+/Bfibqe
         kE5n9Hhl0LkQLhcGU+4W4n5y/KWVzEpPNlDL4lfmKGVQgawS683RQowDyAB9sgQ++n/0
         PlMODuMmrXNegt+v7T6G8gK2/fwBZJXOH259XlVFHJlQ0QFyy8YMzR2N2ZqsmxSZfhmw
         oycVhGOwl3enHu4J4yWGmvDvEqfVmRAydZ3VEBVhYkJnUNNIdMY7N++L902RcBFS59b9
         IHWjPh4Il9yebvMrsbmh0UrlecKv7VVeu6N82sZnZY2cnrf6okRcPGwxxPj1BCxZpqPZ
         ZHTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+PY3ZbSnsMEpyHvcRkMn6ZVXNQDatFxHEQJ3jnenUfE=;
        b=BJNqwPOvQuSgFXmWNn0+pqn2QJ4/Lg374SisuS67pG3D3beMMei57ZxCmvTMGzIOFF
         4SGaYVWQVWujATiwkRyM4QzN9XOcUJSMYwCbh4Ue9U8nJKBL65SWGfwtuVEAsLqR24hI
         9p+I8ZnCTDU6XFnoZaQ6ozdH2DZqzGzXaP2GI65WNguqFxUTl1KLUiUsrJ4S20F5lLcl
         dD/TWKGxxH/A7WzYfTozhG5uqBhkQACNHOn3RhO2OzZ1DU+zPA7XmAEaYxfySApqbXse
         h/tVSS6B50bccTZ5+GNrzgOaT2m6X+PTVAEqfrh87rWeGqfASifi/7tv+EiE4S+VmEXM
         iCGA==
X-Gm-Message-State: AOAM532oAhhRmzS9wdUMqfmIJseeQwp+XUxESsmB3Xhcff3nqT5tW2hi
        uIYvAOZJXG2JRuHeGxObYywWqGHlMXkmVQ==
X-Google-Smtp-Source: ABdhPJyixdwdeJW1mDu/HG6w7XZdefDxJHQ7wNZmI4Oee9Zygn+qLa7vyLlhjhpSVUp7v/ddnl6hmQ==
X-Received: by 2002:a17:902:724c:b029:d5:c1de:e34e with SMTP id c12-20020a170902724cb02900d5c1dee34emr15705230pll.71.1603736872650;
        Mon, 26 Oct 2020 11:27:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5sm13280716pjt.54.2020.10.26.11.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 11:27:52 -0700 (PDT)
Message-ID: <5f971528.1c69fb81.b5193.ac08@mx.google.com>
Date:   Mon, 26 Oct 2020 11:27:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-260-gbad1094e2c61
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 178 runs,
 1 regressions (v4.19.152-260-gbad1094e2c61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 178 runs, 1 regressions (v4.19.152-260-gbad1=
094e2c61)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-260-gbad1094e2c61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-260-gbad1094e2c61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bad1094e2c61dee20dbedc800b3fb3e7458bd268 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f96dadd9cdcb50e82381056

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-260-gbad1094e2c61/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-260-gbad1094e2c61/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f96dadd9cdcb50e=
8238105b
        failing since 3 days (last pass: v4.19.152-15-g0ea747efc059, first =
fail: v4.19.152-15-gc47f727e21ba)
        1 lines

    2020-10-26 14:17:19.921000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-26 14:17:19.921000+00:00  (user:khilman) is already connected
    2020-10-26 14:17:35.540000+00:00  =00
    2020-10-26 14:17:35.541000+00:00  =

    2020-10-26 14:17:35.556000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-26 14:17:35.556000+00:00  =

    2020-10-26 14:17:35.556000+00:00  DRAM:  948 MiB
    2020-10-26 14:17:35.572000+00:00  RPI 3 Model B (0xa02082)
    2020-10-26 14:17:35.663000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-26 14:17:35.695000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =20
