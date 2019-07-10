Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4E64632
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 14:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfGJMc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 08:32:26 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:51858 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfGJMc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 08:32:26 -0400
Received: by mail-wm1-f49.google.com with SMTP id 207so2144256wma.1
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 05:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HJ12h/vt+isZPvkFOcNxFMEIvb9v2eRHx6WmwKkB7W8=;
        b=1U9WQAJHqSlDyBx7G9pKAcX//oi6+uWu559jqXFoUlMKP08y6/eGx+WW1mrJAL8qvY
         l+WdAtOd/aZkXiJM+nUzjeNv8trSmwHP/uEe6eRQm8u+KRfj5J9axhYxJ3ekcOIix9N1
         ib0r41t3JFXRqX/+FJ9TaKMBWCFMWJ9J5W5mKLZ0YhVtgQfI8/Vv3NoQrcGUmdUhkJN6
         +8WsleGZ7GpDI1j4FPtYjPEsoJv/jyq4NUxFlGW3BNC+Bwcth9YACUeVXBSg76v3TLdd
         8YRZnXKjtxV1iWGvCbLSFFD3rjLm09sdvfnIKMoB3JDn7x4GIk6BoYkI7tquvHWmbLA1
         Lzfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HJ12h/vt+isZPvkFOcNxFMEIvb9v2eRHx6WmwKkB7W8=;
        b=sjVgOJPj5yRK4Fv8QJUUtNSXdOj0zd/pOQnI0YxgpYyWmGHb8VPOjveFiPbDNRhubV
         vE3qRGQ14SzYh9ZCHoTAvabVvO2iU30pV++bmvM6WMHb22xoOZzc5FyX5tt/l9vxU5pw
         PFe4eazBsNbXERsudGqeVN9MAYpNZ5UcGEyhun8/AhI3vIuNyOlcUSZS+OrcsJi8Otth
         9fJmhEWYogS5+H71yoZbTOk01K3agHPaHUyTE64ardhdzAXMO/PDKjnvcM+yuJaFwOTs
         7G0yzCFUfogUoqSicKn4so107jxnZ0gqnp3BBtBHC/VZ8oSvgZ+ZdaJkqZeKiGTaDUdl
         42jQ==
X-Gm-Message-State: APjAAAXhaWk2y5p8ZNGtNypA0znQpBSJqphrK8V9hpyO6AUzV4gDnvBX
        54An4fEgOTXOsMzyjNYH2KbWZd/wM74=
X-Google-Smtp-Source: APXvYqwt8Gxzv4XBnjlRXd98O6NwIrqD2btTDne3lSpirB/9Ibg9bfdeUkDQjm7hF7Rg18S3ZHUfsA==
X-Received: by 2002:a05:600c:214e:: with SMTP id v14mr5472424wml.96.1562761943676;
        Wed, 10 Jul 2019 05:32:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v124sm2222103wmf.23.2019.07.10.05.32.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 05:32:23 -0700 (PDT)
Message-ID: <5d25dad7.1c69fb81.47d81.ca53@mx.google.com>
Date:   Wed, 10 Jul 2019 05:32:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.185
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y boot: 60 boots: 1 failed, 59 passed (v4.9.185)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 60 boots: 1 failed, 59 passed (v4.9.185)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.185/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.185/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.185
Git Commit: 9c51e1102c95e1c4849bf9b88c8b0c3da56b9c13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 25 unique boards, 13 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.9.184)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

---
For more info write to <info@kernelci.org>
