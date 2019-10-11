Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF0DD3C18
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 11:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfJKJRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 05:17:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33663 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfJKJRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 05:17:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id b9so11073967wrs.0
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 02:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1XrFbfSHSPu20NUsNnjpShCJ5Fb96JIWKP07Yk6xQUA=;
        b=m65cvtHfiO2oFpwEzUUJ5kJk8mClJK9XIm1ezuLZogceM7VD1Hwz0P2jLHDKpxYR1t
         iwtXluN+f3VHqM0YlXPnsr12Qo42R4YmURH5prN217IZsmg6PmhXZ+YN+86gxMWaWmsf
         NR3PTEpQ/waTDE4cTEFSCupbEK6yO1O6pQmOatTVeac4dR6K9WrFAKo/a4lff2myGik+
         ufIPrx/7lX6kFeP4lblSZzfn8v4kdOX/3qi9RDOxQJdl+8w28h0PXi9zdlNrRW1Nz68B
         HxP/qCi3cMkKtR8mkgkLmXrIJb3L8ntH566acAL4QGs3/FkbzF1FwhhYdeorj/DwdpxZ
         Sjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1XrFbfSHSPu20NUsNnjpShCJ5Fb96JIWKP07Yk6xQUA=;
        b=EIyVM+7jqSRy9blsBQ9llkq0skTqIptWwuyzUoKHyoUT400eLFpiW11Vx5EQUWGEbC
         i3aEaOcsXJ3842ohuD26goHxm+Uqtiz2aeRYpwvolsnq3MZYouvJsPRDTT0WYkwozhcM
         J+EjGBBfkDT1sMHOsiI9XL14su9olHofKDn9ehKId9wlK9IrFUqCjAYV8RCzAidBegeT
         gFLVm6xTe3A+Lh//aS6cgaGk1FQ4kHTfzH9koMRNhSQvLI5Qqe0384SSph566kV57C8H
         dByoIBJ3OfPbzBh6+8LHrxM6e0p02KHw3HBkePR9dtjmdy0b44tLwlBx1d87Hmg6eN6a
         OP7A==
X-Gm-Message-State: APjAAAW6Ho8tIIaFD/OW0E65dbIWqU2blRiT3j2MQym3E87cSiVfGdQc
        17gQ8UG92DNyZ0FnG/X07siafOg5JBQ+KA==
X-Google-Smtp-Source: APXvYqxTuccP8/der4viAZnwJWj2BSD1Xuv+L4TUdiLAAoqtEt2DcIaeQogLnnIAsiSSgtLL96O8eQ==
X-Received: by 2002:adf:8087:: with SMTP id 7mr9441055wrl.296.1570785451771;
        Fri, 11 Oct 2019 02:17:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e9sm15207983wme.3.2019.10.11.02.17.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 02:17:31 -0700 (PDT)
Message-ID: <5da048ab.1c69fb81.c7adc.a1c2@mx.google.com>
Date:   Fri, 11 Oct 2019 02:17:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.148-61-g6f45e0e87a75
Subject: stable-rc/linux-4.14.y boot: 118 boots: 0 failed,
 109 passed with 9 offline (v4.14.148-61-g6f45e0e87a75)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 0 failed, 109 passed with 9 offline=
 (v4.14.148-61-g6f45e0e87a75)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.148-61-g6f45e0e87a75/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.148-61-g6f45e0e87a75/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.148-61-g6f45e0e87a75
Git Commit: 6f45e0e87a7551cae6c20b88e1132d7ab2e340b7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 21 SoC families, 15 builds out of 201

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

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

---
For more info write to <info@kernelci.org>
