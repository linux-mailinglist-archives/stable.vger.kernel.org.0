Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7E9500F0C
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiDNNXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244016AbiDNNXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:23:03 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB929969D
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 06:18:10 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id p21so5329006ioj.4
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 06:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8MpfZpSAdDem4/WWvcf9HUw6O0E3fHY2MASGd51wpJA=;
        b=fqJJXXt+ZL5FmtkBytvLMUWVUq4Xzatpmx//AKX1ZyUP3pPvUlVD9xrzlZjacjE+m0
         S820cNGTSCWqK9lmm10lRKbHKvrhAJKG2FR8qR/vJo7rnKcvd/8dbUw9yTvawyzhKwzS
         +LzWWJerQFSOL4M9r/siOIPTMKXsNoBo1ieqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8MpfZpSAdDem4/WWvcf9HUw6O0E3fHY2MASGd51wpJA=;
        b=yZ6kG7Lrn6Njxl/VAFU2i3Ki/DBNJmJFLFNyi2Yzxy/icWFsp5Wa7RvKBbeW4hQTJ3
         ad3dwkDD5fJE29gYT/iSaVtKuJ6GsEwh7WxTnMdeNHrme40BAQecm2N1boKfo6MmDak6
         sLoV/PZeJOX59k0d2MJf7yg3+Ve7RePh3BceP7dwElP4FE8ZEkOM2LZKLmn/6JDo2w3u
         aGiW1iNkYFu2b04s1Wsb/Kw+eNUbWvXw703MBwyalkbNnH9YOZOS+xmhE/7+RHmfuKvs
         Q6NaNY3tsZqnAQpq7W2DrIf7whoDxQwaCyhlUKW+5Ts9BAIqrX/Zwp5eAYuA9mL3Q0cx
         w6Yw==
X-Gm-Message-State: AOAM533ysklb+WO0EKvn6GPf4O+7/Y3NsYOzE+hpp5UA41hQTOMx79bm
        4fo1OvkF6q1ksNoou4LWkaXuSw==
X-Google-Smtp-Source: ABdhPJyDSA8cFt4msoVPu0HNohLrCOvJjv0PdUT3gKJ44zlF31hBllhh1Zy6M6giw5ysPFHB60+yng==
X-Received: by 2002:a05:6638:349e:b0:323:6d60:e715 with SMTP id t30-20020a056638349e00b003236d60e715mr1103202jal.165.1649942289730;
        Thu, 14 Apr 2022 06:18:09 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id n12-20020a92dd0c000000b002cac22690b6sm1043321ilm.0.2022.04.14.06.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 06:18:09 -0700 (PDT)
Message-ID: <f4b6ecf2-50e6-2fac-9608-0cecd507ca28@ieee.org>
Date:   Thu, 14 Apr 2022 08:18:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/3] soc: qcom: aoss: Expose send for generic usecase
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>, Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, Deepak Kumar Singh <deesin@codeaurora.org>,
        clew@codeaurora.org, swboyd@chromium.org,
        bjorn.andersson@linaro.org, kuba@kernel.org, elder@kernel.org
References: <20220413144811.522143-1-elder@linaro.org>
 <20220413144811.522143-2-elder@linaro.org> <Ylf+zbeq9+fAidmn@kroah.com>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <Ylf+zbeq9+fAidmn@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/14/22 6:00 AM, Greg KH wrote:
> On Wed, Apr 13, 2022 at 09:48:09AM -0500, Alex Elder wrote:
>> From: Deepak Kumar Singh <deesin@codeaurora.org>
>>
>> commit 8c75d585b931ac874fbe4ee5a8f1811d20c2817f upstream.
>>
>> Not all upcoming usecases will have an interface to allow the aoss
>> driver to hook onto. Expose the send api and create a get function to
>> enable drivers to send their own messages to aoss.
>>
>> Signed-off-by: Chris Lew <clew@codeaurora.org>
>> Signed-off-by: Deepak Kumar Singh <deesin@codeaurora.org>
>> Reviewed-by: Stephen Boyd <swboyd@chromium.org>
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Link: https://lore.kernel.org/r/1630420228-31075-2-git-send-email-deesin@codeaurora.org
> 
> You sent this on, so you should also sign-off on it, right?

Yes I should have, sorry.  I'll send v2 of the series.  Thanks.

					-Alex

> 
> thanks,
> 
> greg k-h

