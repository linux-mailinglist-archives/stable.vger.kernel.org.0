Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD93E33323
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfFCPJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 11:09:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35492 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbfFCPJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 11:09:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so8557843wml.0
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 08:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=+v0ksz+v1QeBz3AO0+lw6RHxL2RhfcevttjzMHAowN0=;
        b=grt6b5GEAxzqTT8DRiCycpMhGnQ7jjRLQXiNHrcmIFttcMmPCVfhMOZopQ8UT7HULc
         mpjZKN21wuYbrJ++Xp6iRx/MLlcxu5rCKDpG3vaix2YzdBSGOkQv/X8Opg2FJNY+kVhS
         qEacSe+16eOhtdfVOFapxvXKsTrnasqFbtPhVsJ0GiZcorqHbY7TUwRB5WhS8O6v7CSE
         W7fzVJMD/RFWeN5nwajML+VuTd9Q+MgVH+MzM1L9+5M0my8uT4J6YASXhkndqTakkfeq
         yStwWQSJ1Bc3VtkNoraRnuvwGGwlFiu8tqdFKLhRcsVE9uGuuc7hGEWxtmzpcPq1rC27
         tJQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=+v0ksz+v1QeBz3AO0+lw6RHxL2RhfcevttjzMHAowN0=;
        b=g5gQhhpfYSwtjWZax6La8s6I/QMiMHTFb2Q0Pl4XDQXyho2vLrgVZ+55g8G7xRhP1D
         mDJmjcYoVQFgb/cZuMgST8QS14R+mlRbvvq2Kp62R67Qzay2xXtbMuyM1BWMWSOxGXQ3
         0y6gj7KjeU1Zy63ETAlfISPvhDmotH0AL78lpoQykY3ob7oErY8Sca38/e4/HROKWLtk
         GFmOdXP5FXfSImWFP9TmuEdX9MtrSXN4MPIGHLRlr9jPvnJ2g3Whr0p4huOx7gIqjvZL
         F42KqCXheQjDT5AgjaKOvVC/pCl8jjCmR5mFgeSxCdgYIMxdifCkGiLCY9ueo97j9wXB
         9HyQ==
X-Gm-Message-State: APjAAAU3GLbhgEJU7bzcfvfz1bijsdDSAFeoXtuJh4dirQTm+wjaIlxQ
        EtCzLjltDqmIo0MZQHWGwqtqzg==
X-Google-Smtp-Source: APXvYqwfFVbYULRxFu/j0snY1WG18gwE+wmUhObgB2TydpP7QCujHGs44s97PTHEuPlxdxs7v7cetA==
X-Received: by 2002:a1c:4987:: with SMTP id w129mr2680223wma.41.1559574569345;
        Mon, 03 Jun 2019 08:09:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f26sm6730600wmh.8.2019.06.03.08.09.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 08:09:28 -0700 (PDT)
Message-ID: <5cf53828.1c69fb81.e6aad.52e2@mx.google.com>
Date:   Mon, 03 Jun 2019 08:09:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.0.20-37-g9866761971ed
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
Subject: Re: [PATCH 5.0 00/36] 5.0.21-stable review
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

stable-rc/linux-5.0.y boot: 132 boots: 0 failed, 129 passed with 3 untried/=
unknown (v5.0.20-37-g9866761971ed)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.20-37-g9866761971ed/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.20-37-g9866761971ed/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.20-37-g9866761971ed
Git Commit: 9866761971edf6312f8144e0b73e8e831883a461
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 23 SoC families, 14 builds out of 208

---
For more info write to <info@kernelci.org>
