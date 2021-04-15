Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1B360824
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 13:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhDOLVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 07:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhDOLVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 07:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB63E61158;
        Thu, 15 Apr 2021 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618485654;
        bh=A9gVsvIvPP0UOGMduAzHl6VvzCVaASF1eIJTfQQRUgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nZ1uWx8mfAibaFevwXE8gH9uxgXZVago8NzXALUi8rlJwzZONYY9ld+VLYKVni8nk
         NUzdUOiks51bH6Oqhv6T/a9L1QcMJrDj5/hsRpfvKCpl2d4q8GLzDLUJ7jP1JjBTUE
         PVcpz1hTYEfgN8i+1fFJ8P1x7qPgujBOTHXG546KFCJyinQq2XViNjYyNltzrZu17m
         5w+o/in7vK0m4TfWuKVAFePx/eXyov0iMgDP7RALeQT2MMMUTegM8GOMK8mNrVWHAI
         5xrzenMbDQhTnOiZuwZ3wOYouuyINA91UVrK5qk6fm0ixAAI3Z5C7ZFEhpDslXFBFS
         7wrN5GhYi4Itw==
Date:   Thu, 15 Apr 2021 07:20:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        NeilBrown <neil@brown.name>,
        George Hilliard <thirtythreeforty@gmail.com>,
        Christian =?iso-8859-1?Q?L=FCtke-Stetzkamp?= <christian@lkamp.de>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Sergej Perschin <ser.perschin@gmail.com>,
        John Crispin <blogic@openwrt.org>
Subject: Re: "Backport" of 441bf7332d55 ("staging: m57621-mmc: delete driver
 from the tree.") as well for older stable series still supported?
Message-ID: <YHghlaftXxH49lUy@sashalap>
References: <YHdGBm2WHb5I8FFW@eldamar.lan>
 <YHgIEbn1UqhXHdzr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YHgIEbn1UqhXHdzr@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 11:32:01AM +0200, Greg Kroah-Hartman wrote:
>On Wed, Apr 14, 2021 at 09:44:06PM +0200, Salvatore Bonaccorso wrote:
>> Hi Greg, Sasha, all,
>>
>> Prompted by https://bugs.debian.org/986949 it looks that files with
>> prolematic license are present in stable series in
>> drivers/staging/mt7621-mmc/ prior to 441bf7332d55 ("staging:
>> m57621-mmc: delete driver from the tree.") where those were removed in
>> 5.2-rc1.
>>
>> As the license text at it is presented is problematic at best, would
>> this removal make sense as well in the current other stable series
>> which contain it? The files goes back to it's addition in 4.17-rc1.
>>
>> So it would remain v4.19.y where the files should/can be removed as
>> well from the staging area?
>
>Yeah, it is odd, and we probably should not continue to distribute new
>updates with it in the tree.
>
>As the commit does not backport cleanly, can you provide a working
>backport that I can apply?

I killed it :) Thanks for the heads up!

-- 
Thanks,
Sasha
