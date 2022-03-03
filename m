Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9924CB46E
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 02:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiCCBmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 20:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiCCBmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 20:42:09 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40FA1B6080
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 17:41:25 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w37so3188040pga.7
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 17:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IOm1CsBuzfBO4hHQIlMIj7xifbxkoOrrvv1NFFoV0VE=;
        b=b57s7p4zzuDiAJki1RnkbxMeN9uzt18dQz5pLykrYClokkS/YolK5eR8wplC+RwVVc
         qoY+U5V4NfyrKMg2wHeEGJKFKXxJVXf34KJ4FHRwJS5xAvocP26OfYYdqJ4QYPlyFW/o
         WHgHBfoAY+S03lejWKu3dwFAoWqAv2ywaBvJaqWIGWVaoG+4po6Zay9U7K7f/8fdvi7/
         U0IAAJhs52M8SJIW6bVh6YQyG+EqH+nkOFdnrwVL5RMpzSRk9QUlxDVBQlB/c+quWckE
         NpArFzJN5uyg5A5Bx24BapYJnnlMso1mrV7YN/wsYdDR1cMP5TnY2OXwkBI9/8kscYzg
         oyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IOm1CsBuzfBO4hHQIlMIj7xifbxkoOrrvv1NFFoV0VE=;
        b=HvJmXwo/40/3sTaoK8u+mWEcs6ZIbyjlTh/xZeDunTZhlXyF9+zAb5zxIWRA2f9SEu
         Fu7O3boe560nJdnusaQghfY6vYiK2WxZmt5HSMOBg5JxUvA6dLVDmL3p8PH1gGBDydr2
         QdUe9+G/cGv2SkVCYfcC1i8nFeTecvevaIsKMTl0PzB8J/MPVG9WnP6kLRidaPb4NL2M
         tdyOfiCCHlFzAnAPOMGj7laxveWBqmUf69vB1F8cAZ+QzWVnCMlugLFyk2qC0Bgq3PG4
         PjsMY1rUGznGgyAqTY7C6APKgSFtvQrFHb8t5PZCmEXjkyHEiHJY1ylWLooj0FMiv8wF
         dCTA==
X-Gm-Message-State: AOAM532Yksz9P8F5F8MMnBGQgYOaDxuLW8sOdpNJoRifmh0LBTAS69nj
        mKvmuMusywFW2+AtrhxO5yVJsQA0UyoJZHBY
X-Google-Smtp-Source: ABdhPJxdYfVTILFww5Y+x18PXyGf1tJDLzUQYfhujljQ6CZITQwCcKhhdqjKiprN2X91zCgu7ZNkig==
X-Received: by 2002:a05:6a00:b84:b0:4e1:b113:d444 with SMTP id g4-20020a056a000b8400b004e1b113d444mr35885471pfj.12.1646271685291;
        Wed, 02 Mar 2022 17:41:25 -0800 (PST)
Received: from [10.11.37.162] ([103.84.139.52])
        by smtp.gmail.com with ESMTPSA id k5-20020aa788c5000000b004df7bf0a290sm435934pff.1.2022.03.02.17.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 17:41:25 -0800 (PST)
Message-ID: <4638b4c1-6d83-02b2-2641-0c2b6945b7cb@gmail.com>
Date:   Thu, 3 Mar 2022 09:41:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [stable] usb: gadget: Fix potential use-after-free
Content-Language: en-US
To:     Ben Hutchings <ben@decadent.org.uk>,
        stable <stable@vger.kernel.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>
References: <a4e0a5446a231fd67d1881d68047920918f1be65.camel@decadent.org.uk>
 <a4cc25a6-c6a7-37d6-d889-ddd80b2d8a44@gmail.com>
 <72f61101e4b40d4986435058d43eeb21c80d5c64.camel@decadent.org.uk>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <72f61101e4b40d4986435058d43eeb21c80d5c64.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I get it. Looks like I got it wrong. I already submitted "PATCH 4.14" a 
few days ago. You can see it in:

https://lore.kernel.org/all/20220301022608.10950-1-hbh25y@gmail.com/

Thanks.

On 2022/3/3 04:04, Ben Hutchings wrote:
> On Tue, 2022-03-01 at 09:33 +0800, Hangyu Hua wrote:
>> All right. I will do that.
> 
> That was actually a request to the stable maintainers.  You don't need
> to do anything, unless there is some reason why these fixes don't apply
> to older versions or need to be adjusted in some way.
> 
> Ben.
> 
>> Thanks.
>>
>> On 2022/3/1 02:47, Ben Hutchings wrote:
>>> Please pick these two commits for all stable branches:
>>>
>>> commit 89f3594d0de58e8a57d92d497dea9fee3d4b9cda
>>> Author: Hangyu Hua <hbh25y@gmail.com>
>>> Date:   Sat Jan 1 01:21:37 2022 +0800
>>>    
>>>       usb: gadget: don't release an existing dev->buf
>>>    
>>> commit 501e38a5531efbd77d5c73c0ba838a889bfc1d74
>>> Author: Hangyu Hua <hbh25y@gmail.com>
>>> Date:   Sat Jan 1 01:21:38 2022 +0800
>>>    
>>>       usb: gadget: clear related members when goto fail
>>>
>>> Ben.
>>>
> 
