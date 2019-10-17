Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA255DA31B
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 03:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfJQB1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 21:27:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51446 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388936AbfJQB1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 21:27:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so712571wme.1
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 18:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3Xntyt+4UjZOHRaYbyJvz4tAyGncxIudLMCv/B5OxcA=;
        b=KivvPwek5f5Qb9k+q3vo6LXfBR63x5yOI5yFrM4FhKc/K6s0omT3kyFIKrTKWmOYsv
         nKRnjT3XlFmw7oblHhewyQte6EQA03lizAFhbiCkUt+sErNT/rdWPZeEk80hJu1rh30E
         uY6OoonJTmz06C1BkapPwkiXcbmHi3VDh8eDbe+gdYU8nfqHssdsYwbBdYOJYzq81KZw
         +NpxbjBILuVdGvdasRdToEDYqQWq0V3Vjmeskp7uNGqRqMzpVe//5q1QE4kX7Yy5sbgl
         JguttV0HQrNo5rfHC29ZxG7pspb/Go46AmDZpgoc983q1uiJ6+l3v0CfhpIYFYSyCZZs
         CJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3Xntyt+4UjZOHRaYbyJvz4tAyGncxIudLMCv/B5OxcA=;
        b=LzLVtAS0+MZuelxWK8PktfQuFTSV5t+jewFqehKUweS0VB2oR7/JjsRkGPk5tqUyLz
         EhnE3xkYoR//p/B3Q4rPkCyzg4MSxy1hZzPGzBcqKTxE7U/2cZLzRcg+ehF9rT+EYulw
         4cMRpfT08q14hThbziekhBQjuvrzv7hkBVqVFHeknI/XtDmLaxg2fYKt5p+lcdGEpsPV
         0FfepvhF+3UUE8+S5xKlwQPLNdxiDPE7Q9aOYEvzueEYshfvSOmcVFHAYLAfxkUTLKBg
         DtWz/O8D+ZIKeBT8CkIfyju/78Xp4WL9ujwWk0aYyzL1p6EBPffFptJVsb+i7RYz/152
         Afag==
X-Gm-Message-State: APjAAAWd8hu5RIFQ6aj1ont/f6QDM8bo6g8snDX/w4dEGC9U8r+7i96B
        Ev6uUJE16AdrnffNfT/APan85kW7oQ8=
X-Google-Smtp-Source: APXvYqzhdLtNuh+dQy604GwpLVDdUIvQ/aKsgNu/PX6MkoZq2p/y5ygM5h4u0IIA7TcBtCRXjcUNdQ==
X-Received: by 2002:a1c:6a0b:: with SMTP id f11mr511987wmc.78.1571275630346;
        Wed, 16 Oct 2019 18:27:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id q192sm682164wme.23.2019.10.16.18.27.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 18:27:09 -0700 (PDT)
Message-ID: <5da7c36d.1c69fb81.74284.2ee7@mx.google.com>
Date:   Wed, 16 Oct 2019 18:27:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.149-65-g642c3804ba9a
Subject: stable-rc/linux-4.14.y boot: 92 boots: 0 failed,
 87 passed with 5 offline (v4.14.149-65-g642c3804ba9a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 92 boots: 0 failed, 87 passed with 5 offline (=
v4.14.149-65-g642c3804ba9a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.149-65-g642c3804ba9a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.149-65-g642c3804ba9a/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.149-65-g642c3804ba9a
Git Commit: 642c3804ba9ab2a5fcdcfc4d336995093a3c3031
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 21 SoC families, 13 builds out of 201

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
