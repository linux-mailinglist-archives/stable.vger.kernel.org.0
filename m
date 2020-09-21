Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5131127353B
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 23:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgIUVyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 17:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgIUVyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 17:54:15 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F96C061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 14:54:15 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id d13so10204824pgl.6
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 14:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kU4aX/U17UJKH8vFmklyaXCbbMCz+oL5z6gFpDlV3Yc=;
        b=fuMy813syZ7MilBI0rQF2AFO0C1tN4HjcMWan9WcpsnEMgj90GGg43J2S3EAZ/Zm3w
         KLyHa61sZDVhJKejI4SwQXtANCj7LGJ0EBOCGrZ0H6fCs8VAlPoDmy6ENnlEJn2fhGup
         xwxJ6DDNjyLnCE7S8vKugYDCbWzg/8Rbn6nbd9oSLthZZ54qPmtACA393QreBlZe2Xho
         3paJxuBE5O6Vjs3UPECAihFK9kBNnt88/9LKI7l2R1XQ35PntIhOPUq7sXQVgu5wivd0
         LytFglmtj5b+YwLrjgFSUe8ZEwlW8LnYzdNR/N50GglCk2WQuW6+Dd3IS7y3MM4baRAv
         W9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kU4aX/U17UJKH8vFmklyaXCbbMCz+oL5z6gFpDlV3Yc=;
        b=mIzqgjz0vmHT2on60CK0Ay9U4u7dKTpP46A8kQMUrmM4Uv2Rz9KvGmGscWglmLM2gA
         0Emm0qc2xt6AdAYjwuH2yqbGQGrPwo5CK/lkQ0HyO18AkNFugx/rnJ5rgtrmp88oN+eP
         qegUg+gZ/jk4tpIATytYVQo62nTsLtx5rz3pvu+WhR1WUQe0XHUJ6ZhyGt218W1TLXy4
         BarsBFzAFDS0zhYNo61osx+hxtmWQwbHLfEYFgJ9u12Q4/jvx5x7pmvKq2o5myeI6GSN
         wRMnHe1jeAkKED6lfMNkS3+QVV+KHlvpUeFromKld7d+yiVoRLu5V44pUwLEskpEGG0C
         yf3w==
X-Gm-Message-State: AOAM532vRvfMQI+/QOrKWGACJREmgMHFKfLtHwDsXB07tegtCinvdw0i
        V2XSGuo2OQQB5jAawbt5I9gcpcbpZ6M77g==
X-Google-Smtp-Source: ABdhPJyzMiDw8ypJKP+t5x/PPv5VbZ6OIzN6EZHhWWjiBROeGpUxv4IGyjJZAxQFYiUNzYwFOjOm3w==
X-Received: by 2002:a63:6dc3:: with SMTP id i186mr1190406pgc.272.1600725254355;
        Mon, 21 Sep 2020 14:54:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13sm11222770pfj.199.2020.09.21.14.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 14:54:13 -0700 (PDT)
Message-ID: <5f692105.1c69fb81.1941d.a19e@mx.google.com>
Date:   Mon, 21 Sep 2020 14:54:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.198-94-g663503675993
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 1 regressions (v4.14.198-94-g663503675993)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 1 regressions (v4.14.198-94-g66350=
3675993)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig        | r=
esults
-----------------+--------+---------------+----------+------------------+--=
------
qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig | 0=
/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.198-94-g663503675993/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.198-94-g663503675993
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      663503675993c875faeed749ea7f2d3062f6c02f =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig        | r=
esults
-----------------+--------+---------------+----------+------------------+--=
------
qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-8    | x86_64_defconfig | 0=
/1    =


  Details:     https://kernelci.org/test/plan/id/5f68f09eb6a7cb9cf2bf9db3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.198=
-94-g663503675993/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.198=
-94-g663503675993/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f68f09eb6a7cb9cf2bf9=
db4
      new failure (last pass: v4.14.198-63-ga928c757063c)  =20
