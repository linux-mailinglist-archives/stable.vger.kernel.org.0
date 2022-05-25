Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF5B533A82
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 12:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiEYKSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 06:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiEYKSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 06:18:04 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F008A95DD9
        for <stable@vger.kernel.org>; Wed, 25 May 2022 03:18:01 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id er5so26353996edb.12
        for <stable@vger.kernel.org>; Wed, 25 May 2022 03:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CWcbS5L85/mEeW1mF6bU3WMw7UT8O3cm3JT79L0gTxk=;
        b=v4BbHDiSDvL5R73FWR5xbtJy6LNxqmlEePT1FtrfGJ6UkSFioQszcA8rOIeRxf6iHL
         0+BN0eR8A3ge/2dyAKxSIiwOOmWmxKixLr7vIcI4r97yybZLeJzbp2dfYgZ204c2idzK
         rmC9K9er1G3Cl5FEEMABQXaepeopRG/evCzlzWUAieWV+DXmRv4sDU5hU3nnp1g7Mpb6
         He5z/JQV4zJT2NOYtfE1pzQG/7lfdOxPHCrKBk+p/cAqGl3rKL871evgBEGfRGPN3hm2
         jbV5O54mDau6gzvomfvJpi5gqd2jHaKo03uVpZWZKJuwBOkAUqEhaKHAMCBI/S931Rfj
         iHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CWcbS5L85/mEeW1mF6bU3WMw7UT8O3cm3JT79L0gTxk=;
        b=pZkIhPlk5ricA+U27i4AUpCPA2yTHVO6Ng6jCPjMYhxVhE/6SgS1CLxJhovqMUDKvB
         FE0teDIw/noQsmf0uB4Sgc4M/46PynWtmIFn7J2QdvhibcaXBqzG8xZHt/u+9KlYf1tw
         pytZkkAqcnWMs1qLUaM85qanrkwNUfH0V7WVE0W3zlfWCWMoAIEmEfmXRFsFlqeK2uXw
         Y4gdLwWj7bh8zSOi4Zs2akIn3HY7e4OjLph9Koq4OnRXKuu0ct/tGzDjUon7pJttGC+f
         AoN5gaXmRhWIT1OZvxuHH7RdFQyUafeWpghYItaXNGgIP/P0j5NVJbd64K91UUoYrCBU
         +GgA==
X-Gm-Message-State: AOAM533OPoi26kZ+0FBF7U7BovicI4Jwud0y9BFCrR9SSdOV7cGHpx+h
        0ZLdfWFLy7tW83tdGd/8n6QZRVMiPKLkSyLY
X-Google-Smtp-Source: ABdhPJx71HmX/6m5vDdLrQDBd2fZlBrC5klCkXUMKj3Wv/QHDoe7s+eFtf3w61AtpymFBwhn8Fk1Ew==
X-Received: by 2002:a05:6402:2996:b0:42b:49a:6d24 with SMTP id eq22-20020a056402299600b0042b049a6d24mr30849124edb.145.1653473880217;
        Wed, 25 May 2022 03:18:00 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:2c21:b442:2fc3:f06f? ([2a02:578:8593:1200:2c21:b442:2fc3:f06f])
        by smtp.gmail.com with ESMTPSA id y20-20020aa7c254000000b0042ac4089dabsm10334757edo.17.2022.05.25.03.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 03:17:59 -0700 (PDT)
Message-ID: <6207feca-1cd2-be15-e1cf-0ae2ff680b48@tessares.net>
Date:   Wed, 25 May 2022 12:17:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.17 114/158] mptcp: strict local address ID selection
Content-Language: en-GB
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220523165830.581652127@linuxfoundation.org>
 <20220523165849.851212488@linuxfoundation.org>
 <fa953ec-288f-7715-c6fb-47a222e85270@linux.intel.com>
 <Yo3gAprjnapHfKar@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <Yo3gAprjnapHfKar@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Mat,

On 25/05/2022 09:51, Greg Kroah-Hartman wrote:
> On Mon, May 23, 2022 at 08:51:52PM -0700, Mat Martineau wrote:
>> On Mon, 23 May 2022, Greg Kroah-Hartman wrote:
>>
>>> From: Paolo Abeni <pabeni@redhat.com>
>>>
>>> [ Upstream commit 4cf86ae84c718333928fd2d43168a1e359a28329 ]
>>>
>>> The address ID selection for MPJ subflows created in response
>>> to incoming ADD_ADDR option is currently unreliable: it happens
>>> at MPJ socket creation time, when the local address could be
>>> unknown.
>>>
>>> Additionally, if the no local endpoint is available for the local
>>> address, a new dummy endpoint is created, confusing the user-land.
>>>
>>> This change refactor the code to move the address ID selection inside
>>> the rebuild_header() helper, when the local address eventually
>>> selected by the route lookup is finally known. If the address used
>>> is not mapped by any endpoint - and thus can't be advertised/removed
>>> pick the id 0 instead of allocate a new endpoint.
>>>
>>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>> net/mptcp/pm_netlink.c | 13 --------
>>> net/mptcp/protocol.c   |  3 ++
>>> net/mptcp/protocol.h   |  3 +-
>>> net/mptcp/subflow.c    | 67 ++++++++++++++++++++++++++++++++++++------
>>> 4 files changed, 63 insertions(+), 23 deletions(-)
>>>
>>
>> Greg, Sasha -
>>
>> Is it possible to drop this one patch? It makes one of the mptcp selftests
>> fail (mptcp_join.sh, "single address, backup").
> 
> Does that mean the backport is incorrect, or that the selftest is wrong?

The backport is correct but the commit that is backported here was part
of a series that was changing the behaviour. This modification is
visible in the selftests.

If I'm not mistaken, we would need these two commits to fix the
regression in the selftests:

  69c6ce7b6eca selftests: mptcp: add implicit endpoint test case

  d045b9eb95a9 mptcp: introduce implicit endpoints


But we don't want to change the behaviour in stable and it is better to
drop this patch ("mptcp: strict local address ID selection"), it is not
needed for stable from what I see.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
