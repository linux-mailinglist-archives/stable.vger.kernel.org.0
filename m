Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942CD4D7ADD
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 07:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbiCNGig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 02:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiCNGif (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 02:38:35 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BD4403E7;
        Sun, 13 Mar 2022 23:37:26 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s11so13388318pfu.13;
        Sun, 13 Mar 2022 23:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iMJcv9ubCLFaXCjQftcG68FsrXlS8RsUXhTzNLm32HA=;
        b=bWop7XSVxqRKr17UzCTLL4YmEzaWVfR/gAAvsfWVV30KLp/TPoTZUGTsx3uXcNTq5m
         2+n98f48BV9TVMSUWrC7V5eHp1Wv0oY6+KQlrbfj6tmXTfJ7SfIg8e6qWD/8yFhibgia
         w87vsgP6we7r/FeySUqP+a28J+IHhyLamBgOjUWIN3wYlYGKVUPAoQHYTtbwvdDyVz/Q
         XX1W0MUiv9qLU3dbfT/jPratHDFV1Psftc9nkrNTRQIfJxCdzmtbC0CZD3sP2tMBq84u
         O99y45etVTO21mFFncbnN1zsmM0R7nty8iNIDCWsruA8aDtGeop4kqAHzAkWOfPIxM5u
         xAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iMJcv9ubCLFaXCjQftcG68FsrXlS8RsUXhTzNLm32HA=;
        b=clpAruSUWC6KzVnUWi8EKq7FejZ8qJKEMV3JlrMg/R4rwzYDPug7cPL71dcqZmZ6wF
         8iXpd7dQ1UcujJqGZi+EOoYvyAHJ3IUsMhFK17AScKgKojzBDmiKPkmseWIO4gfrTxl2
         VRd9iRxlV7JMXXEnxS1NJo5NtWblItlbMVigvKCJwcTDCC/6X9vaUct2omLGdyd98WNR
         M/sSffk7AuXje4oGZU9njbkWlBbZQEdwEh8FRE3YOa9vgtGHjqGD0R+fANaw7a3+cIRW
         Yic1nNy6Kcaya77AsxpCm1f6/JI1Qf1sBcYeOi5uaZaS5Fe5QL1Y07WqdrxQe1nf6HNx
         0fgw==
X-Gm-Message-State: AOAM532ZCimWBIrc4tErMNhn+JLqhKX4UOPRzDysF1pM2Xj6fR3w6sV6
        pAZ8JtFLWgi0E0QZUE3JlxTo5fmmYyUy9w==
X-Google-Smtp-Source: ABdhPJz99X1JFaMwku7p3h3zlJyKIVqq/vJNpuKo2Ws/ONDHTb8XGmjKm+FC59eOi2WtF5nQisBAug==
X-Received: by 2002:a05:6a00:1586:b0:4f7:56e2:7a8e with SMTP id u6-20020a056a00158600b004f756e27a8emr22202718pfk.70.1647239846378;
        Sun, 13 Mar 2022 23:37:26 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-42.three.co.id. [116.206.28.42])
        by smtp.gmail.com with ESMTPSA id hg1-20020a17090b300100b001bf70e72794sm19604724pjb.40.2022.03.13.23.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 23:37:25 -0700 (PDT)
Message-ID: <4611d0fb-c8a2-8f23-ad6d-9c28b216a105@gmail.com>
Date:   Mon, 14 Mar 2022 13:37:21 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/4] Documentation: update stable review cycle
 documentation
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-doc@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220312080043.37581-1-bagasdotme@gmail.com>
 <20220312080043.37581-3-bagasdotme@gmail.com> <YixqnPTe0Wr6E1G3@kroah.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <YixqnPTe0Wr6E1G3@kroah.com>
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

On 12/03/22 16.40, Greg Kroah-Hartman wrote:
>> diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
>> index d8ce4c0c775..c0c87d87f7d 100644
>> --- a/Documentation/process/stable-kernel-rules.rst
>> +++ b/Documentation/process/stable-kernel-rules.rst
>> @@ -139,6 +139,9 @@ Following the submission:
>>      days, according to the developer's schedules.
>>    - If accepted, the patch will be added to the -stable queue, for review by
>>      other developers and by the relevant subsystem maintainer.
>> + - Some submitted patches may fail to apply to -stable tree. When this is the
>> +   case, the maintainer will reply to the sender requesting the backport.
> 
> This is tricky, as yes, most of the time this happens, but there are
> exceptions.  I would just leave this out for now as I don't think it
> helps anyone, right?
> 

I think wording on option 3 needs to mention backport. Something like: "Option 3
is especially useful if the upstream patch needs to be backported (e.g. needs
special handling due to changed APIs)".

>> @@ -147,13 +150,22 @@ Review cycle
>>    - When the -stable maintainers decide for a review cycle, the patches will be
>>      sent to the review committee, and the maintainer of the affected area of
>>      the patch (unless the submitter is the maintainer of the area) and CC: to
>> -   the linux-kernel mailing list.
>> +   the linux-kernel mailing list. Patches are prefixed with either ``[PATCH
>> +   AUTOSEL]`` (for automatically selected patches) or ``[PATCH MANUALSEL]``
>> +   for manually backported patches.
> 
> These two prefixes are different and not part of the review cycle for
> the normal releases.  So that shouldn't go into this list.  Perhaps a
> different section?
> 

I think these prefixes **are** part of review cycle; in fact these patches
which get ACKed will be part of -rc for stable release.

>>    - The review committee has 48 hours in which to ACK or NAK the patch.
>>    - If the patch is rejected by a member of the committee, or linux-kernel
>>      members object to the patch, bringing up issues that the maintainers and
>>      members did not realize, the patch will be dropped from the queue.
>> - - At the end of the review cycle, the ACKed patches will be added to the
>> -   latest -stable release, and a new -stable release will happen.
>> + - The ACKed patches will be posted again as part of release candidate (-rc)
> 
> Is this the first place we call it "-rc"?

Yes.
> 
>> +   to be tested by developers and users willing to test (testers). When
> 
> No need for "(testers)".
> 

So we can just say "developers and testers", right?

>> +   testing all went OK, they can give Tested-by: tag for the -rc. Usually
> 
> "testing all went OK" is a bit ackward.  How about this wording instead:
> 	Responses to the -rc releases can be done on the mailing list by
> 	sending a "Tested-by:" email with any other testing information
> 	desired.  The "Tested-by:" tags will be collected and added to
> 	the release commit.
> 

OK, will apply.

-- 
An old man doll... just what I always wanted! - Clara
