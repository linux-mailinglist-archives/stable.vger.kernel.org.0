Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDEAC45DB
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 04:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfJBCQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 22:16:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45586 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfJBCQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 22:16:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so17640761wrm.12
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 19:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uwxTtv+PWfH2D9J6Lvq8kRmoIJ8mz2/f+Y465lGmITY=;
        b=Ork+DLigoy7Nu/8v4a9Q2MLkNzMYYhVWAEic1nYSb5RwvoKud5c51GMj7IjRjyh90A
         wSCY5XCnZLowHeNojRuSFUA+0McKByia6GinmnO4Z5iaSjHJ2Gf0lcnRxYn66SwKHFX6
         wO+IBxXIUxMj+ySx8aMqq9LD5IfUg7dC9n33JrV6WKx2NqbyA8UDRSIqpOY3Tw8VW2p0
         DeMDSmlLgQJeOSL7EH769SgeZ/14M/oxP3O+Nt9LlX6XPescYcc8FfWmGVWkpL1PcqcQ
         H3H78pja3xbwP4sH9VhbFUFQvbgQvNhCwI2/pP0B+b92otb32V+27Om6ZvyVLpRJ5YT5
         woDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uwxTtv+PWfH2D9J6Lvq8kRmoIJ8mz2/f+Y465lGmITY=;
        b=Yd52Sf4WtiHz5hhxcl0i9S6y8eRnLslIsxvoNqsGEr9RL+al0ReWrY6TJcPs8mdJN1
         y5cO4E5UQwjdqEQvJhKO6vg/MgMKKQ0xw58JnhnQseQMMUnzjwyHdvqreuNGDOWd7Xni
         4EKSESTwJd5jEtz3+kfdNBsEMC/JHQI3JpS6UwS7UV/uTRYVNcQOMIy7f5WUFW9YH2fM
         5Z7JEulZ6+AasIBiQ/W7TibvFppr1ihSXeOq+AYvMajFzdW89vpzfmAsMoCR+L8iUI03
         d0qmZRu2zygK1g3NvNE+VjQHBjzeXZJlIYw0xLhODKFcp9iwgHcqfvyP8FqL/KWreCBs
         lHLw==
X-Gm-Message-State: APjAAAUreZBMWKMmG+PU9Dqfmo2L/0m3AFmpsXsaewWRntwfBUdmqkfT
        HDl2M4NiV9MNoGfL6VDFegZ+GebLEWTxcQ==
X-Google-Smtp-Source: APXvYqxyHh1jAHu4I9VmqY28Wl6vwKTnwfEchX+WmQDrCajwdUYi07TqFk5zAXsNz/MZSf3nyV/YZA==
X-Received: by 2002:adf:dd41:: with SMTP id u1mr593113wrm.49.1569982572188;
        Tue, 01 Oct 2019 19:16:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z9sm28390908wrp.26.2019.10.01.19.16.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 19:16:11 -0700 (PDT)
Message-ID: <5d94086b.1c69fb81.e0657.70ac@mx.google.com>
Date:   Tue, 01 Oct 2019 19:16:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.18-228-g92d573180e7e
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.2.y boot: 84 boots: 0 failed,
 83 passed with 1 untried/unknown (v5.2.18-228-g92d573180e7e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 84 boots: 0 failed, 83 passed with 1 untried/un=
known (v5.2.18-228-g92d573180e7e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.18-228-g92d573180e7e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.18-228-g92d573180e7e/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.18-228-g92d573180e7e
Git Commit: 92d573180e7e14ebb9ab362667123b087f7563ec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 47 unique boards, 15 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.2.18)

---
For more info write to <info@kernelci.org>
