Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36EB89AE
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 05:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406280AbfITDTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 23:19:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56305 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406249AbfITDTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 23:19:43 -0400
Received: by mail-wm1-f65.google.com with SMTP id a6so673076wma.5
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 20:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Wb4nM1o4hpn6TDve7X6UVxGQm0c4ZWpt+c+J43uiITo=;
        b=Hvl3PU0DmAUtGenROsMmH19sJFDTdjVFgG+cHDvKlCf58x6tHbKCC/IE+dEKfzwikW
         A35SH6S4k8T6B+fcqKLnm5yWEZnH1y1bvpGXicLgCqoBSi63/+ggmTtCNBfMtWDMXAK3
         gXUauMeVu49ne9UTr3PqJVdxa/5ubhGB2kD2fOhpc4OUv3BozzQCxYNWFGV7axMngTsS
         ZJowKq4kPwtH2Br7iVski9nkLfOYmGir5uExX2z3M8CKBch9h4VKU/DuoZGEiKozHXzp
         4TCfR14oSXQ6YuqDbkQRaW4OY1H6RtpO/NyL/TwQ0qLa/xZFbSf+r9L7snJFz0fWhs3X
         3Aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Wb4nM1o4hpn6TDve7X6UVxGQm0c4ZWpt+c+J43uiITo=;
        b=TsohOQNFLW1KXAtRKDr6J4365gTk1FbD/UUdVjsMejuUqa0nOnr8p4U+SCJ+ihEAFx
         xZis6gC10x9Vg62XhLdumBi9X8lEfIhYMp5ee8PQShfKYe5HLtQlQ6j+j8DBmT2ew3K6
         KRaVKalu9yynl+tgWkAxJ8rFEhStF6zl9De3WmJa5cCKe88Ys10sNlOVj5t277bKPi1D
         q8sDCA2cb9lrwoJzuRqKUQaTFrJYjpWEZPfdVmd0GXcqweKZBzpkF5K2tmB3KtETLOON
         Ug6f5lSqYGSRAO/zgeA/s/LOFb2G/dJaQwz4admEvo7aM8UZ19vrJnfSyMT+Gktw/YCI
         AIWw==
X-Gm-Message-State: APjAAAVvPBQZLiIO5LdFiLLLeVgjaF/0nsCxMgK/PBdNj5R1Xy/sjQef
        ekibTBoaiyaFOf2PC1iLUrBkRw==
X-Google-Smtp-Source: APXvYqxLG4yddaJ4TMKUnPcZN7QCG7Rp9rvQWBQml/CUzUfeVDBIlpv5Lh+3mTePhAJbQ+9Am0GkAA==
X-Received: by 2002:a1c:6508:: with SMTP id z8mr1220641wmb.93.1568949580917;
        Thu, 19 Sep 2019 20:19:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d193sm619920wmd.0.2019.09.19.20.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 20:19:39 -0700 (PDT)
Message-ID: <5d84454b.1c69fb81.d3c01.21c2@mx.google.com>
Date:   Thu, 19 Sep 2019 20:19:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.193-75-gfebb363e252b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/74] 4.9.194-stable review
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

stable-rc/linux-4.9.y boot: 54 boots: 0 failed, 54 passed (v4.9.193-75-gfeb=
b363e252b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.193-75-gfebb363e252b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.193-75-gfebb363e252b/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.193-75-gfebb363e252b
Git Commit: febb363e252bd50629d7efc675ba30286a33f209
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 14 SoC families, 10 builds out of 197

---
For more info write to <info@kernelci.org>
