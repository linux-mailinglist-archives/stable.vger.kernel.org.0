Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6A4AC2CD
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 01:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbfIFXJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 19:09:37 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:35606 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731231AbfIFXJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 19:09:36 -0400
Received: by mail-wr1-f45.google.com with SMTP id g7so8161488wrx.2
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 16:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sXdU6oDeFBzDfxa4Kjk7n88ceeJ79d9RUxWTE7pG7UY=;
        b=cAR3tSbCEXXNG5VMJNKHFIRNEYKghQF3B06dQMZPWYlJujHR+JdKEi9ahFmvbtBuTT
         v/9+iPi+SVCCgXoK7NZiu67lvrezYO97oWztFfDGnaWNEF7Zj1nV+StARR+UVD/ramRw
         cMdZ4Etva+oc1LpM6eyXkmUQiyq2AVbyc9jgEPImtuqBpb1NK1eIFOTwrYl7VsxguN1i
         4P/KjSYWMwdYGCuQc0xltMzWteybSSNzClL7SsjCEbPBrZq+dUd9zHc5D8AQWY8crcdY
         JZGnVVmbPhrr8KWURJAnPR424NcaJrj1wMqbdPdhZO4edSAoOLRdC1AS9ldd/NA+44JN
         vI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sXdU6oDeFBzDfxa4Kjk7n88ceeJ79d9RUxWTE7pG7UY=;
        b=I/4p7MqrELu0gh//S/p5pNrCsBwo8d65/YOYtifk96/c1YVM6gqwdMgpp1leGLyXT+
         bRboc6A2K5mrJRzxw+aN5eR3Jqraa4FydUSD59os4lfkQRItr+uIpCcQCQuzkwkWKOq2
         s5wEBBCOdLccNxp41C/Fj3vJavCzwLml8AWwUQBvPaA2pPY/V+7TcVPXt3lMWmB04S7L
         AEloQKNmH30jp17zoWqQdkB5ggISCNF8aZDKIIzR2O9QLxWCoj+dT11CRYM+Hmr/B6gC
         oY1glHoFeKayKiyAJmk6dYr35RPD5XMpz3fJrqV99LC4k2liUKAqwY81N7V5sJvlDUQD
         1PZw==
X-Gm-Message-State: APjAAAUbUoVTV4G2TqdkGj7/Pp/yH3Vm1DzeLUc7bNjNDBKFvUotqUk/
        8Yqra/Rd/iWkt39w2iVT/PlqE4JSy6jhgw==
X-Google-Smtp-Source: APXvYqytR1//P7jiaWZU7G5sSMUf2o4hCyqwjCvpWIhES0LdRxfDoLVkYTwAW3mB0VL/Ry3ggfShgQ==
X-Received: by 2002:a5d:6647:: with SMTP id f7mr9209533wrw.170.1567811374661;
        Fri, 06 Sep 2019 16:09:34 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b15sm6879518wmb.28.2019.09.06.16.09.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 16:09:34 -0700 (PDT)
Message-ID: <5d72e72e.1c69fb81.b58f.05de@mx.google.com>
Date:   Fri, 06 Sep 2019 16:09:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.71
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 93 boots: 1 failed, 92 passed (v4.19.71)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 93 boots: 1 failed, 92 passed (v4.19.71)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.71/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.71/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.71
Git Commit: e7d2672c66e4d3675570369bf20856296da312c4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 49 unique boards, 18 SoC families, 13 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.19.69)

Boot Failure Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubietruck: 1 failed lab

---
For more info write to <info@kernelci.org>
