Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CC8466D28
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 23:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242876AbhLBWuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 17:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbhLBWuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 17:50:25 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B8C06174A
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 14:47:02 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u17so762934plg.9
        for <stable@vger.kernel.org>; Thu, 02 Dec 2021 14:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ydih9iSs9u5YuwmRhdwkD/lRt6PU+8hytGOIYmSlnqw=;
        b=UzyfaEEk8v8y41raiYwr2GPqBjC+V3sGgl4f5kKtm8vU7dVhrpx0hFaxih5Y4mPsfL
         kM82TZnyiO9F4M88vkJxx+o3AKA94870JK5Tqic3+lln3/o11uaEBKkRwqqXYARS/Z/I
         FEfNNkGHEiivOyalxvnlVcT8vI4WHrRzEhOXZEO0vMmDOSmXsnT19OxJK2cXWbGLqK9v
         PhX7JVLoBVcAeCQXAY6KpEYLE8yU0mK8L0iuw+sG4A5Cc3CuY24q4guTURVCIOuaKQNf
         O3hKk2b3EnsDR1XRQHqmI7WxFCC7PNo3X9wWP5XPWXQ93QgpoNphcRI6bfV8cnQTiVjm
         7DOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ydih9iSs9u5YuwmRhdwkD/lRt6PU+8hytGOIYmSlnqw=;
        b=r1THzKoaYJd4qFt97N7uR/29t776udBlwB2VJsoJYMlZkGdG6Qi2lAeERE0C6HuGmC
         KOl8DhwLRPSiuRT99mqYkORxwMjFb4MvPFuBbDb6lKMnTLvaYtKH2Jl2Wsp4eu+LlJm+
         vS9w494RyPM+l02gSMTSQRY3sqCLl421AlF5gyCIT5wnNH8il57Mjhps8T9JzhjhfTA5
         yGdnBsAfTIMnHVrWVmdd+PSK0qYhhCQEkbx72eJF9xTuvag65LVZxl7mqAOjii9rW7xq
         GLRBjWN5wVafmz2Iqd9o9O4+EIrvL5isOvwoiQOuc7iltdEICGuj6T+4lLNNnc1XEb9E
         4+9g==
X-Gm-Message-State: AOAM532QdVCUwbMxuOQuhaFlBN6bbwSrbjw4uqp/PAtcZUx/LQsDYjOH
        WASq1H0BOUNMi74KCAmmk8avTmYm7UJE1qxG
X-Google-Smtp-Source: ABdhPJybYMoSmhfTbL7GCxcdChXrgIKrC7Lu46wx6nLXeGXfYJlnweGkjxItNaUJRLq8vGDocJVBgQ==
X-Received: by 2002:a17:902:d50d:b0:141:ea03:5193 with SMTP id b13-20020a170902d50d00b00141ea035193mr18100870plg.89.1638485221636;
        Thu, 02 Dec 2021 14:47:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e15sm760612pfv.131.2021.12.02.14.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 14:47:01 -0800 (PST)
Message-ID: <61a94ce5.1c69fb81.ec2d6.32bf@mx.google.com>
Date:   Thu, 02 Dec 2021 14:47:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.83-2-g4b8d7dac2382d
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 1 regressions (v5.10.83-2-g4b8d7dac2382d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 1 regressions (v5.10.83-2-g4b8d7da=
c2382d)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.83-2-g4b8d7dac2382d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.83-2-g4b8d7dac2382d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b8d7dac2382d796111cab7180dd0984689b884e =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61a917933d8f9480c11a951b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
2-g4b8d7dac2382d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-na=
nopi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
2-g4b8d7dac2382d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-na=
nopi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a917933d8f9480c11a9=
51c
        new failure (last pass: v5.10.82-121-g8cfe6efdc7582) =

 =20
