Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA2E6E6CA6
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 21:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjDRTHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 15:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjDRTHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 15:07:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA5710D8;
        Tue, 18 Apr 2023 12:07:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z11-20020a17090abd8b00b0024721c47ceaso113947pjr.3;
        Tue, 18 Apr 2023 12:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681844821; x=1684436821;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8GqM2Zh7VC75fP6xQJrS+F/nfBNrK09g+cvHjxUvQkY=;
        b=gmTene7NaLXXa3osb+DoGnLvSE/e8CCCdWTokrao7JOqj8Ntm+1c8sE9JVNWkp6nQR
         KYhyIaVQn9HmvQRAv/vZvslr0/hONegDZV+GEtERhgALU72HEeNE1ZHDDNCEmae0+fAP
         Hlma6CeMrMc9kwh7fxGdzbWLfAq/c6ADKAqrWUlOvdjpRPKORvjV+ua/CwbZN8iZ8153
         /RiVhHCp0VCjx1Bxpv+886vy0OGrufD9ubPcVlqeILqZLjuTArXTDmhCfcwR4OOuHX9o
         HVyZeHQS3/Qqx6yqY0DPGzZF4blnLXgoEXevb6n23Gp4bGg066HZjTuAhqrVsLA79AFS
         OKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844821; x=1684436821;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8GqM2Zh7VC75fP6xQJrS+F/nfBNrK09g+cvHjxUvQkY=;
        b=mIF8HF/Bgfd3CiU7o+F3944dEc435652NyDd66azPt4T/CEmG1kqCAtFumpIoOe2zh
         9vOEc/7GozokqfGu36GuX8O+3XeuFu5jAIZFaWwSgL2Vb3yjp4NpALr3hReMU5zx6qkH
         zynpEHWbn7bhWD8L/jUNLwnAbbnHARiGpzmrOkrMSq2vbyeu5bItS2O7AiJjF+Piy61F
         uR9NnnO2ibZl63d4Up8jquLj9Zrq0J7VNSEVdccRjeheRK5VYtuQ4LqHKtzGeolofz8F
         /ooLVuCKoe3l+7ukkkD2nMu2r9kHXK1Wu7CKCU1t/OYt0udsfVfI1zpnC3jVvQjrqzG7
         TuQA==
X-Gm-Message-State: AAQBX9fNeOVH6ak9ayI3ZHeQhpffiB+73/4lhC4VQMiwfDCW6isfEIKn
        htQxVd4FFvSQtoMKzBMpsPk=
X-Google-Smtp-Source: AKy350aZZrDhoz78Bzyp9D+tAPEDzPOQKFU0KLeuxo/A9EBVw4JrCnhZQnqOwuVbtV2uRF2tVtz8ng==
X-Received: by 2002:a05:6a20:a29f:b0:ef:d000:494f with SMTP id a31-20020a056a20a29f00b000efd000494fmr429280pzl.49.1681844821309;
        Tue, 18 Apr 2023 12:07:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o4-20020a655bc4000000b0051b9e82d6d6sm4890761pgr.40.2023.04.18.12.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 12:07:00 -0700 (PDT)
Message-ID: <cd44ea64-cfb2-a337-5e2a-59396fbd1fda@gmail.com>
Date:   Tue, 18 Apr 2023 12:06:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120309.539243408@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2023 5:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.178 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
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

