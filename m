Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21F94ABFDC
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344387AbiBGNoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448204AbiBGNFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 08:05:53 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 05:05:53 PST
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0833C043181;
        Mon,  7 Feb 2022 05:05:52 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CB2275C040A;
        Mon,  7 Feb 2022 07:47:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 07 Feb 2022 07:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=eKfIrsSnacR+Sp
        yNgSovGoZD1LB+PIAhf4rhYFJZzCo=; b=S28oh7/f5IcE/TLo2XiemyZlvMnS6H
        jf3YbyErHaCNjfojwfodBM9slksrWo4DfNWnoW/3asMHe7u5hNFLdEuO/IPQ4IFD
        478gHhkMgLpLXqix1PuP7L49YjArahIv6GI1JvtPXdRLJDMlcV1sSs/88t2lfYmX
        Ha7nFT3ZnFGe3/Jw/wSYu21PtH421e2SFdESrCRwpy1Q6PZlOf0AWs+h654yFg36
        zsSSuFyKEXYIx0KaCj8hHkPBSOtadLSI/bMqPkDk69/+lYw/DZFwsViqXV4cL2T2
        R3qdfEaC/orxjMZ93KHBwxu4CvScMEVgKMk2sz5OwynzSNGpc3R08bJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=eKfIrsSnacR+SpyNgSovGoZD1LB+PIAhf4rhYFJZz
        Co=; b=f6166IuU4qDkptkfXdqRW/a2rH6rq15x/EGzqumBsBidrCiwET2+u+pV4
        iZBVqd19pJY4iklZd/tLT7fCCa1kcmo7KEkPG1xpFUwN3mSSkl50FOk2ATvNLWYs
        0C7tQPrfIBJsf4N1lGt1oThdRnN+GCMUSfKTbfpxUWG34V0jemk7oiuE+FwaVvYj
        qicfWiK0rDZ+HUGnTPUlMsdL8w7gieDYI85Hi92gyNDiErBSbfq25Z+WJ3JgrSPN
        dUrd7jzcL4g4sxum/+H4oa9PtTFh4G2BHXipki3p2fzD6zIqlF/+tEoEsJ32O/h1
        +IEkwHXVgpLEOHs27/qwcuAQVk7tg==
X-ME-Sender: <xms:7hQBYpKEI06vNJW5wI7dY7EbW9fO0fe1dq2hSxqdOLy2FnVuXfBs0w>
    <xme:7hQBYlK6yEh4gFhqr8bO2RDxVRB_Xcu2twZbEJbOxMjcVYtlz4gGS8eOfcyKpw8N_
    -_wZkFFSpp671SNquI>
X-ME-Received: <xmr:7hQBYhtZ1SsG50VQRPFf44wFgR0KixR953OC0d0LdZtkFVZuFAQ5ruM6oKKI_hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepjeefkeevteffheevkeeitedviefhhffhiefggeektefhgfelvedu
    jeelgfefteetnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehf
    lhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:7hQBYqaerCusXO8aUdnlf5kZsZKiCDhfrh2SKJ7IQ-YDRap3_MMoGw>
    <xmx:7hQBYgZ1VCDQLSv2gl18sw0VUnvXGZrmpuDRU9yhq1gQ8fwMBSVE_A>
    <xmx:7hQBYuDThzuWSLONlRzkTwVhoz3HY241TT6oD5dUvyd9kJNZF7hEzw>
    <xmx:7hQBYryYHvuDWUVZ3T_P2za26fFhkUMMwY1xIb-_wfkSkV3BpuZVmQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 07:47:41 -0500 (EST)
Message-ID: <4b23a6fe-32df-f20c-eb1b-eea3b01857d1@flygoat.com>
Date:   Mon, 7 Feb 2022 12:47:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH for-stable] kbuild: Define
 LINUX_VERSION_{MAJOR,PATCHLEVEL,SUBLEVEL}
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <20220207115212.217744-1-jiaxun.yang@flygoat.com>
 <YgEKBAWp+wAWLfFW@kroah.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <YgEKBAWp+wAWLfFW@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/2/7 12:01, Greg KH 写道:
> On Mon, Feb 07, 2022 at 11:52:12AM +0000, Jiaxun Yang wrote:
>> Since the SUBLEVEL overflowed LINUX_VERSION, we have no reliable
>> way to tell the current SUBLEVEL in source code.
> What in-kernel code needs to know the SUBLEVEL?
Hi,

Ah sorry, to clarification, backport here means "Backport Project"
(https://backports.wiki.kernel.org).

Though it is not in-tree, it is a vital part of kernel ecosystem to
deliver some new drivers to stable kernels.

It relies on KERNEL_VERSION macros to enable compat code.

>
>> This brings significant difficulties for backport works to deal
>> with changes in stable releases.
> What backport issues?
Context: 
https://lore.kernel.org/backports/bb0ae37aa770e016463706d557fec1c5205bc6a9.camel@sipsolutions.net/T/#t

We are nolonger able to detect linux version > 4.9.255 in source.
>
>> Define those macros so we can continue to get proper SUBLEVEL
>> in source without breaking stable ABI by refining KERNEL_VERSION
>> bit fields.
>>
>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>> ---
>> For some context: https://lore.kernel.org/backports/bb0ae37aa770e016463706d557fec1c5205bc6a9.camel@sipsolutions.net/T/#t
>> ---
>>   Makefile | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 99d37c23495e..8132f81d94d8 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1142,7 +1142,10 @@ endef
>>   define filechk_version.h
>>   	(echo \#define LINUX_VERSION_CODE $(shell                         \
>>   	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
>> -	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
>> +	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'; \
>> +	echo \#define LINUX_VERSION_MAJOR $(VERSION); \
>> +	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL); \
>> +	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL);)
> This is already in Makefile, are you sure you just do not need to
> backport
I wish this can be a part of existing stable kernels so backport project
can maintain flawless build againt stable kernels.

Thanks.
- Jiaxun

> a specific patch instead of making your own that does the same
> thing?
>
> thanks,
>
> greg k-h

