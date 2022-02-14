Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE164B5DA9
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 23:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiBNWcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 17:32:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiBNWcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 17:32:53 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4812213C27B
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:32:45 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id h11so13462552ilq.9
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 14:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bf3Bc9D0jq7FIQN8gAz+SqtonqNFQ5fVJWGQu1QWYfY=;
        b=VfdBSkpHshMp5wBY5CwOnjlb5zUmG+oIpXuTRFgzc47kldK0W9AwzZJxd5XsTdul6l
         uxIgUsbnceGZaazbjfzdmNCcJxdeQhupIeig1cUYRR2j8HD+ZRu4aF8NaOoAwIA8P7Z7
         4uQ4CoSwDy/vRcbhM3FptNb1F0GvhcnzRBl0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bf3Bc9D0jq7FIQN8gAz+SqtonqNFQ5fVJWGQu1QWYfY=;
        b=OCHA+wGt0Tv4hK1HeA9VmaVRhTcYPvQ6u4CyPIYPbJ1bxBUIC7SxUkHKlNVZNdIR6q
         64/upc/RTJcfjFqilOkEff7YKV9ynBxBeFzOgWCz9k3w5PnnF4f8Tuafwt+IjP52XpN7
         zpjSZVrBbtoGv6+naB7inH1bnZ+d2b5lvY82WG/gp7x9s3JCJ76j6KyYOiDwhEmhAusM
         oDzB0UsSJehuTsV6MA2fCy28r8KPE4LJsDw9d3WN6Xqtz5HmnY84vpc2C1CRIXGlC9I5
         xfakxFdZpQDu0NZk29oBwHPPXQgFIahooa48c6mS0xSTu2u2Fi0WTC6h6ipcvK7IiaeK
         huMA==
X-Gm-Message-State: AOAM530v1TXuEMd1jPONO7vr3LaZWFK5c33gVNzded6RnbqjW0K37t6t
        kTvfVSBOT2E+VQ+W5NgcIkTiOg==
X-Google-Smtp-Source: ABdhPJxo1HOhkhI5r7CSbOsckdFZTyzCWIiFOOl2YmJ2qTKrqbkUSaH13SB07sOPD1onMQZSFPIRag==
X-Received: by 2002:a92:c5b1:: with SMTP id r17mr617226ilt.320.1644877964635;
        Mon, 14 Feb 2022 14:32:44 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id x14sm5865419ill.88.2022.02.14.14.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 14:32:44 -0800 (PST)
Subject: Re: [PATCH 4.19 00/49] 4.19.230-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f9998c23-3ebd-d9d0-60cc-14a375772846@linuxfoundation.org>
Date:   Mon, 14 Feb 2022 15:32:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/22 2:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.230 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.230-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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

