Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF517658
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 12:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfEHK4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 06:56:11 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53434 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfEHK4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 06:56:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id 198so2681692wme.3
        for <stable@vger.kernel.org>; Wed, 08 May 2019 03:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1t2s8exi4X43Hr5aODp/Ihlw2PwlwLJckexwVyO42qQ=;
        b=zI2KhR7UXHPIoNKBiTfzcAajgvdecRA9f5idH51XXyVkK0BRop8MWW8Kw9B55CVFwU
         35YnXKeHtbJI01CS8m9UH4dSGt89de6DuykO/1QFT03zIGxxU3goXWqMnw1j0Phkj3vp
         cPe7LATYLr+JFn+3GpCJ0x3AZG4QHqMWzl4KonjjgVqb1hysWDv3CRDdOSSv+O1COrYM
         nR1PQWmMQK70DzD4EUXY2yTLTEebL9ku2GFTqUFSi6pZuNJMaLsmKmnCJ8/F7orLVXeH
         AxiP8GGGkIbrAF7aInKe6I9jQOKedYv+5IZsFBlz7UIGOQ23Xh5Y7XqLyxsXl215iFUA
         RgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1t2s8exi4X43Hr5aODp/Ihlw2PwlwLJckexwVyO42qQ=;
        b=ceYPHT6N2m6iA2eI958qrBLSWfJ4QWsZM9joUC8kiiOlfLFQytS0VfLAObak2dpkG7
         GzYL+FgB3NyTeTePclYVfzVwx98WUmI6T+omfNCsM56ntt3PtF+i6E4SnIMknjO3Y2Q9
         FZNv8B1eY/4uozyo1as0QG7Ubdd1t1LL3QrxEDxaxT57MSk6COJMYmaIpRI34lwpRUbc
         soi5/ZzOQ3dAYneHPtaaYL2o0evmqgr4S9deWWxXbya1tthQ+UH0041uAean+h/zOlEY
         nwzOMD0E6rem+DObs22TWY1nHcFzapZddpYyDtdBAG3Uo+K0PzvBfJZPEo+cIcPBZiiR
         rtVA==
X-Gm-Message-State: APjAAAW4BPEft4fcA4D5ae1hu2lyDhC5ZsdVFWq43pRpx9S0hFCOnJ0e
        J8mImWf/cNq99QxtYz3nWVz8k6Tye9GN0g==
X-Google-Smtp-Source: APXvYqwGOAxxfbm2n3qyEBmryCS66M3uoUlxvBhDAW0iUutZb+RfVCBB3AidMgjcpRq44fHTCvxVrg==
X-Received: by 2002:a1c:e916:: with SMTP id q22mr2596929wmc.148.1557312968963;
        Wed, 08 May 2019 03:56:08 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t18sm33932433wrg.19.2019.05.08.03.56.08
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 03:56:08 -0700 (PDT)
Message-ID: <5cd2b5c8.1c69fb81.a79d7.ccea@mx.google.com>
Date:   Wed, 08 May 2019 03:56:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.174
Subject: stable/linux-4.9.y boot: 51 boots: 0 failed,
 49 passed with 2 untried/unknown (v4.9.174)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y boot: 51 boots: 0 failed, 49 passed with 2 untried/unkno=
wn (v4.9.174)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.174/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.174/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.174
Git Commit: d79b8577dfb7d02cada8c6671d39d10c09af891b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 12 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
