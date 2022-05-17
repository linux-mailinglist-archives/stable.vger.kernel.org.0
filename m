Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0C552A4C4
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 16:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242382AbiEQO0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 10:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348881AbiEQOZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 10:25:56 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5464427D8
        for <stable@vger.kernel.org>; Tue, 17 May 2022 07:25:54 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eg11so8823998edb.11
        for <stable@vger.kernel.org>; Tue, 17 May 2022 07:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:cc:content-transfer-encoding;
        bh=8V6VIcJkal9li7ymSO5VT9QRNhGf46wYnc+DQ/xNrQ4=;
        b=hYYzgjZYsXnTltezQHqu8cqCOr+iZl6efeLeI2JZo9OeKs+Bsm5xYaXICnRQ/3lUGv
         2GSBXSGhUz1HfQ/QvNO8miRufVCvrzHKNwCNHON2TEZPPHwkk76Y34XnQN50K9z9Gchi
         ejjoGqxTxfVZfRXs53gi23BYshTQVpXMX60L3ptwbr9egBA5VuiPRakD1vUBoGw6EPzp
         p/UF4FAfRfl5UwxLMv+gpErf0awlm5LgmNrYJNN989XJQunb7LWYY0ef8YadXal8VDLt
         V0jn/ytSvuMw95GKaPQTvFcP8231GZICJOrDpNhNQr6+RbBMWaUIOTtqavzFPxG87LJ3
         PQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to:cc
         :content-transfer-encoding;
        bh=8V6VIcJkal9li7ymSO5VT9QRNhGf46wYnc+DQ/xNrQ4=;
        b=XEQ/3d+BpEQ3uRtmLDZ4hiQKvJ8N80flm47qWa4XYa3OFhW554E5OPqvM88ySZmvU9
         4FsTwBfno8gQeZ/vggiKyGg0qKTVE16FttlfDvyMlrd/JVOjD4UC9ATmQSqbKYW6IFAi
         Ak29Ygu3MWvYyNj8Yc0BoJP4ZhlOUiCkJASFHjLtexnwBSgydFtgOGqFG+d0YiqRToAC
         nQ3+/5CbqokDmSpTSe4NDIq2RCCQ2Xs5nyYXqcAAwhisYSm02YeTTkScQqq68T0bSnGQ
         V2Nxb/lgrEoaYCNvn1CNSYZ+NS42S9Uxfxf2zriVlvC7/wbb4saagBDSj5EpVcmEBVlx
         vnZw==
X-Gm-Message-State: AOAM5316NTROA7urrJwvyMc3LTG6SZIhqvOkBWOEwmq1oARv3n5yWd0O
        AxEe+8y49yICaMEN3UcP8oUuEgEjzPwhP+LlFDQ=
X-Google-Smtp-Source: ABdhPJxL3eUfhDCs6Vt0GByDLaP/ejwfMbHQOvPJKHWjVxA5eBbfamKWaoJQJc2KgJG60u9FeJ0zyw==
X-Received: by 2002:aa7:dbd0:0:b0:427:4e6e:d779 with SMTP id v16-20020aa7dbd0000000b004274e6ed779mr19480761edt.27.1652797553214;
        Tue, 17 May 2022 07:25:53 -0700 (PDT)
Received: from [192.168.1.110] ([178.233.88.73])
        by smtp.gmail.com with ESMTPSA id c28-20020a1709063f1c00b006f3ef214e63sm1088604ejj.201.2022.05.17.07.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 07:25:52 -0700 (PDT)
Message-ID: <2f331adf-6f95-06c1-a366-ea81b5bf6ec2@gmail.com>
Date:   Tue, 17 May 2022 17:25:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] ASoC: ops: Fix the bounds checking in
 snd_soc_put_volsw_sx and snd_soc_put_xr_sx
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
References: <c2163c71-2f71-9011-3966-baeab8e8dc8f@gmail.com>
 <20220517011201.23530-1-tannayir@gmail.com> <YoOdauC5Q8POpHLe@sirena.org.uk>
From:   =?UTF-8?Q?Tan_Nay=c4=b1r?= <tannayir@gmail.com>
In-Reply-To: <YoOdauC5Q8POpHLe@sirena.org.uk>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 > No, the minimum value we expose to userspace is always scaled so that
 > userspace sees a range starting from zero and that's where platform_max
 > is referenced to - we're applying this limit before we start remapping
 > to actual register values. The code would be a lot simpler if we didn't
 > do this rescaling.

These are the results that I got from debugging my phone
which has a wcd9340 audio codec and a kernel version of 4.9.314:
The control is defined like
-- SOC_SINGLE_S8_TLV("IIR0 INP0 Volume", 
WCD934X_CDC_SIDETONE_IIR0_IIR_GAIN_B1_CTL, -84, 40, digital_gain) --

Now the OEM mixer_path.xml file defines the value of the aforementioned 
control as 54
which is read by the user-mode Qualcomm HAL, the HAL then uses the 
library libalsa-intf
to issue an IOCTL to pass this value directly to the ALSA driver.
At this point, the snd_soc_put_volsw_sx is called and the $val is 54 as 
expected.
$mc->platform_max is 40, $mc->max is also 40 and $mc->min is -84.

The problem is that the snd_soc_put_volsw_sx, checks the userspace value 
that has a range
starting from 0, directly against the $mc->platform_max value mentioned 
above
which is set to 40 at that point so it checks for the incorrect range.
