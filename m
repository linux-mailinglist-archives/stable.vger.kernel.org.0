Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB914383A0A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbhEQQgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbhEQQgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:36:22 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ECFC00F623
        for <stable@vger.kernel.org>; Mon, 17 May 2021 08:32:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t193so4909943pgb.4
        for <stable@vger.kernel.org>; Mon, 17 May 2021 08:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D8LNI/PwVOc4/3ZQWnGe/sX3s8YenD8FjHSnoDLeAVU=;
        b=jIpRvnTakkV4R5eV1H0CLJXhV0bm14xIpucAIHugs6cw+4NCT13Hos56w6tm7YIJdj
         fvM8hIJhlqx52IakApQ/FUi9Sw9v7EB7t4itM4nQfjwVaC7wLaF+lVNloOmBuU0ND0RI
         cBIHkzoq6HxK7ACuXhcDgdWh4L8icdTuMZWGHXHaEkIrs9ftxQOLIIgHacWqCsYLdx/x
         C0AnG57W9MuJu4jXzxvKjMXSdowiDfwhXzSMj8YtLhlnyeTk98oZYM2XEgDlK9iKttOU
         tcHnPFfz7joxurZ4mW5I3mm7e94rQqdJYrT4EOC3PxnwKSc1qGGKSCatTCwcluDJEb7f
         SUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D8LNI/PwVOc4/3ZQWnGe/sX3s8YenD8FjHSnoDLeAVU=;
        b=TegDV36GQfcKbTNne2mOLMtilyShcqaCiYpEzu9jjWMkCTiWgz9uba8WQs7boMvUXB
         4ZR2t8y8HRn6kpWcwZqxSYw8aJRZkx5n1P1ZMRuwwdIeG9UkYK5EEvBnXi2Bn5IrQusm
         mlxceN6JrwrvjPxwHZj1VTBpyA8J/+AWDEIvjSqTDC5ZhwiDpjri7qLQU+vVBSvhLxwK
         PLEcRY3tK4qde8ukAXuSwoSxv2Q3yRrdCLtYR9OepSIBsy7LztYrBSfwXeVgFm3O8Zby
         urzXqRqeAiBbDrdS4hRC5W+PgxUC2AEv+WUx6bdPCvcpRQTV/Peyx/URoIOHZxFTK/un
         hhmw==
X-Gm-Message-State: AOAM532yETy0w1M8FBdISEwN2empLc8pRbiAEnTYwzkuWn+QvMSBkase
        2nwDgNdxXAXCRVns2aLIKgdL8APNybe/WQR3
X-Google-Smtp-Source: ABdhPJzVOlqxqLUj3R4UNgCU+K55WyeAnZ267eg9pvtGOP1itEsqnMCSgsfWuZjbM3AwIeH4jKG+dQ==
X-Received: by 2002:aa7:9632:0:b029:2dc:6ef5:b1d3 with SMTP id r18-20020aa796320000b02902dc6ef5b1d3mr310688pfg.53.1621265537450;
        Mon, 17 May 2021 08:32:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y190sm5722735pfb.69.2021.05.17.08.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 08:32:17 -0700 (PDT)
Message-ID: <60a28c81.1c69fb81.bd50f.2866@mx.google.com>
Date:   Mon, 17 May 2021 08:32:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4-340-gdc9ee8b28006
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 134 runs,
 1 regressions (v5.12.4-340-gdc9ee8b28006)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 134 runs, 1 regressions (v5.12.4-340-gdc9ee8=
b28006)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.4-340-gdc9ee8b28006/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.4-340-gdc9ee8b28006
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc9ee8b28006073671abff09426c2368e7a7ce3f =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a258ad3bd979d4eeb3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
40-gdc9ee8b28006/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
40-gdc9ee8b28006/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a258ad3bd979d4eeb3a=
fa2
        new failure (last pass: v5.12.4-307-g93ac62543375) =

 =20
