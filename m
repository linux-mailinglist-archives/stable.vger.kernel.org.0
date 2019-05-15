Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44451EAF0
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 11:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfEOJal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 05:30:41 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:35379 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfEOJal (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 05:30:41 -0400
Received: by mail-wm1-f54.google.com with SMTP id q15so1755133wmj.0
        for <stable@vger.kernel.org>; Wed, 15 May 2019 02:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pepdagd47ojacYXKzsXRF53CiupyHnyGthHq198R2X0=;
        b=2B4miMjc/RBsfOaFd/HPh5CZ2mdKfnbCXURL5ZtuZ8A6sNxUrqtLJCS2EefnS39q+g
         +egb1MaPWfVGfznoIg60SVHc34CRvGA7AZfPLOMamiMt18L8taRCYnzI4qnyTxqPQ73x
         c2mQMOaQpb7559D2iHPpMPQk+xdIOrOc3S6IdpCVw8HEUg4fQw15JtWtJSgnIrbk53U+
         9EPQVqtiRZucQEbpjA0fArVu3vIHtY31llDS4PmOl8kEGlMidJthDi9fQUeEyUXnAmbi
         sHXoKXozlZU2mi2wNNDj8QS/gn8T5bbWg9n8GFhC0CwFYvVrsb5q/+X75g2KAieJg+g8
         7+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pepdagd47ojacYXKzsXRF53CiupyHnyGthHq198R2X0=;
        b=Xk2bVhtCwGdlqcdJ4KmUZw4qEkTHIrkVergMvIHGiByG8wPu89MWkedQPKHFAIwXYR
         1PwPOnmacTMzDUiIo5EdLRBJENn0ykdbvfktrLDumYXJMWb9P3R6zsM+ssa5CGJPNoWJ
         FR2qadyUzRPdhnTH4tBPN0KiNSZ1GtmXH8KZp4T17l1RKMuQzoSrN+t/ejJrh/QfiMHZ
         XYfgAWMcta6oOz82i9I5JJ1HB4rayd2vmP1BHjjgfXAFEMmXevlZki21Bn3eWNV8nIDr
         QrKoNo+fnyTVGKnvXKbmV1JlFVdnW3HTLuG/or70WgEYHYziPG1mfoOJB4efaA1Linx1
         Pliw==
X-Gm-Message-State: APjAAAUr2fHpma4cuOphKSeMa/ilu91BKMc3o8IAXD5hSLCTwp8Ybc7u
        XZ5Lol4dqFoJ3+u+bhHw7iYyJJ6JkvYUzw==
X-Google-Smtp-Source: APXvYqyEoGCn9j3fCfR57pDPszkP+JD9if9IkwuwoQ3ylo/wwX7mnvY7lysPjXThWLjyh+IsPaYTzQ==
X-Received: by 2002:a1c:3:: with SMTP id 3mr14377762wma.44.1557912638716;
        Wed, 15 May 2019 02:30:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c9sm1062260wrv.62.2019.05.15.02.30.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 02:30:38 -0700 (PDT)
Message-ID: <5cdbdc3e.1c69fb81.6d0a7.525f@mx.google.com>
Date:   Wed, 15 May 2019 02:30:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.43-87-gc209b8bd5e5e
Subject: stable-rc/linux-4.19.y boot: 131 boots: 0 failed,
 128 passed with 1 offline, 2 conflicts (v4.19.43-87-gc209b8bd5e5e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 0 failed, 128 passed with 1 offline=
, 2 conflicts (v4.19.43-87-gc209b8bd5e5e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.43-87-gc209b8bd5e5e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.43-87-gc209b8bd5e5e/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.43-87-gc209b8bd5e5e
Git Commit: c209b8bd5e5e415c40c1b5fc90e2b1cccfccad4a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.43)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.19.43)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

arm64:
    defconfig:
        meson-gxbb-p200:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
