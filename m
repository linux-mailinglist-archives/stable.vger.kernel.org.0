Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41A815DA70
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgBNPQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:16:22 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36481 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbgBNPQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 10:16:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so11345482wru.3
        for <stable@vger.kernel.org>; Fri, 14 Feb 2020 07:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WwHRTKXETNKyuhbyRqgeJlejWA8nhiXD4KNuVHcGelk=;
        b=hqOZakI/A4zoNalvIJFUKjsnkti3AzPSpg3J2PTaUeYeNif4YLgsQyk3EzbKh3pua9
         CRyTxIIUQcQWxEg33CBDxMI++vC+TT79+x6pKbOZRhVazR4saJwJsZPtkD5q0zMJx7+w
         E/t4PZ2AhJYVVt/BUHurND7lSZ1lCCDAz6YqZVO+cFc1MypkYzzk4ZrIQ5Egw0AX3p2U
         84F1iI5qim2+cz2fqoR42D8qsIQ3U/U67E6iKxkFngOR1FGkW+z4EOEFTmh9R+Y9fKgD
         S3FEIe5REbPWFi1xJ723Um0/enJrpQSvwBhTMkKjUFieuOWReTtphvnhcAI3Fu1zggnL
         eR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WwHRTKXETNKyuhbyRqgeJlejWA8nhiXD4KNuVHcGelk=;
        b=mJel+d5XnSU8SbUUCCmDY5Xf9/ecktD1IHdLiQ+9ZlbMTu7U2IENdP8QkMs6YLAUDx
         U23aiK2g9B6XGckxKndQ/fQrEL03FVzNtUF/dH4j0a/OdGjjC4lzKx4W//1VY0lfTREw
         cpSoy1JlCTMt3M2ETiGzCcQ/HKrujzC8RJ0dcTjqrNYD5iNQoguA4tF7f9OL5J0yqvq6
         56bbBXp7Mj587I6MPhGwr7Mbu1I8dP7yWuAsFX3eioM7B+gvl9qYGj8FfR6jAGDSTCkn
         543qtmz8mXeH22dIcKoQ/eIzw16fcqh9WUPgauggfZeGYqWfmpxjzBO2443jeaU51484
         iyTg==
X-Gm-Message-State: APjAAAVhGz/lUdbtebE/pKkshGornqHUW9AuGr/nKA4AbmGD2grfeITp
        C5abcD540qqfO5KtPrFAGyP9uBqBl0OE3w==
X-Google-Smtp-Source: APXvYqxMbtjo9Y2AT3DphaxHNNErGtog7nnddp/BG9cBynKikAhhcUyMYS1HS8mRLKEoQkPVQ3XZrg==
X-Received: by 2002:a5d:4e91:: with SMTP id e17mr4307152wru.233.1581693380883;
        Fri, 14 Feb 2020 07:16:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r1sm7248995wrx.11.2020.02.14.07.16.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 07:16:20 -0800 (PST)
Message-ID: <5e46b9c4.1c69fb81.c913c.f978@mx.google.com>
Date:   Fri, 14 Feb 2020 07:16:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.170-175-gfc30e3f7ed49
Subject: stable-rc/linux-4.14.y boot: 92 boots: 0 failed,
 88 passed with 4 offline (v4.14.170-175-gfc30e3f7ed49)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 92 boots: 0 failed, 88 passed with 4 offline (=
v4.14.170-175-gfc30e3f7ed49)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.170-175-gfc30e3f7ed49/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.170-175-gfc30e3f7ed49/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.170-175-gfc30e3f7ed49
Git Commit: fc30e3f7ed49e3e207a81a7945cd2524bc6a9cb7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 53 unique boards, 19 SoC families, 12 builds out of 135

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.14.=
169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
