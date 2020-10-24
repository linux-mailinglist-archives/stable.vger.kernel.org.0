Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC040297E88
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 22:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764526AbgJXUty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 16:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764525AbgJXUtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 16:49:53 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EED0C0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 13:49:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w21so3844201pfc.7
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 13:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3F72j+rbg/9m36/kyblcuHGgXPUVnYJ/RGqW9Gxv7PY=;
        b=s7T/Ak6XQsTH7e7IhjU90BmTibQtzlcFH2Fh0S7pbtF7KAjRuvvvfZaJJpbr/cBIa+
         z7U6TGywP2YwUXaupSXRd4YoJ7Y0hCjfJGh6l2HhTMMNpd9VX1y9n5ebm+V5elHCye+s
         O16CFrDJy77NTNzlnD5hWQGqUOfjO505zxN41u1bqNG2uF+vmQWMto89ZiRBeYG/iQ2V
         Ot9tFjDAy/3Ix/14XP+dZebXjaGXOHpcqEOPeFIFOtb7VSCpURIx4e0VQJakK5dUl93f
         x/oVYXe+MMEzwL9+Ro8JeQcj4etzLuaKEZkgrjGVq8bMbiKMaC08cm+Mp25D1RkiT0uG
         eqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3F72j+rbg/9m36/kyblcuHGgXPUVnYJ/RGqW9Gxv7PY=;
        b=uOETwfvBPHiX+Trhx/X0pm5m7XX+XNmQQHAzp3yOyn6G5QdbIyDpdtqUzs6jJAePD8
         4fKFI2zrQK+h7b9fKke4UZKVIsRzHHkF8w02VMnX6WdMg+qY/zRoiapxnrwogEkdqmxr
         6f2tLsh+xp27GirgloWFr6nmAQ3PImvg2vqU8voR4nEHPRB0klTYXV0NJFL+Bym/OAvi
         741Sjuea0bH38VFRznTP8o5NH9ds4R73ew6be+P069n0p86bRItelGUU5xDAxTh3M5p8
         S4swqZRCMQCf/7zWK10HwsI30IoxGmPxpbY50nclM1b78XQp29kDJs/ITe4vIS6Yv5O9
         OHHQ==
X-Gm-Message-State: AOAM530CxQz3hlaMX3f4HFtwTJml36VepreQQy1Jp6gSXyXipgBQUSlE
        gXORjewYE5GNXpoWYb/kh0u/mrVOa1O8uw==
X-Google-Smtp-Source: ABdhPJyjj+f2jb5NNK6IYG9RtReFrwQ+w6y+pJ5CmUBkRb4UynBOLEn+aqBwGDanBU3t0V5UAnN58w==
X-Received: by 2002:a62:d418:0:b029:152:8812:8e47 with SMTP id a24-20020a62d4180000b029015288128e47mr4663855pfh.40.1603572591484;
        Sat, 24 Oct 2020 13:49:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j15sm6374619pgn.32.2020.10.24.13.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 13:49:50 -0700 (PDT)
Message-ID: <5f94936e.1c69fb81.b04c5.aacd@mx.google.com>
Date:   Sat, 24 Oct 2020 13:49:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-54-gc97bc0eb3ef2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 195 runs,
 1 regressions (v5.4.72-54-gc97bc0eb3ef2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 195 runs, 1 regressions (v5.4.72-54-gc97bc0eb=
3ef2)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-54-gc97bc0eb3ef2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-54-gc97bc0eb3ef2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c97bc0eb3ef29cf2b50b4ef4b060b086574d31e4 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f94616d67e45757fa381024

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-54=
-gc97bc0eb3ef2/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-54=
-gc97bc0eb3ef2/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f94616d67e45757fa381=
025
        failing since 0 day (last pass: v5.4.72-24-g088b4440ff14, first fai=
l: v5.4.72-54-g5ae53d8d80cb) =

 =20
