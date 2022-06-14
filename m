Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E454BD71
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 00:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344143AbiFNWMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 18:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiFNWMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 18:12:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBBB4EDF4;
        Tue, 14 Jun 2022 15:12:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mh16-20020a17090b4ad000b001e8313301f1so2072970pjb.1;
        Tue, 14 Jun 2022 15:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h7bXHj/PM2CUZ3XoNksJ4Hdtwz7ORUrDKBYGQb+dhAg=;
        b=TUMcMrO7JiWxZtESdzYr4V6hGGrwwu+0ck/dqjV+nd+m0zHTIaSCvw+oBC8VLN5SDU
         t/rQPzlrLShN6UYMV/dClB+hkwsrUNrfWckcbzLMckosArtIDAd0nvvaGa3BfaDDbhn6
         ltosBigSMAnpbYvSzDAk86LMA8ivKSxufXEjdqw5FDSDDbpkuoKsji6a6mFGysTUTIeK
         Z3mfxtxk/O33bSyFdvoEr8D3IfpDRly7QFS8K8ByXJ3SPDbGddj9nC5be45I2ADjHAuU
         zjEgH1J/RadfNca6BJs7NQFckRfVA2D+ZIWQU71s+zQbIxKx5sxVIy5BoWp6edPfFxZR
         aPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h7bXHj/PM2CUZ3XoNksJ4Hdtwz7ORUrDKBYGQb+dhAg=;
        b=euKEEJ/2QqhRUnb8coiA2CXAu9xVTpTxOIwZ4+7YeQhvLr5UDwx6ZU6DHZawaZ3n6I
         73ewO9LEC5nhG/o2MX2AkBpAwQ3DzUMx6XtfPFHK65sMQlAEyZTK2+xl5AJ2voYYMbsi
         lwYmn3ry/Pz+rvY+30G5ijOvGJ5IBfcnjAhwls9SlxN/6JklFGIhcnX0nL8GFOcpGrVv
         qCxpLnbu+qCHqoyLtNJvH3zv3cZA7GyjaiHvqQktHAmupUaYcX84YoN2b2BDNistdGyt
         sP41mF8b9RK745clE5IvkOxER4X85AVJfZNHTcp+0b73cDyhZ4OMrhn5ZSOb4krhQbZp
         03VQ==
X-Gm-Message-State: AJIora9Kbamk+jz1iZom1IfGImve9GgTM3ZmgZan1B7mTynSmfAWnKn9
        /mvOA+1tv+z2chLNYj27LWY=
X-Google-Smtp-Source: AGRyM1vse/tpkg/4SA5FfXWHkvZFzQZTsLLeE5mEigVhCrDsP05/9rds3ZYlkxkaNgvns4VWSUbuWg==
X-Received: by 2002:a17:903:1210:b0:168:dc70:e9d8 with SMTP id l16-20020a170903121000b00168dc70e9d8mr6561184plh.92.1655244735619;
        Tue, 14 Jun 2022 15:12:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u5-20020a17090add4500b001df264610c4sm4473585pjv.0.2022.06.14.15.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:12:15 -0700 (PDT)
Message-ID: <a3c74f50-8e51-1652-ea70-36daaaa5aa9a@gmail.com>
Date:   Tue, 14 Jun 2022 15:12:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220614183720.512073672@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
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

On 6/14/22 11:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.48-rc1.gz
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
