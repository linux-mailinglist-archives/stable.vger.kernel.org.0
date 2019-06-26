Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677A756AA7
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfFZNee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 09:34:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33934 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfFZNee (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 09:34:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so2805312wrl.1
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 06:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lQ+kH+8OcyY0c8JYG72kvfeQsmfca58t7L4uorcaVGM=;
        b=NQd3VWLOrNreUf/55J5EOMv550b47xcBqAdZemrvku9rzIzi3Ba2itJIyNgm0qXdvZ
         xTXhp7sjujhhLjSMqvJTdmHfhCysQhO4xzsT/g3TqiT0fsMgu2XzBskqxRyoZ9mjQ8ch
         Qek1oUw0sSFtrXZLAtl7/6r6QUWfHZVBEcxksL/xPcE5d7Vgw1iZs6X2wSRTDKYHPzpP
         QaEMlLQP8VTGjWDhsudcxZXiuyc7UrJG4BCZ82Wz653RsCnRfGLB94ejb1+vsMJ6/ouN
         O24p0QFzwmdeM2HDF6SF8WWBoBOk7YRQare/kNRUs56SNd9VO8Dd/Fn5E3mUaYnnGE/W
         t1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lQ+kH+8OcyY0c8JYG72kvfeQsmfca58t7L4uorcaVGM=;
        b=DnvNOfE5P/mb3MUvhToPq91gKDF9c0hUngmSuXrfhBvDkK96cbVTaQLd4vD5hfjSsp
         L9EtLQJccosMKZKya7C5J1Z15kwN5BKvl1RDDwakeyNeT2ief6ymPHP8wazmu4KGrTJ7
         6L+XrkbG06961+G1deP8WHiaAPk+4U8Jg1d0vZlrYZusZP+HB82Z0tEAILaXlrlHsq9B
         bTcO5exjDviRFSsF2Dr+XMqR+13VEb7xJPZRJrMJ53AJ/IPyb/oqSzq046FSWEMx+5CY
         KUEgtiyziF1JUNKJcVm1FFxCG7jRsSFlnnn5UJr24fYBg4m/FGTHbiGgyx9BCOHFf/Cc
         sTog==
X-Gm-Message-State: APjAAAUA82ujJXZKx8u8oQAaZAMGkduv4twoZNUXkmJxz0m4qiXAdqZg
        0rIFVWOOsaCvjMI11sQ1eQoYxPVxq1Bk3w==
X-Google-Smtp-Source: APXvYqz7llAbM3D8LwPY32d0VS8H4G8yMo8sNSLXPKRrFe8PeCcmE1WmpX7mMN1MPswx62eeUdwOQw==
X-Received: by 2002:a5d:4849:: with SMTP id n9mr3691843wrs.139.1561556072521;
        Wed, 26 Jun 2019 06:34:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o20sm50225768wrh.8.2019.06.26.06.34.31
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 06:34:32 -0700 (PDT)
Message-ID: <5d137468.1c69fb81.cef30.9b00@mx.google.com>
Date:   Wed, 26 Jun 2019 06:34:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.130-2-g2f84eb215456
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 129 boots: 2 failed,
 127 passed (v4.14.130-2-g2f84eb215456)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 129 boots: 2 failed, 127 passed (v4.14.130-2-g=
2f84eb215456)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.130-2-g2f84eb215456/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.130-2-g2f84eb215456/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.130-2-g2f84eb215456
Git Commit: 2f84eb215456bfd772fc0d9efc8446a66a3faa1b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 24 SoC families, 15 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
29-52-g57f3c9aebc30 - first fail: v4.14.130)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
29-52-g57f3c9aebc30 - first fail: v4.14.130)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
