Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA6C4B0D69
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 13:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241477AbiBJMRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 07:17:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 07:17:07 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A14116E;
        Thu, 10 Feb 2022 04:17:08 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id i30so9860422pfk.8;
        Thu, 10 Feb 2022 04:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WHF1RWc56iEqxR4rGHxDa3d4lPmQZECBnMy5/fMq4U8=;
        b=hoZmVVW+gZMMsD122dMrOPK9QHZyUY2vm+hsZ5v71qu64ZBcjS0NnDSOf6TwATJI5z
         RbpRLLViI6k0qt1vEj09VeX5e2De0lcFLxSPuziqdZ5hT84EmAcktFjwRtK0eOi6XwQY
         XEoISYp5x8kiYvis2VkVON7BV3XH6vEXsQFZ7SywJxS1x52TsgjU3Cs9boWOeU5un6lE
         UAZRU0HDNmnvKJn/mH2oF3bvoioc/OkEelXd2gFPDHmjNMN7eb8vtqIz0RV6nShym/QZ
         JZftNdGZhXyTA1TDN9h2VGJo4RehgTCV7q+uJs77GTIanCyiq0IVEX49GkG11d++LMU6
         +6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WHF1RWc56iEqxR4rGHxDa3d4lPmQZECBnMy5/fMq4U8=;
        b=xW/50e8krqyrfbTiTUBgCZhUNIIaSPdJkiux6swkEZmztMF9YjuBMYH5n0aL8rdK7S
         MA8JMt//4HmxHwKeFPwoXw/tYo5ir/qjU3DH203wnjGVtLHFKbOeyq0ZQnLt43rX/GlN
         gLNLRQRyQLFjMBA4NNYAkrFhMfnKy2Nj/G5Zu+a4FfLLGqEeC4q1PfTcPTBBUbMg8eFC
         xFszU6uLf2r0+ucbtsC6h1azlyQHikG4AeLYhGRovLix8Zpnts2m55VhbD1FsIKWsF9z
         bpFobvsbBUj+aXgw7SUIRzImNxyxnOH7Nj1M7gr8Uz5djX8+ZJM0GKd28gCmXQv3if23
         FWMw==
X-Gm-Message-State: AOAM533MTf1uwJWadgdIyIEazWXaZY6/TVrZTzOOWcf719aMGnJ9lOFL
        610ddfn52Plhb/7NYcAsQ/Y=
X-Google-Smtp-Source: ABdhPJzFSaQ5io/oy39aM/do/W/exTdqUfhkx2Vq2aOlHDZ5TFMPqo5tzpket/zIYhtrA+yGv+qiQg==
X-Received: by 2002:a63:dd0f:: with SMTP id t15mr5916213pgg.12.1644495428396;
        Thu, 10 Feb 2022 04:17:08 -0800 (PST)
Received: from ?IPV6:2601:206:8000:2834::19b? ([2601:206:8000:2834::19b])
        by smtp.gmail.com with ESMTPSA id r12sm16860920pgn.6.2022.02.10.04.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 04:17:07 -0800 (PST)
Message-ID: <3531b0fa-4eef-aaa9-6509-39403019c909@gmail.com>
Date:   Thu, 10 Feb 2022 04:17:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 5.16 0/5] 5.16.9-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220209191249.887150036@linuxfoundation.org>
From:   Scott Bruce <smbruce@gmail.com>
In-Reply-To: <20220209191249.887150036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/22 11:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.9 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested on x86-64/Cezanne: No regressions during Clang or GCC builds, in dmesg or during a dozen s0ix suspend cycles.

Tested-by: Scott Bruce <smbruce@gmail.com>
