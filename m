Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491B025A41
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 00:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfEUWVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 18:21:02 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:43002 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfEUWVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 18:21:02 -0400
Received: by mail-wr1-f54.google.com with SMTP id l2so29579wrb.9
        for <stable@vger.kernel.org>; Tue, 21 May 2019 15:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=31GgbMEUC97EdKQcx8mFfdEwH4VWKs3J1JDmeDCBsmA=;
        b=Lv6n2zx9aEqvgXpfDMvYjgZKR6bcAC6eCwe/wRVJw+6ZPI8hRSFB+dFucdhTGwlMB8
         iHcOjRUGNIsQDqnsWzTijyncLlXB2b5DC9b+pTVvdgUbUE3eqP6hPg3eDDpYiWCDcrdI
         TR5e/o/A9gftqoT94TcMncgsOjPI87RTtvwN26U15ZvCaBjxsFMo8Aa7arM78O3CJB/z
         tMOM7W3P6mqNR+t/Ts+dCrX+hn0bPEipzHgIpKrzy62/xna58W5C8B6arpvZeVgh+eBR
         ykx862ZcPQ6U46A0qlAA1/Hu8UtcEwu8H7Toqm3SkYctyOWiY5+5GvnJqIEtRzRMl/kn
         xyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=31GgbMEUC97EdKQcx8mFfdEwH4VWKs3J1JDmeDCBsmA=;
        b=heuiGDXfILrPqdWkgtS++oWH1t/BAcEWRaGyMK2hpP889OB4gBjD8Kdg3VBd6gk0al
         r4n9BYa66PM0Mu9rLGVdRSpkGeAhnNsPBsl2DIN9owGxB1HuDJFHWzQ5JvtavN7LoMNj
         Iegt9LH0NESaDufpyCybc92jirsSl/zBtubjXjOi4AjrWHcxkOo2uAuPp17urHICI9Fe
         rCJlbJ1gbsn/Rbr2bmXalk2gPOTCaYMWX8S8lSbN9C627wc6M4C0tBuDOiqBowpV6ihP
         BpTCholypD6WOmpHrAC5IxiurjD1oxdmUfWBVEPbisZoWMiJG7jcSWCSDzF4Zji7fpfG
         2FEQ==
X-Gm-Message-State: APjAAAUH5LlduIif+7ZjdP7Key7B8Ac+YDj0hchCo6ZqU/QbAkoXidRx
        XoOrMSGaenhC60ACTGhfXxenERj+WP9N3w==
X-Google-Smtp-Source: APXvYqzYWLw8hGRyB0/0ZkirOrB49GlAUNAs7plVDFJiZxjOOIr93lgbLWJIsBYlOgl+cjCzb0SOrQ==
X-Received: by 2002:a5d:4886:: with SMTP id g6mr1342229wrq.108.1558477260352;
        Tue, 21 May 2019 15:21:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v184sm6901858wma.6.2019.05.21.15.20.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 15:20:59 -0700 (PDT)
Message-ID: <5ce479cb.1c69fb81.842a8.27ed@mx.google.com>
Date:   Tue, 21 May 2019 15:20:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.3-126-ga8112defa801
Subject: stable-rc/linux-5.1.y boot: 126 boots: 1 failed,
 121 passed with 3 offline, 1 conflict (v5.1.3-126-ga8112defa801)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 126 boots: 1 failed, 121 passed with 3 offline,=
 1 conflict (v5.1.3-126-ga8112defa801)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.3-126-ga8112defa801/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.3-126-ga8112defa801/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.3-126-ga8112defa801
Git Commit: a8112defa801e2b32d9da822880f32966d30158c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 24 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.1.3-129-gcce3bc9ebd2=
f)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
