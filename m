Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5C71AD39B
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 02:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgDQAVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 20:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728069AbgDQAVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 20:21:44 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566F0C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 17:21:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y22so284900pll.4
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 17:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J131nILW5No+5h3Bx/DPkLFBtmdas96dAYzwascYZ44=;
        b=kRYyzy5UbjDuJjH6khRZaq/K6mc3l/UZ+U+8KCTbs9nvRo1pRoAMc8x7e4Z3uh2r7S
         qTU90M+oGEa08vM08+B4/cB3A6fCBo/KMm0WExJ89xYuvI9YTaP3wpHArsbkXqpyO/ux
         IhhEpovGQrtNd+7X/MEWwPMq1iUT63cbjDGbDpH0sgDUKYpsM/BbaZt4rNAuY4/i0hx/
         8JkFUUuYeDVPiY9PTm6RAHjMhkpgAY9cun0BRhsrXVFSrBU9wvUXdAp4HWXAyMu1bjef
         4+PUN5i2LJChePrJby/0k0W+epysLqMNFCSbwcUJEgJZfduqfd5UdrS5RatBzlDCO4R6
         Whvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J131nILW5No+5h3Bx/DPkLFBtmdas96dAYzwascYZ44=;
        b=t5zjtx9CdQTrtHjGjFxyi/lkqqQHoa5CNtseMjRVEoWGiCaZsOOtbbL5mu4YwsC/JW
         6OuvUct2G+fRxHGXm7DI7bSKCW7eH2B7XBcyqZXeMDbivNLfcAdNZA2ok73Ews/NgeQ7
         LhrBfxxVFZhseZmeGA85Xh4VDrwxfVyrevYZ8IuuXHu/scZ4+GRnZyrIUPNNH9BKby5u
         xUzNBjS06IMk3VLfHW1CDp9IfDqzmQlXSC/iFLQfxo5lrfXmDgHdrtsry/npTHqAS2F4
         Dmff3lL0D9HpJbCM+6CU9GMD5KMZPioJVblERY/i/2jV6kQT6k82aAcSBKtvGhJiK5D/
         Nz/Q==
X-Gm-Message-State: AGi0PuYZVjgfyfRD4msSnZCG6um5cCPQMyyX8hXYti3TjrmlYE3ddQ4L
        pKQHQFS/ejrwMV3w66O65X8JlPZpJsE=
X-Google-Smtp-Source: APiQypJm6v0SWJoFDOgaG8ozMkysrcUf4FjzHnkW3PGVZPakQsq4L3CWLOWXCjweEOeImt/d8p4Zzw==
X-Received: by 2002:a17:90a:2602:: with SMTP id l2mr1201421pje.110.1587082903524;
        Thu, 16 Apr 2020 17:21:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l10sm3542246pgn.36.2020.04.16.17.21.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 17:21:42 -0700 (PDT)
Message-ID: <5e98f696.1c69fb81.fb9c0.d6ac@mx.google.com>
Date:   Thu, 16 Apr 2020 17:21:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-203-g287f80e07bbc
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 144 boots: 1 failed,
 134 passed with 4 offline, 5 untried/unknown (v4.19.114-203-g287f80e07bbc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 144 boots: 1 failed, 134 passed with 4 offline=
, 5 untried/unknown (v4.19.114-203-g287f80e07bbc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-203-g287f80e07bbc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-203-g287f80e07bbc/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-203-g287f80e07bbc
Git Commit: 287f80e07bbc28d3a2a25d2b53674c912d515376
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 84 unique boards, 22 SoC families, 20 builds out of 198

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 68 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 34 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.114-203-g=
06906a122520)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
