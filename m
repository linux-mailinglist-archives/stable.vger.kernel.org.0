Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C32C1E68F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 03:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfEOBKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 21:10:30 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:51960 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfEOBKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 21:10:30 -0400
Received: by mail-wm1-f41.google.com with SMTP id o189so852853wmb.1
        for <stable@vger.kernel.org>; Tue, 14 May 2019 18:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b6SAcbFBIDhBUhdiTw8Q+HVxHxUy6DCoLDSrEERynDU=;
        b=j+j0Mvrxt0uTmfft7tqkBo0CIDQXQKI5I5ivdJjk3g8jWmhBx9kLrBRXwBU406wBYk
         ZGBXaJ6wOnfcY3pq6+uuhrJN2CZPR4FlvDETjuzBbwtRGGBs8NvMRt/uS1BgmMY+q3/J
         rwp0IAZRSsRqRmsFIoUFVXNK1F5L+yVjPjjEx4xDE2fXnnq1xXlwua/cNPMWF0qVf63s
         dE71WKn7U6ATiBsW0OUsUegJn+OTmnHRwQQmJrH/IDjWy716hAvHlNABQWIItE+vTrPk
         UnR/+fSDqa8G08lL+jglbv08dRH7TRL+RAXID9uLt83+h3livytXC0lz0owk6njpzJHk
         TySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b6SAcbFBIDhBUhdiTw8Q+HVxHxUy6DCoLDSrEERynDU=;
        b=gFzoWv6c8C1Bil3h0yIeu4dzf636ukSPf25D7PUljqnjJ+rNKwQgqm3OA5wnZysYvq
         cXY3iEN/pykc/+76OVVCMWg/sI8SoGNYxGg9Kg/TrVCk/hjtQTF5OQ0ZpoGL1BDRW6RL
         t+Z1O+qLJqp23jWw9/tul/wW9QcmEDSmX49tbx8KqFZYyLOCxmU09+4SrNu1tzWftcs6
         b8C3XT75elDwCPK2EpV7E+WG9MjprHxDbFF+0YtHwGXYxVcWiVLZuPACnG8q/xXYtruW
         xl7IYyXlMMCvCYb2C+0ICjSyRttxNsvM2Z/rHEWhdWofb184JKZWTmnDdV7475jsUscY
         YSWw==
X-Gm-Message-State: APjAAAUnXr4wdrH3Vt2OzTw8k6ha0W1K/ugW2mBlQ3Vxgkbmh4f9qAPZ
        PvTJWTLkqs5J4Jw8sAlLnmcDdS/cEifcWg==
X-Google-Smtp-Source: APXvYqxdlk/iBG5uiLqqJOOjHjxiC3/dEt9HzaFllJvwBGFMjGgjA/FkiTjNb/+anNUEscfGBZ2y6Q==
X-Received: by 2002:a1c:b782:: with SMTP id h124mr22219014wmf.5.1557882628596;
        Tue, 14 May 2019 18:10:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u2sm1419384wra.82.2019.05.14.18.10.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 18:10:28 -0700 (PDT)
Message-ID: <5cdb6704.1c69fb81.2833e.77ec@mx.google.com>
Date:   Tue, 14 May 2019 18:10:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.176-35-g6194f35e779b
Subject: stable-rc/linux-4.9.y boot: 112 boots: 0 failed,
 105 passed with 5 offline, 2 conflicts (v4.9.176-35-g6194f35e779b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 0 failed, 105 passed with 5 offline,=
 2 conflicts (v4.9.176-35-g6194f35e779b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.176-35-g6194f35e779b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.176-35-g6194f35e779b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.176-35-g6194f35e779b
Git Commit: 6194f35e779bce6fc83f12e0406422dc480c09cf
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.175)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
