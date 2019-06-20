Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB2F84DB47
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 22:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfFTUcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 16:32:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35779 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfFTUcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 16:32:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so4444178wml.0
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 13:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/s2gwm0sZfZZV5XA0kcyBBUAFQrCfBaVYcE+D6EFBeA=;
        b=pkTSz8ijtenmggKgZH35ba0ki949jj3JbfpH0+yz8lsek0EHqUA5AB+O7tNiGSI9wm
         84tgLRy7B3/WBkuRZ+TYe2InBUlDDSyEMhSC9+gd8f/0E6zpDnVrMjCJA9MkjtmKrnOb
         pibXCwxz7EcSUii46NN/WRJB2MGIjOUib3zgypetvdjVBsrzEzgCOzJTyv/ErsRbVtFo
         xlJ8qV6OMfIo7PBvkGFD6UtBa4h/WEmd0Jop9RQ55grgfCH+Dcbs2NybDXslFqL0o+MN
         i/e3DKvai+Ave5aesFBj77Cn5C+KWWEhFnzF0h+DeThW+O51lI8QhlUsAYMGbtbGbn63
         oMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/s2gwm0sZfZZV5XA0kcyBBUAFQrCfBaVYcE+D6EFBeA=;
        b=CvKaYtA736SW1fFCJbpQPQVuK8YGIZirtqqTIrDYmfQ34MURhcweagQyeeQBuUrSpm
         WPJedUF1FSxopOlkb4uuGV30fEKypawqixPlDVbZxi5x6lUpB2dU8zwCMrCMaAsNggRS
         YPCKu8HiMDX92CpXDhVq0gAKrT4ZIGcd48Wd+Xt/RfncmlenRrL9eLmxG3I5hsb6vvof
         jyZM/B4LDUCiQKKqJIeH1hkqNwOnGf8bK+Uvr5/S18eAdvaqGELjQz6DUvGExXNG8bNV
         u3GqSrnrJD12TuKr3Vnonz+1GoM6QhtH+xfYnkFokNPABZ38jIYqa/23uUJ09/jwJN7G
         Yy/Q==
X-Gm-Message-State: APjAAAWoREJEp3AYS2Q3lwt4HAL057P/0RF7eC+P6pSK0t7NcPCSlC3/
        7/eZZcc3X12e7/BdIzJMN6WoQcvuFj+D3Q==
X-Google-Smtp-Source: APXvYqzRy62kBWrdt77glA0PCLClLyc5zXsUAJ15ka1X5T8Gr2k2jrtmGI0dKeh5YTssx+ePqwiW/Q==
X-Received: by 2002:a05:600c:254b:: with SMTP id e11mr764167wma.171.1561062763402;
        Thu, 20 Jun 2019 13:32:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e11sm1243684wrc.9.2019.06.20.13.32.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:32:42 -0700 (PDT)
Message-ID: <5d0bed6a.1c69fb81.9efbc.7a27@mx.google.com>
Date:   Thu, 20 Jun 2019 13:32:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.128-46-g593d1fadd024
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 63 boots: 0 failed,
 62 passed with 1 untried/unknown (v4.14.128-46-g593d1fadd024)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 63 boots: 0 failed, 62 passed with 1 untried/u=
nknown (v4.14.128-46-g593d1fadd024)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.128-46-g593d1fadd024/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.128-46-g593d1fadd024/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.128-46-g593d1fadd024
Git Commit: 593d1fadd0247d5932dd5e626b90fe30984c2ae5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
