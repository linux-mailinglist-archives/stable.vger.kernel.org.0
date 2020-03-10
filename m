Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48BD1805EC
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgCJSKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:10:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41712 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgCJSKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 14:10:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so5751861plr.8
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 11:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Foocfuui+6dxfUbTkpY0gqrxQ/+fXEmkWXFzC26h0PQ=;
        b=opRAnGYNIJ45yyqknJqaA1nPeb1UGT1r6jYkOLxibiWhvWNvTnsSQHyCIBiwwp8ht5
         QF19pcABOV2mOltJ9y5tUpBOa3b+lBbUqc3i9K+W3j+PAHuUEINrNPjR1YdiWrgc3jN8
         63r5ChUwlMAlV9ocQmgI2GJJflHxDnpRmmRu8W/j+ns0BuuzJraBR5taLxC0iQrG5Aew
         /oC3KyOoS5YhVfCJ+Vwc5HFNbxPUQfVbP6OblcMbQd6HdIKSM2+WD/xzfIKwKsmJvirL
         MCfbdmmq7B7Q5VQuevUb0R1B+GCnXjfP4SksF024sdeNgDTibGPdPaZtuKq9dSSNb3Hm
         scgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Foocfuui+6dxfUbTkpY0gqrxQ/+fXEmkWXFzC26h0PQ=;
        b=npioF0yOW9I5gOOGKZss5JpApUbGaCq7XWN6Pt2cDAKJVC2egQ49lMN21PMlmU1Byc
         DRy58gDdL4tnhPgRNGqz2w8a2EmwZrEjfqBn+8K2A7Pim3mdpt5VRkPMM5qQ9pTIDDtt
         0gslvlFOpxwv6VxYVKfPZL3aYapqbj6IwUSL1U2pBhk2Htdkfnc/HHzwByFPXJYi+yUF
         RlJxcnsrxUr3BMbp2CHl5X7lrPLXyfH7v+ph0qQuJoZoOns8TburwmabSLA11IMPRLWd
         dvhn2RXgX+/lf0ZNthkfPbkIOgs9xuEw6PsNL1QI+CqJ2hOeMgtfx3AazeyyMST06sd6
         JH9w==
X-Gm-Message-State: ANhLgQ07I6a/FdXPGEUdwZNpXX+9YoTDCb3LFsSrUgeGV9PPWVtGHJoe
        tPD92YFK0CNhKtlfg5LmzDkyWRbrqso=
X-Google-Smtp-Source: ADFU+vtZ9et5GbZXREgGVfA14pKaDxntVgmr9M70EHpBr/UW6J1v61fyJ+t6F1VTnPa9r56rj28RAg==
X-Received: by 2002:a17:902:a5c4:: with SMTP id t4mr22400999plq.242.1583863842433;
        Tue, 10 Mar 2020 11:10:42 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y18sm47058139pfe.19.2020.03.10.11.10.41
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 11:10:41 -0700 (PDT)
Message-ID: <5e67d821.1c69fb81.571ab.22fa@mx.google.com>
Date:   Tue, 10 Mar 2020 11:10:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.215-89-g823586b24f36
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 76 boots: 3 failed,
 70 passed with 2 offline, 1 untried/unknown (v4.9.215-89-g823586b24f36)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 76 boots: 3 failed, 70 passed with 2 offline, 1=
 untried/unknown (v4.9.215-89-g823586b24f36)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.215-89-g823586b24f36/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.215-89-g823586b24f36/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.215-89-g823586b24f36
Git Commit: 823586b24f3634fefd5b5e83293920023c6f008c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 18 SoC families, 17 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 31 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 25 days (last pass: v4.9.=
213-96-gdf211f742718 - first fail: v4.9.213-117-g41f2460abb3e)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
