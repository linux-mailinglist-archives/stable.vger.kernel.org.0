Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2E0AF30E
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 00:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfIJWvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 18:51:52 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:38966 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfIJWvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 18:51:52 -0400
Received: by mail-wm1-f51.google.com with SMTP id q12so1279787wmj.4
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 15:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vUA0M7YHIT36dwtiYEMaoIEsjh/ApMtiew/SBErDWSk=;
        b=QMVjwyFZ6ZIHcWee7/6STUnpaKIg66VtYULXijLtZGlXVlTsTwlTsFSvVuqh5u7YZz
         L3OAhARMWOBx8mNOJ9GNlXBeYqPf0b47Fao53LpoeGYYHHteoIKdiySCPdMsPbb37Fqz
         1lMIpv81tQusGMowEgR9h0iXxBNf3uj9VkdkNBe6lBemCqZv0UV3lmgfFtRMlDhh/uTK
         sZk7kLMszja0/PRjC2AQtI4jzu1hoQ2xs+a6r2fkIFPLGNitn615RKLyABsC3lW8fW8E
         sNQfuj7lz0xZ1tOm2vqvBQd4DxKJjdkWN7d3azPuGtuwDzCXlAnHDL61gwJe5EixL/1S
         f+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vUA0M7YHIT36dwtiYEMaoIEsjh/ApMtiew/SBErDWSk=;
        b=opaw4ilkKTw3naF88AEbNh3c9moc6n+54MVzOf6XukD0P/BjW4mcIrTneS3+EaESIY
         5UkRKemgXIC27r6G06O4IurvwGapLIQON6tWDUvEAnskzHI9izUPjeymgOLTTtB8jMur
         bgOkiiCFPhgOTXiIh0YKRLZo/ovqqQOMD130in2Lg+WaGjF6neHMXvGItuFlRFmTFa+0
         eWTaTqVY2l6s2uELKceTN2S1zgzY65zWy5sAwGvLitYGF4HyrqddMoq86kjwqHAQqpUu
         T/PU+ckOqjm/831jHueCY1g3+wVKGCrQHOk7D71OHcN3vFvPBek6QcE2viNqBcrVHmaF
         qmYw==
X-Gm-Message-State: APjAAAU3E7QIqhtOcJIymdgi5qXOdLDna1KvuGC8cBCHaEVIN6C0bPtP
        850ghaIWO9jHHEpU+BsuAA0vSCORkZPoZg==
X-Google-Smtp-Source: APXvYqyw+A0jIGLRX1+qDt2GDgjWDYbyMQbKjMMIOBjprT/pyPn6kw42SLyTZPdQR6qZYEPYLjE6+g==
X-Received: by 2002:a1c:80c6:: with SMTP id b189mr1450847wmd.34.1568155908138;
        Tue, 10 Sep 2019 15:51:48 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j22sm37187605wre.45.2019.09.10.15.51.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 15:51:47 -0700 (PDT)
Message-ID: <5d782903.1c69fb81.48ae2.01f4@mx.google.com>
Date:   Tue, 10 Sep 2019 15:51:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.143-7-ge07958d6cf48
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 123 boots: 0 failed,
 114 passed with 9 offline (v4.14.143-7-ge07958d6cf48)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 123 boots: 0 failed, 114 passed with 9 offline=
 (v4.14.143-7-ge07958d6cf48)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.143-7-ge07958d6cf48/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.143-7-ge07958d6cf48/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.143-7-ge07958d6cf48
Git Commit: e07958d6cf4894e54d7147e789a35a020f1e4d79
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 23 SoC families, 13 builds out of 201

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
