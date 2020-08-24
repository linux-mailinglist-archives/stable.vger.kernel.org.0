Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3EB250B45
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 00:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHXWBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 18:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXWBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 18:01:16 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9C0C061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 15:01:16 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g33so5331485pgb.4
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 15:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HBi5t43NcggenXGed/CO5nvN7gqUxyTZr7FHZKFbzzg=;
        b=vP80v6gl0x0CZxW+dC/gqFChbeTHeI/2mmHXVycF3OJFfsXTNr/Tkc7EmeBhVmjcJK
         CUMY+829HlhL4usjGeWvQVWpCe2pqwhuhMdHvq+VIkD1OtNkLX/9ZXpc4xOBi0VB5kEw
         ZKf10YiUeVgleF/PUi6tb/eJtMkeYoAN5OkuY4fyQlZOxkSzfeQzt2RGiAV6sIl+PXSX
         yqFQis94ZzQkxfltXzRJ4JhAIVGst+Ak0MtdjvzuaXzpj9DTeGtOy+nPzH/3wetCVPOr
         zuiMWwaKs5wHGHZ/Y8AMk2HpQMffcLlOZIRGS0iUshQf1kZBpy1AT7cTSljtk86HZqFj
         zUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HBi5t43NcggenXGed/CO5nvN7gqUxyTZr7FHZKFbzzg=;
        b=Dm6iOFC5Yllg2HD9EN6xznU489Wd4BET5XqxDOvwAP9tyUYySJOSnhUjgr9djVii4F
         Os0PpzuPEi6y4o34POZMYgbIlyDPVl5mcgwXLkCeQM1FADZakBSc5d6KWWNqgzt8CUZ2
         axmafUrc5FLWIcsA4qgxeJPCPZ11hpKh7dEf5fw3WAZyVLwFK+fLLDupW4lOepjr/4Vd
         sOiBhcf054pRaAnUuOww1Q1pU8aL0zEhNd1r0DsSLKYsGD/FUdmbTYjrWx5i63pEZZts
         tSndzjUXHxITTWC+l/EUKEYm3Ys7V1Fy2BCvYbBnqm1SytwiORH17XrYyaWr/bSZN5T3
         tVTw==
X-Gm-Message-State: AOAM530jDEqwetYdRws2dhRMQxh245SnQ6atOiRkG6AWsxUDU4WLPQoo
        pbURM6pZ5PQEMetRDz9QCnehQI3FNgBPoQ==
X-Google-Smtp-Source: ABdhPJyKG87obYGt6JtgFCISUQDBwLhak0fkMpu24H4KVie80HMiiQ6fwyXdar3FFpjR1yv6eF0aLw==
X-Received: by 2002:a17:902:690a:: with SMTP id j10mr5203223plk.155.1598306475671;
        Mon, 24 Aug 2020 15:01:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l12sm477361pjq.31.2020.08.24.15.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 15:01:14 -0700 (PDT)
Message-ID: <5f4438aa.1c69fb81.67099.16b1@mx.google.com>
Date:   Mon, 24 Aug 2020 15:01:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.141-74-gd06cb8bccfe1
Subject: stable-rc/linux-4.19.y baseline: 160 runs,
 2 regressions (v4.19.141-74-gd06cb8bccfe1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 160 runs, 2 regressions (v4.19.141-74-gd06=
cb8bccfe1)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =

hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.141-74-gd06cb8bccfe1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.141-74-gd06cb8bccfe1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d06cb8bccfe117b0d29cf8960e38a41911a945ed =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4405016ca3cd1f479fb439

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41-74-gd06cb8bccfe1/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41-74-gd06cb8bccfe1/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4405016ca3cd1f479fb=
43a
      failing since 69 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88)  =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4406088d84770b4c9fb4a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41-74-gd06cb8bccfe1/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
41-74-gd06cb8bccfe1/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4406088d84770b4c9fb=
4a2
      failing since 35 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
