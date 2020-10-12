Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D325A28B989
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731195AbgJLOBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731160AbgJLNiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 09:38:17 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896EBC0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 06:38:17 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w11so862660pll.8
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 06:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QnyKTHYBCHQo/4P7AkNoGAB/tCf2S4G5aT8HwkJtBOA=;
        b=xiEVjANHm9nwK5GitlxjS96UmZsxIMGPk4k3iV6RTpIQUxPczwUItDrWjNKs6Jpku3
         PWu1Je4Ygkqz+jzjA2+OW+Vk71FrkKvLuhUnBgfOKrt5SMH5ETkMSh81yR/aWKFjWsrC
         0Ei++UQj1bs2Zubuu6wyTvRTE8jehWAONKzwvbZVVPEsdDlBPjowPnUP162nt4BIqDKf
         htqjNw/Ys62E1wAmONj8K7eRVvXnRjnHaY/Upipd7uWYtfrWGCvT9tSHvL3WG6jzOJiU
         MZ4shjOq52tLVZG/IWm30mm1qYotYImt1Gwl7oEi6bvdMN875aqqz8k4xasvSdJHhWLN
         50vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QnyKTHYBCHQo/4P7AkNoGAB/tCf2S4G5aT8HwkJtBOA=;
        b=NVico7zhMK1985P1RBH1Q++zBKO7C+HffaPCWtWQxBy99eRmJ+AsQx2ut81zlFzGSz
         fjlx1BJA9c6CPPK5J7XJr+xcu8VbEe3S4ZkYWMCbEJryQsgvEY75/9PNjpl85G91qxFI
         296qkN6sHfLk0RUA9KCH8Do69SxLW/zy6i9YDz52sO2MJpuxPTGBens0zkMJ3hWA9NlV
         ojbm0+Kjgc4RNK4Samc/XMbTA5N8VWgH0tdbTMw3QgbH2ZhKDLLNUwOWqVlV74q3Bcl8
         WddVtaYtebNmWtSmVmVUx3JdM3ubQYK1eJhtwNms7uh0efMfPE9+isW9TFmayJPqNj71
         Il2w==
X-Gm-Message-State: AOAM533dkSc0MbsFHe61VDSuciaHnZ7KHtec5ANT2F26zbIWLGJzVbHK
        6r6fuL5+h5UOhaH9Z2hmLJ0kD8G42+3yWw==
X-Google-Smtp-Source: ABdhPJwkFXUBRMU6s0HgGeYRI/eLwZpqhkj8+L+o9+7l5w8dfVCCJSzSusG9hXeXhscOwPZOwG1lwA==
X-Received: by 2002:a17:902:d355:b029:d4:d88c:ded9 with SMTP id l21-20020a170902d355b02900d4d88cded9mr6457590plk.13.1602509896759;
        Mon, 12 Oct 2020 06:38:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm25075529pjd.10.2020.10.12.06.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:38:15 -0700 (PDT)
Message-ID: <5f845c47.1c69fb81.aec2a.ebe9@mx.google.com>
Date:   Mon, 12 Oct 2020 06:38:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-47-g818a20155705
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 132 runs,
 1 regressions (v4.19.150-47-g818a20155705)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 132 runs, 1 regressions (v4.19.150-47-g818a2=
0155705)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.150-47-g818a20155705/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.150-47-g818a20155705
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      818a201557052b08424984081d68d509781f0dd2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f84182cc2e80f11754ff3eb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-47-g818a20155705/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.150=
-47-g818a20155705/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f84182cc2e80f1=
1754ff3f2
      failing since 0 day (last pass: v4.19.150-28-g0d0080f64605, first fai=
l: v4.19.150-29-gd8f1e7f2dffe)
      2 lines

    2020-10-12 08:47:35.789000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
