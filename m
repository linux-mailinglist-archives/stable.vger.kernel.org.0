Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A6837EDA5
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387906AbhELUku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382748AbhELTpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:45:49 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6044BC06138C;
        Wed, 12 May 2021 12:38:43 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s22so18973145pgk.6;
        Wed, 12 May 2021 12:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X2+po+CE8y4b516zNKcwR5jnPBfnwHYbKT5dIIbbfa8=;
        b=ESFYbRkgXH+ffHdMg/rpuah9IsM5pwiyyYZFE89PySUyG37tYLHH86pafnhXE6xRDY
         ojQePTb4MYZURUg8OdKndJQJEvaxztx7KOb1ElHw3Bd9V6f0favj+MnyYWBUmfPO/44x
         Zzd839s+r0shcVsgV+KHTbUEZt+9fKEwwtu9KxZX+FcDFosKpDOslq/Oxo44FGQOEQEt
         dHu51QujZYa7DsGu95W6fHAhOE9s0/g9P5umIPma5ltIENlWK5r22iJ1BW7WZIdRweHp
         uNokNu7XZhdZknJs6wJxBqifc4eO+uCslGpTUVDLXr9dEzKoUv4upwO2bXlmDsRl95yE
         wdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X2+po+CE8y4b516zNKcwR5jnPBfnwHYbKT5dIIbbfa8=;
        b=MyeI7MSKrkZx2BHjTTHxZXYPxPnifMIhNFJy0rT2I5x+Kp7IIhas25ULXIQ8xjOdL2
         CMA2WD9cHvr9ORjQjeE+2BU+5zZZqDkf0VZ7TBDmq7BGLxn1WcrVoc0q93zYGfpemPU+
         +lbarGPGr9mamaCjj+rX9DPVPNSMRkE94Hivfh2uvWzovmwCqVJfwxl9SITVRm2sbjtE
         aifDXZ3xJaWoqGs8tkxAhyNqU0B7uR7kzzB+EWdQDpbNNOd42stfReN3fG7dncErOyxK
         3oHPvemBmIxAIw4H6iBnojWEtpqOPEq5jPaKeWjOyM6my/PPRW1XFv1339BzM1eCqCod
         fMrw==
X-Gm-Message-State: AOAM533J2IwQcqj5lBmaXJZsuAvCw/ySBBduyqftVWmQiBE0mFvxLIFJ
        cYgZH/L7snwrGj9ZpYe5o6vmnJTFy94=
X-Google-Smtp-Source: ABdhPJweJCK9XZDcO7EjC8CFYuUemhul94ii7u8S/aCjKaWJgw4HSbFTOXQZ3pWWfD5SJAdoI29l4g==
X-Received: by 2002:a17:90a:a581:: with SMTP id b1mr41325649pjq.53.1620848322637;
        Wed, 12 May 2021 12:38:42 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q7sm511891pfq.172.2021.05.12.12.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 12:38:42 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210512144837.204217980@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5d3aa062-5a47-8600-2a33-afc61dae5596@gmail.com>
Date:   Wed, 12 May 2021 12:38:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/12/2021 7:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.4 release.
> There are 677 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
