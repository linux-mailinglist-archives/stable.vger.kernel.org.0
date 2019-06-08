Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299C33A029
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 16:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfFHOFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 10:05:42 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:36429 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFHOFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 10:05:42 -0400
Received: by mail-wr1-f52.google.com with SMTP id n4so4865314wrs.3
        for <stable@vger.kernel.org>; Sat, 08 Jun 2019 07:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X9QCSRVrKe7SgyAUE/yAaL7V9mTkl9b7I3Mu2D8VEP4=;
        b=ZgXGsHgas8yCNrJL9r5Oa3KcZerPxswtjOEVhX+U3uZSyKdxAtm3LRxPdKxyguy/UZ
         f2UhpiTc7dCQRXo3mezaHiWqQY/SDos3fN/vFcYLGR8AOdO3zsyBOXOF33wAtfo2xAY0
         hUocwC6rOAP52Lw2f4EWXB9kJGskYmXvPDqTfyZqYLdUoIIbWNu+rrthoqS0I7C+DUMe
         zwqvCcGTaBxacvDHyN8PBAX9954nczm6wVtn3mAMVlbKGyOdZyT54/X4nFwjL8+5OytH
         QZE/3jaGIHo0CSH4fl4cZqOt2R6TqazQaCEIL5hRv6xh6nMEYXOhXLkT4+OB8gUBvxeD
         GbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X9QCSRVrKe7SgyAUE/yAaL7V9mTkl9b7I3Mu2D8VEP4=;
        b=Ccp3Negr5jtl6yMCBlMlIpNGR6odsFNR0vsk5ufZ/+V9MbAba3xypfLkJOb8VhkDE7
         4mKMnbzACoBtlC0jldYdyhpocpyZbICHk/Ll0RLQLg/l74Nw7rDpynRXnh+szU6ql6A6
         X9DI6F+aSXaEkFrBDMfsj+DUyogzyPE+C+jJryAh1r3eeGH/ldcyrdwuQs4dCXFIMw9d
         jXC2FEa29x1siGX+8QoDZnDIfPgQWffgkyBf4qFFqlofzmjLnbEYpv5FZumTZ/zRxNR8
         Wh9xBXAkX/y8BB5RdT8b7Is1fb8QZpdtxrHvAha7mRPxzym9UvPNJNkxeXlrCIcuE+05
         JPOw==
X-Gm-Message-State: APjAAAWWvL90068xqGsvwv9jeV3SNhedDq8NcwQRF78n+0Y/EyMTZJZH
        Bka17rQXmCOXCa2zcmgSBQrigwdmzVRRKA==
X-Google-Smtp-Source: APXvYqx8d9dUUVIz6VhfCZZ6Ky0am+iCWtaf0ixgO2oZx5iF+pZyriy2ys5cqs3lFi3KgyR6+sul9w==
X-Received: by 2002:adf:e309:: with SMTP id b9mr5607718wrj.135.1560002740977;
        Sat, 08 Jun 2019 07:05:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o185sm6204094wmo.45.2019.06.08.07.05.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 07:05:40 -0700 (PDT)
Message-ID: <5cfbc0b4.1c69fb81.2d932.6b33@mx.google.com>
Date:   Sat, 08 Jun 2019 07:05:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.123-70-g396e28a10fff
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 116 boots: 0 failed,
 114 passed with 1 offline, 1 untried/unknown (v4.14.123-70-g396e28a10fff)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 0 failed, 114 passed with 1 offline=
, 1 untried/unknown (v4.14.123-70-g396e28a10fff)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.123-70-g396e28a10fff/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.123-70-g396e28a10fff/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.123-70-g396e28a10fff
Git Commit: 396e28a10fffc503c28b113c1e867b8e3684a98a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 23 SoC families, 14 builds out of 192

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxl-s905x-khadas-vim: 1 offline lab

---
For more info write to <info@kernelci.org>
