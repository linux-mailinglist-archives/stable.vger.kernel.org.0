Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6C553DB87
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbiFEN0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbiFEN0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:26:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89132FFDE;
        Sun,  5 Jun 2022 06:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A95960F5F;
        Sun,  5 Jun 2022 13:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF9EC385A5;
        Sun,  5 Jun 2022 13:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654435604;
        bh=iV3ySxhhsjLEfUOT8pqPH0g4K7CFiE02i3cToEk6lec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IInc0KwpbZFLb3E7OpJ8NAYBVggrWHFd1SzkcGEwoW/3I9Sj5eBKzNbK0VPRpoCoa
         8bhkE7yoROnMwdrJJwXuOYevULjgTnFjN1iw7QK8iqB5yVAI0LjrwSfnTMh5EdNa1W
         ykqQvzA26+u7n1DmyYpPRoaxLSxHeopnh680T+e+tmgtRW5/8YR5qS8axkw3t4UNJv
         amtfBgca7t3VFiN6hS/iLPiF9sD0cA0ZAViZ/Ar5/dSlfZpxImVmWbt48eKyZkne+1
         okSO8liHrtwzREntI5wAkq0bCaN/Izx96XQNoucB+hVPSxMFmKITaUIoGPYtnUnJh2
         lwsR4Ii36+amg==
Date:   Sun, 5 Jun 2022 09:26:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Daniel Latypov <dlatypov@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com
Subject: Re: [PATCH AUTOSEL 5.17 089/135] kunit: bail out of test filtering
 logic quicker if OOM
Message-ID: <YpyvEyomrPpj3JJR@sashalap>
References: <20220530133133.1931716-1-sashal@kernel.org>
 <20220530133133.1931716-89-sashal@kernel.org>
 <CAGS_qxrtZBrpk8x64oj53o4EEUCgTj1c4D12W+6UNArQfiiXaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGS_qxrtZBrpk8x64oj53o4EEUCgTj1c4D12W+6UNArQfiiXaQ@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 31, 2022 at 09:15:11AM -0700, Daniel Latypov wrote:
>On Mon, May 30, 2022 at 6:36 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Daniel Latypov <dlatypov@google.com>
>>
>> [ Upstream commit a02353f491622e49c7ddedc6a6dc4f1d6ed2150a ]
>>
>
>Is it possible to make sure the fix for this commit gets picked up as well [1]?
>I was waiting a bit to see if it was going to get picked up
>automatically, but I don't see such an email yet:
>https://lore.kernel.org/stable/?q=kunit+OOM
>(Perhaps the automation just hasn't gotten around to it yet?)

I'll make sure the fix added along with this commit.

-- 
Thanks,
Sasha
