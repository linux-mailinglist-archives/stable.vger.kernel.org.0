Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F405292F
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 12:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfFYKOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 06:14:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39390 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbfFYKOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 06:14:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so17169864wrt.6
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 03:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Whop85WzF5Gd+F4hK4DSXaHouQ1I95XUhj5PRaWMOvc=;
        b=AaHnuISLf4DMizbgsG3uG2So2XN3wJ065jvQAHDn+vFUlwEoqAalUHS932bRVUv3H9
         8bgptTMvEG6lb9BLNnkM/0MvIdMavHDGZiaH+MNNatMUASql4WNTPrk7RCtU7LXK+CmV
         n6lqH+Wri93ZzI/YyzrSQT1LmF1fznP/Vbo9AoNDDhW75V2XYQNY5wOCzEqnUrjMly/q
         KW+/az9vMyI8yF+T1+rd1LY+oQ4uF62/fWe9opuNmzSKdQ0nXouQ4C7oBaHEImjquoDn
         7b8ZFFR2GRvvwvZ/au4qlnf3PAh7PGAg4ptyej5iUlynSRjCFsiPfMCVL7KuYY4yovih
         EoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Whop85WzF5Gd+F4hK4DSXaHouQ1I95XUhj5PRaWMOvc=;
        b=q//rVuci2n18WEshBAI5qfn2suM9a/J5mSdhofRlqRXXIU5Uj/mzT+XChZkd7Pv91v
         faniEa0NaHjnDj1iPWPK6vi5Zmpj7GAMuxbVln8pPqArS2aqZfV6ERM1/LeUOIWyIrBN
         icbZsag5Orr13tkJ+hSeFT15XUujVEw1WCH7Kxx60zhNxwiK/kFiMbmpgKyvAYRm8age
         RbYbPxO46Sy1W7Yn1SgedmsKxBmtfZ06HJ/WgmYjbGZCI1xL72Xz1xAQnNLkhvi2UMkA
         1e+xPHeUhliQ0SNz6lSnofXHQO1+FCyM6WalvFWKOWjorQjQNiYzSHsF2n3XTDctQiBf
         /MjA==
X-Gm-Message-State: APjAAAU4z8eB0A+2i5CSzUam3Uy/0PBze8Z7D4E0+xora7it1hUPWCbD
        kEV69TgQgN31g+HCONjVX53KNCFy/J1MsA==
X-Google-Smtp-Source: APXvYqw6iJLP8RrgAq7TDymMoRoIF4L4AUHMEcuALQLCIUhdJAnewr9ZQwOKRoa1cUqlZQvOYdzp6g==
X-Received: by 2002:a5d:4642:: with SMTP id j2mr14995507wrs.211.1561457653298;
        Tue, 25 Jun 2019 03:14:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t12sm14571318wrw.53.2019.06.25.03.14.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 03:14:12 -0700 (PDT)
Message-ID: <5d11f3f4.1c69fb81.a06a3.ee3a@mx.google.com>
Date:   Tue, 25 Jun 2019 03:14:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.130
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 73 boots: 0 failed,
 72 passed with 1 untried/unknown (v4.14.130)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 73 boots: 0 failed, 72 passed with 1 untried/unkn=
own (v4.14.130)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.130/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.130/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.130
Git Commit: bc2bccef19ee4353d759a12950088b968b5c6618
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 35 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
