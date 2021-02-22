Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7518321F45
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhBVSld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhBVSk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:40:57 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791F7C0617AA
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 10:40:17 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id e6so1120183pgk.5
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 10:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/vkOCnmKJbxhQwFeIkp6a2/QxO3XiD9UZzGgTztoQEg=;
        b=SDTGkaYWUqC1b77St5t6nWbMdU6bktRWRztfkkkOlYWOJWnPeMOtPoCa/o8NkHFE/4
         QMyUIN7My53dU3fD/BL771VAFis6OLnt7svBKZJ55WJ/h1XB2+tpEHcfL2inb5UA095T
         ZIsV7J8tYqcfXPPXMTAeqcmH2qMAk1G+QYEeaw6MgS3xZDUBQ3Cxw7HclDs75NQE8wpB
         tmqwiiEX8nhLhNM47kv2QZ/enY6EH8YhaPRp++iuQA/DJUcRBJsz/PsGwFjjVNhAiDEr
         xj3BuQVB25mchLGx7PMgy8ONw9/VVcGw2oYm1z90N4PRNs5JsftR5WcibfgdvKjhGCSV
         vZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/vkOCnmKJbxhQwFeIkp6a2/QxO3XiD9UZzGgTztoQEg=;
        b=tZaPW+B9zk/i4Hz0Y/5pHuPbtIoChROrEmra1P9F+xbptRfcDGIYMn8tnqlb9scXQ6
         BOUo7B4rS0eoxax4iXvs06E64GlSWN3VogrV1QRtyyGGWDYfa+lhq9EAfu20Lssr43X/
         xXyG0KcRHCTx1VSlbzq9uelB/qxDykJmc64qAikD97pWchFxTLysPBfEPJYyhSzL/NG9
         tobo2fW3swsKl0sDcHZrg2bC2yaDCEDkHcxaq1m8dFSIESsMzznjX+XNYmcyP3D4x+8X
         gAxy4Vu2oVkVaCP7h9HDl24OAVfSTYG4HIwp6iYKcPk8w2u6pJhmq+1dG81htqV0ST4L
         wGbw==
X-Gm-Message-State: AOAM530D43jFeycX+c+5F4x/YDSV8nDLw3rzwX8w7c3G+1FpxecfE8jh
        3xT8lu+CnDXKb5sDTd/uWpNwDiAJB5WCCA==
X-Google-Smtp-Source: ABdhPJwfRQo4rdYk54mhWlDXzvHCbuZ/CchhIq33uZ9wRYhdHmY+G2Fe0GNHsw6U+Y+ht9N4ilCTAQ==
X-Received: by 2002:a63:574c:: with SMTP id h12mr21044545pgm.79.1614019216787;
        Mon, 22 Feb 2021 10:40:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j34sm18238375pgi.62.2021.02.22.10.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 10:40:16 -0800 (PST)
Message-ID: <6033fa90.1c69fb81.a1083.6f4b@mx.google.com>
Date:   Mon, 22 Feb 2021 10:40:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-49-ge7fd2353eaf6c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 52 runs,
 1 regressions (v4.9.257-49-ge7fd2353eaf6c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 52 runs, 1 regressions (v4.9.257-49-ge7fd2353=
eaf6c)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-8    | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-49-ge7fd2353eaf6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-49-ge7fd2353eaf6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7fd2353eaf6c19d2932c9c7e3b5c9ef2050538b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-8    | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6033c107d2ddb0d8abaddd3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-4=
9-ge7fd2353eaf6c/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-4=
9-ge7fd2353eaf6c/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033c107d2ddb0d8abadd=
d3f
        new failure (last pass: v4.9.257-47-gbb4595d8d8db) =

 =20
