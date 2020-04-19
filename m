Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950571AF74E
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 07:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgDSFuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 01:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgDSFuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 01:50:03 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AEBC061A0C
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 22:50:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x3so3304698pfp.7
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 22:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=53tdCibBqBSFLrXwY1Q3BR0H6uJy/Dcce21VpCQsK+Y=;
        b=pcDyNAAm/3jZCfJlYWrRXBDMBcvX79po3v8f40kVVQSs7qFWlG3miTmTiwdj8L3CFi
         OMQcHSM6Rp5/NqhxgniBr1MRy+uQItRMqPZWBLK4hPNNheipztTZAEXlFcvqIsrHrWls
         vkfHHKuSF4mGJ2NZO+TycOv8vehB1/DGlLYmp55lYw93vsvwpcWOocxhwctRmxfCMwnI
         n5xAdQ2zpxHk1q7sm9WgAfivcQMoZXBX3Jy4JZU+cO3a8MBAIfgStXcoNv8dxIcCC5Tw
         9y6ghVUCCa9QmHojoKTTe8/A4wP1JbrY7sIFI2YQFwTLHnsNHVxMflDpHFMuGJ1E8HAT
         B+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=53tdCibBqBSFLrXwY1Q3BR0H6uJy/Dcce21VpCQsK+Y=;
        b=sdyAUl/2//XNcejqfuOXkspsveX1C0Znpnwrb6rCMHSoQgz11CVyDV9Z4r50TqJ8+u
         LQSeGt1qsIjFY/wFCCNnYeruNc5DX14ZtrQFEZKJ6H091L9MXejDOKo5867o6W1bVM98
         8f6MCMuGwRRv0sny/OEtJ8a2tjWnvtGgzTL+pLqgdDRSlCP163ercnqA7f47CjLrLBTu
         qeYFg4tRo3K8YFiWLbEnR3VaIzjwafvi7S8mpahPtsNhFZIJ9SKDSvqx7N2FXE82mRth
         wIdvce3F+hhefEtITObIlNpDvyveNkg/L+ANwZZVe/b1qH8ZZP1WAbJdehSNF9zjSnUP
         GQ5g==
X-Gm-Message-State: AGi0PuagB1DodHHz/akdGJ6ogtXZlgf12E1vVvyKzPM5+Vf/oRFOCqAy
        Id1L+m19y831EVUxUlfE8EkE9gnG880=
X-Google-Smtp-Source: APiQypI6JWeRevPdrfsSlzPH67xL4/VTrOpAUCcKJgbTL2gUk3QC5X35aTtynnqpKhOhBEc4Dglp7w==
X-Received: by 2002:a63:7805:: with SMTP id t5mr36516pgc.141.1587275400859;
        Sat, 18 Apr 2020 22:50:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f10sm4832595pju.34.2020.04.18.22.50.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 22:50:00 -0700 (PDT)
Message-ID: <5e9be688.1c69fb81.1f77f.fd7a@mx.google.com>
Date:   Sat, 18 Apr 2020 22:50:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.6.5
Subject: stable/linux-5.6.y boot: 127 boots: 3 failed,
 118 passed with 6 untried/unknown (v5.6.5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y boot: 127 boots: 3 failed, 118 passed with 6 untried/unk=
nown (v5.6.5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.5/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.5/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.5
Git Commit: f07f08b09f05e371d988f83f06d41be4551bc68b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 81 unique boards, 19 SoC families, 20 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.6.2)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
