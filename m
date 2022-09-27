Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F19F5EB698
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 02:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiI0A7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 20:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiI0A7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 20:59:21 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C8DA926E
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 17:59:20 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id h194so6649491iof.4
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 17:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=/cxJ2RtF5lAdYw39eIOATjUYWPEe2tKmpN8dMrga17M=;
        b=KFH3g21hryNRGGEXjd13W0ZZD+MyX81HQ2cEHHdQ3G+jH3mt5bzCnWdWchc4y2ezU4
         tDI4xub+h7uMYjtc1dZCHosBxMN5rr/9rQDIyjBwqzGG9To5wIh3rF6ahHyJDOQ3UUyU
         cd5mjtAhUsDBl+uneLe+RElq5jL2mZZd/tUWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=/cxJ2RtF5lAdYw39eIOATjUYWPEe2tKmpN8dMrga17M=;
        b=wBP3FZG8Cvl4Ktk1GJqAtHIhgJ7HYYmDNtgy56S2jocvNBVb0tik2QcQzVrAXI53w3
         R5kQO1eTFpLmwEnfMEw+iV9Rn69q0MRqKGMHhKMdFU7fpL9dvLYA6GstoR4KbODsk6Qy
         4iuyP4qlEZDs/tL4TmF85la/e6CgH3X2M/UUoOGuO36yOJcSiv1J14W/yG1eBSr/WxAX
         7sZnHJUWWj67WtBrKa0YncPiit/5vnLdCE8AbwG0CszZZa6+njqzLeT81Jgg+ROEGF1c
         7++8vaN+5mbjUi7QN4hBo+y++ipujzOgmO47YgTLT1O3MYikYmA0XO48IRU4oL+Uu3o/
         GWLw==
X-Gm-Message-State: ACrzQf3ArObae0PxBwU4Wq8PnaqKlMvdBI5t/Mg1sS1PmRpVtOUIx4Uh
        oZQAE97M9TSbyQioXa4CKAvvAg==
X-Google-Smtp-Source: AMsMyM7l0+yRdLwaBzhRLAbv1rdk8ALwUqx6zLoDDJ+H+6B53TSXCegi1imcBte2ZGPzUyvbZ9SihA==
X-Received: by 2002:a02:cb42:0:b0:359:766e:fc8c with SMTP id k2-20020a02cb42000000b00359766efc8cmr12950391jap.108.1664240360158;
        Mon, 26 Sep 2022 17:59:20 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u75-20020a02234e000000b0035b4f7172e6sm30756jau.137.2022.09.26.17.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 17:59:19 -0700 (PDT)
Message-ID: <247df1a4-b343-42e7-7c5c-3af3299d03d5@linuxfoundation.org>
Date:   Mon, 26 Sep 2022 18:59:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.19 00/58] 4.19.260-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 04:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.260 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.260-rc1.gz
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
