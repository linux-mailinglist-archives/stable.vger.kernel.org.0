Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690BD412CED
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242236AbhIUCs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346610AbhIUCSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:18:37 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B6AC09B13D;
        Mon, 20 Sep 2021 11:39:25 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t1so18315232pgv.3;
        Mon, 20 Sep 2021 11:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=47B7bJ2OdSD4sQtwxnbZjjAo3ZQYWPFB2ZdzZ8PpSSY=;
        b=llMT7GV53k3r9MHCtyebOIJqa+t5/j/Str3h0OR81mdyi4mfN0QA6b/HTFzKDY69m0
         08jkkvY6n65uEBxCKiefCIsxZrR7hZt3Fvczy28vvrg/L41/EnCk/+SgTjckgAcv1p2C
         u/PEZREHg0GuzfwP/nojPxsOXXHHSkGz/bI2W+1p+znXqd9D1AF3AK3zMo2QumelVxr+
         majiGXsY9rg0ki4WfdUjoBKHPsPxK2krUv3fpjQDZyoXT2COn0WaZaNw3QWlen89ub1S
         6VuC15IsgywZW9ab+oAdRz9ZU0SyE7dc7j+WYveE7MoSIUQXYjuVbE1r9A9zS+IDa7p+
         H6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=47B7bJ2OdSD4sQtwxnbZjjAo3ZQYWPFB2ZdzZ8PpSSY=;
        b=ph4n7TINXNJNJGSPPGwq+lcDzOa0KchBl/B7d1cgedNp5+6OFVftq3UiGmb1Fc8WsJ
         Mc41iFNyuCVzcdt7cUar7KflXywdxyplZltVdQ5rYA/OMfQIpSF6XY3J4bHuOIW5CxzK
         lpnDcLXqZpEcxMU3YQq+c8sbtteGFqsrCYtoX6knn9obFmOTkv6t264DKrYSaldnmQuF
         qzA8DG2rIrpeh5FNptuLVhKGYbIzLMfcaQe0cxrh12egL0m3mNdpm/4AI4Hf0xs666HM
         kbL06Jea23rBSAPmMXWICRT3vBLPL79UM311upFKIKDhOXhIb/WJeBanVusMeGBuqi+N
         aeMQ==
X-Gm-Message-State: AOAM532xxc98KiPZLchxRL86AT4NNKUMKHBxdfTjRAr1ptYMKH6+0/kb
        6K8Li7GxaPRzJ45AjCJgUwdT+UrQ11s=
X-Google-Smtp-Source: ABdhPJwZtjQmtlL9QUYuMxoALhC7iAlRjdW5ftMSHqfsPwLE/FYSgjLGjSFOvgYhhbEC1+/nyPhtwQ==
X-Received: by 2002:a63:2d86:: with SMTP id t128mr24836446pgt.316.1632163164296;
        Mon, 20 Sep 2021 11:39:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x9sm15553520pfo.172.2021.09.20.11.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:39:23 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210920163915.757887582@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <87001227-a271-e9bb-38bc-059279caaf3b@gmail.com>
Date:   Mon, 20 Sep 2021 11:39:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 9:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.68 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
