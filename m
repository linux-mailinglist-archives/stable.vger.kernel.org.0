Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719B14D3B02
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 21:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbiCIU0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 15:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbiCIU0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 15:26:30 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D51928C
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 12:25:30 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q11so4129998iod.6
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 12:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1XpTtFRyRBp8OjWhCm/MZGVaucnEvplhfd/lfZENsRc=;
        b=FFgTN+ZlkuPN4lQETJ5WTsJhZvWqPRMFJy/6B3Lqg0bgBfsysxvO9kfQ1/vOLyIv3p
         EDE7T9nadlXRohjxcfJPbrgZwjnNqWHDQ8JYRm7VnOK2TYlYclUBv8sfoY0gLkUdRs5K
         rpYWFMcblwrLXUEc8MLeXv7zrPcgvIo5/3VmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1XpTtFRyRBp8OjWhCm/MZGVaucnEvplhfd/lfZENsRc=;
        b=dHgByZ8NfVnGTiBRZHTpfNrjDF4rffiZq+YSJrUCIjRuvueltcHC7Q8t+An7sim4QD
         xwpb/nIFreQm7EubvtjEVoToLjK3hz4iQwOOTDU31aqQlRrMPPDaDSq5SL+SOLvXkBo/
         9MWqKtCy1BPH939jIVoifwrF7vEjUJ5DU9TeOA89Mxfs7V640MEWBbSJr415dumWaXww
         RGqOLyNSzwOx1epLe30FAyy49Y91dzUDBCyG/rm5KamrZLT7UVlmQ22bLxz1aQiq7y6C
         mjc1mUX2bhEuaBQcJepREkjNoVTUevVrl64EAW8LS5GZ47+C4zzqLp0jRuUDtzMTtCbd
         j1oQ==
X-Gm-Message-State: AOAM533oLKJTdAiFh7NU5MTqvSg/C15jZm7gGiCEuimQ+os/L1AuymrO
        qYScmPf8yWLrbCUFHhhnvF6uIg==
X-Google-Smtp-Source: ABdhPJyRaFN0D2zzyCfVq1M6oFEgS6+YAPCfYxjJlOH+h+E4PJxSAPZVpfXMI+w5RHMX1gN2Li7hkw==
X-Received: by 2002:a05:6638:2388:b0:314:1ec0:b012 with SMTP id q8-20020a056638238800b003141ec0b012mr1069604jat.224.1646857530362;
        Wed, 09 Mar 2022 12:25:30 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id e21-20020a5d9255000000b0064160848e5dsm1510296iol.52.2022.03.09.12.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 12:25:30 -0800 (PST)
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220309155856.155540075@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e33dd043-a9d3-8cb5-5f2b-90843b342ab3@linuxfoundation.org>
Date:   Wed, 9 Mar 2022 13:25:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220309155856.155540075@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/22 8:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.234 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.234-rc1.gz
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
