Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0A45E772E
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 11:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiIWJbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 05:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiIWJbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 05:31:19 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB462ED5D8
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 02:30:24 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g3so19427699wrq.13
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 02:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=NsCaxjSsnAPb9dr7jfz45Z2k7us6uvI3bad+ssBYPRY=;
        b=kbAlmpgaEhf+5kfZd0SX24hWQBfs6lcGNXHiOLu0XLbPbbDq0VKm8G5TI+fPbE0Vm1
         JomapF/69N/+VHhQNzJckRo24YdeHtN2fRdvUhLT/DUjRZv7hny8rK4zUIZStUCYN2Bh
         wVUvQovR86bYYvrqW2XAIiCP7d2AszTLEftzWrTtOUP5E6SHsqL3tD+HHW6GfcIVPMzj
         Pes9Bk7HYpkTskt9vLb7QCAb6XvOl6dCcssaqJwfalDPtBykq8O7KdtEdTJEB9U9VfcR
         C4HRGXiUbojFb0hx6rCow34cFwi8wqHyx+P0OqGbC0ikFlnI/7iEt1nB82stw5N/CJpU
         RtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=NsCaxjSsnAPb9dr7jfz45Z2k7us6uvI3bad+ssBYPRY=;
        b=Dy5O4Be0wAbI2j8Gdv/n9xQIEK3egw9019lESImKFIfiSzh22nhNcZ7y6dj6FGP09L
         xBfgxRRMU0hqXTq8RXrTQvOEj0y17uXoXJ1X4aDyxndFvSD1yemIEWAXmsUJaC9mbQDt
         zxzY79wapgiSNT25MmWZS5Ho9pTvvZDrRXxOHtGUawxYyBRVxXtgO3xqenRQn+y4QkIA
         ZWxw1PKFeJAA4jfHzqoL+wb2AB178w1NrRCnPFSjMB/jlCxiSM++tJbO2ryuGr3ifc3x
         nlwnmcr2qO8GLuSINK3ru0uz8EXXcgXYc4/C1Z8H6ODGDIrOEJZtIkF1yBG8it6M6139
         O2CQ==
X-Gm-Message-State: ACrzQf1xVu14/UBWn8wK/yAjHMPu9i6GKcLoLBsBDezKGzRKbA3rTaX7
        amNrVNDdMPAoe37Qs9IFdgmQLw==
X-Google-Smtp-Source: AMsMyM44w6e4lTsfnYrmAUHtoedhrpX4y0mRP2LzWbfviDNNggw30fENEV3+xEJfkW3hyLy2wWMfFg==
X-Received: by 2002:a5d:53c8:0:b0:228:62ee:64cb with SMTP id a8-20020a5d53c8000000b0022862ee64cbmr4495871wrw.267.1663925423276;
        Fri, 23 Sep 2022 02:30:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:5990:ddf8:daac:3833? ([2a01:e0a:982:cbb0:5990:ddf8:daac:3833])
        by smtp.gmail.com with ESMTPSA id r9-20020adff109000000b00229b76f872asm8619293wro.27.2022.09.23.02.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 02:30:22 -0700 (PDT)
Message-ID: <b9aa1178-5848-70fd-2dc1-9f36d845985e@linaro.org>
Date:   Fri, 23 Sep 2022 11:30:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 5.15 247/779] drm/meson: encoder_hdmi: switch to bridge
 DRM_BRIDGE_ATTACH_NO_CONNECTOR
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stefan Agner <stefan@agner.ch>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-amlogic@lists.infradead.org
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180347.894058731@linuxfoundation.org>
 <892a917454bd0bbfe8a4d34a5170fe50@agner.ch>
 <685b64f60375b69c5c790286f1386be3@agner.ch> <YyBoACiWvW1UnfQA@kroah.com>
 <db3b3082-5278-7ed8-4322-2422cec227a5@linaro.org>
 <Yy154kHD7PPtj05W@kroah.com>
Organization: Linaro Developer Services
In-Reply-To: <Yy154kHD7PPtj05W@kroah.com>
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

Hi,

On 23/09/2022 11:18, Greg Kroah-Hartman wrote:
> On Fri, Sep 23, 2022 at 11:12:02AM +0200, Neil Armstrong wrote:
>> Hi Greg,
>>
>> On 13/09/2022 13:22, Greg Kroah-Hartman wrote:
>>> On Mon, Sep 12, 2022 at 08:48:24PM +0200, Stefan Agner wrote:
>>>> On 2022-09-12 18:08, Stefan Agner wrote:
>>>>> On 2022-08-15 19:58, Greg Kroah-Hartman wrote:
>>>>>> From: Neil Armstrong <narmstrong@baylibre.com>
>>>>>>
>>>>>> [ Upstream commit 0af5e0b41110e2da872030395231ab19c45be931 ]
>>>>>>
>>>>>> This implements the necessary change to no more use the embedded
>>>>>> connector in dw-hdmi and use the dedicated bridge connector driver
>>>>>> by passing DRM_BRIDGE_ATTACH_NO_CONNECTOR to the bridge attach call.
>>>>>>
>>>>>> The necessary connector properties are added to handle the same
>>>>>> functionalities as the embedded dw-hdmi connector, i.e. the HDR
>>>>>> metadata, the CEC notifier & other flags.
>>>>>>
>>>>>> The dw-hdmi output_port is set to 1 in order to look for a connector
>>>>>> next bridge in order to get DRM_BRIDGE_ATTACH_NO_CONNECTOR working.
>>>>>
>>>>> HDMI on ODROID-N2+ was working with v5.15.60, and stopped working with
>>>>> v5.15.61. Reverting this commit (and two dependent refcount leak) to be
>>>>> the culprit. Reverting just the refcount leaks is not enough to get HDMI
>>>>> working, so I assume it is this commit.
>>>>>
>>>>> I haven't investigated much beyond that, maybe its simple a case of a
>>>>> missing kernel configuration? DRM_DISPLAY_CONNECTOR is compiled, and the
>>>>> module display_connector is loaded, so that part seemed to have worked.
>>>>>
>>>>> Any ideas welcome.
>>>>>
>>>>> FWIW, I track the issue in the HAOS tracker at
>>>>> https://github.com/home-assistant/operating-system/issues/2120.
>>>>
>>>> It seems that backporting commit 7cd70656d128 ("drm/bridge:
>>>> display-connector: implement bus fmts callbacks") fixes the problem
>>>> without reverting this commit.
>>>>
>>>> @Greg, can we backport this commit as well?
>>>
>>> sure, now queued up, thanks.
>>
>> Backport of 7cd70656d128 ("drm/bridge: display-connector: implement bus fmts callbacks") is still missing in 5.15-stable.
> 
> I see it in the 5.15.68 release as commit 590b4f10e3a4.
> 
> What am I missing?

Nothing, must be tired, was looking git log in the wrong path...

> 
> confused,

Sorry for the noise,
Neil

> 
> greg k-h

