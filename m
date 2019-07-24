Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4AC741DD
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 01:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbfGXXON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 19:14:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44194 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbfGXXON (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 19:14:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so48630527wrf.11
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 16:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=UfZy49/B9rbS8h7ed+p9jIYgC2BxNXVvPg17QcKxhKw=;
        b=AXONP414SzQTyKZdrYqjb0wZ/8hyJbFUEYVuxzsUf/qfV8/5CelNXtt976kSZJggsl
         iu9NOBBEwy8DRFWdgmBtqxuyQOpS+i4JvWhRI2hIYsm7+4OI89M+fTsI677oFmWkACm+
         NQDfCFRo1SyATYZ7SJr3c2DAz+v2HKfdt+fZ4+2SaEcVH1lOObBOFC7OD76c8bdGhGyG
         9knzIYg0Q9s414HsRX3Npy57aPbHBx2q8VFWVug6bx9pB8QA5Fgf3iYjWE13Bd0kYrNV
         vZR7qw6il7c81u9+fy70gNIdgOUv1+xhx+5nPSrITsDXPHL4+mCnALg83L4Yh+qrDnvV
         oEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=UfZy49/B9rbS8h7ed+p9jIYgC2BxNXVvPg17QcKxhKw=;
        b=s3hBbMQ9y+nS9pVZ2KY5QvBGjVCoRCE6UoRuypEJ49ckSGsncEcTYoAn7bMl6vdf8r
         G7IXHeke4bQEgr3ErseNj7a4YKkyDa+jhHRvIv6nJwLWz/o6vD/Luiiq3dagc0uNzH8u
         iwzLP1cqqyeITo/DuLyzHOlEhOZ8RN+KAr0cWeb63xYFJfEEdy6Lj2ZWKn11ci4jHkCU
         DaJnEv+AZ4cLvsw4u+nokNZeeIXUzazMEy3kW7iLogxBLCrxWRu89d/R2vZLmZ5ktWag
         OuQmECl5qn1vUwUQkxG56ydBb2kT5KHZlTj7hSm1t76gUxmE1GvlMFUOMDz+pY0/aGwP
         w9Og==
X-Gm-Message-State: APjAAAXvtNkvdsWatEWoFdKFlA5pioKHscChqcshRkTcwBdwpSGIv4ix
        c44MxcaoxGbQTsAlZM9g3Lo=
X-Google-Smtp-Source: APXvYqwgBaNx4efwTA5LqgKWCGthCQ0HQtQFeDZRvJTEacIJ7Jgw1p2DZE7vTaxRMtQN+HTcZKjriw==
X-Received: by 2002:adf:ea45:: with SMTP id j5mr15050019wrn.11.1564010051906;
        Wed, 24 Jul 2019 16:14:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o7sm40705283wmf.43.2019.07.24.16.14.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 16:14:11 -0700 (PDT)
Message-ID: <5d38e643.1c69fb81.dd59c.1f01@mx.google.com>
Date:   Wed, 24 Jul 2019 16:14:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.2-414-ga4059e390eb8
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
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

stable-rc/linux-5.2.y boot: 139 boots: 1 failed, 136 passed with 1 offline,=
 1 untried/unknown (v5.2.2-414-ga4059e390eb8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.2-414-ga4059e390eb8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.2-414-ga4059e390eb8/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.2-414-ga4059e390eb8
Git Commit: a4059e390eb842ee95dcb0b856eee5cc422a815b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 81 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
