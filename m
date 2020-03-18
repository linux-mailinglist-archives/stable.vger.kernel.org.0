Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACEEE189BB6
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 13:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgCRMMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 08:12:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37859 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgCRMMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 08:12:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id a32so12721639pga.4
        for <stable@vger.kernel.org>; Wed, 18 Mar 2020 05:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qe0Fiwg9IjUUgu1sW/wsCBnk10Zp/UwMSJUjGD0kSbM=;
        b=wmJBwN/mrHXAOVdIUqnsRmZVh94DZ3FeMazg4qXCtTJLCS/HNLeYJdgvSbc0AD9Dfw
         2G52gPReLw22pbUZBxXF2uu7yNiRw/JUlzrYf3klkiiwys0YfnQnYlwU4yZQTNcQs9Xl
         vcXoWxfPJhJhiki835NS+Oz6NEg/MAaVmH/ccHliZlzQhdpdUUIP0rB3dozIdmLJQzKU
         T6aZSDGr70ufP3zKDE4KrNIKHW2kF+f5wEKJD/Jl1AAigE8WMO8515lOGt7Y4V9fQBnj
         kinwssHsvIs8fDat7vhGaSjK+HnySfN6oWF7ZA2nuakDUmVpmAn7bEsqum0VpwSD87Yf
         AZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qe0Fiwg9IjUUgu1sW/wsCBnk10Zp/UwMSJUjGD0kSbM=;
        b=YpHok7+2xbn+BsZFypt71++tGZjg1ABVDNrLicPMpWL6IdRe2iet+sv/OZCLnbuike
         bYIh8SYd7TKHViUXa0fHvsPQUNIFZAjEqjSf3DQLbxhwmlam8PGsJdnsJXatLHTFDnLE
         K4FF0t2aX2A2YwOjEMSaettiMmaLL9pmFJk7u6nprpw/1btRytbxaDErFk5xPh9K2yRF
         GTsOAszqKIoFr/o622MrUuBqjMpS9Cm6yejByNS9w2pKAYTwMf8LdNb0uQxKXXLEffMp
         mKGc0skrksjQd8mxhQoCRH9o6rizoCrlc/IN0l/u68SyY/670PaO1FWqWthOQ1n4qmd7
         p3nA==
X-Gm-Message-State: ANhLgQ2CjIDcUcW84253w7GUMvorEPBTeKCNQeRMleLkkzkPXV1vS9Rn
        7f5BqnzmOdAd/kClXbuZ5urtCWIOTAM=
X-Google-Smtp-Source: ADFU+vvuGOTvOUmwAUdJSU1cYzs2YzPUJXF11RsDS/Mjx4MB8V9EZfVdc1cnByCHwxZe7dBDzEWEJA==
X-Received: by 2002:a63:e80a:: with SMTP id s10mr4240619pgh.189.1584533565539;
        Wed, 18 Mar 2020 05:12:45 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12sm6261865pfm.165.2020.03.18.05.12.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 05:12:44 -0700 (PDT)
Message-ID: <5e72103c.1c69fb81.9b337.6b33@mx.google.com>
Date:   Wed, 18 Mar 2020 05:12:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.26
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.4.y boot: 109 boots: 3 failed,
 101 passed with 5 untried/unknown (v5.4.26)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y boot: 109 boots: 3 failed, 101 passed with 5 untried/unk=
nown (v5.4.26)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
4.y/kernel/v5.4.26/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.4.y/ke=
rnel/v5.4.26/

Tree: stable
Branch: linux-5.4.y
Git Describe: v5.4.26
Git Commit: 257edc6db9432d6d9f19bd313b6b30406b431766
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 69 unique boards, 18 SoC families, 18 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.25)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v5.4.25)
              lab-baylibre: new failure (last pass: v5.4.25)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v5.4.25)
              lab-baylibre: new failure (last pass: v5.4.25)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: failing since 5 days (last pass: v5.4.23 - firs=
t fail: v5.4.25)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s805x-libretech-ac: 1 failed lab
            msm8998-mtp: 1 failed lab

---
For more info write to <info@kernelci.org>
