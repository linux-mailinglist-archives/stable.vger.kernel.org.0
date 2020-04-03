Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E43219D665
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390935AbgDCMJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:09:08 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38982 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390936AbgDCMJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:09:08 -0400
Received: by mail-pj1-f67.google.com with SMTP id z3so2852315pjr.4
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TrVS2BBptdcas5RTH7NhivjXOsTuSKczEcZWQcwZqvA=;
        b=IgiYPXHeP1BUlah2677hJja/hursQBElpx61lXfGUksv/1+CllJbYNEjkUSBPbG8zH
         p5Da3W9cZw6WImyqvBMXlvlzcF7D31iWS33toMgDjkXcX3ND3HZ/XL2YBCtj6WH6y6OL
         Ws6YUxCwI4adKAory8ATLBz6s2RMFBtOG27IoC+5/0PQ/b9/U5XFgZvWOYiu5OwaqQMT
         G2uYOQ//aVSP0p329A9rKVYA5a6O53e1E8E0FdJlGLiSBR/kwjFrnELlwVZfI2ptA7Kq
         vQT+M09s4RIXb3xb6Ie5gwneZ2tvYpm8mAXwCQIB1y2ow0nF7gWxAn9ldjOa8cRs8KoA
         CXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TrVS2BBptdcas5RTH7NhivjXOsTuSKczEcZWQcwZqvA=;
        b=lQXiVaDo0qbnxGirbCH4f80B/lJkDmw9ftlYNH/C7Mxb5PgLm5RmFEFvPzhcH+PjLk
         wl1X3psM2a8AxxHwFVgY2EXMZyHZ1S4J8ner4U37REzkV3WFSm9nech0fEknBDn8uZE+
         ZOx2BPgkI/BaR0qiCO7OaJZUWQqMApGAX6Ig4ZaodvYU4rTMqCBretufpLnKnCL1ERIj
         tYfYyrxIi0WWJO9wnkQ9Kv4CZ8ffK5PSis5OofEuNJw8GySuTzygRSvR7hr/YtmFgXuH
         C9Uoh+iDAk9gS8VBGhUpONob8rFgVb94dt3MCV9BTYHTZWDqvbYrZWz9RR05BTI2qtmd
         chOw==
X-Gm-Message-State: AGi0Pua6lUJu2aVDpUqXS8ylFik20JL02Dydr+dbic37uc1LlHZdEt0m
        US6io5kkxudPikCSH7NBVAU3fhB8A84=
X-Google-Smtp-Source: APiQypJHK1beqB18pKYLf/y8Dbz+hN/fJL/DloFqgwPbScQZ6n5qAVsNBlMJh6DilqiqALgOI+r1cw==
X-Received: by 2002:a17:90a:8908:: with SMTP id u8mr9918567pjn.66.1585915746943;
        Fri, 03 Apr 2020 05:09:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 66sm5804332pfb.150.2020.04.03.05.09.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:09:06 -0700 (PDT)
Message-ID: <5e872762.1c69fb81.cc344.a9cf@mx.google.com>
Date:   Fri, 03 Apr 2020 05:09:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 115 boots: 1 failed,
 107 passed with 2 offline, 5 untried/unknown (v4.9.218)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 115 boots: 1 failed, 107 passed with 2 offline,=
 5 untried/unknown (v4.9.218)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218
Git Commit: a5ad06fc4b7b22f6df0c21b7052a82e039305a14
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 54 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.217-103-g61ccfbbf=
e9f6)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
