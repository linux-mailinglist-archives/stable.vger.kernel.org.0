Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D71526BB9
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 22:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384503AbiEMUkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 16:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384502AbiEMUkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 16:40:17 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F131B1CA079
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:40:15 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id j12so6475397ila.12
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9U7IF8Ez4ASLcDALNaHak7TxdaN1NI8C+9qbNu0DnNM=;
        b=YlzOC48GR6+LtROD4c4bDPZe7MYai+hGz7jzQFiL9WaO0y383azJF7ODat6mPW/WhF
         O3hIScsIJzXuLDZorFkqvM7SqPH53JSgTMIju1bJmewpvsNvoVUjDCwLC4Pvp134gJG3
         npZVs7HwmXvtuylfpeokS5Nek3x1/dhDc5uqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9U7IF8Ez4ASLcDALNaHak7TxdaN1NI8C+9qbNu0DnNM=;
        b=C8Us9U+DRKthsGujj0ME8GBv4DZGQr8MYKDTzhk21fiHprgFM+Fn6Giv9k1HzRxBCU
         09OBOKTrbEs7P/RJbn8mFx2w148igu+5Oj9jbNZVU+r6/uNmuMu+9HpFORElQe95cnmW
         k5l5sMyqvYgArDr7tYk8qYsFfgJQMqCvoyBof9Nt/L7f3KF0TNi1zfpuruB3Jjg7fViQ
         BKnlAPrpvvXFupDa1+PvfFk8hbPNHOK8YGJmfXondXzZF5JFV22ksP9rT/Zz+fJtO3nz
         EgR/WJXyY9bJkTWN599IPtxVpR47Mc6XbkUwvm7FKY/VyQZ2ey3wb4O9hX1FNyqMLAri
         WQJg==
X-Gm-Message-State: AOAM531Eog9rP8TfOISyB1bxd4QL+LfRTpk+I8c9a7kVBRNmFYvifSMb
        MSYIGpJ9WqdqHYMLNVn6hGSk0A==
X-Google-Smtp-Source: ABdhPJzJCjcz01/584Kt6YerjlbCaS2rGcazr61z5HY+9DRctgu0OieSt8xQKeALDg04mAS5+lJepA==
X-Received: by 2002:a05:6e02:1d0a:b0:2cd:fdde:a28e with SMTP id i10-20020a056e021d0a00b002cdfddea28emr3536871ila.228.1652474415000;
        Fri, 13 May 2022 13:40:15 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h9-20020a02b609000000b0032dee7810cbsm927744jam.45.2022.05.13.13.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 13:40:14 -0700 (PDT)
Subject: Re: [PATCH 4.9 0/7] 4.9.314-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220513142225.909697091@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3fc47df8-5b82-e386-e881-ba397e87a8c8@linuxfoundation.org>
Date:   Fri, 13 May 2022 14:40:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220513142225.909697091@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 8:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.314 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.314-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

