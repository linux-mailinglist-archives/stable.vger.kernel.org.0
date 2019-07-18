Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09646CAB5
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 10:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfGRINh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 04:13:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40438 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733131AbfGRINh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 04:13:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so24662398wmj.5
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 01:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=nThpdK5yO2OfCE8SuE9Qiy+7h9LlRqpG8oEJp9t7qAA=;
        b=yx9okcxfEfopABERJdTBJBxvDVVkqSqCNVLbxs6ftK0mWnDtLlAL3cnQSrKIrqZQB6
         Myk598P7HPwm+4Ih1c8U6VhZSaljnFzbLzQyojI9ZotTicPt+KI9A/67chBOElMGXBNx
         YqFQHneklE2yZ6P6ftQpQ0H01SUxSUjzViXBVAiyT1eKfm1eUZWjTdjPrU6KFuL/xlFj
         SqE5DenSFXx91R8pllYTzPa0vuN6FDUKjf2ziQMfQlJ2G0RbBanqSUulMAqtzkyQYKIP
         K1kphWNTxlum/hUN6mTk7J1/SyNx1bxflLWHOZjX+x2rLLjb9G03AVxN2ezAib8/6ZMs
         kxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=nThpdK5yO2OfCE8SuE9Qiy+7h9LlRqpG8oEJp9t7qAA=;
        b=RWn4Wd9/XI7knliiHiHI99VC9eCLWHbmt1QpxpaDp6xnC0j1ZIHTOFkA3uM+Ai+ge6
         ayJqxdsVIdVJqEDDA1ktbyL06swpGQA5e4IijZARhowmXShYPKwuBtvFVG1/GFt+bmph
         8Jp7Kt9nsqejaNsKiIfI3wjX0n1OKV3iD0XgeFAmw2c2FRrlRbZMBy7DwwqFQbckpm60
         v/RSLnkJu6VJ4hYbgY7Ifn3OmEo1KIWXaRAOB4pxc8I3Fia8GQLZlYVO71ED3GUrwZRy
         zFbD3Y2SRdbevLJxRTAtSG2wW1KJpouPtw8qhclpiGChcYiJesIgND9Aus5vpCK9hkbs
         3iHA==
X-Gm-Message-State: APjAAAUFKUWRYV9WYrA8ScLHPtbtw2eKLO/viDTAOYbpZ4v2zHYfg8I5
        g3LULmqkOfvvf+8Lj4Hn4Wk=
X-Google-Smtp-Source: APXvYqyiKE+ZNi3kj4Soc3BnxSsuO5dLIlqnXPQl+JfrF7CA85nJaFOHlXKrYsQUD4QnyB2i9EC0Bg==
X-Received: by 2002:a1c:d185:: with SMTP id i127mr42236985wmg.63.1563437615136;
        Thu, 18 Jul 2019 01:13:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d10sm31770837wro.18.2019.07.18.01.13.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 01:13:34 -0700 (PDT)
Message-ID: <5d302a2e.1c69fb81.6850c.314f@mx.google.com>
Date:   Thu, 18 Jul 2019 01:13:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.18-54-ga80425902cdb
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
Subject: Re: [PATCH 5.1 00/54] 5.1.19-stable review
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

stable-rc/linux-5.1.y boot: 135 boots: 1 failed, 133 passed with 1 offline =
(v5.1.18-54-ga80425902cdb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.18-54-ga80425902cdb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.18-54-ga80425902cdb/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.18-54-ga80425902cdb
Git Commit: a80425902cdbd5ab05f9f9af4e992fee397a1d47
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 77 unique boards, 27 SoC families, 17 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
