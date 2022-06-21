Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E90553E27
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354444AbiFUVsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354749AbiFUVsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 17:48:10 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F4E62F2
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 14:48:09 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-101dc639636so10299553fac.6
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 14:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+XOxgLt+8CfXfbfzLH9tvayu4wMZME/C42A9ODjVEXo=;
        b=JR1YRI1B1KRK7OAqxxxM4RpwErvT9KIOSsVJlcuYsiTa/0Zf0zd+l535FsL1Y+uJIJ
         qPvndOdMelkoexoEvU6qAvt2vsrr2J1uhsv1t/jB5qYxSixEA2h4NzlSaXEoTiQNPZ7P
         6Z5U78PzQ1jG0FTSwaxM+9letqBfAAeQNGqXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+XOxgLt+8CfXfbfzLH9tvayu4wMZME/C42A9ODjVEXo=;
        b=NDA6nwqzMeWADkjVKgK190hTtRN7MTbhKhpAFjpErOnnpNSjy5qq2mAOEXwsWT2417
         r8dJtVEODQcADl7eDJX4f6svmqFo0PsqqGEJfNb0QaBi+xBunhUENdnC+Dt0NqDtDuOd
         U23n8aYiJudRV+A1Dr8GFZD9mhYDYXSBUAK3RGgbIz23vGEGCw9BmN6l0OW2mQ5Tqw7e
         LcGn2Tkb8fnQlTj1bAYH/Z2oXISPAjBNXaWZX7qeSVZimgMbYrBl6q9xqORD5F1pdJLC
         CD2HRtXTsxvaoP6Sx2FwVl7/mID9S4iwRa4vKdPRy7NJTSgmpLVqYy2bQkOV0RElwI6g
         DxmA==
X-Gm-Message-State: AJIora9PfuI7BW+TJz3hi4IIPEr1mndaeombIiKO1DtgsurrxIMxrszi
        ezB/5nCutpJBkTiZy9m6QEu3Fw==
X-Google-Smtp-Source: AGRyM1uq6F4HgZzSIZTbKPiz4Y6m2yStaanhpHmSEbAyXpVXT3YvEwy84fEASiffS4Zcqp8NFYi0qw==
X-Received: by 2002:a05:6870:d698:b0:101:1935:e46c with SMTP id z24-20020a056870d69800b001011935e46cmr120344oap.154.1655848088659;
        Tue, 21 Jun 2022 14:48:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i3-20020a9d6243000000b0060be71204casm9917689otk.53.2022.06.21.14.48.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 14:48:08 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b03a6cb3-b13e-68cf-3909-90480392b0eb@linuxfoundation.org>
Date:   Tue, 21 Jun 2022 15:48:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/22 6:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.49 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
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
