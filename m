Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAAA59AA3D
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 02:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245119AbiHTAml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 20:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244409AbiHTAmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 20:42:40 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAD9116096
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:42:39 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id c4so3655294iof.3
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 17:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=niIN1Kakzgk+A8M8Oxm+5LYyFX23pn1tIT/dk70Tghw=;
        b=fFZuoFBkrKhlHPmkit9lC5X80sc8iqURBH7E0aGYWKpbtXnny2UgMQoJ8p14ja3dBG
         5JzcfBqxPIevqUrXuLJWB8eCWAAAbnA4VDq5uD7apwRxl1e3Ez3t6Vrxf1YgcDn534un
         j0QhwgXXDyqMal6qgh3hA7y3/MuH1jJvQ9zK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=niIN1Kakzgk+A8M8Oxm+5LYyFX23pn1tIT/dk70Tghw=;
        b=ADQDTK2Umf9e0GoaNjzQ7i9aNCD6KSMX6C3ju/cewamVgnF2fVq+jsoKibcrnvC6sc
         XcPItaLOZP2T7etGo//ryYPN4gIC9c2xaWA2bO7r+6f+WtE9bAFtoqb9M/Y7JlHw/W7l
         eJLUCJrR6RQhTlN3786GtbwCOf5E1q6uTOMXR49j4ByzuhZ0IHKC7HA9Gl/o0sVdFg4Y
         aThmEh0NNjz0L8RO2rdQ6kYZQqS7+0KfCtJMrXZizBptSbTlGBfVi7MjH/JptAkO3gmb
         iEmC+6nXNUd7Q/giX4+B8wviXNVuMQH3rxTPV6wNah6DkpZItv1NXd2hgOxH8Qts9YDW
         BgHw==
X-Gm-Message-State: ACgBeo0ApvsG1StJiPZfk6KIqgGXq/MfoNBknmG8PL6834J98nP6O0WU
        IA1bO1+lfLY+IeiS9+crOcib5A==
X-Google-Smtp-Source: AA6agR4hQ3XyPZDm4A89FqG1YXTbZEWJGSlawHU9IvvJNAB4mu0pu31V4NwQFzleoqq6+nxEVYsVxw==
X-Received: by 2002:a05:6602:491:b0:672:18ce:8189 with SMTP id y17-20020a056602049100b0067218ce8189mr4558916iov.170.1660956158723;
        Fri, 19 Aug 2022 17:42:38 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o64-20020a022243000000b00343429c9cb6sm2325852jao.139.2022.08.19.17.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 17:42:37 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/14] 5.15.62-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220819153711.658766010@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <62b2ab15-3675-71bf-2ea6-6376cd0b3b6c@linuxfoundation.org>
Date:   Fri, 19 Aug 2022 18:42:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/22 9:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.62 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
