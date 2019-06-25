Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA7652800
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 11:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfFYJZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 05:25:45 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:50502 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfFYJZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 05:25:45 -0400
Received: by mail-wm1-f42.google.com with SMTP id c66so2061010wmf.0
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 02:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GpCOc9BT7nExdxYdUal5Nh47JMsyJCDh+11loeQ4IPw=;
        b=kmoHgFjtg+pEhyzsL5Ypxe951B29tvqp155YPIob+HnBizcqEt2b8I9NForab/arIe
         CvJ7izOpnCraQvOjD0c8mGVqhgBvi9hRWcWKMM7ZSbGyD5AXNhmey728Nj1u12LDrHEh
         UMVsPQvqZAFSjit2fXT5y3ghu7KXlbNOkEqyvqUrF2GkoA5Etoq+IF6GYu3Z9eqzKu7g
         GPiuU0vXuqtijEblK+EcBhkNmK62GYveswqugf/15qmOdX0XpX3/Xtgic7fgLtWuEtXr
         hcWjeUsKEXsRxaRfz7qmBB/SiVXd2Kz7rwiyBRKShGEZVm5osMiDT6Wu2mM8A2foGlW1
         ycFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GpCOc9BT7nExdxYdUal5Nh47JMsyJCDh+11loeQ4IPw=;
        b=QKBlnDPLMX/ZCmIAG40iofh2GUp1SyCuZ2rw/c+ZrLVA7SYnOOf/iBdQi0N733ikH7
         mBCxmnIcRWcKUsgL6Jc2kNx9QK7sOwYkQeaPsCHAp1N3V33TRfOXgk4336Wb0PBRM4UD
         6ZNSYgoAn7fo7pX6GoEsTW9izqskxlYS+shMCWaAMNGgljnOkmAvgb9KG2X53b+CLWVF
         kcgwVFN+C1KC8mvhewP+NZNko1cfoUQZrtjR81aUTzd54RqNHeJOdxpblts8sTVDDos+
         poFzMuGKcrDOOO4yXpQy5e7A4k62kT+tU1U4Uuxok0uJxpIgBZGNI2ReiXms1HEj8xSw
         et6Q==
X-Gm-Message-State: APjAAAUpH03nAT0bSNy3U4ZiGRObr7idJlqrsZLfogRDhkM0yOqRcKaT
        +PyKhQAqc5yFTEgVAww5Qw+gKKaZLco2TQ==
X-Google-Smtp-Source: APXvYqyOmAYGdeD9jKCm9AsVCmy7GP+owIvjWZkenH8K7xvLH/pfYFgjbYsm4XVWCDza0B0UKWz2Aw==
X-Received: by 2002:a1c:c6:: with SMTP id 189mr10626652wma.112.1561454743265;
        Tue, 25 Jun 2019 02:25:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z5sm1767345wmf.48.2019.06.25.02.25.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 02:25:42 -0700 (PDT)
Message-ID: <5d11e896.1c69fb81.21535.967f@mx.google.com>
Date:   Tue, 25 Jun 2019 02:25:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.56
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 136 boots: 2 failed,
 134 passed (v4.19.56)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 136 boots: 2 failed, 134 passed (v4.19.56)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.56/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.56/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.56
Git Commit: aec3002d07fd2564cd32e56f126fa6db14a168bb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 25 SoC families, 16 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.19.55-92-gd8=
e5ade617e9)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.19.55-92-gd8=
e5ade617e9)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
