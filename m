Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576B1FECB
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 19:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfD3R0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 13:26:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37002 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfD3R0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 13:26:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id r6so21980524wrm.4
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 10:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=vbu+duPQ3Gidqyd1HzI106GHPJ30aNP6V5EEGGBDfZA=;
        b=sRkWg0FEoMZtA3z1TDPTN9w8e8rq4asE91S+ZvRpBLCKAm7bDaGTf9KthYHxfYs8lV
         oZb4jwoKfk5s4v5RmdVdZdeGNMOJSMDhUfR72EFGSH6pyASKhj7AK1v4LP5QVo96Go2Y
         cul99crdIYXIKVdb/lXfK+JeQs6W7xeUyPzAhoAdpVqdU8ZqBDTVDlrHAqvOhaC6GLhB
         vZsrE1wEXAK23a2MVLI8NGdAaq/NxkmHch7fOOODNKmWM7bLxZBo7Ur3mRVnmclJEbP1
         ImuaNbRnKY9GvFfth6a+Okgq5vj9IQrA2gsqe/J0+agnjRU88RDlibOwlSkZBnxzV3WE
         IVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=vbu+duPQ3Gidqyd1HzI106GHPJ30aNP6V5EEGGBDfZA=;
        b=T7F99xdCLmG7iW9lPgLFDxIsP6EPiEY/OmSZY9yFeD/qwivQb5sjOv6xVnqcEJ+fZc
         37FIgLRP1+qd5NeZkf2Kjk7dkFCPz0Ng3mtuGlsmNe0+9Nv9/1ecKAD8e2rLX8d8YQ6T
         eeurTC8XQRioiPRep3DYXXrZmbAIGQG82IXtA1NRYUTou3JzQsQuocisauyYL6VnBP08
         apULm4+gXrd+KymReWBDHOEp8MeIEC/YeBBVBBHfGbsswnI68VGCxr3CmjeM661mYE1p
         2WoHc/5cz9aujkNZebm2f9B318+8PLCOwMQHzjs6r5ph//oivza1eRXz3I4ZYJ5LrFXG
         1TXQ==
X-Gm-Message-State: APjAAAUKBdgOKo25FJJkvYU/0iIx8lZ6vi2krCRCvJ6IBidMQYo8F7yO
        lJf5LHYguI9zM2ShXXuNdMOdjA==
X-Google-Smtp-Source: APXvYqzYns8ymXYxPGouO0Ah685HRLxyXNAFU3Fc4/5PT7OuADwYfQTJI7TgNFhPSvKTDV14OJasRQ==
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr6567107wrs.142.1556645179732;
        Tue, 30 Apr 2019 10:26:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm3413137wmh.31.2019.04.30.10.26.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 10:26:19 -0700 (PDT)
Message-ID: <5cc8853b.1c69fb81.82fcb.2de0@mx.google.com>
Date:   Tue, 30 Apr 2019 10:26:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.37-101-gf0b5b3d18a2f
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
Subject: Re: [PATCH 4.19 000/100] 4.19.38-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 0 failed, 121 passed with 1 offline=
 (v4.19.37-101-gf0b5b3d18a2f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.37-101-gf0b5b3d18a2f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.37-101-gf0b5b3d18a2f/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.37-101-gf0b5b3d18a2f
Git Commit: f0b5b3d18a2fd4e0a223ff2ef04d4d1f435d19f2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
