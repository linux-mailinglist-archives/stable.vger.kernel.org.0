Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B34C6C32DB
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 14:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjCUN1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 09:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjCUN1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 09:27:44 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877294ECE7
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 06:27:12 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id u11-20020a05600c19cb00b003edcc414997so4588925wmq.3
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 06:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679405231;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nmuE9i4BOGv8wbGqII05vBX2hvOFUNZmklG6jr67aGk=;
        b=TWUgzxiNQuNvs7HKZcuVl11DJ1mctEQVxFLCpudW0tHRvL0lXGjm+4L6Z2fiaI/kMt
         xI+L3BVymVEMvaQK8wSVmHvCH9quIyRsWF1gknYrMmNvvLG3ETJtwVl2mPgLUQ6v2fc4
         djM+OmxrRuie9OnzKX+gOmRYv2OJnFTzDHBWw/H2/TrZxeW8qddUCFCHytTBZGotJxUH
         xudE6MwyuMnO4yDx/jwRvxDZcgI5h5zo28nlnmZTaCFgIbKmxEK9crSUkF2ej13pjdU2
         rNhaVogcHF+Keavw1r2sOJYFlXOcCzPT7BL9CL2wTQQnsqRtDOzrujTEwvjA3lS//L8Q
         2jjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679405231;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nmuE9i4BOGv8wbGqII05vBX2hvOFUNZmklG6jr67aGk=;
        b=j80beTMicmJ0jquB2JO+LEzmRbbavwrh/c29NBNk6eh3Tt1ygBczcBBLDq2fGaBrnp
         dWsZ/Up8ECZ3SizBpsXzU31jQbHogn+pNZObMhZKz4C4dzAzO+7Vc3HGHltRzypeqtKX
         hgP3Xxn6nvYZ09FN88btlgtUFDDEMV/PINE+yWrEm0WiVeAKgBilE2rSFSoEOSkGYaMV
         1yiBXQ/noTrgrXcffMlWFhcTyDBkXmmIOZNYSTFYnBzgIoxqjMHcLQXsGnJqLf1zP4qD
         ijcUgZ4GdthPG1FtM0hgWCU+O9QctqPs+Z8X8UjU6iqr3qgs8+WL9K+1G3Wp1pCN06Ia
         8jPw==
X-Gm-Message-State: AO0yUKW1n4gJMsGqK6b/2bH4sdNmCM4Q+y5bBGUF70cXA8NQnzO9BEQX
        lrcOKhpX49dNrxLzzmkWQPUevw==
X-Google-Smtp-Source: AK7set9+2mXnERPRLq+QIR9/XRsWTj2Mg5s8G1jTh6AI8V1S7SD/6C6xUGT5J2z1GE5KNYG1w8JPug==
X-Received: by 2002:a05:600c:28d3:b0:3ed:2eb5:c2dd with SMTP id h19-20020a05600c28d300b003ed2eb5c2ddmr2133002wmd.39.1679405230793;
        Tue, 21 Mar 2023 06:27:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:c8ed:7915:30cc:f830? ([2a01:e0a:982:cbb0:c8ed:7915:30cc:f830])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b003eda357cfc5sm11232426wmq.43.2023.03.21.06.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 06:27:09 -0700 (PDT)
Message-ID: <35aa4401-8b35-09b5-9d97-59867d1df15c@linaro.org>
Date:   Tue, 21 Mar 2023 14:27:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH] drm/meson: fix missing component unbind on bind errors
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230306103533.4915-1-johan+linaro@kernel.org>
 <CAFBinCBsC+P=zvh6RF3UKiPnferUYU0QZvZfnn1oS5xWX-65Jw@mail.gmail.com>
 <ZBmtu4klxYwQyN7R@hovoldconsulting.com>
Organization: Linaro Developer Services
In-Reply-To: <ZBmtu4klxYwQyN7R@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/03/2023 14:14, Johan Hovold wrote:
> On Thu, Mar 09, 2023 at 10:41:18PM +0100, Martin Blumenstingl wrote:
> 
>> On Mon, Mar 6, 2023 at 11:35 AM Johan Hovold <johan+linaro@kernel.org> wrote:
>> [...]
>>> @@ -325,23 +325,23 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
>>>
>>>          ret = meson_encoder_hdmi_init(priv);
> 
>> I'm wondering if component_bind_all() can be moved further down.
>> Right now it's between meson_encoder_cvbs_init() and
>> meson_encoder_hdmi_init(). So it seems that encoders don't rely on
>> component registration.
> 
> Perhaps it can, but that would be a separate change (unless there is
> something inherently wrong with the current initialisation order).

The CVBS doesn't rely on any components unlike HDMI, this explains the
current position of component_bind_all().

>   
>> Unfortunately I am also not familiar with this and I'm hoping that
>> Neil can comment on this.
> 
> Any comments on this one, Neil?

Yep, components should be bind for HDMI encoder/bridge init.

Anyway for this patch, sorry for the delay, but it's looks fine:

Acked-by: Neil Armstrong <neil.armstrong@linaro.org>

> 
> Johan

