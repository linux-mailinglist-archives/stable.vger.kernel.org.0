Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79796420B0
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 01:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiLEAEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 19:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiLEAEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 19:04:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCA5DF6B;
        Sun,  4 Dec 2022 16:04:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC4F60F22;
        Mon,  5 Dec 2022 00:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAF4C433C1;
        Mon,  5 Dec 2022 00:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670198691;
        bh=E2UWquMT8SOEySGuXW9ZjENIHTDB2CRhYj0WBHo+IbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YteI6FDhvVHKCs0GoH/dXXjK7RyfUmxld3g8zmkyJiSNJ2H0R50mW8fAS/d6+2BBp
         glyAwd7CflM0e2uPvW6OgxFq4lOd6KjSO7eNslgZf6qiVcCTWJoWj/g+OanVHm3i/Y
         y5Bz3v5XZ22TpxPQSvukiUZ0+lMdqwoFa+yHWaxofpNRHLhZmFXWJqI6KxU1EoRP09
         eC1SxLu+YhQt6OUuo9uxaAOyTjzkiOvmWaKXvfIh5/x4p1xjN9jAedyKRhcBfaUBJF
         KnugVlSVppuoWa5pz7joE/wZEn1Be2qyiUPx+bgvyMRiuoqqvhxxFrC5mrTpE2Q1Q0
         lt2H8qCDEEahg==
Date:   Sun, 4 Dec 2022 19:04:49 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sam James <sam@gentoo.org>
Cc:     stable@vger.kernel.org, stable-commits@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: Patch "kbuild: fix -Wimplicit-function-declaration in
 license_is_gpl_compatible" has been added to the 5.15-stable tree
Message-ID: <Y401obKZjg5MoOXL@sashalap>
References: <20221203092656.400311-1-sashal@kernel.org>
 <C4884E05-F4DB-4FED-860A-1DF38BEABF3F@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <C4884E05-F4DB-4FED-860A-1DF38BEABF3F@gentoo.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 03, 2022 at 09:29:39AM +0000, Sam James wrote:
>
>
>> On 3 Dec 2022, at 09:26, Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
>>
>> to the 5.15-stable tree which can be found at:
>>    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>     kbuild-fix-wimplicit-function-declaration-in-license.patch
>> and it can be found in the queue-5.15 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>>
>>
>>
>> commit 3f07ef5743bd434f3689f9ceed7a24128dc6b5ae
>> Author: Sam James <sam@gentoo.org>
>> Date:   Wed Nov 16 18:26:34 2022 +0000
>>
>>    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
>>
>>    [ Upstream commit 50c697215a8cc22f0e58c88f06f2716c05a26e85 ]
>
>Hi Sasha,
>
>Please yank this commit as it's been reverted upstream, it doesn't work
>for cross as-is.

Hi Sam,

It already made it in prior to your mail. Could you point me to the
reverting commit? I can grab that too.

-- 
Thanks,
Sasha
