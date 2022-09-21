Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7195C00FA
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIUPTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiIUPTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:19:32 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72032F11
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:19:30 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w8so9731711lft.12
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 08:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=0OQNwidXfglALVVRMIJX0eA8njvh8tvja1lgxaI+Bb8=;
        b=URPgkLc1/gEOLl+n4W6SG44A8sW0ivmUThd6wN1YUN4N6g3JnC2/j/1QYSftU7xaaz
         2a+TEBvw2H3iWYXTihvWlTi4WbCu0Vx0ykuJev8WVHbHOupHTP1OpyE7hsGIraPkOlzE
         VL/eSNVkW8icU54So/jIoYxDwNz3+ICSus9RWWpHKwAbNdbDH4f+4A5KZx24rWjM2cfe
         DC43cw4b0n7Jc7ymx+0uemUcdX+w2/LCn/uF/sKKhaOD0DhlUjHfOEvxQcnjglcQSp+l
         wtLLoC6MS7jOht05JoAdVj4CwHafjJHlKGcXfrpHPgggnfD4HBk9MZSlVf6TRuYVkLme
         efaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0OQNwidXfglALVVRMIJX0eA8njvh8tvja1lgxaI+Bb8=;
        b=gc+6OqQ6dNr9fQFyUgy0EOa1WfXbHHIJ6lHkxj4SQydOohacoYDdRXNDR2fIG1bOzi
         On2UsNK4YLQBaIBjhks1j0/JOuuqQm++Z/iuq2hl82m/LukY0O0o77Y88zPMuMiXV8qH
         o79s0yM+6/gyI7A5MgOwqsO5w4YEqCHrk8pJSnKMLsogBqcgBVb/oH1g1f60eUeRbeqZ
         O2JGIu4C35tbCC3YqpEw60ndRbdqlkNdTKoNNE5LffLUjQOt86v7fbn2F3k7WtN5CR2+
         QdIE/5w9dVOH9wJucmjc1GRWc0+7x7VRUMAuehL2EDWApUieaHtqrR+UULq+my2Jdu4K
         AO0w==
X-Gm-Message-State: ACrzQf0E35lAEI9rMVAm9NzAfz7tOTPOH9oH5bvwTijOvSpNZ9Kr3v8D
        qkL8FSvUutoq8dc1ZZ6cSkAlqQ==
X-Google-Smtp-Source: AMsMyM5W8d7QEhX0GyaMcafFqQFoeDrLIcJcGcKbJeXZ90zLpEd3zhpdII+hyLJ5GGWSp/H+vapy2Q==
X-Received: by 2002:a05:6512:3b8e:b0:49a:d2f4:6b7d with SMTP id g14-20020a0565123b8e00b0049ad2f46b7dmr9680650lfv.627.1663773567480;
        Wed, 21 Sep 2022 08:19:27 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id m6-20020a056512114600b004896ed8dce3sm485158lfg.2.2022.09.21.08.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 08:19:27 -0700 (PDT)
Message-ID: <5e34eadc-ef6a-abeb-6bce-347593c275b7@linaro.org>
Date:   Wed, 21 Sep 2022 17:19:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Vinod Koul <vkoul@kernel.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
 <20916c9d-3598-7c40-ee77-1148c3d2e4b1@linux.intel.com>
 <af3bd3f4-dcd9-8f6c-6323-de1b53301225@linaro.org>
 <9a210b04-2ff2-df98-ad1a-89e9d8b0f686@linaro.org>
 <fd74e77c-f3d3-1f09-2e5a-0a94e2a3eeea@linux.intel.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <fd74e77c-f3d3-1f09-2e5a-0a94e2a3eeea@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/09/2022 17:11, Pierre-Louis Bossart wrote:
>>>> /**
>>>>  * slim_stream_unprepare() - Un-prepare a SLIMbus Stream
>>>>  *
>>>>  * @stream: instance of slim stream runtime to unprepare
>>>>  *
>>>>  * This API will un allocate all the ports and channels associated with
>>>>  * SLIMbus stream
>>>
>>> You mean this piece of doc? Indeed looks inaccurate. I'll update it.
>>
>> Wait, no, this is correct. Please point to what is wrong in kernel doc.
>> I don't see it. :(
> 
> the TRIGGER_STOP and TRIGGER_PAUSE_PUSH do the same thing. There is no
> specific mapping of disable() to TRIGGER_STOP and unprepare() to
> TRIGGER_PAUSE_PUSH as the documentation hints at.

Which TRIGGER_STOP and TRIGGER_PAUSE_PUSH? In one specific codec driver?
If yes, I don't think Slimbus documentation should care how actual users
implement it (e.g. coalesce states).

Best regards,
Krzysztof

