Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D076C2570
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCTXI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCTXI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:08:26 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B911815C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:08:24 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id u8so626708ilb.2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353703; x=1681945703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=193ZdOl7SmXU5xeY7DK97JfDt7Ox2MJXhwHZJWEZhv0=;
        b=Ei4NGEDrdfbAmexe2XLEWXKkrttTK+tBPNy6BhvhSViPqVyVK2uDrXir2qrLOp1DCQ
         23gx0NOvw9hfNRI5xFN5P8n8a6a6jLGjyyH5mLfNvyKqF+jeIxCym7vz1VjGF91WgadU
         /lQQT/IiKeBbMuCKOjkSjA6Mo1DhbdbAR/0qQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353703; x=1681945703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=193ZdOl7SmXU5xeY7DK97JfDt7Ox2MJXhwHZJWEZhv0=;
        b=r3H2W3VLBrsZF0HBIC7VZj7wHz6nJmNU/f54hyRlhAkY2birdS7rD5d5qjmFPatEgy
         HhyOEyMP47Cf/OC+xHRieAoW+QJMegLnDmUU8hUPzu/9Y0XcY4HZ4aoaNe5aRb6bEA2V
         kGmxL3l3wXW3s2P4hUd4CWaU+2xqwtsqRyRPEWCKmIjWCHLcR59t/jo53QTUekLfYASI
         tnO2ncJPa4XtI7EAjheGfWvFVts0gsFqNrdAce/FpUPXyA7Z42GFL2fsLRrzq+XJNhOc
         DPgr7MqNzNpm5AGYQqaOrjwtZcIaOSgKIyQiEjGcX7segkk1WTbIbVl62BAZg9n0Iq1H
         JuAQ==
X-Gm-Message-State: AO0yUKWt7191EPsWPnrIj+wyTgE0EfrpLvtCWG6oOKoWIbFMS7pTmWO6
        uHVtzRDhG8wACpDnyronQ2t8PQ==
X-Google-Smtp-Source: AK7set95aLMy7g+Tk9W3WMdi8i2FWNkdvVdRafgY7l8+4MqpL62RhoOp8c1KBTH3hwOZXZnBezefnw==
X-Received: by 2002:a05:6e02:12c8:b0:317:2f8d:528f with SMTP id i8-20020a056e0212c800b003172f8d528fmr817655ilm.2.1679353703656;
        Mon, 20 Mar 2023 16:08:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p17-20020a927411000000b00317f477b039sm3154582ilc.4.2023.03.20.16.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:08:23 -0700 (PDT)
Message-ID: <2301a5b9-bfb0-07c0-5c1e-b92bbcd286a6@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 17:08:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
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
References: <20230320145443.333824603@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/20/23 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.176-rc1.gz
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
