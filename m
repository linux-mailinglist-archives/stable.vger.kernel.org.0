Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4B5F8578
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 01:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLAiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 19:38:18 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43041 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLAiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 19:38:18 -0500
Received: by mail-wr1-f65.google.com with SMTP id n1so16564829wra.10
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 16:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Y/jVYGtxZg2Ebf4c7TXEDOcUo7LeiKLrXWrF4K3+Nus=;
        b=FczhwqsUQ7HDUf+8LVHwLz0iP9lCeeqeREzM8GUAOTm2VjFEp+m/za1wLgQ0yTc042
         8SbzpsF3GH58adI6VEeAAPFuU3aMC+8btNHHkl7chvXbh7CypmetMhoknbX9HVWb2Cu/
         swUukPVu1KQ3U9k5Y0Anh8LNhouX/3gnPUf45Yo4EQtske1PdJlPpCTkGRBcWgrtpLpn
         G76kGMFl8/zNR2X3Bd6gIZyWSelkCuAeuAQN1C7rWXlzxvyMWO4HjrtvJlqUBKXBUrOe
         tSDdG7boVdEdEGtifMktu7OPdibG1QwttmnZqNMFPc/WbdFVo2HLEV+V/3kSj/yl520N
         /2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Y/jVYGtxZg2Ebf4c7TXEDOcUo7LeiKLrXWrF4K3+Nus=;
        b=jy7YQMqabkZ3gvheeChiQjM2JtY3Zmc+VhLd66WwC+epNktW+Vr9LehsO1S3iXTvwV
         YPnGHkreli/m+LvklbuvWW8vM15rJRinVFZrUCS9QbBaVAP7WNgTpnZ65kiift0sJeTk
         fm2sbgrae6SGKhvh3nj6cMJVIQmfZjQt20cVLILzju6VC+u8aq5QV91YTL0jtv/6Edik
         XNqdLjjFH3zKI9uAaH5fcQxz3vXzJbOvt7GdDSveeXmCteYJ0XePhnxQuvUw+7Fc1YT2
         ps5gNHizkzUWluWWEfp5D/FB9VrZokgP3Ib/Vq1nzEGMl/FWqgM7Y9D/eejhaPG++lwB
         pr0Q==
X-Gm-Message-State: APjAAAUjapS+ks3uYVNQ4OiyKQrdkSQmqbQMRL8v5zErw9umXr7Xw8On
        rLESj3pdcDJfwn4l+kcwW3JHyQ==
X-Google-Smtp-Source: APXvYqxDBrh/PxeqxYq60HtmD6/h7U6vYfQANGYbBn/xqwg6eSNWB5huvpkJt2p84d8efiT7pGXTmg==
X-Received: by 2002:adf:b199:: with SMTP id q25mr24733295wra.320.1573519096510;
        Mon, 11 Nov 2019 16:38:16 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g5sm2121554wmf.37.2019.11.11.16.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 16:38:15 -0800 (PST)
Message-ID: <5dc9fef7.1c69fb81.ffbf3.924d@mx.google.com>
Date:   Mon, 11 Nov 2019 16:38:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.200-66-gc28abeb7953e
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
Subject: Re: [PATCH 4.9 00/65] 4.9.201-stable review
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

stable-rc/linux-4.9.y boot: 48 boots: 0 failed, 48 passed (v4.9.200-66-gc28=
abeb7953e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.200-66-gc28abeb7953e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.200-66-gc28abeb7953e/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.200-66-gc28abeb7953e
Git Commit: c28abeb7953e9602995ee83594fa294f54c07a35
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 12 SoC families, 9 builds out of 197

---
For more info write to <info@kernelci.org>
