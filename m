Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B012ED5C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfE3DfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:35:20 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:34556 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfE3DfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 23:35:20 -0400
Received: by mail-wr1-f45.google.com with SMTP id f8so3154692wrt.1
        for <stable@vger.kernel.org>; Wed, 29 May 2019 20:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KUMg73FBBA+D/BjVI2YR5dC2GmarbmEUXwuNBaPk+7k=;
        b=CEdAvJn81x6qb7S7Cs4RGGQ9h4xyGok0OnnfEibCZYpTBU9v1ZtQ52j5qTLBSE5gia
         y5D/ivVIy402FBbb9M5UhN/AifQBRNIHyrll6mS6fAiU7ofRgKBwc92kMpzT2AUT5RX2
         T4+wo+78/6OK4x1QXhhXmnHyyfhMB8rgZks2X4F2/+E3O1h+AswJXFOhWDf9e5MPn80H
         tkY08jaCudhOpr9ZSqHzE/RribyWike9b+rOyJk+nwbWCtn3xSAx3JsrQBsSNpjBWMY5
         jInfiLD+IR39dV8f1CvReoMo68yEiCoi4vxPF1ecu+GJ1F5zJfgHPesB6oEBim46f95m
         tkig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KUMg73FBBA+D/BjVI2YR5dC2GmarbmEUXwuNBaPk+7k=;
        b=oEW5gwy6EQzfVfLyUo2ckCbVBOXNhKHMI9y3P7RQzNK4qYvb6+S2la5wMs3PAYXEQj
         TeFdzh/FzVU7QRyTllDdwdgBCzTIbKa/7cJhNQpgY6UPw4n/b04ZgaQ9w8cGF3dfGRFJ
         CvOc8fPQpiMvKjU1wzpJOyj5ADCW4emmc8W8yRnAe/IUiFIolBrvk5ubgFq0ve5UMzW5
         v8axlUh2cbaaXHHgGTmcr097zSdM3WYtMuS2Lc2Jvkw5lCDGgYA5Qxp0s70QfXlH/9Ja
         y/jHQPan4Kwrk1b7ODvK94pgfLrmQ6BFXRGVnOWWQ4Xx/PnWFJIm/BjMgpbcuE7vx+n+
         a6OA==
X-Gm-Message-State: APjAAAXaDgA4R+nfXYdeAIIlS1zT8zoIrBzZhx5R3uuHTYV19PSWvvbV
        odXT5I4SqEW6GNQ/LMyUrjKuyWwHuavQag==
X-Google-Smtp-Source: APXvYqxz4hnUSjJ24HhA+DWqvIWIovtipNMYS9JIuQLPV9lqhOQFUrUuez9sGyKiaws/UJleDHTkPQ==
X-Received: by 2002:a5d:644c:: with SMTP id d12mr835713wrw.187.1559187318638;
        Wed, 29 May 2019 20:35:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h200sm1892675wme.11.2019.05.29.20.35.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 20:35:17 -0700 (PDT)
Message-ID: <5cef4f75.1c69fb81.5e0ac.9f58@mx.google.com>
Date:   Wed, 29 May 2019 20:35:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.179-23-g6d72d259a084
Subject: stable-rc/linux-4.9.y boot: 103 boots: 2 failed,
 100 passed with 1 untried/unknown (v4.9.179-23-g6d72d259a084)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 103 boots: 2 failed, 100 passed with 1 untried/=
unknown (v4.9.179-23-g6d72d259a084)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.179-23-g6d72d259a084/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.179-23-g6d72d259a084/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.179-23-g6d72d259a084
Git Commit: 6d72d259a084acf7b787cbb81f972aa07f3c1b90
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 21 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v4.9.179-15-gedcc526ce9=
c8)
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.179)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            meson8b-odroidc1: 1 failed lab
            omap3-beagle-xm: 1 failed lab

---
For more info write to <info@kernelci.org>
