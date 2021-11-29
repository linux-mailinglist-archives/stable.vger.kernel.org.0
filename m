Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0AC4626FB
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhK2W74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbhK2W7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:59:10 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E843C09B136
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 14:04:44 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f125so4299096pgc.0
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 14:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Cuu7I0PmajYNXeyfZfMrGXvl2zY+nE1QKV2xxlAbJO8=;
        b=LNcZaO60+mAz5pPHv3ZgEx1XSktG0U2RMwbhO1VecfYxTpmMAi6b/rp3KcQfICtNOK
         9g75fmGJ1m55/2rsFDqo3/d6krF+wzs5VCn7ZM5rlaN9GBjajOqv2HcUZ6O/S+um5nS4
         WmNL/h3BSEoDEfi48w0Y4dH6vlPxEFO+ghxjzIWFjfhgCP0Nm8IL3U53euI13SF+iLzT
         hIicthWTtGBW3E9wNhJyV/9Fb5+EOUCIFV9xrtRCSuPdEoNrR+qJyufocrOZl5L93NAW
         1/LfGyvCqOUCQVGLcnqzoFvcwEFgz6B4Mirk87BbgNX6vdLiNSzAB5J74HHqrSEe2JiK
         uAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Cuu7I0PmajYNXeyfZfMrGXvl2zY+nE1QKV2xxlAbJO8=;
        b=qZqJWpwu+BC9pZZ3xXk5FpdL5yWHvZUhPikH8+AjlPpKpZOUVa8d9fZF2W6Cuju4dm
         BBCRU/rPlA5rdXxg/rFDChUL9qg0o8+QsgIKrm5OqBCUDZWAblrASZaDdU78XAHIbglH
         0JtbjwbBstvwvmj2ipOW80TLLT84a4Duwb7GSttCGHHLzkpQ7Y0NDg1jThMhrLk3NGev
         p5vNMWexjWJzANE7kns+bgNt/Vy668fbsjGOl3HjmiyDQ3ot8Ki5ZH/L7qGWHR51hduc
         qCnkwzEKpCPHE2ZJqf0IvRVnkcg0KpuKsIsspCZY+/jqUvH47ZbAOUl4ey2Ic5g+8ict
         qm/w==
X-Gm-Message-State: AOAM531bSjvgDnc68ufq0yjLqeKfTcl7D1JSYlL5K3iNhXind/8RByC9
        VPAYEkJWTdXN7+5K8NtJpaCKK65AqS3D0pjd
X-Google-Smtp-Source: ABdhPJyqA69i0nfzazswhPwxJauoJ24tE/SKt0RISm/MNgvHImKBX19bufWKXf2UNABZy3HAbKkWxQ==
X-Received: by 2002:a63:4745:: with SMTP id w5mr37219083pgk.320.1638223483743;
        Mon, 29 Nov 2021 14:04:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10sm13398659pga.6.2021.11.29.14.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 14:04:43 -0800 (PST)
Message-ID: <61a54e7b.1c69fb81.88bcd.44da@mx.google.com>
Date:   Mon, 29 Nov 2021 14:04:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.162-92-g7262d8df3d015
Subject: stable-rc/queue/5.4 baseline: 141 runs,
 1 regressions (v5.4.162-92-g7262d8df3d015)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 141 runs, 1 regressions (v5.4.162-92-g7262d8d=
f3d015)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.162-92-g7262d8df3d015/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.162-92-g7262d8df3d015
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7262d8df3d015d744db73398aa3f707f49b1a275 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a518f98b85d3727a18f6df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.162-9=
2-g7262d8df3d015/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.162-9=
2-g7262d8df3d015/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a518f98b85d3727a18f=
6e0
        new failure (last pass: v5.4.161-100-g5c0e2c8610e1) =

 =20
