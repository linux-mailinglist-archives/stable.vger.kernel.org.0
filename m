Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F79B3195
	for <lists+stable@lfdr.de>; Sun, 15 Sep 2019 21:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfIOTS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Sep 2019 15:18:28 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:33479 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfIOTS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Sep 2019 15:18:28 -0400
Received: by mail-wm1-f50.google.com with SMTP id r17so5758265wme.0
        for <stable@vger.kernel.org>; Sun, 15 Sep 2019 12:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tRVIC1Zo3v0RjX3yHHTODRyUf98ptA2rWa2OXUtASmE=;
        b=oNXmZKK7g8KZsytaVM8kEq5rd4tIqi5fXA9ZyDmK1cQ4mE3l5okCeS86H9Y9wFCGEy
         f6r8bRZ3lOfLbF1GJucgY6P+wkFVQrmWn964QUvmPIhjlRexqOLLfQz36Hr9PgU4ZSNZ
         4o6xa0GQ1cZ/usUOKeRhbixs6TTOcPQ3qxo+S9uqwOPI5hk10ob9vI6ymGa8i8p75lSd
         YBUbLlKHXR4FlJQpQVx337B0pfUiLBynATSnn0GKhfwnJ+Z1/y2e1gNwyB6smtYuSwNZ
         Xz9JdIsB5wOH6Xe7YxvDY1RO6G0uM9OP94ZJ4BtVFO12jE8YTBacVRl6l2RZGbL+ujQD
         +Ivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tRVIC1Zo3v0RjX3yHHTODRyUf98ptA2rWa2OXUtASmE=;
        b=J/XrUuLyKUBOjkIcUkeUFb5oJPyy6qnlTWZsLd4wEC+EJ8Ek2QORqsDs2lIC2DJ0nn
         rGOdoe4Z0wiWdQTNKS4JxwYFz0apoENwWF62U37LDlUWEkwkv27qxQjQ1d49MushwD7K
         tBW8bukt7FAC10XjRPgY0z5HWxVIHVsR82viIJqnLA/HTYzbu1pyRqluGI0gqUqQOZMl
         A79XjgMR+1kLEyQozsLoPOoyDo62HmlNYZDuKUCUnewDtGUd7FX/UV9Kop3u1o0wjTM7
         KPka9dUrB2XMEFzWr217HikeFfZ2J6GzjlbIL9PtvSMwBOoTCvTC9DP4lUKhZaD8UO2T
         tTyg==
X-Gm-Message-State: APjAAAUMzZNBD4oc/ak96i//mEfevcdFXKijGmSgARO4kgd2ld+PoCkK
        kyd8uCdE2qwQbXbY9p0ae3PJWDMV2FA=
X-Google-Smtp-Source: APXvYqz8CDc52CERfOINaWwT2I/87Lqk0xiMHFiQ0J4QUkmIrOXFva1ZaeIQOevyijLb4T64FGWxdQ==
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr7021606wmc.140.1568575104660;
        Sun, 15 Sep 2019 12:18:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x5sm53012993wrg.69.2019.09.15.12.18.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 12:18:24 -0700 (PDT)
Message-ID: <5d7e8e80.1c69fb81.b79c5.c01e@mx.google.com>
Date:   Sun, 15 Sep 2019 12:18:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.143-21-ga0bf0c3c56ab
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 133 boots: 0 failed,
 125 passed with 8 offline (v4.14.143-21-ga0bf0c3c56ab)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 0 failed, 125 passed with 8 offline=
 (v4.14.143-21-ga0bf0c3c56ab)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.143-21-ga0bf0c3c56ab/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.143-21-ga0bf0c3c56ab/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.143-21-ga0bf0c3c56ab
Git Commit: a0bf0c3c56abc31ca4438380e8e87e1cbf9430da
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 13 builds out of 201

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

---
For more info write to <info@kernelci.org>
