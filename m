Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595B0F8324
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 23:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfKKW5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 17:57:04 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33009 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfKKW5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 17:57:04 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so9637515wrr.0
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 14:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YB/iQnWXWnLaxPOVA6oPgjYIUTJKYtz8MoeJ4SEi6JI=;
        b=FWuG+TxDEH+ikPjuZFB3zCafz4CjPaYBKPxmhW1D5Rq+9mPP2b0o/w+cZaNoHdjFlu
         p14GimR637615j/iNHUajH8f2G9auO0xJqCbxSp148Vh2YKkncqWjo2Cw2eOpGNygWmv
         zSUeyVaUIwelQsSVhs5/8OfrlUe2S3PvQ0siphmd3iFi341RLzqdj5sMZtjlHi/kUh4F
         QwQl3B5FkqDanevBe8xa8pPgKNbvvco+jsU5QuswZiAjFUy2K4MKyoXbCFvyFN6C30PA
         /Qx7KtjKdxXrS1ul6okOqVEKKrRQSIxsSytQ1CJI0jpZq5oClChxcJ1yftycudP0ipvp
         Wgiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YB/iQnWXWnLaxPOVA6oPgjYIUTJKYtz8MoeJ4SEi6JI=;
        b=CdnwGNksODl4O6KDUS42Yrq/kHWb5Fu9MToDv54/OlkMGRDKQufiE02cYs3Z8JfF/F
         NHrfSex7xaTAIzBJdns6Ean5mdPO3K8Ws8eHgjbBbKsD1I0S6GZJ9JK8TTDDRlEUo/dA
         TrCOaDQFlyRdg6Qt2bZYuLUVyhZ/IzVEAwd2Esd7lc28/SZdMifKxZ78KyTnM3wgGCI6
         Hpt9jH4O8T6CiXV+7rI4RDALqkOqRwPUrO7F+iwvHcFLvTSgQ6HcGRMVbrEf3jhZKrrO
         uYFck2pXHkAEcC3jrQOoHz3WTfT8aUzx0Aeb82uydArPyFB01sSNF0iBMKrKVMWV1owz
         sqsw==
X-Gm-Message-State: APjAAAVSVwDIk9/o/atAKrUGZCrlxJ1djgV2iE99VIwIkEDBAEd1+neW
        MkQoRw/euQ525eUIBA5CWO267PBgZa1ESg==
X-Google-Smtp-Source: APXvYqyIi93/FflcjC3RJ/56tJ+QewHfeZiNjeHcCcRB4NLfbCF8LhHw7BfAYFiqUmJl/01hwG6raw==
X-Received: by 2002:adf:b64e:: with SMTP id i14mr21687235wre.332.1573513021984;
        Mon, 11 Nov 2019 14:57:01 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x7sm44712978wrg.63.2019.11.11.14.57.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 14:57:01 -0800 (PST)
Message-ID: <5dc9e73d.1c69fb81.f357e.5b70@mx.google.com>
Date:   Mon, 11 Nov 2019 14:57:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.83-124-gb8764c8bac2d
Subject: stable-rc/linux-4.19.y boot: 68 boots: 0 failed,
 67 passed with 1 untried/unknown (v4.19.83-124-gb8764c8bac2d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 68 boots: 0 failed, 67 passed with 1 untried/u=
nknown (v4.19.83-124-gb8764c8bac2d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.83-124-gb8764c8bac2d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.83-124-gb8764c8bac2d/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.83-124-gb8764c8bac2d
Git Commit: b8764c8bac2d5b40de033de2601cded71f291a58
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 13 SoC families, 10 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.83-69-ga356d03470=
cc)

---
For more info write to <info@kernelci.org>
