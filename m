Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF0654A137
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 23:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbiFMVS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 17:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352090AbiFMVSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 17:18:20 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C60B12082;
        Mon, 13 Jun 2022 14:00:58 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id hh4so4780893qtb.10;
        Mon, 13 Jun 2022 14:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gWdErLqInvM1ccInRYlKQ/aTN1Wa+cjq/iTF3o1VN9I=;
        b=bwIHsfewcGBOdBcc4rM9cpENx12C9rDMD5KZHB4fAEQ0jH9IzRN3Dwvr09S3VKJqvk
         Es8clTWrPeBKgS6xy/z1URARKdS6mjSErjKmkU+FWHmnd7pO02dQD8/gYhYero6NlcWt
         4l6GBn0FcjAP/gkAmdbj5oQmu9q3Mk/vbYK/1Qnn1Ip6Zs1EPyCLwbiBusqamrJscW6v
         PtrI6E0EeSMq7nAckFG9FI5ftWlkP/sah696iveqSZwnP9nzEFC3LkCjMgJcwMvuM49K
         YsjspgYUNaZ3fCT5rnHdeEjNwCX1oJYeXB13oecOzikt5rmLP29UawZa4c09dN16fRHE
         Sc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gWdErLqInvM1ccInRYlKQ/aTN1Wa+cjq/iTF3o1VN9I=;
        b=xyW39CT16w68Fn+dCpYfiQ7Jc1TCwDRSCYmFeLBdS6viDPZ3Pg5OtYIRu7PkYD+lPW
         6EdyyP8QSNnHqRcHwwczAurEaBCOGInYJRr3LlS1XvA+pziY0x6Zrpfo2G6zCnt/lyFZ
         fG7ybJ8OWvP/Dtv8iEhDEezHWQNEQE+TrhvITEAMI6E6F1dLNi1XirXjV0YlCV/O+g+d
         DdNoT7K3hUfIMcdgSqXJVS/gUUHkZyFkXOJZSn6OiTQhpI7x6EMhILELsdGqyAjRsrWh
         jFA/bz04+bmyYCyG3n1CY+ygOUFtBFoswoxLWYZvOp3c/5Ds76n/6+eIpu9shF0k/PBP
         qIWw==
X-Gm-Message-State: AOAM531PazIdoIrmALqhc5ADwQZhzbSgqJEsAnkAvpfBk+Gm5d3CTWhu
        xRgUV61P3walXuo5Q7gyG1E=
X-Google-Smtp-Source: ABdhPJw/GpF9MPk9/djp9w3tlTLFzalidGv3+Xfed7VOMHSvwTI2pZM9UEx9e3K1b3XAttVm4dg/8Q==
X-Received: by 2002:ac8:7fc1:0:b0:304:ed32:4463 with SMTP id b1-20020ac87fc1000000b00304ed324463mr1562341qtk.504.1655154057141;
        Mon, 13 Jun 2022 14:00:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y11-20020ac87c8b000000b00304eb8e880dsm5532781qtv.23.2022.06.13.14.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 14:00:56 -0700 (PDT)
Message-ID: <4d56c202-ed90-4385-6075-568ab7c8aa5c@gmail.com>
Date:   Mon, 13 Jun 2022 14:00:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 000/251] 5.15.47-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220613181847.216528857@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220613181847.216528857@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/22 11:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.47 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.47-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
