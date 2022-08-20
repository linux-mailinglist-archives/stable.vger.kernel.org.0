Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E747859AA3C
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 02:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245403AbiHTAoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 20:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242643AbiHTAoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 20:44:07 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D8F5B07C
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:44:06 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id p9so3067234ilq.13
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=bZ8RKWoub7zDI8qytH0/9GauYONSz6zZBCdgAMn/+QM=;
        b=DXhnNDs1SiUs6AU7OzvdCketCPUO9Gb4n33he3lpSzivtc1Sk1iqWzEt8g8fqkC85Y
         mhjcwkh88N0Ue9RBPSOc27DVKFqNlq0a1vV8A0xMGQNg9+Dzgxw60fLhw7Fyy2H+UB7b
         dPofjI16rOaJB+NY9UVLRWuZMazUkzFD/iGf0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=bZ8RKWoub7zDI8qytH0/9GauYONSz6zZBCdgAMn/+QM=;
        b=I5WAJlwaV7TEIIdVwjm0n9beZDoHTMPEQMBsjNxdum4FA0iJj8iDd7p6bEZprGUce7
         Uy3AuAwcd0JeLxsQhdBDD6SIlYeqSzClp1haZNXArBUVxH1m44Z/GPatrPEpXbBYlaFv
         hPrMIpew+VA2RNsPBNIoTB8mPIloifgKhulQpUBwtPv84Frepsmz1mXvMfB0WWUHWgDP
         KgV7lVjltF2pg2IbXJP2umZhJ362bA5cxIpYhJrxVTnvpFYFlLBtNLx4GIuUEVkZU398
         LpbqOuDaSJOP9L4fq3rzQX9rPsmvJMlmhAwGqSAf/AYn23qEwGtMESAPaBONsDKEpAAF
         IVmQ==
X-Gm-Message-State: ACgBeo3xlCVSb1osBoRjyxW8TtF01BpOffHKzJj8H3M/B6dS5rYNrGeK
        gtV795QeoR/eXJFozYhgx5tW8A==
X-Google-Smtp-Source: AA6agR7xgINOqkpvMqrEfKaHYxmlRyc9aD7l6fJHbp2usckoc8h+bWjBsb0jkPWFOjZ822lC9cyWjQ==
X-Received: by 2002:a05:6e02:184f:b0:2e7:f42:f905 with SMTP id b15-20020a056e02184f00b002e70f42f905mr4567760ilv.235.1660956246185;
        Fri, 19 Aug 2022 17:44:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h3-20020a02c723000000b003435319789bsm1187994jao.146.2022.08.19.17.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 17:44:05 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/545] 5.10.137-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <66550b29-fc41-4b24-aadd-b0bf559b94e0@linuxfoundation.org>
Date:   Fri, 19 Aug 2022 18:44:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/22 9:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.137 release.
> There are 545 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.137-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
