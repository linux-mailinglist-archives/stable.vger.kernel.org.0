Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8DD107E32
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 12:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfKWLcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 06:32:09 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38576 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfKWLcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 06:32:09 -0500
Received: by mail-wr1-f46.google.com with SMTP id i12so11743807wro.5
        for <stable@vger.kernel.org>; Sat, 23 Nov 2019 03:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4fA3z4McOB2u6JrUQUn/k1S4aqAazJDDcMV/K1foUH8=;
        b=1fvRii6KipSzo9MQz1adaIRlK2CFkXZnlkWtvTAUstn9kjs4NI9/3IHbznHiapoaz/
         Zz9PODXPoXtKnCTaP0w+hGms441w+j2D8hfRhO3JQFPtG48l2WWxQnEfRUnpIExtRb3v
         a3/SJh4xL5N9fpx7sKY957wB4/JznoqPC2M7Jtc18mWIEx+7DAulUqso5MTrFabIMrH+
         kQV5VayLZpySe7a+40slNla5OCNwRczfd8UclCYGeDRtR7Dl20N817rCgZCPgk2jWcZr
         rn61DLyE/5K9HTrpe885ZvPsCp2GMNr0swBZ8bZKUNXCgqfQSoa7u3O413rcSCyEAc5E
         R8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4fA3z4McOB2u6JrUQUn/k1S4aqAazJDDcMV/K1foUH8=;
        b=swMS4WYNPyYlZ4MjWzJXSIj+eVpBFdeLyOjvdclfqhvHJkolEezv5nqjBUnksDZr0w
         ujOCRdLhVUpCLhzIIitewdKOkHf3TM4ASN53cjbEK1x/BKmvNMJJA4QE13Bw3fpdcZmK
         Qgyqm3dc9jv/4ti+equSNRKQ1OqJrJupdn/4Pgul0/gpk59dghdA8U4xgHhGxlHu5nIU
         HeTC/wYmIXUIVJrP/NgkGryZQHqbyRgN5B+53PrAUCWAzwzjEWzzicy10jcePt5Ew1Aa
         /Ot3PED3WIEzshiC7yAiDP28h4hRD0lzwtU2DGF7cZ5lrwcwVlA0GfIKJoNX4yuIEjKm
         7lmQ==
X-Gm-Message-State: APjAAAVsaGHrPn888Wl0gbFkThwcdNxPwufkCJz2ufrZ+vtzMVR3chTa
        FgYHEE329hrEiyzIRaZlCD1t/fyF5o4l9g==
X-Google-Smtp-Source: APXvYqxUe22JCoZGzk4saU+dGFo4YnulrsMDKEX1e+7dGE25YwIfbx55CI0eaDPH5braDBDD7p4QJg==
X-Received: by 2002:adf:de86:: with SMTP id w6mr803524wrl.115.1574508726848;
        Sat, 23 Nov 2019 03:32:06 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o133sm1634400wmb.4.2019.11.23.03.32.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 03:32:05 -0800 (PST)
Message-ID: <5dd918b5.1c69fb81.ca527.67e1@mx.google.com>
Date:   Sat, 23 Nov 2019 03:32:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.202-159-gdbaac4c54573
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 50 boots: 0 failed,
 46 passed with 3 offline, 1 conflict (v4.4.202-159-gdbaac4c54573)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 50 boots: 0 failed, 46 passed with 3 offline, 1=
 conflict (v4.4.202-159-gdbaac4c54573)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.202-159-gdbaac4c54573/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.202-159-gdbaac4c54573/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.202-159-gdbaac4c54573
Git Commit: dbaac4c54573d428113956f3e4c56f9d94920c28
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 35 unique boards, 13 SoC families, 13 builds out of 190

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
