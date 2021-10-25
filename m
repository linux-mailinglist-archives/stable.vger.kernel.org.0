Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B61643A42D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 22:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbhJYUQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 16:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbhJYUQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 16:16:23 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25A5C07C9B6;
        Mon, 25 Oct 2021 12:41:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oa4so9102249pjb.2;
        Mon, 25 Oct 2021 12:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1VT/3ZNzyAuWFO6ELlxEU+lUWEAiYMrT/MpbWt4weaE=;
        b=XMl7+0oqaZL7TBOH6Bpd3aCiw1QOy1C1bwXsPhyLZC6kJzjaUH/VHAYEsy+vfZGVu1
         J7MIiC8g9YQfzkkgQzTzIE6OOJHNzmXKjHH1x1J2N/Zygtv8irLK+9RQbsqLwm9njp+q
         ov+4baufDvpw+ZeCCtpkenkNMkeOnM8rmX26j/n8hnKNXdoXMs8bmeRJxXvhfLNN3we9
         dzuQ2uLFfduVtDOluRKbgQbNtIoXkEy1Bk1K3FsaVty6UVXnEWZu2Ba1RS43E1qRXMsI
         fE2CK/GUdP3lKRD+QD4er3MfGIMul7LMOUuC47VHyzwPIMo3Cr8xd6E/oPvWKexXSgXS
         9+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1VT/3ZNzyAuWFO6ELlxEU+lUWEAiYMrT/MpbWt4weaE=;
        b=quEzq0SMk9BvQM66sQcjtnJ3317fnMU0CLMY0dk4XLue8jeLErsQepQpOCoE9/KRgg
         SHu1jRNt0I7KT+rViAkrQUbj8cO1ESwo6VngQvqpNu57xlzoY+Gi8ev/Zz3u6nNxqRk7
         7IxILTwM/hWRBfoBCJHaTghajnjtwBxQoGqpFgKP/r3UTsp1ABUeudktLOINTPcHoybl
         bx7UIE81YzfkPGMu7bi4URkZ7gPC8/JymObmBZ/T8g8djbWwpg65APA25lI3gx6w4YyI
         c8a9BJHdDutm+jkao1szJFucO51EeeIugMr3/BKtnYbFCqpG2Jpp7rhXI3zTGBxOkPeK
         E5BQ==
X-Gm-Message-State: AOAM532swLY0rgDakhDucysYT8ciAGI4zmZqcVXE2I9KWb9Z88XacHKA
        mSIsUnbMCRBDK0T6rR6YL6eto21hY9U=
X-Google-Smtp-Source: ABdhPJy/GEhSpROMpmRTZ4743z30G5t2hqV3FWPrdPAa8ImRsltGW81OgHcf9cbvpZ/Yyq70pBxlKw==
X-Received: by 2002:a17:902:db02:b0:140:581e:6eb5 with SMTP id m2-20020a170902db0200b00140581e6eb5mr7089879plx.46.1635190915530;
        Mon, 25 Oct 2021 12:41:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f16sm3703301pfj.193.2021.10.25.12.41.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 12:41:54 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/50] 4.9.288-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211025190932.542632625@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <87a066db-95ab-5b09-1834-9fd372c03535@gmail.com>
Date:   Mon, 25 Oct 2021 12:41:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 12:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.288 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.288-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
