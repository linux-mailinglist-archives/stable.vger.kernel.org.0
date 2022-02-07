Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5930D4AC5FC
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 17:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbiBGQfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 11:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389590AbiBGQXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 11:23:36 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40999C0401CE
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 08:23:36 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id 15so11486702ilg.8
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 08:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X2blKuObfXNE80hmcUNeFStEMfyaLwrofTJ0jHNw/vY=;
        b=AQaufvKBgRC7hdiokBnIfoyUZ5h5cYR9xlg2vwcMwIyhI5ojONlASRRHD6XOPnK6As
         HAW6AmD8+73nPiquEEDg48JX9m9eKh3S95pCaCS74QWXdMnYpJ81pwPUbfRmjuP60kOz
         lBtta/Lcz6Ny7tGM91dDSt3ONx1Y8PEXDQ9vUloHGfyOU+GZ9iuRFpqdS/Ilt2z+XuB6
         Aw3yf6I3CTg1IoXir/EdZ+o/gGRwKVbgJFEMxGo3UF5a+u17MAwperMMc3+uMuvju2OJ
         R70lqZ427OtfXHUw7n9/9mLss3Gtw/gW69R7cn+PtVj+mxjRhQ5iuYqKXzSEq9/2BvK5
         vEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X2blKuObfXNE80hmcUNeFStEMfyaLwrofTJ0jHNw/vY=;
        b=XFnEZlfGtEE/wMJ685VsrhvpkpA54DjJQ89hMTBQaoVfyKqtwyt7VfD60w932uTTkl
         xjuFmaFMubyepLwtswiKkVmxiwVfuHNqC8ZGWVAQbJ1CvKZWQo2YQlN1sSEuHc/mICg7
         ylbMdQK1QoKGhhOHWnyGTx0YEj4j/s6Mk2EA4yTp6IP5qFd0gK0fnaONmBigbd1+Uk/K
         fnVtaJlM+spMyqXmqLSWoPq0QZzS8kMNNCwvk5i/UvhkEgHMaRgngShEFfv+lDobaGHf
         +1yI/CDf5S0UT0L6QJt1rNGVG3He38wGBnc0Kk7kQ9gAYbOrCofz5JRV1aWkqZDkt924
         tmrA==
X-Gm-Message-State: AOAM533dYYhleMez9DhYhqyo5cOTB3bqGlF2gk93DJYV72zGjCtI2xFK
        Uiwb9zzGDPDgUc+CbvY2D6udOA==
X-Google-Smtp-Source: ABdhPJzUXxyzj8vN8GEo+B6OoFHl80vE4YJKkbmLaP5eowOZPJqZIs1JYon9cF70slozvy8hHTTOwQ==
X-Received: by 2002:a05:6e02:1786:: with SMTP id y6mr163709ilu.152.1644251015532;
        Mon, 07 Feb 2022 08:23:35 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id c11sm1452720iln.56.2022.02.07.08.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 08:23:34 -0800 (PST)
Message-ID: <4a8c8a8d-b760-5dd4-512d-ae08b95ab902@linaro.org>
Date:   Mon, 7 Feb 2022 10:23:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: FAILED: patch "[PATCH] net: ipa: request IPA register values be
 retained" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kuba@kernel.org,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
References: <1643964634201142@kroah.com>
 <b4a3db1e-9bee-5075-9b45-1e1dcc06869e@linaro.org>
 <Yf4vTqtKLQ71O77S@kroah.com>
 <d66a5ce0-acb1-d2c4-b6a5-c4783abc1482@linaro.org>
 <Yf7CWW+kGnH86KtE@kroah.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <Yf7CWW+kGnH86KtE@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/5/22 12:30 PM, Greg KH wrote:
> On Sat, Feb 05, 2022 at 08:32:30AM -0600, Alex Elder wrote:
>> On 2/5/22 2:03 AM, Greg KH wrote:
>>> On Fri, Feb 04, 2022 at 03:41:20PM -0600, Alex Elder wrote:
>>>> On 2/4/22 2:50 AM, gregkh@linuxfoundation.org wrote:
>>>>>
>>>>> The patch below does not apply to the 5.15-stable tree.
>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>> tree, then please email the backport, including the original git commit
>>>>> id to <stable@vger.kernel.org>.
>>>>
>>>> I just tried to apply this patch on v5.15.19 and it applied
>>>> cleanly for me.
>>>>
>>>> ----------------
>>>>
>>>> {2314} elder@presto-> git checkout -b test
>>>> Switched to a new branch 'test'
>>>> {2315} elder@presto-> git reset --hard v5.15.19
>>>> HEAD is now at 47cccb1eb2fec Linux 5.15.19
>>>> {2316} elder@presto-> git cherry-pick -x
>>>> 34a081761e4e3c35381cbfad609ebae2962fe2f8
>>>> [test 71a06f5acbb05] net: ipa: request IPA register values be retained
>>>>    Date: Tue Feb 1 09:02:05 2022 -0600
>>>>    3 files changed, 64 insertions(+)
>>>> {2317} elder@presto-> git log --oneline -2
>>>> 71a06f5acbb05 (HEAD -> test) net: ipa: request IPA register values be
>>>> retained
>>>> 47cccb1eb2fec (tag: v5.15.19, stable/linux-5.15.y) Linux 5.15.19
>>>> {2318} elder@presto->
>>>>
>>>> ----------------
>>>>
>>>> I don't understand.  If you know that I'm doing something wrong,
>>>> can you let me know what it might be?
>>>
>>> It fails to build :)
>>
>> Oh!  Well that's different!  Sorry about that, I'll spend
>> a little more time on this I guess...
> 
> It was a "include file not found" type of error if I remember correctly.

OK, yes, I did discover the build problem.  And it can be
easily fixed with one more prerequisite commit.

HOWEVER, there is a "matching" DTS patch that won't land
in Linus' master branch until v5.18-rc1, so I'll have to
get back to you on that later anyway.

Which means you can simply drop my attempted 5.15 back-port
from your queue (if you haven't already...).

Thanks, and sorry for the noise.

					-Alex
