Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFB5558C7D
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 02:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiFXAxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 20:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiFXAxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 20:53:33 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ADD4FC7C
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 17:53:32 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-f2a4c51c45so1715700fac.9
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 17:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uTdstcLiwi45Kq7NrkTuh33QHrRDlODGJnmWa1oTpfo=;
        b=MLNCUL4UAZc/rOWzabkiYXMczZj+mtR8TkpSqwN85kYkX+RcM1WYCBDYgljjpJ8CGC
         LSaB/nf5JkCWUR+LPqwFlsIIQ1MAKhkvAZMuAu8Ms4lx5sKUdL1lC44OeQ5dos6WfZJa
         cgDLVBwF402r+28YUV7vCrTWHtlVEpTtaJctg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uTdstcLiwi45Kq7NrkTuh33QHrRDlODGJnmWa1oTpfo=;
        b=XuXtRoPMqneNEMMxN2xuojk3ukxm5Ec8rmfgDDu/l9uPk1fZeHRRjHTpA1ac/mHK24
         dmYvpuWDKyPjH4m2L/+1RQ2EJHh6soT/VvXazEK97fFPwO/+GajVL6Pihz+EDJh9ijRn
         JzyMWORHYjUEUCyKMOM/P4PShfdHHq83cb5Qcs/j5Q7wbc9w7lL14RfMBD+Hpq/GEhL0
         Ijm3eFzxlI6PyXCXzdeF6QzDpGlujHPWS9K9W4m2Yo7ZIJAl9/ymqN1UdJDghwtwkJRG
         cm2J6WEx/O/pijLkTTUPQiKC3kkvBfrugeoQhAs7PfqE3cqEI+geqgipkvK2vFaSdL8Q
         KSMA==
X-Gm-Message-State: AJIora9u1bC4+WRirThjZzU9v9b6xrhW+S4CTMVxmywuAtezj0cYo5U4
        +er89213OpX1zLhHM2TbJsmYg8xnxKKeNQ==
X-Google-Smtp-Source: AGRyM1tlo16zzHO19J7yR4CzpDMkddwetXPyXIRGsKkUP3MHZ6WD4PzUJMbtmjGgPvyJ6J0aMj/ZVA==
X-Received: by 2002:a05:6870:354:b0:101:1a93:312c with SMTP id n20-20020a056870035400b001011a93312cmr416116oaf.261.1656032011565;
        Thu, 23 Jun 2022 17:53:31 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a62-20020acab141000000b0032ebb50538fsm326102oif.57.2022.06.23.17.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 17:53:30 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/234] 4.19.249-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4b524ecc-0e34-fdc5-9869-5601b118b6d6@linuxfoundation.org>
Date:   Thu, 23 Jun 2022 18:53:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/22 10:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.249 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.249-rc1.gz
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
