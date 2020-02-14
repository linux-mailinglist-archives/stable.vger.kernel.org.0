Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C94115CEE3
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 01:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBNALm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 19:11:42 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:53031 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbgBNALm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 19:11:42 -0500
Received: by mail-wm1-f43.google.com with SMTP id p9so8218563wmc.2
        for <stable@vger.kernel.org>; Thu, 13 Feb 2020 16:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EzKe/ntKoUUFG0fuenXaKf0iZvmjYm6NPGJilusev+8=;
        b=jGXClwq385wqTs5AJsmraD/D6yMy3wwU1F7VbHqE9EZG2uWTHSiNZu3zPUAlMnswI3
         uvBPznaAyEEeMReBNeGlwv84Y/chrkFrI8/J14PhlkRjkvxe+hFTIRiV44P0RgDhjO3c
         HFJIoLfxHRIaCGgjvtP8yapd9iCqUxtEcLNRhD2/g2WJogLo90KhLHtIMLL+njSGYKh2
         o+yK8cKpqxYdfhe1LhC7tkfOh3SE1tIAAD2pYGPtIGzU7TDFaPCa+eZ4CuTjXNjpnO1R
         3djOUhPwP+LBnjc4DOkBUZESEPMBVXnqcseP8Ev+cAPvq9gqZLje/oC9T/3wWCTI/rt6
         eJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EzKe/ntKoUUFG0fuenXaKf0iZvmjYm6NPGJilusev+8=;
        b=J3ZyfANoX1JEz3jeTtoFVz8B967/vgAYGQzhLhObsOY8Zjn7LjDalI2aAMIHiyQCkG
         UyPB9oAcDm4doRXseKhtOu5zCfIKLb8sHZhaMwbAxU8P7o6A0VTRGectZ5TUcQ+zaeY3
         3agLogs14wUiStXdhh/OkA0tZYT+dcMoQzu/y+uCHk1PVqy9wSeEKDMYBMR1VsQnnPuu
         IiXYLUaF30ccUTj5JXQJz7O6fMmYMCz4ZDl+o13ojZFgKt1octMjjVIwY4Kb2qxjLi/Y
         j7mx/VUq13sBEBUr7gwkAY2khZ+b6om2nkDRtYI4FPX3hDuloIFvd1oAsJ7o/h0Rdeb9
         G/yA==
X-Gm-Message-State: APjAAAWfZuaNvkFDN0ukYpfhkmpmad8ZLeAItKpx4zpUZj4LGqSbiyh5
        U657FF/TzR71vCWbDIDjG5LoOPHwPjxYPg==
X-Google-Smtp-Source: APXvYqxxcIMdCLCC+yF7cX43J0D2rGOW+GZC9jADVOMNjWiY4DWA6pKemvawUxa+T5aFIQE619qJcQ==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr594087wmb.99.1581639100072;
        Thu, 13 Feb 2020 16:11:40 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r6sm4637557wrp.95.2020.02.13.16.11.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 16:11:39 -0800 (PST)
Message-ID: <5e45e5bb.1c69fb81.955df.4e5b@mx.google.com>
Date:   Thu, 13 Feb 2020 16:11:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.103-53-gf1f9ded7a002
Subject: stable-rc/linux-4.19.y boot: 28 boots: 0 failed,
 26 passed with 1 offline, 1 untried/unknown (v4.19.103-53-gf1f9ded7a002)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 28 boots: 0 failed, 26 passed with 1 offline, =
1 untried/unknown (v4.19.103-53-gf1f9ded7a002)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.103-53-gf1f9ded7a002/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.103-53-gf1f9ded7a002/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.103-53-gf1f9ded7a002
Git Commit: f1f9ded7a002e2c006c68df203c3e2147abfeafa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 22 unique boards, 8 SoC families, 10 builds out of 133

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.19.=
101 - first fail: v4.19.102-96-g0632821fe218)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
