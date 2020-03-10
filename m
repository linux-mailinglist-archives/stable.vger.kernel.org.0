Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618DF17F05E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 07:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgCJGNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 02:13:08 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36115 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgCJGNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 02:13:08 -0400
Received: by mail-pj1-f67.google.com with SMTP id l41so276754pjb.1
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 23:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bEc2mCpyy2LSehP6o1H38WpZ4vt8en3f+dXWxSffJV4=;
        b=F52Bgp+dZUOL2SgU+x/H2wAeid4HndFTgElCN9GVw+KQjUW9dlYqrDpPcT2xwnzupj
         vwsZraEwJHnjoSDeaaJQ5epXqvgQ2XuYccXlmLEpkOPAILfYQEfnOkmsnsjiEtOVUY+6
         L2EYhvCudjHlU3pJLf+gxLWLNmIa2yRK/MK7YHkv5NVkmD2NgtvscFDQPIX9CouiBYx7
         RB7x1ImtiQdqGFKgEHoXC0GuNQC/GXfun9T7ZHEuxBMiPdcMWmpdL7qk644cEt1sqbJQ
         8QNDDR4UjG2agKENaQ4qmICtAIwT8N7u8/E4AFvu3FQnnmzCZgk2K9ZsEzj8zOtjM2Bb
         k3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bEc2mCpyy2LSehP6o1H38WpZ4vt8en3f+dXWxSffJV4=;
        b=aki1NLzN+0NbND+uv3QVNyGaJ8AC+n8uRv5CLhucEHWY10gnZaldv0itjWf4eSqxcP
         WKTV1+KCVzbvFiRF59E56ffURA0UNoagZD7u4dnZetUVLpswZosr5lhEdzit8V6dQT8N
         iN6zRuKlwLqBUUdYgc/nVNF/r3OK0hoHNoqkVcoT1q3kh5qvPiL0Q9BUoErRUEFNvWDE
         JrVXYc4xikTSyvo4ptlfCUnntnSn3LWMbuy87oFM65/ocAp4TaNErUOgK54zFRpu3+nR
         GFKB8u/hxIo0QQNWl75gI71iI3LiGbbT/CQgZCGv6TvRcTYsEYKLVh/mID4WphCMkxWC
         Qv/w==
X-Gm-Message-State: ANhLgQ1CAFnofWvYb0cqZG86JcJYaWLtU+Sc0RA9HCmpIx8RIoieykIx
        KA7b5YFzHAAIFsNHG2hHg5yW90ZhGa8=
X-Google-Smtp-Source: ADFU+vvPeA3n+HzTjKplervDj4yeuaUOdOr7AVWomy1kzC8o8QQXaog7xnhmKL0ft+h+60LaGmCvMw==
X-Received: by 2002:a17:90a:ae16:: with SMTP id t22mr147751pjq.34.1583820785083;
        Mon, 09 Mar 2020 23:13:05 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15sm1226265pfq.107.2020.03.09.23.13.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 23:13:04 -0700 (PDT)
Message-ID: <5e672ff0.1c69fb81.62c6a.5a94@mx.google.com>
Date:   Mon, 09 Mar 2020 23:13:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.108-64-gdd4b8602acb3
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 106 boots: 2 failed,
 101 passed with 2 offline, 1 untried/unknown (v4.19.108-64-gdd4b8602acb3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 106 boots: 2 failed, 101 passed with 2 offline=
, 1 untried/unknown (v4.19.108-64-gdd4b8602acb3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.108-64-gdd4b8602acb3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.108-64-gdd4b8602acb3/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.108-64-gdd4b8602acb3
Git Commit: dd4b8602acb3016ae334c01c54d19a0df928ea7a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 22 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 30 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.19.=
107-88-g619f84afab6a - first fail: v4.19.108)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
