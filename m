Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F73CC523
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 20:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhGQSGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 14:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhGQSGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 14:06:49 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCB8C061762;
        Sat, 17 Jul 2021 11:03:51 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id s6so12182445qkc.8;
        Sat, 17 Jul 2021 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wgY7HgYfgsELpkywBQJmB/15G0R7MbmFiQSBuw8ZIUU=;
        b=J8UbZqWc3/Cp9CNAnQ2qFcTz3g7/FvoASDvCLGXte/SG3/F3PH1Gu7pT2nixoHRG01
         +7Of270dI9Z2ojJbFTMWRLCxK8EjWDCXT7HmHnX+4vGWwz4RYLtYifYSzGAl/3160a9N
         U84YQ7jRyckCD06g/MjIuzIdnsyIERDvSdh6VC9HizEi1Th6gAvLCBtB3z09U1e1+kOG
         EAkytGKTLtGRuNb8N09zHfNV43qczOcfbQwcU7HcgZuJX2yadumBlJnqo8A2PhA4gP/P
         epptub8fSOiEXz+TSgJ90SfwyoDibH6KPijcsz4KtLZnFh8Gzqdd1QX0XlorCR+secvM
         2IkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wgY7HgYfgsELpkywBQJmB/15G0R7MbmFiQSBuw8ZIUU=;
        b=ugKEc29FxAc1cEzIdXDLddlAPNm9DyvTTQMp/EO6YSYyGO+wZh2+wmsuEeZP68Ag02
         /tfzcFc6YptnUiQi8GO9icTBzAkKZUncsMUhYb68SF9+MsOjrRKFTSaB9MjTJxWRMKL4
         nrfT3mAEnwopoppdhSASLVSVFC8n3bCUV05CrAxd5wMSZcxxzq/dGVo41meFq1GNor+3
         Ha5IzaLq/CfdQTmNHkZ59ixUq/yPCoNC7VHJUcL5haC8j/lC80Ojw6cb0udsr2kW89Fb
         uZp0wzMCggxGQ7DudPJedG6947C+mZIlXMtxXxn+AlGAibJQSKMf7Lh8NIAnahqkwuwu
         mvJw==
X-Gm-Message-State: AOAM532HWn7L4Gj6kaFajvSJ0qrmkQ+efw0gD9t4lktquGKiUb0IYUJN
        41EQh/VoVD1C110e/PLuRBI=
X-Google-Smtp-Source: ABdhPJwyGyIwbAuQMrBUpbofZjVFbvm5YZ5GrdLaudscP3eoGuniJlZGfLIbK+iHVUO65DgB6VJpzg==
X-Received: by 2002:a37:8242:: with SMTP id e63mr10396190qkd.294.1626545030595;
        Sat, 17 Jul 2021 11:03:50 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 20sm1758770qka.50.2021.07.17.11.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 11:03:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 17 Jul 2021 11:03:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/119] 5.4.133-rc2 review
Message-ID: <20210717180348.GA772394@roeck-us.net>
References: <20210716182029.878765454@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716182029.878765454@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 08:28:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
