Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699EE5060B5
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbiDSALs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbiDSALs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:11:48 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E72181
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:09:07 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d3so9511919ilr.10
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 17:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xBYRxu3ooTGcBwD+jjIlBhk9FkRMvsQZ36qo9XY7+PY=;
        b=JRv98ccg6BqRGuqyNqN9MjbZcx3Mqb2iCSRZ3WKYMYFnW89ABytpdfc5jsYua4K7Jn
         b1mFdHRJxxuSwdQAyRagKcerHTyDFKoH/yBPeBdg/j8atAEJV3wENOkysxfUavM3o5hP
         hoJQb4kHY8pL6X8JgP6czlduJ3avq4NiBKYSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xBYRxu3ooTGcBwD+jjIlBhk9FkRMvsQZ36qo9XY7+PY=;
        b=oKbkBWHmrc9XuAdisvfsU8yVxKd2AsAgo9MIP28JXSP5+V5cDrJ55UoELvaQGXiEWd
         g2Ydzl4edu2wFOLMgEtQHhg0nMxSswqSKLKCKVRaw+bD07ZXCFbyv2F4OkF5tdovdQOs
         hqxq1ftpNHrJj0QIqbMUwZHtUZkdbplh0eS6mivgKDnXASpXMlnMqHXJc8aP2wnd1SUB
         0KgN4EN3rBu7LbNCoNHs8TS3TzZdo95LmQoV6n88JPa70Xx7PBZ+rgxllnADYGDBcvCm
         1vE3vaa+urbz9Aa51MNWamCYKrNlV7GsqSPO6a7ImSVRPfpVH1LTXUnt9DtZkxSgXg74
         8bBA==
X-Gm-Message-State: AOAM531MWLN86qVingY2NIWLC9kAPbzeGoHuM1Uof4wpqZK5mKN+7YuK
        jMhPWUyX4ilny/l0uaJEDZ8wzA==
X-Google-Smtp-Source: ABdhPJwUctKmVR4TQKXoWDJXP4KY1ydRv1tjZWk+KAvzbnN0iI8E1+TiYFgSM46HZ0RznJe5J9fTrg==
X-Received: by 2002:a05:6e02:17c8:b0:2cb:d6f2:74d9 with SMTP id z8-20020a056e0217c800b002cbd6f274d9mr5486419ilu.3.1650326946856;
        Mon, 18 Apr 2022 17:09:06 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id k6-20020a6b4006000000b00649d7111ebasm8706347ioa.0.2022.04.18.17.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 17:09:06 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/63] 5.4.190-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <05d6d15f-b4b4-32f3-b431-c9970a945856@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 18:09:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/22 6:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.190 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.190-rc1.gz
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

