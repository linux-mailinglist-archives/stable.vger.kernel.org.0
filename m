Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254CC5E7687
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 11:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiIWJMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 05:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiIWJMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 05:12:07 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A1111DFF0
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 02:12:05 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id cc5so19432124wrb.6
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 02:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:reply-to
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=yOhBcsSjO+MpzEhoe8MX0+hDz2sg0Smantc0+52tgkE=;
        b=NjlqivXbtpQ5CRPwvLVYTWRRKOozg7t6ougcXLcAl9rRG7ABs+TlL/HReI/tSZjG44
         fcO/MY/f7yRHW+LAdUucAa9lxh+knCGFWTqz0jszx/C/ZP6pvgBU3PInPUeY1/55oQtE
         6Owj1nMJglWOnZ89roBuak811ui20t0gErNDe/99puoK9nctXPdzM/5RpYFpidIPtl6p
         SxlAP7l95SC5jmdEfYViACDknDV+tDUhBfwBN5UMIlXWXz9737qkS9ukG3mVLVjG1BAp
         dXIdlRPYxRJrQ0iUJtIh/yD2+2/qwg97AQcWFBsR5S6zRXu/nO3ieFrkJof8DX7Ro9HG
         vJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:reply-to
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=yOhBcsSjO+MpzEhoe8MX0+hDz2sg0Smantc0+52tgkE=;
        b=c6QnuEhTm2lEDZILYC1j2eu4Gg8eC9kN7Tz8pzDupa1W5OCUAM4W9+TG7pFVL0M3pd
         dRrU/aJyFfTxWatIAOOKXIJNksNpkvoEb0iqqMSbI8Bw+9OMP6ojEOaYYKD1s8JfJ5T0
         jvjvosaQP3YgLBDfHYxDFlDsXZhnlzGBEFJVSJMhvNYTqRxwZi47lZokZfO8n6qiFNSp
         16QZvp32/AM25W6G0qE6yrrAKC48VFnwycXA10fTR4eJz5I3AN/PR+aMgG7scF3WoVSI
         DeFXVlv/wOu0RXwrD60+wJi/kUfKYxAp75WjN12MXtgVDhFwXtDTE622+e5d/SOHubV9
         yTwg==
X-Gm-Message-State: ACrzQf3ZHInCpijmdyTnALd6nA2FaK3klnu9SPoOFuQ+F3qsUfwg4m25
        v3/173VbpXpbFKIP3zsSlK/5JhTM/Z+HgipG
X-Google-Smtp-Source: AMsMyM4as+Pxy/mIXDrxTa6jW7JBFzmQns6zeg2+qRdsIpV8qVNxU+HJKLnue+tm/4+m4R+F/xlsIw==
X-Received: by 2002:a05:6000:1788:b0:22b:315b:450f with SMTP id e8-20020a056000178800b0022b315b450fmr4801695wrg.615.1663924324444;
        Fri, 23 Sep 2022 02:12:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:5990:ddf8:daac:3833? ([2a01:e0a:982:cbb0:5990:ddf8:daac:3833])
        by smtp.gmail.com with ESMTPSA id az41-20020a05600c602900b003b492b30822sm2050892wmb.2.2022.09.23.02.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 02:12:03 -0700 (PDT)
Message-ID: <db3b3082-5278-7ed8-4322-2422cec227a5@linaro.org>
Date:   Fri, 23 Sep 2022 11:12:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 247/779] drm/meson: encoder_hdmi: switch to bridge
 DRM_BRIDGE_ATTACH_NO_CONNECTOR
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Agner <stefan@agner.ch>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-amlogic@lists.infradead.org
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180347.894058731@linuxfoundation.org>
 <892a917454bd0bbfe8a4d34a5170fe50@agner.ch>
 <685b64f60375b69c5c790286f1386be3@agner.ch> <YyBoACiWvW1UnfQA@kroah.com>
Reply-To: neil.armstrong@linaro.org
From:   Neil Armstrong <neil.armstrong@linaro.org>
Organization: Linaro Developer Services
In-Reply-To: <YyBoACiWvW1UnfQA@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 13/09/2022 13:22, Greg Kroah-Hartman wrote:
> On Mon, Sep 12, 2022 at 08:48:24PM +0200, Stefan Agner wrote:
>> On 2022-09-12 18:08, Stefan Agner wrote:
>>> On 2022-08-15 19:58, Greg Kroah-Hartman wrote:
>>>> From: Neil Armstrong <narmstrong@baylibre.com>
>>>>
>>>> [ Upstream commit 0af5e0b41110e2da872030395231ab19c45be931 ]
>>>>
>>>> This implements the necessary change to no more use the embedded
>>>> connector in dw-hdmi and use the dedicated bridge connector driver
>>>> by passing DRM_BRIDGE_ATTACH_NO_CONNECTOR to the bridge attach call.
>>>>
>>>> The necessary connector properties are added to handle the same
>>>> functionalities as the embedded dw-hdmi connector, i.e. the HDR
>>>> metadata, the CEC notifier & other flags.
>>>>
>>>> The dw-hdmi output_port is set to 1 in order to look for a connector
>>>> next bridge in order to get DRM_BRIDGE_ATTACH_NO_CONNECTOR working.
>>>
>>> HDMI on ODROID-N2+ was working with v5.15.60, and stopped working with
>>> v5.15.61. Reverting this commit (and two dependent refcount leak) to be
>>> the culprit. Reverting just the refcount leaks is not enough to get HDMI
>>> working, so I assume it is this commit.
>>>
>>> I haven't investigated much beyond that, maybe its simple a case of a
>>> missing kernel configuration? DRM_DISPLAY_CONNECTOR is compiled, and the
>>> module display_connector is loaded, so that part seemed to have worked.
>>>
>>> Any ideas welcome.
>>>
>>> FWIW, I track the issue in the HAOS tracker at
>>> https://github.com/home-assistant/operating-system/issues/2120.
>>
>> It seems that backporting commit 7cd70656d128 ("drm/bridge:
>> display-connector: implement bus fmts callbacks") fixes the problem
>> without reverting this commit.
>>
>> @Greg, can we backport this commit as well?
> 
> sure, now queued up, thanks.

Backport of 7cd70656d128 ("drm/bridge: display-connector: implement bus fmts callbacks") is still missing in 5.15-stable.

Thanks,
Neil

> 
> greg k-h
> 

