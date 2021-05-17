Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D295238275C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbhEQIsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEQIsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:48:08 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A79C06174A
        for <stable@vger.kernel.org>; Mon, 17 May 2021 01:46:52 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i17so5448354wrq.11
        for <stable@vger.kernel.org>; Mon, 17 May 2021 01:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IgAtpP4C42Jpn6aKz2gV4v3gKQwjgJ+HgC0dgeMRD1c=;
        b=uajCC0Ebo8Blxm2wh0QYcJBamX4RuhCCoVg3VCJfHbv6I7qBmqI+JXSonkCbtmV3Kl
         PZq3/Z1FpmhMWvAGIYOpsNrPsWhyGamfFOLWi8cP/HKGpo/ffQu5mgvFlUAMLpzSA2GB
         OSPsdWHL8ki9fzR2vya7EkNFMJMKVLyI5y6nVeHgFiO2Vwr6m6z2Wpr5SVt3Suw/aYdb
         8IJz6KE5W4l+Ie7IjE2F4N1epS9YGpMSq0itwOcpSbAHlBZCzGNf8nplG8XR8joHkm7k
         FoI8ELJ/mb2YSsRNmqG6FkBG5IvtGSPmKN8b2OGHQJnTvuIfliE4ZbC5QxG5hhEoJpsz
         Lv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IgAtpP4C42Jpn6aKz2gV4v3gKQwjgJ+HgC0dgeMRD1c=;
        b=CvLJ4dVZ5AxxvNGiwynWdKiJxkcSaJwtP2znfkQpmWpAra4hQhwA4hUXaDu9UaDcfN
         /DKoCx4Pk1B5vgI4M7ZhWRaupbBEHKx0WpLuzxVXFTFmwArZZyVXPc5HyBfXBc+3+Epe
         wFHjVZ4b2xxsiJx2LI13FRUAZkgjwFzDy0qfCGkeMAQPlAu1prHDiDy7pdRU7PLqPe0q
         DI5OpkTYAKy7sJbK3ncvQ1pXa8u/MeysUix2uO0Ya2iVo2xVcuehstAYMz4Q4FZ0ouJU
         MEBj0UVG2Fb2Dy8GsZv0bzJuOuqNAbxzw+796Uo/3DQCoo+h/ZFGMDx00pb39puMYyxb
         5xOg==
X-Gm-Message-State: AOAM533aS7yXtVyjljes0P+rGEqcZzY+VO5AyFiXN1p/JV5vaKhOvim5
        8wIrjqCWC6SdOR7nRtFazlsyKBnnq9C5q3Fg
X-Google-Smtp-Source: ABdhPJxbQWH0NruvXyA4qYlWgdE4BXN8N0wrN1exubtTlt6z0Q3rO9xWKVEb/vBUmkb+GYTX9W2Q5w==
X-Received: by 2002:a5d:6d85:: with SMTP id l5mr71256571wrs.22.1621241211237;
        Mon, 17 May 2021 01:46:51 -0700 (PDT)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id r5sm15847622wmh.23.2021.05.17.01.46.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 01:46:50 -0700 (PDT)
Subject: Re: [PATCH 5.10 160/530] arm64: dts: qcom: db845c: fix correct
 powerdown pin for WSA881x
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, bgolaszewski@baylibre.com,
        linus.walleij@linaro.org
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144825.099918971@linuxfoundation.org> <20210515081814.GA30461@amd>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <55d58470-f606-8c75-1f00-a2eb09314081@linaro.org>
Date:   Mon, 17 May 2021 09:46:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210515081814.GA30461@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Adding Linus W and Bartosz to CC.

On 15/05/2021 09:18, Pavel Machek wrote:
> Hi!
> 
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> [ Upstream commit c561740e7cfefaf3003a256f3a0cd9f8a069137c ]
>>
>> WSA881x powerdown pin is connected to GPIO1 not gpio2, so correct this.
>> This was working so far due to a shift bug in gpio driver, however
>> once that is fixed this will stop working, so fix this!
> 
> I don't see the correspoing update to the driver this talks about.
> 
> Do we have corresponding driver in 5.10 and was it fixed to match?

This corresponding gpio driver patch was submitted along with the 
original fix, however it looks like it was not picked up yet.

https://www.spinics.net/lists/linux-gpio/msg59264.html

Bartosz/Linus W, Do you want me to resend this?

--srini

> 
> Best regards,
> 									Pavel
> 
>> +++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
>> @@ -1015,7 +1015,7 @@
>>   		left_spkr: wsa8810-left{
>>   			compatible = "sdw10217201000";
>>   			reg = <0 1>;
>> -			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
>> +			powerdown-gpios = <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
>>   			#thermal-sensor-cells = <0>;
>>   			sound-name-prefix = "SpkrLeft";
>>   			#sound-dai-cells = <0>;
>> @@ -1023,7 +1023,7 @@
>>   
>>   		right_spkr: wsa8810-right{
>>   			compatible = "sdw10217201000";
>> -			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
>> +			powerdown-gpios = <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
>>   			reg = <0 2>;
>>   			#thermal-sensor-cells = <0>;
>>   			sound-name-prefix = "SpkrRight";
> 
