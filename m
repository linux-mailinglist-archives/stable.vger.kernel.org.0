Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221D7133B9E
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 07:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgAHGSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 01:18:42 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:52850 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgAHGSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 01:18:42 -0500
Received: by mail-wm1-f52.google.com with SMTP id p9so1193252wmc.2
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 22:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7gsl0ypkKYSkmhlhHXB1uqOCIfk0usiVMtgzrFHz9o4=;
        b=ZEWUN+xZfAoPTsp9tZftQ1WyD8eaDDvsXmDx4Z6jLzZLktXuQ1hNaAYP3aen/0g36/
         3FQINBBF7AAFOWHd+wtarjcUMhhsd6mFTtIkRGbJ1CAFiGpQhSlkeKzkEVoC0LEso+aE
         HToxvBShN3enuSTAvV8wRrnSj8r397JkFNH4oZUjACWbPLEhEVYXXdufQyIl7AQPC4iG
         igTWSSmlURVR/A72Ja0gndP2EhlMcv55lOPpoxq/5NlgeeC4rvPT5JQ67Bc/CWMoi71I
         nC28kRyWND04ZduIx4Srkl3fP3kBR6sW219EDpgtbZxFbk6D9cpZ/Ww7c5+sHcuTuOce
         yzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7gsl0ypkKYSkmhlhHXB1uqOCIfk0usiVMtgzrFHz9o4=;
        b=Sky3SwQfoCeyGS1H39utTnHvFLvFq/i2SYQCJQ4PdwWAP8j1UZw3JBxL+Urb//c8GF
         fT8wyZzHpIsqpzMRAmM7F9B0tRFKPU9YTinqWQsrz3Q500EvEHQliDjtdPwRy5//EoXF
         aGS7iyhf7txOtdyGOBPWwr7uUZNNbeVsxdTjUoGRA9OpZayoQAmbA4XSSWp/zYTtJl0/
         /b9qDoDVQ1J1IGDXNQOXqR3cHgmeWg465uxuUptrqXs897GBAdfE++cXgBZyMKaYxi9U
         Rr9Dmvi2CJ7R4anQlHL1oPUnbw5oR/++cgz4dyIt/m4CXcMBsAY9HuGR8KrFrcOq43+z
         T6fw==
X-Gm-Message-State: APjAAAXcFm4xgah6g4KtsiPBckBbH3zrN44iCY32mi7uqJ/A4DDAGqQZ
        zn17YCGqATlnLJQ3hbQqPdJQNVOd++qOvQ==
X-Google-Smtp-Source: APXvYqy3TtCu65zHmtIhRKOwGir9xCMNqk/HIuytvCSk4ZnzCjKK3Z5xrhlFL2fX/QsgQMbcVbkm9g==
X-Received: by 2002:a1c:22c6:: with SMTP id i189mr1865652wmi.15.1578464320273;
        Tue, 07 Jan 2020 22:18:40 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z8sm2810261wrq.22.2020.01.07.22.18.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 22:18:39 -0800 (PST)
Message-ID: <5e15743f.1c69fb81.f2337.c8b8@mx.google.com>
Date:   Tue, 07 Jan 2020 22:18:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-172-g500b760fc4db
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 25 boots: 1 failed,
 23 passed with 1 untried/unknown (v4.4.207-172-g500b760fc4db)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 25 boots: 1 failed, 23 passed with 1 untried/un=
known (v4.4.207-172-g500b760fc4db)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-172-g500b760fc4db/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-172-g500b760fc4db/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-172-g500b760fc4db
Git Commit: 500b760fc4db3e3b15d24918889271efbb147686
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 18 unique boards, 6 SoC families, 8 builds out of 190

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.4.207-160-gd71a25a4=
4549)
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v4.4.207-160-gd71a25a4=
4549)

Boot Failure Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

---
For more info write to <info@kernelci.org>
