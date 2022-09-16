Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CA65BABEA
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 13:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiIPLCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 07:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiIPLBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 07:01:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097401AD;
        Fri, 16 Sep 2022 03:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE47DB825F9;
        Fri, 16 Sep 2022 10:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CD7C433C1;
        Fri, 16 Sep 2022 10:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663325626;
        bh=sfUahhMCzyg4fILtSRS2+o8JlDYUlTgKqPhLIPQQQ3U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eRl+BF+HJcx+REGkA/xkeM7KR8kK1mxHXqTNvkOKT5CsU47qVgk+e2RI0YttQVDjD
         96N4GLPLZOQZg8QmLvEe9+bMtqsIl16iXNE9HiTdqbITlyqDxaRRxHOndE9qRFU8GK
         o6A/qv8Z2TKDG3SpsDNS5qPeEkaADEwNf/2ioDyo2N5AsJFyTLSYL4bIZyIBPakUcX
         MT+k4Ew5qgyKxGYiGeMthuMoyg+uVu0ejxwTvsLw46eF+sQ1XzOvntS8HUgc5/dg8m
         3cMSt1PcZU5NueYwuunhFyTCMpj++TLNU5xSVl+ESrgSK7/5oXg0tOnIpeUvE729mw
         lfQCKd7msoNfQ==
Date:   Fri, 16 Sep 2022 06:53:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        stable-commits@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.com>
Subject: Re: Patch "hwmon: (pmbus) Use dev_err_probe() to filter
 -EPROBE_DEFER error messages" has been added to the 5.10-stable tree
Message-ID: <YyRVt4tbji1aFAGI@sashalap>
References: <20220915124557.591485-1-sashal@kernel.org>
 <92e8f14b-04f4-88a1-6071-fc87117ba5a1@wanadoo.fr>
 <20220916104725.GB4060280@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220916104725.GB4060280@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 03:47:25AM -0700, Guenter Roeck wrote:
>On Thu, Sep 15, 2022 at 08:48:05PM +0200, Marion & Christophe JAILLET wrote:
>>
>> Le 15/09/2022 à 14:45, Sasha Levin a écrit :
>> > This is a note to let you know that I've just added the patch titled
>> >
>> >      hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages
>> >
>> > to the 5.10-stable tree which can be found at:
>> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>> >
>> > The filename of the patch is:
>> >       hwmon-pmbus-use-dev_err_probe-to-filter-eprobe_defer.patch
>> > and it can be found in the queue-5.10 subdirectory.
>> >
>> > If you, or anyone else, feels it should not be added to the stable tree,
>> > please let <stable@vger.kernel.org> know about it.
>> >
>> Hi,
>>
>> I'm not sure that this one makes a real sense for backport.
>>
>> It can't hurt, but it does not fix a real issue, it just voids a potential
>> spurious message.
>>
>> In my original mail, there is no "stable@" or "fix" or "bug" keywords or
>> "Fixes:" tag.
>> There is also apparently no patch in this backport serie that relies on this
>> patch.
>>
>> Why has it been selected?
>>
>That is essentially how AUTOSEL works. It picks patches based on keywords.
>I am sure Sasha can provide details.

Likely because of how many issues existed in this area (deferred
probing), that it got selected automatically. I'll go drop it.

-- 
Thanks,
Sasha
