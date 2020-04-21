Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D605C1B31F8
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 23:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDUVco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 17:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgDUVco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 17:32:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DB5C0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 14:32:44 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kb16so1930020pjb.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 14:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eYl3q6GKXCP5i4Fqa/PM5lc2yyd/sfIc3m3EI9bNLTo=;
        b=MQkVIV+vyNo2+YPM6eUHEXrW5uJ/z6P3mvcu/DyG6zeEaDCho+XlkWr2RqprTsX9jz
         cFI4axlwfjUauXXYK0cXqHmW3g9X8kjjleF7oG1RjjhzbU7zvHa7+swxOepsQbMriPze
         tvL57nhcpnFx/wbdp5YLrfurfKNVzD5CSgTy+EYqkCu+py7ki8iTbdECNgo/wO9f/KIH
         f4DY+gfmOxY5HIRncj2QKypFcbfmD5mzc6vYMDJAOupcxBZR7BFfJ4iziTon3evduCUs
         +NLQ01d0WyExb+Dpvng+ARSzRZ91ysfBoi3rw1NBLVvXs9mPJOb353DhTw0fAoN6Tqyk
         jmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eYl3q6GKXCP5i4Fqa/PM5lc2yyd/sfIc3m3EI9bNLTo=;
        b=Fnmkfr/mFrc59boPimOUkFkcXy9niOCPiOrbvF/SbD499RYtibSeGgTlF/OqtlP9bX
         MS1PLBjqvYyFSLG4FXDXGmqbcabodhLkRN7FgaP/tTSHEQ3TQKE+WPk0+6Uc36en5bOf
         cxwp7XIjsbGmNAyzGvBxnX9Vet1TMnQZq6eQWHYDbe9YCFvoomaSDAequDe0tNgMVTpW
         zrOaHFahRwK7UZ0+wgVUYfJ0yVeaSyyylpkUIFNii8rs404hrMldKbMndMrffqnH2NYW
         DVI1OIiArVeMOPo5YoPul4HgsTCFJzs5tkgvT5lbHEk/10wZ7xRSqBTWwC20v8KXdhEd
         yuAQ==
X-Gm-Message-State: AGi0Puat8mPnXJ8SCRBykPMaOR469AkiaIl7aQGnm+YVfPnuHuAOl7EQ
        PZ/vnHMLtR6FpPJXpDYvi+xIinxysyc=
X-Google-Smtp-Source: APiQypI0JQaty+XUkROKNoRxxHYQgKKeRFz7sJEqolHl/rxkoN/OU8pUQKBBbMgUkWuEdQ4G7iwuvQ==
X-Received: by 2002:a17:902:704b:: with SMTP id h11mr11194241plt.125.1587504763401;
        Tue, 21 Apr 2020 14:32:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 18sm3407805pfv.118.2020.04.21.14.32.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 14:32:42 -0700 (PDT)
Message-ID: <5e9f667a.1c69fb81.3480e.ac23@mx.google.com>
Date:   Tue, 21 Apr 2020 14:32:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.176
Subject: stable-rc/linux-4.14.y boot: 86 boots: 0 failed,
 81 passed with 2 offline, 3 untried/unknown (v4.14.176)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 86 boots: 0 failed, 81 passed with 2 offline, =
3 untried/unknown (v4.14.176)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.176/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.176/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.176
Git Commit: c10b57a567e4333b9fdf60b5ec36de9859263ca2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 57 unique boards, 19 SoC families, 17 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 73 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.176-136-ge60eb60=
a661c)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
