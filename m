Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334DB278975
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 15:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgIYNYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 09:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbgIYNYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 09:24:07 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC536C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 06:24:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id n14so3169616pff.6
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 06:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zK7OXzfeJ07lRShU+UnH4VWyFreH0agrnVZ0HFxazUM=;
        b=zQW7pvKWmjpGkPBsWL9qCsFDKo2xvY5/PrD5wyN4kTm7yPf+4kw7DYwr0bKJthLNH5
         d5UtAcLEu7gwbmXchZ9F650gcBwN4+7xGRiUVgSPQ42V9982lMHnNxCFqrxUquWQzL2d
         HtaSI+LX04MMLZdnnIBUHIaJpHOLD2AGhsppwJKlgMFFfGzIvEk4tRf1RzEa1nt75Ghg
         lSNvPle5xOaeQK4V2FY9L4COoNdMURYBeIZmXjUQBZtHzFt2xC9xcvZjbsKEtPY339Oc
         vTX+dVxPs891OT5cNoFZT13mWBb3/DF1bmlxsrRtoavM23aKYAUGo4AQNdJgn7nGziY3
         Tp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zK7OXzfeJ07lRShU+UnH4VWyFreH0agrnVZ0HFxazUM=;
        b=ob67NghdcfXtqEX63k5m3FO4VwBJv4Ouri6l8FXMl27a+YiK9pwebMiLUkSV8KUbVI
         FDDGW7yMDZUQH0lLIWx8YSkOhtLz6BdL8eW56sRK1dyvBDcSKyE+NZ6Olq0Xsbo1/Ohe
         hFcW7XIuCCygdXoTt14SMNVQrz+jEuxEkGadJui+8YPMQiXttAmFDQD0ws+HiuhckTQR
         Pb8SVRA1LzYsMsHPUjuKRqNvHkSyUqh6x6fvdjY3ZAV+AlhHbOemnRyiXFaqJhvZKMsK
         pp6NIhBGA0MzbKC+90xwMwRx1XVOhMZu6IbzRUAPLMj+Ygdrws0YphxCAPdFRuV6JfNN
         Fd4g==
X-Gm-Message-State: AOAM530lLqhp0ElFs02HbqBTcD4SiD89//5WHN+YteJ5AEiugclRvhJb
        P8XwImr2kwxL2aGYUBXFFSieINGbyfMByg==
X-Google-Smtp-Source: ABdhPJy3Z/VsesAxhkdxpVoORcHiyxHWZIFHJ0MR2dC5t+6S20/G3dzhvMUyHaWaIknwVEfLoOm3vg==
X-Received: by 2002:a17:902:934c:b029:d2:6356:82b7 with SMTP id g12-20020a170902934cb02900d2635682b7mr3936296plp.35.1601040246902;
        Fri, 25 Sep 2020 06:24:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j14sm2104087pjz.21.2020.09.25.06.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 06:24:06 -0700 (PDT)
Message-ID: <5f6def76.1c69fb81.53ef5.5c86@mx.google.com>
Date:   Fri, 25 Sep 2020 06:24:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.147-33-ge5c020f734b8
Subject: stable-rc/queue/4.19 baseline: 183 runs,
 1 regressions (v4.19.147-33-ge5c020f734b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 183 runs, 1 regressions (v4.19.147-33-ge5c02=
0f734b8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.147-33-ge5c020f734b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.147-33-ge5c020f734b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e5c020f734b869b3eef19bde5e31295b84bcd26f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f6dbd736f0b4ab645bf9dd2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.147=
-33-ge5c020f734b8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.147=
-33-ge5c020f734b8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f6dbd736f0b4ab=
645bf9dd9
      new failure (last pass: v4.19.147-4-g5be0a4a9a40e)
      2 lines

    2020-09-25 09:50:38.571000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
