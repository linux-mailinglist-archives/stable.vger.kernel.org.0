Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06FC67DC29
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 03:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbjA0CJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 21:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjA0CJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 21:09:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB0E20D00;
        Thu, 26 Jan 2023 18:08:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D94461A00;
        Fri, 27 Jan 2023 02:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D758CC433EF;
        Fri, 27 Jan 2023 02:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674785338;
        bh=ho7KbqdMR4TEgp6i52yf2SbTP+5ULm3e4g5tvDSjJxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o2a61l3s2jwJJtKoB4qZdva2n6CtnagYcmSnJjpjAZOnJdzjqttBimbK+Qoo10WRN
         5TtdHj3c0Q6HrxyJXQZYeyis+w8Di71AalrG/eH6pDi5xeoZDvn/xgiRQpxmHhX+sa
         Vw5Hf95gfL0KL4E+GiQiFk2FCPYNFGle66/0hCofbV7A41I3KFjmGjxfNyXvKcbJbA
         byC6E80/T3l3LifeEFqME7dWZ8fCghAYZVhF1dskCZSbdW17AxlJvJgVvQYITjPr3V
         vkQj95792wrOww/hiTgFy+rVj1iAqGxZjXWFZhrjHeHg/0KqjCwIq66pAXp12OuZxf
         ciCiDBKVkr8oA==
Date:   Thu, 26 Jan 2023 21:08:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15 00/20] Backport oops_limit to 5.15
Message-ID: <Y9MyOMfBASwPSsAs@sashalap>
References: <20230124185110.143857-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230124185110.143857-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 10:50:50AM -0800, Eric Biggers wrote:
>This series backports the patchset
>"exit: Put an upper limit on how often we can oops"
>(https://lore.kernel.org/linux-mm/20221117233838.give.484-kees@kernel.org/T/#u)
>to 5.15, as recommended at
>https://googleprojectzero.blogspot.com/2023/01/exploiting-null-dereferences-in-linux.html

I've queued up this and the 5.10 backport, thanks!

-- 
Thanks,
Sasha
