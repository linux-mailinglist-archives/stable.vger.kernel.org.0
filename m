Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F732737B0
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 02:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgIVAxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 20:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbgIVAxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 20:53:08 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ACDC061755;
        Mon, 21 Sep 2020 17:53:08 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a9so663223pjg.1;
        Mon, 21 Sep 2020 17:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U0pBTPDq66IbqqYZMmKN3p9tiI5lRbAxtZVgmKot9wM=;
        b=qt78eYOlkyH7E6CzNI7TM0DeZI1fAMbld2tdwIvPbktdyujQLDD8gZMeWSlFlNiOn6
         vwqiXAQoq7C5G2fmoFFeiV1+b1hNO/Xd+n55qbZoopy5+Z+RyGISKj/snfyK334Gj03Q
         D54e3x8F6RdaCky8do9lYf2EvdtkdiEnPTYWJhHRAfhWfCmJcOB4abkiRH5Ulx67y6Aj
         KK2tTz8J48PWjDHLFZvOdprtu8hxqI0JNEDWDdlOmti2ZdII5mfElXUD9C35wOWaA3lK
         SnJqpqVO1N9VAbxZ77VrJtS8UsxmiJPpTYEJNcxg2jD5Mu2jwiqeRkGnOl8KX2l/7Z1v
         Q4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U0pBTPDq66IbqqYZMmKN3p9tiI5lRbAxtZVgmKot9wM=;
        b=RUGy0c3ZRCdno1F7MUMCwWKRFW8h2qtXN/0x8eEeimWz47eGhYVIeSxVP+L1jGxbJN
         zITAniE2W/t6ZdpW2eZCdTq6FWN2BEIboTsuBygpj44eUExBO/Q3BtRvnj4yFjT5auW0
         XWOPN3fpuEhjR1vFrjv18Wt2wPgVug+2pAHYC5+kjUyYS+E0P/NKp6DqoIy/vrI2TSop
         Zy7va43/Z3E6XQXzAeYHtalW71FjFg74fsePHXmsIaW24dG5CFLBAtTNn9OorJhm9vra
         /qpoR8m2HSXFsLVPGlA+neve+V9r/bYt9mrCaDNZtXez7Vfm1315r2ZAhE9tOkC/oYyT
         FqVA==
X-Gm-Message-State: AOAM531oLreUT2LAaiRNzY0Pu2un2sgT6RS6MoI9bFZSnuIOwjZso46j
        DOLAm0BujvtyO7BmUysGkQ==
X-Google-Smtp-Source: ABdhPJyNjvKNpNmUXH0D2XMreACGk/P/lOfDzczppeoooOImOIqSiQL5kMKSbJ8xoRErZveVl9uTSg==
X-Received: by 2002:a17:90a:d152:: with SMTP id t18mr1543736pjw.27.1600735987789;
        Mon, 21 Sep 2020 17:53:07 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id z28sm13928158pfq.81.2020.09.21.17.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 17:53:06 -0700 (PDT)
Subject: Re: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
References: <20200921104234.9C539216C4@mail.kernel.org>
 <EE2DABCA-2B97-4D46-8AFB-7F94DED675F8@tencent.com>
 <20200921132850.GM2431@sasha-vm>
 <E0D58EE6-0CA2-4594-877B-FDE2C1806272@tencent.com>
 <20200921142807.GA643426@kroah.com>
 <601A8297-7002-43E1-93AB-DB29F7E3BA92@tencent.com>
 <CAB5KdObZ2PZZRF56xb0YT4i0Mt=_mz36fE9U-D2GOhuUVX5ujg@mail.gmail.com>
Message-ID: <1da91e3b-4fa8-6e24-50b2-932e8085f598@gmail.com>
Date:   Tue, 22 Sep 2020 08:52:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <CAB5KdObZ2PZZRF56xb0YT4i0Mt=_mz36fE9U-D2GOhuUVX5ujg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 20/9/21 23:08, Haiwei Li wrote:
>> On Sep 21, 2020, at 22:28, Greg KH <greg@kroah.com> wrote:
>>
>> On Mon, Sep 21, 2020 at 02:14:41PM +0000, lihaiwei(李海伟) wrote:
>>
>>
>> On Sep 21, 2020, at 21:28, Sasha Levin <sashal@kernel.org> wrote:
>>
>> On Mon, Sep 21, 2020 at 10:54:38AM +0000, lihaiwei(李海伟) wrote:
>>
>>
>> On Sep 21, 2020, at 18:42, Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>   KVM: Check the allocation of pv cpu mask
>>
>> to the 5.8-stable tree which can be found at:
>>   http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>    kvm-check-the-allocation-of-pv-cpu-mask.patch
>> and it can be found in the queue-5.8 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>>
>>
>> This patch is not a correct version, so please don’t add this to the stable tree, thanks.
>>
>>
>> What's wrong with it? That's what landed upstream.
>>
>>
>> The patch landed upstream is the v1 version. There are some mistakes and shortcomings. The message discussed is
>>
>> https://lore.kernel.org/kvm/d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.com/
>>
>> Then, a revert commit was pushed. Here,
>>
>> https://lore.kernel.org/kvm/CAB5KdObJ4_0oJf+rwGXWNk6MsKm1j0dqrcGQkzQ63ek1LY=zMQ@mail.gmail.com/
>>
>>
>> What is the git commit id of the revert in Linus's tree?
>>
The revert commit was pushed. I am sorry I just saw this commit.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7d1f8691ccffe88cec70a6e4044adf1b9bbd8a7c

--
Thanks,
Haiwei
