Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C799B4B0478
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 05:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiBJEbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 23:31:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiBJEbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 23:31:06 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E79137;
        Wed,  9 Feb 2022 20:31:06 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id a39so7230069pfx.7;
        Wed, 09 Feb 2022 20:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EU2DHxZQyI/LD4ONMnYRPgPVdOBJ/oJ/+lLGC8OmrPw=;
        b=n0x6Iu29u3QIYLy8mP5zuOhxDmEaZz7ibO93bXt8aO9P6QP49RVMpytLWwNZIrgHK7
         f3IxXpWBhIhCxh8trHtIwcndXrPdwOwvo/jkeuMG/c89MRBFHNURI0caDhiqVIC2QHF5
         1n4YO8gNHnERmLB4B/33GeDT0nn+rrsIYNsVAysXPqcLDL+wvCie0i/EGUGsTD2jLQpL
         I/bqeuV2cKTy30Y0GId7RWHI1EKQqaCQIpxjF28RJRYN8Hl2WS+RFfCTmpB/M28Wt++B
         aqj+4j8R6QnudvyqpJ+7nU29omS8UCceYKX/tPH5W+UPVgGpEPrUXQmhMjzGmb3uDA99
         QNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EU2DHxZQyI/LD4ONMnYRPgPVdOBJ/oJ/+lLGC8OmrPw=;
        b=fd/PdlGTvO8kUfp0VrDVlxycEOtpzHWVX25kN6hr5fDxWMAdKBeSzay7LYOrlfTl8i
         JaTya9wN2gvDQu+e5ZDu30CnrKMGs9kWltZ4Al1GIfYoOqUsewx7q5E6cdOC0s7EmKnf
         Z+SCzDKLLGa63h9dVkMltcp3L5WlATdBg3q+xqfIxcbCh9QrFDyMYYI4jCW9VE2WE3F9
         wCt+WPlXeQeB6ZLq1b1sNczYRCcMg2AHHVGo+7XyaPlTRYz5gPijBmN1xPBrCt4akM2L
         7UFkf3XwustqcCC4lBbfU9UPaeUSzMQKlSSD2wyOAZXZ++6SH/qol9XQ3E/CwYafB72E
         Uw3Q==
X-Gm-Message-State: AOAM531wP0v9KRp7Wfl0l8KY3aGp6fr907DA3GCcZhzGS/gRW1pQMNrT
        xkjpROr0AxMCeJ4QNsNK5vcxOoFEd14=
X-Google-Smtp-Source: ABdhPJydLOTjn2VIrrcKKTReGp/uIcjH7uIKT7IgL9qiPSA5JM6h2N7rRFuP21Yh44Z68gU3URnhmQ==
X-Received: by 2002:a05:6a00:1d9f:: with SMTP id z31mr5534070pfw.38.1644467465478;
        Wed, 09 Feb 2022 20:31:05 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id pg2sm384440pjb.54.2022.02.09.20.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 20:31:04 -0800 (PST)
Message-ID: <c1a8b3ee-febf-a33a-6c54-39e116957470@gmail.com>
Date:   Wed, 9 Feb 2022 20:31:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 5.4 0/1] 5.4.179-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220209191248.688351316@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220209191248.688351316@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/9/2022 11:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.179 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
