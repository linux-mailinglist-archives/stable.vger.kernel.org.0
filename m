Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3514AA975
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 15:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiBEOce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 09:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380155AbiBEOce (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 09:32:34 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8239EC061346
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 06:32:33 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id 9so11086154iou.2
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 06:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Dl+yM1HWxH/FJccyQomi5B+Q1/xBaz8xHANwkioXGTE=;
        b=U9jlRqwy6+n+tv62nvnJzor/G4xzTuIVyxZENYdyw1GZzbZeX3YEosQx5XA98h9DHX
         Fark05vHl8IkZsB8eIh4473HYtGMHlovVHt8WMOOkHQ6+p+IUjShwvhYbEKkXSVUu0vD
         4ERyX7BAVIIG/AxyuggwH41IUWoW1EuR6gh357Tr+BIjZopLH11zjVhuLWInme71QUIz
         Xy5ViDfCPBfIefucHJOKFFSjKz2OuZVYhqGqpuOzqPhSO+N7L75vXEamqvOOXBxwGj6u
         lsHf14ldd2KF6BA7zab3Q5J9qhayCk/BzLgW8/2Kh2MR4DO3bJvDKlWsG/1PhzBhkn8k
         v/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dl+yM1HWxH/FJccyQomi5B+Q1/xBaz8xHANwkioXGTE=;
        b=1gcFa0cgw3mlEyUDGyYkkaCwiIJ6OSPr4Kmpar37ght4O/1Y9l9RZOOyxNN+ejukny
         AMMyo1hapHdwIpPGKKHrkx25BPkbApn825SLXKFO6WYNvXwQlZ7YNfr95toG8l7gnVji
         kpFICy26UXdzf82MF98kk3CfzNCTCVU/vz82A28wM0cIUd7txkTtOAAiIDnu5IEVhlHJ
         d2ewmlWYF7KEvhja7lMUszCxNMnyd1imo+RX6f6Wz/Wz+61tAZPZoRwe9UkQovV20m5E
         bVnCffE0YkuW3uJV+pD4c4+r+zWPSQQmoikV4tXzwC6fbJ/4r8fiJfrhGHCXBM86zk+y
         N4+A==
X-Gm-Message-State: AOAM5302oxDq0QGhzwgLR875GRbolnITZOFo5R428ocjCnEWhSL99/hK
        N9cRE5TnE3ZPqWHdyIRv6J1g9w==
X-Google-Smtp-Source: ABdhPJxF2Tku+y+Z+gXxI3oS++Y4cUu3Imy7sANw3h44RBFFtdZh+zQdLeAXejW4n6mSvaTfGOoXBg==
X-Received: by 2002:a05:6638:2184:: with SMTP id s4mr1846695jaj.177.1644071552809;
        Sat, 05 Feb 2022 06:32:32 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w1sm2493396ilc.41.2022.02.05.06.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Feb 2022 06:32:31 -0800 (PST)
Message-ID: <d66a5ce0-acb1-d2c4-b6a5-c4783abc1482@linaro.org>
Date:   Sat, 5 Feb 2022 08:32:30 -0600
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
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <Yf4vTqtKLQ71O77S@kroah.com>
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

On 2/5/22 2:03 AM, Greg KH wrote:
> On Fri, Feb 04, 2022 at 03:41:20PM -0600, Alex Elder wrote:
>> On 2/4/22 2:50 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.15-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> I just tried to apply this patch on v5.15.19 and it applied
>> cleanly for me.
>>
>> ----------------
>>
>> {2314} elder@presto-> git checkout -b test
>> Switched to a new branch 'test'
>> {2315} elder@presto-> git reset --hard v5.15.19
>> HEAD is now at 47cccb1eb2fec Linux 5.15.19
>> {2316} elder@presto-> git cherry-pick -x
>> 34a081761e4e3c35381cbfad609ebae2962fe2f8
>> [test 71a06f5acbb05] net: ipa: request IPA register values be retained
>>   Date: Tue Feb 1 09:02:05 2022 -0600
>>   3 files changed, 64 insertions(+)
>> {2317} elder@presto-> git log --oneline -2
>> 71a06f5acbb05 (HEAD -> test) net: ipa: request IPA register values be
>> retained
>> 47cccb1eb2fec (tag: v5.15.19, stable/linux-5.15.y) Linux 5.15.19
>> {2318} elder@presto->
>>
>> ----------------
>>
>> I don't understand.  If you know that I'm doing something wrong,
>> can you let me know what it might be?
> 
> It fails to build :)

Oh!  Well that's different!  Sorry about that, I'll spend
a little more time on this I guess...

>> While I have your attention on this, there is another commit
>> that should be back-ported with this.  It did not have the
>> "Fixes" tag, unfortunately.
>>
>> Bjorn has committed it in the "arm64-for-5.18" branch in the
>> Qualcomm repository:
>>    git://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git
>>    73419e4d2fd1b arm64: dts: qcom: add IPA qcom,qmp property
>>
>> He says he has no plans to rebase this branch before it gets
>> pulled.
>>
>> I can send a followup message when that commit lands in v5.18-rc1,
>> but it might be simplest to take care of it now.
> 
> According to the stable rules, I have to wait until it hits Linus's tree
> before I can add it to a stable release.

OK understood.  I'll work out with Bjorn what to do.

Thanks a lot.

					-Alex
> 
> So if this is a bugfix that everyone needs, it should go to Linus before
> 5.17-final is out.
> 
> thanks,
> 
> greg k-h

