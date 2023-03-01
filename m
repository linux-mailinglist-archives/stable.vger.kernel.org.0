Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95276A73ED
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCAS7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCAS7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:59:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1940B1EFF5;
        Wed,  1 Mar 2023 10:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A927E61448;
        Wed,  1 Mar 2023 18:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EE5C433D2;
        Wed,  1 Mar 2023 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677697150;
        bh=GD4ue5id52LPJqSDQUoM8gDAQWL7Hip/zzpyh7tgYew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W7MyJIWA1O8XhpkDCLO6bPeFT4poEczvttXqZOfJrQVq32kClh1rBTxZNc0BkErkY
         jy/FFM7AvtfEnjuhwB1u/ksYzgbyakyeaR0gCe9m2b6QRVlEJUUh7/m81irDtBHkpL
         6hAvHeCBoe+4p/a2sBjp67w5Qr+7M9aW61lx9s1YQ6IIQxJsGWos9DAQjVZYS0s2hL
         1QZSMMnh/wyed4f6FJSlqcwqIxqfvXjSQ64gaRqYI6yxoKCdLy/AXRCl7q+prfCPRi
         Bf9DsLWrfzuaJlyPzGe6/+60cPwfBpBNWdaKS7Rd06tEFfG9u4VzX4cJUK9M5hYxCj
         8qg/QM03broFA==
Date:   Wed, 1 Mar 2023 13:59:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.2 2/6] efi: efivars: prevent double registration
Message-ID: <Y/+gfKHBuub3IxIb@sashalap>
References: <20230301162929.1302785-1-sashal@kernel.org>
 <20230301162929.1302785-2-sashal@kernel.org>
 <CAMj1kXHr4tFjC65v5BN465tYBr1_gsMhCHEd6R-d3CoJ=aiYsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMj1kXHr4tFjC65v5BN465tYBr1_gsMhCHEd6R-d3CoJ=aiYsQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 05:31:15PM +0100, Ard Biesheuvel wrote:
>On Wed, 1 Mar 2023 at 17:29, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Johan Hovold <johan+linaro@kernel.org>
>>
>> [ Upstream commit 0217a40d7ba6e71d7f3422fbe89b436e8ee7ece7 ]
>>
>> Add the missing sanity check to efivars_register() so that it is no
>> longer possible to override an already registered set of efivar ops
>> (without first deregistering them).
>>
>> This can help debug initialisation ordering issues where drivers have so
>> far unknowingly been relying on overriding the generic ops.
>>
>> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>NAK this is not a bugfix.

Ack, I'll drop it. Thanks!

-- 
Thanks,
Sasha
