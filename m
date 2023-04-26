Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F9D6EEB6F
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 02:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbjDZAao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 20:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbjDZAan (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 20:30:43 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ABAB236
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 17:30:42 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-760b6765f36so15032239f.0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 17:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682469042; x=1685061042;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9r2n61XQ2tavEnqazBzHxzy9CxgS4MxG6ODhVmjzzO4=;
        b=emwickuX3pToJ7a+2euZf1fTcQX8qM16FUyr280BGOsM9eJd0koFamWyMgj8xt4zCS
         DEdOh6v6JiDHl0HD7fObCtYDBAWqD8VrTgfqAMbNol53u2DchsNqad4VzQomUV8pc3MA
         DcT34CluFmb6RFDfheWuYyPCR98Yio39/h6so=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682469042; x=1685061042;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9r2n61XQ2tavEnqazBzHxzy9CxgS4MxG6ODhVmjzzO4=;
        b=ULcspNWUut/33ftEgjqHLOb1I9LftxmouwFiM5dM+qtV/85gOlyO0NWhjVEpCNmsll
         AOMZbpieV05NIg6CMN72xsVZ1aveYc9sYqsC0k85fnxzschwddZ6hZRN0jen3D7j+xAM
         TmUPjuJ+xgLTlkEMhZ4yp4xgHJL+/3VjlQxX0Vl3nyZHMHyXlaOwIrAP2BjmgM+4yqg3
         uYF8L/2JFeSFcvKCM3Rczb8EMhAkAZ08zL16/6pg6ApnNLDBlxyWgKz9LbcxWj/qyAwN
         xIcxLHPH4slN82PrpmOwY5PZD90lr2LQ2TxIZAv/nJ37S4GovhktmouyRsVUdtZwE7mt
         oLqQ==
X-Gm-Message-State: AAQBX9cnMwMDUIdttsrM1f2jhZjDQ9QKorbilo6EWW0B8+9pA5OtelU0
        oXZrSAFSOnEwxcOuDjcb4mri9A==
X-Google-Smtp-Source: AKy350ZjCHRbeWBKeFGPldyJwe1amgMDnqjftO6jFhmxd9on5UGZ7D3hVzYYSogDnw6rGvCex2DBDQ==
X-Received: by 2002:a05:6602:379a:b0:760:f7e4:7941 with SMTP id be26-20020a056602379a00b00760f7e47941mr10668374iob.0.1682469041983;
        Tue, 25 Apr 2023 17:30:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id bt6-20020a056638430600b0040f98da8c45sm4303128jab.72.2023.04.25.17.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 17:30:41 -0700 (PDT)
Message-ID: <5c095468-7c35-ac80-fa29-97256f3e5f55@linuxfoundation.org>
Date:   Tue, 25 Apr 2023 18:30:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.4 00/39] 5.4.242-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230424131123.040556994@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/24/23 07:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.242 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.242-rc1.gz
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
