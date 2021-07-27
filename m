Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468E73D7D15
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhG0SIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhG0SIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:08:17 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFDFC061757;
        Tue, 27 Jul 2021 11:08:16 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id x3so13229068qkl.6;
        Tue, 27 Jul 2021 11:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EanZXjHMRanakeK/cStCSBbEsXpWDOkprYeaqLcjvEI=;
        b=G+Tbrpgf+t1bAMiUiwJTDoFOWHdhEDoRocI01MqK5jDeuUQuslJOI3x5TUmut7WDkc
         lcpubp7W94G5BdTIjIntd1MknMVhsznYfVjA+JIb4WRa2C2HAjQNExlvG0YbnM9ZYd5v
         pZn8cFVOcG54MetzeSGIhdqQ7GiCjLrGGazEmLitEwQ4fGSz8q3RwnJ/vXvHC+nYq5l4
         GpFzEbstnl0ccHNUmnTEuG7uH8waIxURGCbHvBgInAQJq3RPZXjaf7F94fH/TthPkmxh
         ZkM155JDVS77o2czPVm+xjIOcP7ziPmIUK2MAqU/GOGcODT7Zro4yuR4JA7RCLSsY6MB
         X7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=EanZXjHMRanakeK/cStCSBbEsXpWDOkprYeaqLcjvEI=;
        b=ovWJrKLxaQqhNht5vFy5lWjx9PShOX8ZLSjqH+pzqK2386LKSRJr58TnSG7JXP3WGe
         MmhELXvkpshOhoBv7iiEovxY+Rx8Pa8CY/oDv8BTgqRN2LBswLM3BtL1TsbpDTWSUtID
         gVNY+Hsa0AghQLZaocjKMhaHs/vz8bNZmiEyCVuCIcVmcPM9I52CGsPZ2urZ3JInorm+
         8pzvwuz71Llwo3LVoZVOQHK1ySkMeSWhU8SNlnILL6X8uZPcixxK3kQ5vWpwPiuwqHwO
         vad77pEKE4teDeyr7eL3lug5co3P8gpJXNFQneTkK9mSIPPM3GsZ+D/V9BlMTQlwyAqQ
         kBGQ==
X-Gm-Message-State: AOAM530wr8MIyxsRllxrHLJuniT1CykyLlqtK9BDXatWHDR4K0yPjkYq
        7wVlDOWqvIZrc+dyE1YH0Rc=
X-Google-Smtp-Source: ABdhPJzWsxmgTNL33fCIQLoEubrHGLtjEr8kaUwGIxUW9zfoHJd5AcZa6k+YGcdD5OwcRiQJijV5fQ==
X-Received: by 2002:a37:66d6:: with SMTP id a205mr22999437qkc.422.1627409295408;
        Tue, 27 Jul 2021 11:08:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d4sm1715582qty.15.2021.07.27.11.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:08:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Jul 2021 11:08:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/224] 5.13.6-rc2 review
Message-ID: <20210727180813.GG1721083@roeck-us.net>
References: <20210726165238.919699741@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726165238.919699741@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 07:06:12AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.6 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 16:52:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 471 pass: 471 fail: 0

Note: The previously reported build error
	cc1: error: '9880' is not a valid offset in '-mstack-protector-guard-offset='
with riscv:allmodconfig has not been fixed, but it looks like I was the
only one affected by this problem, it has become a disctraction, and it
may hide other issues. I disabled CONFIG_GCC_PLUGIN_RANDSTRUCT in my riscv
test builds to avoid the build failure, and will no longer report it.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
