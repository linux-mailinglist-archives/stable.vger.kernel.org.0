Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D8DB262B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 21:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388732AbfIMTil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 15:38:41 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43726 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388393AbfIMTil (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 15:38:41 -0400
Received: by mail-wr1-f51.google.com with SMTP id q17so28478868wrx.10
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 12:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TdseWFi9nNeS6hr9vU8WMp7sk4P8F8KbbFD+cmn/ufY=;
        b=kocKP7wZjU7zLnAeE00SbmK9ywfrYETMbAXhMDjL5AWBmUH1e8T+MfDm9tYIXp7OBf
         EEJBdieFaqf4sMO19BR4Rvo1fBYDCWxZP3qP+eiqU8C0WBb/Ra4RBE1KGUA3ngYbr/mE
         BgUqGpCJBFoOoXhR0cmeVdDHZu8kbGKPKmzih7uddnp8GDW53j+XedQ5/91bq1nS6dsc
         mOyI+w5+Wlp1/zRgq4OaYBHhZ+nfCXl6UNAN93YFH8kvM0bS5tSBuahO2EiVwq0UZtHb
         JBs8BD5xYhHHFpPtBN8jZ0tDIoYwPPcZ2MD3N466YncXWlLSmVVJd0jOL04x6sw9Wy2n
         u5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TdseWFi9nNeS6hr9vU8WMp7sk4P8F8KbbFD+cmn/ufY=;
        b=Cxwzf0mLnWp3W2g4j0kaVVbVsy4SxJRpxvXsUQAEx+6335MpICY10Gmpjylob5oO42
         j+jSDbP/7RRvk56v5PUaaJFbtU2gPsI6pkf25fA3J84H0PkuB1bpUQBJ2udzZ6qRVv+O
         Znf1HnYI4Wi+y6qwoPBw5jgCXcjwAP/SbFjJb++5b9gPeyO8ZgK+3biUuTIt4Wbj2EDa
         show/694JtcxUGCDDq3C+1LKNWGHjq0geD9MYPcn1dOP+gIiLDRcewXB2lp7dcRcZUXQ
         GwSGpKbkOm3yIvSOLRbk+3hDgbxecHu75clUZ/QkJK2DXn/RC4y9/9tyNx8dHkk4XIJm
         jcNg==
X-Gm-Message-State: APjAAAU3xWvZOhaS3go0QhgYYreRRZ8K5j2jvEU4V+dtLJjLGA+iedCe
        rqCRfLXbZ19Foc+KQW3QijsWqjn1fDJVqA==
X-Google-Smtp-Source: APXvYqy/DGVnC3watKp4zNokBOsnkHCgRHuikxLsNlOM3oeVBSD0HGy3NMcDmawbTKx54hqS30k0YQ==
X-Received: by 2002:a05:6000:12:: with SMTP id h18mr39319678wrx.156.1568403518003;
        Fri, 13 Sep 2019 12:38:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t203sm5010732wmf.42.2019.09.13.12.38.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 12:38:37 -0700 (PDT)
Message-ID: <5d7bf03d.1c69fb81.fe1f6.945e@mx.google.com>
Date:   Fri, 13 Sep 2019 12:38:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.143-22-g6073f0ee406c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 130 boots: 0 failed,
 122 passed with 8 offline (v4.14.143-22-g6073f0ee406c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 0 failed, 122 passed with 8 offline=
 (v4.14.143-22-g6073f0ee406c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.143-22-g6073f0ee406c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.143-22-g6073f0ee406c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.143-22-g6073f0ee406c
Git Commit: 6073f0ee406c52baaf3625e28c631a33b20efef5
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

---
For more info write to <info@kernelci.org>
