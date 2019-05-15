Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4D61F6D8
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 16:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfEOOtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 10:49:01 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:44793 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbfEOOtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 10:49:01 -0400
Received: by mail-wr1-f45.google.com with SMTP id c5so2982325wrs.11
        for <stable@vger.kernel.org>; Wed, 15 May 2019 07:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gHYB+5pDwnOyiAAZ8gR6hokFzxBIAqvius/f3TazRDo=;
        b=CvDEi83j6bWbr7Yp2rpxkEpqydDRpF9+C8otR0DYroGbg/8ajHLF9x5PM03YCDI/CM
         90BYW1QfPSyTXBgxyLgn9t8dVhPQO39ux7Q3DZtfCzLXvpLoivCEhZ69XVUIYkZrcFQx
         XfEE/iXT07qPyIGDHL47v0aZzDb+JIrcfYaXynYXeG7ehzgYxIEy4a3hHMr9jTrr2y8C
         TCSxscKNwCr72oanuVhK9B7CKBC+G55ysN7aFlVbQXHlVOGDSENuMSNFKoIMDY2+sNgC
         om8xLUdoOWz+lfQ1lSCp9hH38HfujTEdsB/RkBZDbRgBSbM0PjWSzcNQnq4Qh7meXRPF
         fcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gHYB+5pDwnOyiAAZ8gR6hokFzxBIAqvius/f3TazRDo=;
        b=Zvtavj8bt0jHEkiIJUdqPw9oHixiqCJ2iad8oGPAtYdStsBC5/oX8dtoRH3P/9u6PB
         5iagzTtEYMssAWo9uXG+9TY6MB47oXjDm/lB0iPS9sODU5bSsIhh15pztAIcgqWhF94u
         j7Q+BiCKuR1kF2WUrXgopzQNefniH5lyBfPnySarmzsItAYI7qy1FSR4i2/kWywBCHMF
         NrQK9ZuBxe9wb70JvFoC9q195CY45uB4MYzumztXSNgCh/NoosE1azuZnlVTO5coZIfH
         tGVcuj4Qmytt1/Cg1OZ4yQ9pvoG7sIyngTRaQh7IcCNp233+W08WTvxn7rgYOSpe5sDi
         ZUgg==
X-Gm-Message-State: APjAAAW02Oj/dNetuyGebY5Vbt3WfYW4s1/X6s20TtTM+5/L1oRxEyao
        6SUZC2UqqSQ+UHiqcsfN1xMaartyp6elog==
X-Google-Smtp-Source: APXvYqwO4lXgp5yEAS367rg1THWfu2hMWcTKowNyUMvcytbNE6KYNLHic1wbFNJCoe0VwFTeOzhjeA==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr9002527wrv.264.1557931740019;
        Wed, 15 May 2019 07:49:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x5sm2671519wrt.72.2019.05.15.07.48.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 07:48:59 -0700 (PDT)
Message-ID: <5cdc26db.1c69fb81.86a1b.f62f@mx.google.com>
Date:   Wed, 15 May 2019 07:48:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.43-114-gb5001f5eab58
Subject: stable-rc/linux-4.19.y boot: 131 boots: 0 failed,
 129 passed with 1 offline, 1 conflict (v4.19.43-114-gb5001f5eab58)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 0 failed, 129 passed with 1 offline=
, 1 conflict (v4.19.43-114-gb5001f5eab58)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.43-114-gb5001f5eab58/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.43-114-gb5001f5eab58/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.43-114-gb5001f5eab58
Git Commit: b5001f5eab58fc1a2a3d5dfc90fa9bb513c73d8a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.19.43 - firs=
t fail: v4.19.43-87-gc209b8bd5e5e)

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
