Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2ED12552
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 02:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfECAGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 20:06:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44406 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfECAGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 20:06:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id c5so5599480wrs.11
        for <stable@vger.kernel.org>; Thu, 02 May 2019 17:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=u9fjAdS4qdgFfKFlDRvvkJV9M4g4jVaDIHEILhziWRQ=;
        b=lwVcWn4fm6lmr28FcUaQsljk8FqtLm5Hte6ys8oWd59t9ygx2NiGxEPj6JoZwF5opJ
         J79wAJ1J3kHm4sOV32Or83vLTqNxrm3DquSx7ekcoR+7DhwXYRYG8pp7TBo2WQF0xm/t
         DJjD6mWcgA132V1mYKqI6H8hho1Ap79YKUK3OD0Er7zooJvKvkUnFuOtI6Y0+c3afkAM
         Ppiz/is79P/UvLNDKzgSXsqjLxnT2sofXL9WLTfkQGcKc+rG/6rh3lSV3nS0s7WlJMiB
         uV/4MWxjwJwve8u+o7KnkALqqwEZTqaREypJEnYhiL836pxNRsQGyjLX86NBV7mhvBMb
         FegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=u9fjAdS4qdgFfKFlDRvvkJV9M4g4jVaDIHEILhziWRQ=;
        b=O3J3i/CyPgUJTRKDl91GFCTN+YZ1RO1s3F/nK7xe9g78N3pus1mS5n1zlchknCk906
         8zzDCqW/eyPPrp/4Oorgl+9WKxKpjwkzGLr/+qCKarf+lhBXzk/7o4cKJeXYmh7qpuW/
         y15o6OQ2UR925dnQ40KAilAFPAxVeQdD1TFI+SgpY8rm4+5bbipLpCo8I3XT77NhLxeT
         6ltg4hcPaiXZfLqTbv1Pi6XDD8NM9A+RTg2h6uH21wJzl9lghBV+E/fT4M6z6qhVkv7q
         QlsuJAMBVjR2k5iRySNvy5fZOAb6yTkg7TEEwKPj3JR4K8BDlkEyMWtqgBPs4zA2GzWF
         yPmg==
X-Gm-Message-State: APjAAAV79agMjPDntrLJNgUhc9NalV5IPNuZxaofAjcqydyupj4pEskR
        H2pknGyBeMToVM5eJfhOE6qS96fZklbDyg==
X-Google-Smtp-Source: APXvYqxe7cb/mNz0rZXAg3iZnw2AsmeMfr8H9O8EUYtf1Wley4+M0XNIm8yW59JI2swvkgST7iOeXw==
X-Received: by 2002:a5d:408c:: with SMTP id o12mr4671872wrp.302.1556841990764;
        Thu, 02 May 2019 17:06:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u9sm538056wmd.14.2019.05.02.17.06.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 17:06:30 -0700 (PDT)
Message-ID: <5ccb8606.1c69fb81.24d63.3313@mx.google.com>
Date:   Thu, 02 May 2019 17:06:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.115-50-ga4aa5bff0752
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/49] 4.14.116-stable review
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

stable-rc/linux-4.14.y boot: 122 boots: 1 failed, 121 passed (v4.14.115-50-=
ga4aa5bff0752)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.115-50-ga4aa5bff0752/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.115-50-ga4aa5bff0752/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.115-50-ga4aa5bff0752
Git Commit: a4aa5bff075214a024ba945abb791813e33860ac
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 24 SoC families, 14 builds out of 201

Boot Failure Detected:

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
