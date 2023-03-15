Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5056BBDD5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 21:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjCOUSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 16:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjCOUSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 16:18:47 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4492B2BB;
        Wed, 15 Mar 2023 13:18:45 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h19so1459568qtn.1;
        Wed, 15 Mar 2023 13:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678911524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i7Oo4rCLmTR5khONcZOf3GrOVIeiQMyZuYfMGppjVe8=;
        b=g4iBEngLjsfZmcXFPg0qcwM7BY/7iF8NmuDx0pve4vKan4QD8olTTnPv/mMm2U4BxO
         D04tG9G6sGbIeRT4WFXX79HhdIOSiNDUfp3KNl72rLAP0D7NjOmox7AAo+fLNhfpxW50
         08pwI5j4ah5lJ7ftuzCYucjS33UYIy3IdIyXfipRKvTGwLPnrX94srUe4Yoc25ceEIPH
         0rBHVbxkrK2VhFfw4aPBYI/MQNaKtPZwFM+igvt1sxVgPhmNbed99BtQW7sRLGg0hQs6
         DlmouuxDgPERMPzkyd9ciCJx1DoOxp8E/EQV5INBozTZlKQDy8LzfL1RQhRNyBslOFrn
         6CwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678911524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i7Oo4rCLmTR5khONcZOf3GrOVIeiQMyZuYfMGppjVe8=;
        b=nU2C4051OwDdSgQ7LE7uSIvQAR1leKJhCtjX0oJtKZetZ2ZgzKaaNo0hzzT/WkqvDL
         Vpi/u4NRJypsQQZyaRxoor5AslE+uN3ILE0b8zQsbUzU15ZsFskSoAtYbuZ0qgUUCd4l
         40K35s7NHlNNRqubviUExRTZK7UUMenbqqrZJsQI+JzK1G35dGUe8BDocgaYHXH7ex1U
         NRKdAYFRJmAfiQwc4ieMa+xm/Mnz0AtPlplIRWDSYw3oEduPezzG1O/bIg/97D0rHZfV
         +1T8UNSg4JtJSfArIwG1WSJE1qe4daP2/pVMADzjym7lUy5wSQyNLII68F7HwwJ0m87U
         VPWg==
X-Gm-Message-State: AO0yUKUqP4ZGNjB4cHHhFechwbXDdSUTdOOkfsg9h904sjPvSiEBR/ny
        YYL6mgnBYz1gGLgB9oMuf90=
X-Google-Smtp-Source: AK7set8ZnMwV6chz+Olux+wW3D2kVdtiHQV8qLisY8LiCrsEcF0E7sMgOsppzt4taZJaYW5HIk6aQQ==
X-Received: by 2002:ac8:4e41:0:b0:3bf:da89:1946 with SMTP id e1-20020ac84e41000000b003bfda891946mr2084099qtw.1.1678911524243;
        Wed, 15 Mar 2023 13:18:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 24-20020ac85658000000b003b85ed59fa2sm4424090qtt.50.2023.03.15.13.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 13:18:43 -0700 (PDT)
Message-ID: <27903740-0dc3-4373-bec9-430455bb98b5@gmail.com>
Date:   Wed, 15 Mar 2023 13:18:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115731.942692602@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

