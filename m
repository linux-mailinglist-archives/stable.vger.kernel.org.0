Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B135959F762
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 12:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiHXKXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 06:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236724AbiHXKXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 06:23:35 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B5D74CDC
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 03:23:33 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id h1so8529656wmd.3
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 03:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=yz74Ngza1/9c+/7faceWu/qG1cVkpiiucFVOt6nZTzU=;
        b=BGfmKnMGXzIc1ZBxis4k/ZJhKCwXiDuXTHMbDTbfA2iOELxAZ8MmU9SG0Hu4jjAefY
         Q24GNcqOzFAn7G1pjdFmJCytTaUDv3Ar/4D0pcBVr3OCd+Aaz4gLTLBgsKdCrXdhCQVo
         kIhvVBfLKfl770FTQOY5sL1bww4UxTyzOxuizDO6RuUEIlI92AiBrJdzKDFPRZNQ0039
         XVtVKWIPO3danPoLXwHWnlQrzHaH+kRXxc18B+f/DVWy++yWuF205f1FeHZfxi7zo5eU
         Hjh8DIXbnKU6oQuRwoBt+Ikpps6l4EaKkxNNb9njGqmn/XVhGkFFh74gnXqga1JMqNM7
         mguw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=yz74Ngza1/9c+/7faceWu/qG1cVkpiiucFVOt6nZTzU=;
        b=rSVZ9yUjWq1qBU4zt6mjY3rSBkFiFpVgzHRUfqZauGDQ1Y0FSQgZ06JT3NYd80uQge
         ynpgccC+hv8vCs2a1lfFOfTVbxQSGI8kbjreDBrW89Xn0iHasamyMXE02MO5gczZY665
         Aepe71pNEe9tDE640nvi2w/YLuGIB6BRVVNPO7tPLfNu2rGdKxioFsiBZM/0C9bPrWyI
         dcIqcOEJAiyso4Xhz/uq9sSdLmBNiUw0AVA29SgL0nk4jdOFAr572IzFIfqO7Ye2fe5A
         lV+ug1c0OmVW2SU/bLPyGwMT3IOWDZ48OIjXTc8sy1PbIn8myTPKniC8V6SRL1HD6Vs/
         LBug==
X-Gm-Message-State: ACgBeo0dGv36hTqvlXxN3vWTN/DXA7zvr6qFvZT94i/WAVceyUr2agQI
        pT6OsbbjqJL9r19e/tY/139XOA==
X-Google-Smtp-Source: AA6agR4zuTRt0NDnGFMkDiyNsfe7QXkfipgC8+kycHbpP+6wqJmmXsiGVyx+jgQtnUrFzecn5/zvRw==
X-Received: by 2002:a05:600c:3508:b0:3a6:10a9:8115 with SMTP id h8-20020a05600c350800b003a610a98115mr4998318wmq.164.1661336612221;
        Wed, 24 Aug 2022 03:23:32 -0700 (PDT)
Received: from [192.168.86.238] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id w7-20020adfd4c7000000b002216d6f8ad6sm16522482wrk.2.2022.08.24.03.23.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 03:23:31 -0700 (PDT)
Message-ID: <39011753-38aa-2979-c6f7-eeff015e515c@linaro.org>
Date:   Wed, 24 Aug 2022 11:23:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Patch "soundwire: qcom: Check device status before reading devid"
 has been added to the 5.15-stable tree
Content-Language: en-US
To:     Vinod Koul <vkoul@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, stable-commits@vger.kernel.org
References: <16604006172842@kroah.com> <YwT537rlrckb0/VV@matsya>
 <YwXHtBc2Du+a+rY3@kroah.com> <YwXwaSflH+XCxxWP@matsya>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <YwXwaSflH+XCxxWP@matsya>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vinod,

On 24/08/2022 10:33, Vinod Koul wrote:
> On 24-08-22, 08:39, Greg KH wrote:
>> On Tue, Aug 23, 2022 at 09:31:35PM +0530, Vinod Koul wrote:
>>> On 13-08-22, 16:23, gregkh@linuxfoundation.org wrote:
>>>>
>>>> This is a note to let you know that I've just added the patch titled
>>>>
>>>>      soundwire: qcom: Check device status before reading devid
>>>>
>>>> to the 5.15-stable tree which can be found at:
>>>>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>>>
>>>> The filename of the patch is:
>>>>       soundwire-qcom-check-device-status-before-reading-devid.patch
>>>> and it can be found in the queue-5.15 subdirectory.
>>>>
>>>> If you, or anyone else, feels it should not be added to the stable tree,
>>>> please let <stable@vger.kernel.org> know about it.
>>>
>>> This is causing regression in rc1 so can this be dropped from stable
>>> please
>>
>> This is already in the following released kernels:
>> 	5.15.61 5.18.18 5.19.2
>> so when you get this resolved in Linus's tree, be sure to also add a cc:
>> stable to the patch so it will get picked up properly.

This is the patch 
https://www.spinics.net/lists/linux-arm-msm/msg117502.html that fixes 
the issue, Amit confirmed it.

Can you check in on 5.15 incase you have a setup to try it.

thanks,
--srini

> 
> Thanks will do!

> 
