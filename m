Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712C560C15
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 22:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfGEUMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 16:12:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34264 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfGEUMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 16:12:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id u18so11042780wru.1
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 13:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cksq2dR7cOu8h0RN6pyFQfsZhORmIU1iCI9a1AXqw5U=;
        b=lba1zufMV8W52IIe27hKWWxP4GsUkxRiVGnfxGoZKNlUshZyocprvHhkCxkZmWbCA+
         rlsFd8MOTwlpZKJ1Sw3n4aLjFrOQfvF8FGvzovwe5mS7q82YovY7vx1SubOf0RrauPIE
         F1ZieBxcBe45R2z72H2V83e+RoFKA/zDFOIoFbviHjoRDfQaYCD/yrpsF2mXsrMfcExV
         jwmJJcOQkahSMKRS06TL41f2m3NVv7TyJz07LJT8cl/31R28sL8XwTcchOCiqxvdRhFO
         xhm2BH2OzJWsZEpaC+oYhYFsk3AF7oj3gZdhaDjXY7UOd9HAuw3f+b9mg06OdJkl/gPB
         fR3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cksq2dR7cOu8h0RN6pyFQfsZhORmIU1iCI9a1AXqw5U=;
        b=qrg3FUEMBUxsth5qvfOmFn48IOiiMcCaKsoS5t7Q1UiiLuLC4l221N0PlQcTqp1JST
         +oJ30hpDMsLyyvEy4OTl2gk+dms+YxhBKE+PJOHOVTmawb+7THoxjfIECsT+3A1XgeuI
         0BGVjQXRYALxskjPkSjhYYW++wIK0jiexVo9QrLfwtYMwvk8i/CAe14zBeoKu0NmoO98
         q185L7AAjQF/VjMackaCiSScZ+T3Vcg0jKGw3Yg49KRUeqeGWhLHkfYEzU28aKYVu0K7
         cvXGKCVidHYCOKI34EOeus4EJPnGQvF+jJO9DMwQ2BvRgnQPujzvpNccBm4EgAX03m5B
         oqZQ==
X-Gm-Message-State: APjAAAWNV4iPRa9UVdQ8Uo7HVQG5+aVzXABn28liOhN/dreO2TFi5ndg
        Emi7hFIjIfKlnzXq7BqwIwaaQhqxM/wRmg==
X-Google-Smtp-Source: APXvYqwvSDV618H8Z9BPsGu65W6ADAkqVBcKqOqdp49n6/TG5FfZ3vX1LVwiglLEPD47VDqBtsQ75Q==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr5257980wrw.138.1562357537480;
        Fri, 05 Jul 2019 13:12:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q15sm6695519wrr.19.2019.07.05.13.12.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 13:12:17 -0700 (PDT)
Message-ID: <5d1faf21.1c69fb81.52a43.4989@mx.google.com>
Date:   Fri, 05 Jul 2019 13:12:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-69-gb12a932c6c2b
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 100 boots: 4 failed,
 95 passed with 1 conflict (v4.4.184-69-gb12a932c6c2b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 100 boots: 4 failed, 95 passed with 1 conflict =
(v4.4.184-69-gb12a932c6c2b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-69-gb12a932c6c2b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-69-gb12a932c6c2b/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-69-gb12a932c6c2b
Git Commit: b12a932c6c2b8337027f7b4fbcaf1cc2c703f3c6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
