Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867904995E
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 08:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFRGwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 02:52:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36599 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfFRGwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 02:52:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so1876036wmm.1
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 23:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=02m2a1o5+s7GyPNc1AgUm3cMQsolTbsFQ7z8ZvS5IlM=;
        b=JlEp1NGe3J9N9/HIVaXJwlB+op/GM3JRslFwPEeG78IYyLYgW4WWRQXuBaRv/4HUHZ
         Z2Ett6ETOXu465BjWV5bzWn7uAUMzAC5JW1qS1Ws5Ww8oZ9KdexYqptdaiFjV6EdvC/Y
         HcbNRSnyfJ1O4+kKPw9BntwM4d5YxrDpMU6+SneU3AHoVnKnhjBwf8JglK+uePHAHlMm
         qIuTAqNkqeXVVig42n4oOvPb7rksbhQsFlCaHJCOlgxHMgz7uKMXKj2ELtRtPeypbo4g
         R/esF1iZT4CYxijCPFJFf+XB01ci0gCNfcfxzlnmB4IWAL38B46XoHc8mwQTb6vHKycM
         MGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=02m2a1o5+s7GyPNc1AgUm3cMQsolTbsFQ7z8ZvS5IlM=;
        b=WHm8QGIZ7p5uOfWygw2M745fBXJ3LED+641V87FFoITK1dYd/0HanLCMRur1t9RDiE
         Kq5lN/9zz9j71LChufk8K3qwHZt20tH9tpuWzqgLRquC8EzRpNdzKyRN7euJZz/RY1KV
         k8qM8iKkGX6eBQxxtvZ0OG9mdpfWzAU+EVm5VcOIgw2E8KEOo256ECNU6wgkUArOwffW
         oSFsTmuk6f1N2R2AnF6h6SdeX+byxEzG7vAxTddAqlCyjxUuu/KtFoAmUFqfRu477xUY
         biSZESmB9GIic74v6fT/zbm7GM98Ayvuvdt1PxP+HHGiEH9ZSGrUZe92j3T5lcDKwVy6
         qYyQ==
X-Gm-Message-State: APjAAAWvg/SWRbbIuNBVOS3k+5V1zqT3aMYeMYdtXM9ogaf8R7LVEJ2M
        tYZSsrx3Uo1iXrppPsuMiOg6kmQQkr56GA==
X-Google-Smtp-Source: APXvYqzKNEJS2TeAUoBVkaFF7rORA1NhFo+OxEzPinT/zcAM5lHapz6bqQk/dQs2IuVwzsOF7Z54Zw==
X-Received: by 2002:a1c:b189:: with SMTP id a131mr1851667wmf.7.1560839054346;
        Mon, 17 Jun 2019 23:24:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j132sm1608528wmj.21.2019.06.17.23.24.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 23:24:13 -0700 (PDT)
Message-ID: <5d08838d.1c69fb81.88d7.7ef5@mx.google.com>
Date:   Mon, 17 Jun 2019 23:24:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.11-116-g760bc74bb0d3
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.1.y boot: 118 boots: 1 failed,
 117 passed (v5.1.11-116-g760bc74bb0d3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 118 boots: 1 failed, 117 passed (v5.1.11-116-g7=
60bc74bb0d3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.11-116-g760bc74bb0d3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.11-116-g760bc74bb0d3/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.11-116-g760bc74bb0d3
Git Commit: 760bc74bb0d3cb65cdc8af61a564384ba10374ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

---
For more info write to <info@kernelci.org>
