Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E0454A767
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 05:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiFNDJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 23:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355416AbiFNDIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 23:08:30 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A93B2B1AD
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:08:24 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id l9-20020a056830268900b006054381dd35so5714811otu.4
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 20:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IHIDIw9X+HNgKqaWMjFHWnqwFWpPOebnHCqcRjTjWNw=;
        b=PMQPtNUJQQqL9XLf5KR5KQ2vJeWTp4XHJl2jW8Ny9EpmaAOLIqZ9fMOjCx7THEfJXF
         0SARVf7yd+bN+UA1ep4GSZNQcqRGR2BJ9T0+mC0WgkD7KkD6gxosFeWlcx2hW4rhdxw5
         tpaUTW6m4iLOw/R2tG7afCfD80fgacS0XDNEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IHIDIw9X+HNgKqaWMjFHWnqwFWpPOebnHCqcRjTjWNw=;
        b=5LM88RJJnMJ7/7rVMDiB1UmF+/5gqClGp2bnGxUnNyLN0NjbdQC//178MkGlz3KXYT
         chULbBi8aor24aTcP1J0yyCcp5JMgaAfkfRMVES7xqbhoqzlbQOAXhuyivT28KdscijF
         7qOCEKgsbjKtMxvuqlX+V1RSYHNrZ57XWuEK6pozkXwUwPXD0oQc59/UjK/A/NL7JT6A
         ycnJlPg/Pm8E1GaPYCfAP3Waul3Qoo/AalqohDCmwJNGkQs4P5E2T24F1kl3eat1RC8k
         clcOGbgx6bMV5srY14PrgLV8S9s0mlgQ4WwDNYfZHFQCsoR0GOpQtyArLd7i1qsykfpI
         on6w==
X-Gm-Message-State: AOAM530GICoSaioJvwq8WJlxSal0V+/iavs5fGt5bDqpVP10OPCSDRvh
        PX4oQfXFWZCZ6WCHQ8p5lw5QE8cxLztCJQ==
X-Google-Smtp-Source: ABdhPJxazMlM0UIfpR46K+DuC6Dn5o5ozeYOvYKpFUnjZWXSMJ6tIU1okWRKXg2EroEX/DcnErrmbg==
X-Received: by 2002:a05:6830:2695:b0:60c:6e16:460f with SMTP id l21-20020a056830269500b0060c6e16460fmr1238403otu.249.1655176103512;
        Mon, 13 Jun 2022 20:08:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id bf34-20020a056808192200b0032ba1b363d2sm4069682oib.55.2022.06.13.20.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 20:08:23 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/411] 5.4.198-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e5577360-ef13-1d3d-81a5-2195b2421967@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 21:08:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 4:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.198 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.198-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
