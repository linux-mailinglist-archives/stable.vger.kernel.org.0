Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2425E321F61
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhBVStu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbhBVStA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:49:00 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C455C06174A
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 10:48:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t11so10772802pgu.8
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 10:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bo1+XwMt5a7+pOMtFgeFRtCeBNu/q9xiSslIjOO5vTs=;
        b=pyqLzYG4R31AM6qGfE6LRFCPcCUgUTQW8i8I/5w0cWVERYDtEaLO/Ztyqlg5X3gtt1
         yheRorRcgH2zkTS9dWbdb5CAK6g+tjfsgCU/kPihw+wYhfBzjP/U0iCepqjh1+Own0Sm
         hsLYt2tWE+1lpwept6l3Vie57hXrh9eW6wzovHO2RRK+FurxSIt7diNZVUQdqOU7qGwn
         vLRSdrmKOKoUZIfDpm/Kxul/16dUZAyBBCTg952clncloM+CJlTTxY2djDpVckjyZQiK
         oK+Gri/e8EndGMJt+PCAbq6iPgwXhhfC3c3awntWnahPh6/pi9lLQlrBo+l+TlMH1EO4
         JfsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bo1+XwMt5a7+pOMtFgeFRtCeBNu/q9xiSslIjOO5vTs=;
        b=MmKqHryEx2X7RF88nSI4cCYI1aRSATQr8Eqbti1JXpJuB+Oq9+B55IJLFJdWMZe6aA
         NiE6I/6BHlelWMqaoLitxnOB93C8VX3kKlZnCcBUSjlJ1YwtPsWGFk7BeLzQqkeu6u5E
         fhFPFpF4eeZZh3SjbIOtjoBqbJr56nsMqHQXCOmK10O5eIv7jUI9WSj+waeU2YoDT4ox
         BE9qF+6jfll8V5Y5gvqPI2YPbl5aABBUYP/sv6xAV1IsC2fiiZ7JTHuhGfLmil/4YN7J
         Bp/WPkmZyRl3MuLL9GhPEBqHITZmYlUR7LObJ74qv5ebh7CLfhcEkkB15hjeobf20VI+
         N8VA==
X-Gm-Message-State: AOAM531HQwwEzJvgpxPofLZlq0S6bBZaD+cp6zrxgiMC9S5+gmFuoFWQ
        vi9udyAaiEulONBpHoMgRJQJh+kdfSH4fw==
X-Google-Smtp-Source: ABdhPJyR+PNdKGupvDljlK03ZDEXYE0/5GmHTmvGZoD5/Yynzcan93dRsLCewQofaKr0U0qEy9pnmQ==
X-Received: by 2002:a62:d454:0:b029:1ed:a6d6:539d with SMTP id u20-20020a62d4540000b02901eda6d6539dmr5801125pfl.63.1614019699527;
        Mon, 22 Feb 2021 10:48:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w3sm155583pjn.12.2021.02.22.10.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 10:48:19 -0800 (PST)
Message-ID: <6033fc73.1c69fb81.a586.06d8@mx.google.com>
Date:   Mon, 22 Feb 2021 10:48:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-50-g4e98c9bdd022
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 90 runs,
 1 regressions (v4.19.176-50-g4e98c9bdd022)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 90 runs, 1 regressions (v4.19.176-50-g4e98c9=
bdd022)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-50-g4e98c9bdd022/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-50-g4e98c9bdd022
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e98c9bdd02276f367f8f5aca280f003dc686cad =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6033c2e2f024ea38e3addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-50-g4e98c9bdd022/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-50-g4e98c9bdd022/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033c2e2f024ea38e3add=
cb3
        new failure (last pass: v4.19.176-50-gecbf7af016c09) =

 =20
