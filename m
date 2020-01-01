Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4203B12E058
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 21:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgAAUKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 15:10:19 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35111 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgAAUKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 15:10:19 -0500
Received: by mail-wr1-f54.google.com with SMTP id g17so37559910wro.2
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 12:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UcTDc4HL9TiTCRlNUV5WjcqEIV9uY8DXNe2jjE/cnys=;
        b=Qw8yracvVHQCWdIK5QuXLMaqHn0L0BDqzHyPAzkx2D50Ed1DMIHecSv7fs+Pen8Oui
         wgs3sMQsD9ZJHKK9cGslmepzZ3zGiekuohLG4wNfNDM8HjE4QrCH5c8f8QHTuobPDQfU
         meHFcfUErlZD9Fmf7IUF908JarMXLnAYp89qUwQFzFr7L8r46KKH5gteUVgAmpovR1n3
         uBeq7dCj8dhJJ5VsqBlicjlUaAOwI8piB7u8NammtTru81af7IZJw4vfUB1H88iez3xb
         2qmAErziWxfwXNcGsErCMT+LEJfy5CYC2lsKHlovS+jew0QBve6wy7GjcpjCYcCvaHno
         RDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UcTDc4HL9TiTCRlNUV5WjcqEIV9uY8DXNe2jjE/cnys=;
        b=h+mlCAj6MAD0V6e1UL7iuaz/Xpw35nNFKtwD6Dg0Sgc3sx75tE2Ba8v9A1NoCl4IxL
         EfaKn0ytzkTzZfRlYJpEkGCPmCpW7SvNlUjse19Q0DzXWN+1et9nt+QkqdfPXMNPB3TP
         f8UJMS2UW1EeARw2AsKSZzqa2WuZixKtiaNNEzzlx5l5eHv4xX1qW9HQCFo4KtYLWHfO
         pBT3TsUE1lITbTa6sUzjdc56FpCx94JjYJ5DAA8nPTYI5rGVtbEjAPYirT6dNK2Awq7E
         2A6bvqGsNBWjRechxuR42zgBKdEYdTFSBIRtevFBy139vhoAoNPJwoRELkcBVgCgolO+
         8GKA==
X-Gm-Message-State: APjAAAXqbmvyMHxXhEFEvYN/BNv8bW5yeZQgTfK+tXl3o/b5Hee4ZeE5
        3pLWqqAO35zTZIh1jpA2+nUasPDcw79iEQ==
X-Google-Smtp-Source: APXvYqyDyfLGhBHSE+CwDWgcH8JE5BUX9Is76tfnegvYDk1Q4zZxKxf9T+5RTYmd3e+pkexclKRjkw==
X-Received: by 2002:adf:a285:: with SMTP id s5mr77715693wra.118.1577909417080;
        Wed, 01 Jan 2020 12:10:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u8sm6311660wmm.15.2020.01.01.12.10.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 12:10:16 -0800 (PST)
Message-ID: <5e0cfca8.1c69fb81.ceb0d.cdb8@mx.google.com>
Date:   Wed, 01 Jan 2020 12:10:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.207-127-ga42767bfef96
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 20 boots: 0 failed,
 20 passed (v4.4.207-127-ga42767bfef96)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 20 boots: 0 failed, 20 passed (v4.4.207-127-ga4=
2767bfef96)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.207-127-ga42767bfef96/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.207-127-ga42767bfef96/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.207-127-ga42767bfef96
Git Commit: a42767bfef9634ab2a4a3b6c64324fc6e895e9b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 15 unique boards, 5 SoC families, 7 builds out of 190

---
For more info write to <info@kernelci.org>
