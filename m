Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3086EE590
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 18:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfKDRIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 12:08:54 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:42252 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728974AbfKDRIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 12:08:54 -0500
Received: by mail-wr1-f50.google.com with SMTP id a15so17978294wrf.9
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 09:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u69vBb4advZHOH4GyT9ssRVBFwHygaWdr9i2jiKrfS8=;
        b=Euf6OTnMUEBE/9vUwBId2HyH0KF1agkx6vmkqpS6e6fw9/pnAe3+82LlC+OUT1g71i
         /KyohDIyD8aX0UXe2jswhCuY9N3hbOwvOTQxTuiLrFx7smOuu5Ey5kVA7PWw6nnUSgpA
         OkFYP9b8R1JGDD9ZFPMuhW6PnfDRetMM4RMBwK+Iqo41SWfTZG/RcppxmxCangKARhVB
         7zDaBYIV8JlR+OSuuDhd1Vw7mr8jZPb4cTZP/rxur+AZ3pAgbr8RKYhKsppRxMJ9JMYd
         w68ArlwuUJrad46uqhXtGbpL+BDgf5eazVUmeY9UFC9heCAiixFpjPvjt+7Ol99g2yuC
         RZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u69vBb4advZHOH4GyT9ssRVBFwHygaWdr9i2jiKrfS8=;
        b=btS8puJDYzBLV1gj5SsENc0XCGDolJwFWKK0vtnniH9BYsvrr/fLXqaJbyHL4DyNK3
         BcDczwr5zA00LuuTAJrvpVDQEd3bDs9qMLvFXEUYdFhb9Jf+C1vsImE12LJo7rhYv5E1
         uHZmFmih+7mn/aIziqc8Z9urkZcqKy2KeHoBQzaxoom771UAA6T5XWqvJ14Kho53a1WH
         ru+QSuT3IhL118syixPI9UbFWbhmWXn7a29RtQKYme557ZifbX4qkBwisjAcF3Tc4QpC
         JaZxQKi8wUshCiburP6Rpaoj3g8rrq5yt5Jvl3XIGi92STV7tdiOyEJcDCgNPOZORLUZ
         QFQQ==
X-Gm-Message-State: APjAAAW+CLuYUPPP04sk3C929YZj6rF0ux4rEhYNugoE+eR9xMOYTv+t
        vHCRGltsFaTVmH1QZvSTgUtyLgNfdMktxQ==
X-Google-Smtp-Source: APXvYqxiP7sZfxsgt0ECZcXfw0RYoT1p1H2RzXq8vqkE5xRRuXOvkN82ox0dhcWOpVA8DgjzuWSCfw==
X-Received: by 2002:adf:e506:: with SMTP id j6mr12791935wrm.19.1572887332457;
        Mon, 04 Nov 2019 09:08:52 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v10sm21988539wmg.48.2019.11.04.09.08.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 09:08:51 -0800 (PST)
Message-ID: <5dc05b23.1c69fb81.fe9a7.9e51@mx.google.com>
Date:   Mon, 04 Nov 2019 09:08:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.198-59-g4e59c9878a95
Subject: stable-rc/linux-4.9.y boot: 93 boots: 0 failed,
 86 passed with 7 offline (v4.9.198-59-g4e59c9878a95)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 93 boots: 0 failed, 86 passed with 7 offline (v=
4.9.198-59-g4e59c9878a95)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.198-59-g4e59c9878a95/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.198-59-g4e59c9878a95/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.198-59-g4e59c9878a95
Git Commit: 4e59c9878a95af67c72f21d9bad59ec22c67d935
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 20 SoC families, 14 builds out of 197

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
