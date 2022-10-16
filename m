Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38385FFFB0
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 15:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJPNfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 09:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJPNfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 09:35:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF6F2E686;
        Sun, 16 Oct 2022 06:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0985F60B84;
        Sun, 16 Oct 2022 13:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE83C433C1;
        Sun, 16 Oct 2022 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665927334;
        bh=dAlAkJpKgz/yL9xyJ16Ke5fmJ+B3jax/ykuVAw2woSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TfWEurdFGiWYyrRBvwI1OsXs1kaOLOXEWryCcbsRHD1gT29ukXIPpIMoGiOpMz8Vo
         LEFTCJBc17IhbsrRKKcZ+gkLgnvHoXHic+BllKjwVnGhX+5aXzdgvNBZQjtflytBI1
         6FpDwpsVWVIMLyCDcQx6kFCUoSbkifPXolYiXHqXXU+hCGn7Z5wCgUes15//zCie2f
         7io0sAe7QBFtgdETBb1XGFgoB9HB5YRfFFW6XEwYyggncYROxAU7wZCqbyK+kDyQF4
         Jdl03JgKUS0K/D06k1dvCrq+GLymcd5xeZ2GCUfQVAwu8Ti4zow+cqxtWGlFUzm5Ko
         W4Nlgp4cEkz+w==
Date:   Sun, 16 Oct 2022 09:35:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 22/63] gpiolib: of: make Freescale SPI quirk
 similar to all others
Message-ID: <Y0wIpGsQNhwEw7/B@sashalap>
References: <20221013001842.1893243-1-sashal@kernel.org>
 <20221013001842.1893243-22-sashal@kernel.org>
 <CAMRc=Md25wNapmU4ZxNfTPAOgCpSkW6Z7Oen6NFKj-kURaupAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMRc=Md25wNapmU4ZxNfTPAOgCpSkW6Z7Oen6NFKj-kURaupAQ@mail.gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 11:28:14AM +0200, Bartosz Golaszewski wrote:
>On Thu, Oct 13, 2022 at 2:19 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>
>> [ Upstream commit 984914ec4f4bfa9ee8f067b06293bc12bef20137 ]
>>
>> There is no need for of_find_spi_cs_gpio() to be different from other
>> quirks: the only variant of property actually used in DTS is "gpios"
>> (plural) so we can use of_get_named_gpiod_flags() instead of recursing
>> into of_find_gpio() again.
>>
>> This will allow us consolidate quirk handling down the road.
>>
>
>Sasha,
>
>This is not a fix, it's code refactoring. Definitely not stable material.
>
>Bartosz
>
>PS Same for the rest of the backports of the three patches I commented on.

I'll drop all of those, thanks!

-- 
Thanks,
Sasha
