Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46FC149A1
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 14:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfEFMe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 08:34:58 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:39718 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfEFMe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 08:34:57 -0400
Received: by mail-wr1-f42.google.com with SMTP id v10so4758625wrt.6
        for <stable@vger.kernel.org>; Mon, 06 May 2019 05:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vgex8qbr4QYXSHfW6OrtmKUdrxdG62gaRmMHUu2MsEs=;
        b=jJnt58Uevc+qceQA7wblCujNPNKMhsM5CnsWphF7Drd23ByXlsT39vZkrJimW3oE2b
         fgD8c9HWLnLFB4F7aDygCOvyls7nwCW1ZrDC4MxKJ3XVjXiRqZu0CkcqU/hUdu18CGhD
         xa6AOzwRCabvPHwOT/S5IZROjWm2m3imWJhuxeTXKXWEAPTnWHnMkrqBKZvl3edwDlwX
         g3k2sVkpxrmH9MfTHwKeW5Q88LK4hcVwd0MsuJQuvRwkUzRsCU/xpr5FhhpiT2SPRU5L
         tmQxij095b6btdnjZqg3SHjZRfpZej1i9dQoKKKqP7Mebgnm3noLdACt+Bz4CQsya5qb
         W1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vgex8qbr4QYXSHfW6OrtmKUdrxdG62gaRmMHUu2MsEs=;
        b=t7KWuuENRJgj5P0q/gWWQJ+OK0xo27Gd2YPqXfgO/9l6J30pfY+kVNinZXBDout9b0
         sV0bUIK+1zgFfDksyyKhKqxe3nHJeKfNdPiilltvtRFZkErtdWwWa2CsrReucah0WN6B
         lN4IbeuGOVWpRJX05O+XdGk37dlj9qi9AWW5dNa04vv5SxVaBEhssZvxsMypecc4ZHJd
         lwpLXocWTCtXsba+1FQAujiFM+JRf1rltjqKGUC/XsFfdaAutxfJbtXH+W4VsvHblgr1
         qiLWx29m1WyqUPRjQDsCXIBwBEmW0iS5esbtYVfVmDeO9g5FtIjRLqiBFmjMmhueiYTd
         JggA==
X-Gm-Message-State: APjAAAXdGUEzMOP6ggAFswrYRoSteKtvpDdjbLoacB23OCThJI4+il5t
        xxhqeQxsQwVny1uacMMDjvtKKAezBYtEYA==
X-Google-Smtp-Source: APXvYqw0pNqWYDGoWjgaIbBhuAW5J8QbrgNt89lPYpcSseWX1ALFtiV2gvRAdFaoJVZYuFK7oXJfJA==
X-Received: by 2002:adf:800e:: with SMTP id 14mr18377805wrk.303.1557146095978;
        Mon, 06 May 2019 05:34:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s124sm16080671wmf.42.2019.05.06.05.34.55
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 05:34:55 -0700 (PDT)
Message-ID: <5cd029ef.1c69fb81.fb56c.650a@mx.google.com>
Date:   Mon, 06 May 2019 05:34:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.116-59-g3411f7e68071
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 122 boots: 1 failed,
 118 passed with 1 offline, 1 untried/unknown,
 1 conflict (v4.14.116-59-g3411f7e68071)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 1 failed, 118 passed with 1 offline=
, 1 untried/unknown, 1 conflict (v4.14.116-59-g3411f7e68071)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.116-59-g3411f7e68071/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.116-59-g3411f7e68071/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.116-59-g3411f7e68071
Git Commit: 3411f7e68071605c59387e65eda0d685e9561931
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 24 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-7:
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.14.116-25-g653fd35b=
a15e)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    exynos_defconfig:
        exynos5800-peach-pi:
            lab-baylibre-seattle: PASS (gcc-7)
            lab-collabora: FAIL (gcc-7)

---
For more info write to <info@kernelci.org>
