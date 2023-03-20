Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147786C2558
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjCTXDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCTXDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:03:45 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6416D2B63D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:03:42 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id u8so622213ilb.2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353421;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ol+B8Rm7LVaQanwklijT53+0nw4R6I7B4CbLiSGN/Pk=;
        b=RgYCX9O06NwGjLyuHV2WomU4VjXgs36NaRYJ0sE4B8OL458JDfwZ7SguBvR6fpVpsJ
         E1pqiN23oVloOKu/jZ/GI4lwGArFTBgJ4SPYnvHh6kvnQ8bP7JE48Mo1eQaEFmphfSD4
         0CrK5CLjWMqvfbiKh13UKqHgWt0jbxtJa28WQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353421;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ol+B8Rm7LVaQanwklijT53+0nw4R6I7B4CbLiSGN/Pk=;
        b=HJAfKDWXAJ0FnrYHYU+zVr5n81hCvd8tXO/PX3oQ10YnFQP91kvFENxCnzLV2TycxV
         lkCfIaqzcaL5gqAszFfbHJeqheGnT1tNLafaKrSnkwcdhs9mIBP+OsRjx1iZgeD6quP1
         aTkXCqkOnAXOrA7uQZR7ObKYhp/eJ2R6nG+3D+EBF2x5z4SA0/UXQeEmQ4CRv4D+l2ZE
         i2DC/+QdCs3Znz+iR2Abo/6SMwym1IRMfvh5u9zq83vChaotta+a5i+C/wHeijShJ3/4
         JMFsQSf4pRJQGUMIBfkwFwKIPEolyuFXFD7pPJJ/i1KuoSkO1GZWv+EqX7JkWeGmir3x
         xbtg==
X-Gm-Message-State: AO0yUKU2JK4o53/2R2do4bAxNbtCIAm7ZbzaBoXkkqFbebKNaHx4DOxO
        4JfElqf/ogG/r+WZE9Z8NuXKhQ==
X-Google-Smtp-Source: AK7set+qoYIZU3pybFsXNLjZfkMU3+Ix9iiBcaZ7cGlom31OU6hykJgVvVq6i0d4ySEK6jtvlWiY5Q==
X-Received: by 2002:a05:6e02:1152:b0:31f:9b6e:2f52 with SMTP id o18-20020a056e02115200b0031f9b6e2f52mr686717ill.0.1679353421695;
        Mon, 20 Mar 2023 16:03:41 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s12-20020a056e02216c00b0031798b87a14sm3167497ilv.19.2023.03.20.16.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:03:41 -0700 (PDT)
Message-ID: <03bfee60-e4f8-3b47-9c09-7d997fc801d9@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 17:03:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
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
References: <20230320145513.305686421@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/20/23 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
