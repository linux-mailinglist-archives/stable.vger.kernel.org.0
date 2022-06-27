Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351DE55E23F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238533AbiF0Vul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 17:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238258AbiF0Vuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 17:50:37 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC9E5F45
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 14:50:36 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id s13-20020a0568301e0d00b00616ad12fee7so7467549otr.10
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 14:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=azufkNPmRwbrIbp+/oMcurf+3VkObt2rdfnsu3lrwHw=;
        b=XljOkQGzO9z9gSyOxBj+JHGmA4CUkdIo3NaZN0ZgWQcchevT6io2KtRSmmMs4kq3oK
         2E/GKPIugFg+qEPmJ2wtmi7r8+XBjF+zL+Fx7auaTJ+B2J0iZDLoKsy5QULp+3uN7L1o
         +uq6tNnRioJjR+V44teIB1hS8mJCJxWCCptRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=azufkNPmRwbrIbp+/oMcurf+3VkObt2rdfnsu3lrwHw=;
        b=x/Ajx9tQmdYqMn/8fGMPtNffWgG2JIHM6bOTFaMt2Raw9PbRus72a642z5Mp6pjUtL
         W3ACpMt03Vd6Hh0CMLZRcIMi0ane+ZEga+J4lctVpNQZtEcD6/FrlYUi34ZjrUsAdJ5W
         MkDr43L4qy1MRMXIzsyxGBQd51JFFjoW6ardFicUnGB76vBuzuZFB4lyRdiqP6AFL5oM
         seFXy0pY6ZkDt8IAp8DXNExxRjdu/YVEZo0YAYMSSfP5i76t1QR98Ajm2+CnBz4ih+fw
         DguuzY4I9R8y1FayzfC5Z+fQybGJpq+z8ALhhqC/ik7VDGurvqFAUHXU/icF6JtiWvLd
         fiOQ==
X-Gm-Message-State: AJIora8LH9mM9eLGgo1ZtYw0UqwvUICb0WLE6uaSD1nuxs0YGWNRfHAH
        C546/CwvvU5Oc6VNExtZLcQMFqBOerxEnQ==
X-Google-Smtp-Source: AGRyM1s/FZw3CUj3prTAP2/OypO5WuTlfA9kKefHRgV28tAuvGZYXsfuZfGAydB88c+jFDUJFS2FBA==
X-Received: by 2002:a05:6830:2a01:b0:606:d153:1ba0 with SMTP id y1-20020a0568302a0100b00606d1531ba0mr6832788otu.35.1656366635890;
        Mon, 27 Jun 2022 14:50:35 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m16-20020a4a9510000000b0041bdf977c6dsm6561751ooi.31.2022.06.27.14.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 14:50:35 -0700 (PDT)
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0c192f4c-be76-bc41-5aba-dc87cdb3cd39@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 15:50:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/27/22 5:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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
