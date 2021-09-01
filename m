Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3FA3FE50E
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 23:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhIAVtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 17:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhIAVtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 17:49:06 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5EDC061575;
        Wed,  1 Sep 2021 14:48:08 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 17so887864pgp.4;
        Wed, 01 Sep 2021 14:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=qKCxtiziZJ7ouXgy5e72LsOyc7Mm7+2JHQj25q8XJYo=;
        b=ZP6HS0gNK00iSFZ5/LCv8P8n8VQtTB6X0HDHIFdSIY/0fWNadtpHxuw/pWt+y5HhC6
         gJx5zg0ItT6dc0HT/upAyBErxqAxelxQd/ovnEHOxtYazm0CyDZ1e2Eq/IVJ3i1zjcaX
         Awsm1UxF+tzEpPfvdyPmMIfdQnZakTR/U+oU7or/Ftclh0Dwz3x34uwytNCFrCgzgbWX
         XyxTD/kaTpoBNrGiwn8RnvixjbG91xcXlsc3KWGCvio0ItRjuh4PxnMUrKLZ3tyrzDgo
         4xuogE3nh52nUCQQYfpAR2om8NGbMKN76de88aQdH3QwdoGmN9R+ClWD6xEHSwCgyXHO
         nitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=qKCxtiziZJ7ouXgy5e72LsOyc7Mm7+2JHQj25q8XJYo=;
        b=lR43caPSbZ6N4t471jwqDaMsHSl4Ew/5fKbaWrxLd0rBSo55lycfBDsh+98oOkxo7/
         aLdlFm23s1BOGkKRZbUln6XLo22zEljN7OuTxAGGmqBS0BC9TsU9vdEcbfqJhb6X9Df2
         MTMbubeoTkbDNAMrsEl67zOW9MadFJZh8+5PCu4gU/G0F9T/ytzWDU20t+bnjhQocpTQ
         zINpclheIiAWAFZ0kcyJNMYVzhAeyx3y+GB8Q2YfM+nKkpDVuu0wsL1VUtVsIzARw25A
         4Hb22Qn6TQKACF2njxzdMtMn3NVEefYEqOn0/K1TgehpFzEjuwhZTWovSCWzKM6AotMu
         rTtw==
X-Gm-Message-State: AOAM533xV9Nyx7uIIvGKVgvL/HvkLgrftGmCNwXtnTbdTuUm4Y+OuT6p
        6o0wksX72bq/tmAxOdn5z4Q=
X-Google-Smtp-Source: ABdhPJyQpCLx641e/Je5p3h0qENF2oqHbiYpBvcN2erWTsLAVaEv1hSHkQYwRujI4KcUYMA6H/ca/A==
X-Received: by 2002:a62:8287:0:b0:3ec:f6dc:9672 with SMTP id w129-20020a628287000000b003ecf6dc9672mr1348389pfd.65.1630532888456;
        Wed, 01 Sep 2021 14:48:08 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id gd14sm413662pjb.49.2021.09.01.14.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 14:48:07 -0700 (PDT)
Message-ID: <94fd2615-9f3c-1ecc-f094-b3c36c10b893@gmail.com>
Date:   Wed, 1 Sep 2021 14:48:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/103] 5.10.62-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210901122300.503008474@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/1/2021 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.62 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

