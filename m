Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538BA5C5EF
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfGAXd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 19:33:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38519 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfGAXd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 19:33:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so1234363wmj.3
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 16:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iXtulTrN6xp+GaUJwXmBpA3IZZ7RIl4MzHckByx1sOY=;
        b=jHT9FuQn1f56gTAupODX1MWcjPN6Z1Egasgng+mHo7gRGHog2mkCA9KgGfh/fCZdxt
         IonxHtYL7qQSHr7LcNoUYhf8qJvzUbLNuCJz0SJ3klTBcjmdrO0I6dIveQoASDmJSgCe
         mzCaRC5QwC9NCiB96O7Onf0Go1rFiE1mSaE2p60fud9tp2LmpJ2m5p1NkVDsB1V9loFC
         JlJXz5Q363stHnrEyfPwKE2ui7AizPPxrpug9aYytJLYt2tpSu6hoqn5/Skul9xvMjAU
         4iQAF995H0w/8Z2LsUbCSbcb3G4/rkJypHptKsks0iZ+XdKLBBPcJYY1BDHtAzCtanfs
         PPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iXtulTrN6xp+GaUJwXmBpA3IZZ7RIl4MzHckByx1sOY=;
        b=FLtvU1NStaAHIxmI+7ldLejgGd2DenlSK4Fd9jGZP7LSuh+RP9thE7cg7IgC58q1nL
         dOKbkJMl2RtIvqtAG/6l3kuWZdBNOWzSC4obfI0v/Z1Tm6T8zW5LDiHBPZmr+kAbbaSy
         i7IT8v85nZjYqZFqLioEeJK+tcJ/jtBWL8UYgr11RBGF0GWf7+Jx4huAa530QtORIs/4
         i/pQt9Pirt9aP9I8DLRJLRbe9v2a7ocq4q8LG/50pwNaMx7ru1tETqSOobWF0sTeYL7I
         LvznAYMTnvJLJU6xQ7aSQ6+JlPOBO3sghYhh3Cz5IQWIx78fHwegBvPeHsCqBF4d4hHV
         1N+A==
X-Gm-Message-State: APjAAAXWgXmQx4hByzJn7ocOYgVlY5iPwY02FAlmj2POjs39dSKgUWg1
        Hc7g1NsH3TbimuXRCGpRe/sX9E0z
X-Google-Smtp-Source: APXvYqwOK+F3a5953txf82IKqGRHZqtk1I9veddjSZyvnnkrpZ5SKnj4+ifj63G89hYKprCI6P1Ciw==
X-Received: by 2002:a1c:c74a:: with SMTP id x71mr891362wmf.121.1562024036059;
        Mon, 01 Jul 2019 16:33:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u13sm9893913wrq.62.2019.07.01.16.33.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 16:33:55 -0700 (PDT)
Message-ID: <5d1a9863.1c69fb81.ed145.9ac5@mx.google.com>
Date:   Mon, 01 Jul 2019 16:33:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.15-30-gc93daa83169a
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 137 boots: 3 failed,
 132 passed with 1 offline, 1 untried/unknown (v5.1.15-30-gc93daa83169a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 137 boots: 3 failed, 132 passed with 1 offline,=
 1 untried/unknown (v5.1.15-30-gc93daa83169a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.15-30-gc93daa83169a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.15-30-gc93daa83169a/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.15-30-gc93daa83169a
Git Commit: c93daa83169abdff20d5cd1f446be359ba0ab899
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 26 SoC families, 16 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.1.15)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
