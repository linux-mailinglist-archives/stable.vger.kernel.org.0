Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47578E83DE
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 10:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbfJ2JJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 05:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbfJ2JJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 05:09:45 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE58020717;
        Tue, 29 Oct 2019 09:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572340184;
        bh=6xewZwzEDZm0BJwjNyiTn5HPxc795xoDtGQ7k7FbBeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s1XVqUbRK7tSeIa0z4nvyUmPasVi+VNCCFif7ArUxyxxNLB8wAYAYaZrhRKKgAX7j
         rpJVf7YSZMSh1xrZ4S6yqJLlYV7TqIMLt/i+S9gWBnVe0P0EkICpdJMrO1Y7aBLg0J
         PzlrJjFqgGSkA8LwQVk2MR4iRsWFpHxuZIU5HGMk=
Date:   Tue, 29 Oct 2019 05:09:41 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Matthias Maennich <maennich@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.3 50/89] kbuild: fix build error of 'make
 nsdeps' in clean tree
Message-ID: <20191029090941.GK1554@sasha-vm>
References: <20191018220324.8165-1-sashal@kernel.org>
 <20191018220324.8165-50-sashal@kernel.org>
 <CAK7LNARovn6jNGUBQbn-0KbwsCfC6GHE-ybqHDvRUXiCCDuMZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAK7LNARovn6jNGUBQbn-0KbwsCfC6GHE-ybqHDvRUXiCCDuMZA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 19, 2019 at 09:14:13AM +0900, Masahiro Yamada wrote:
>On Sat, Oct 19, 2019 at 7:04 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Masahiro Yamada <yamada.masahiro@socionext.com>
>>
>> [ Upstream commit d85103ac78a6d8573b21348b36f4cca2e1839a31 ]
>>
>> Running 'make nsdeps' in a clean source tree fails as follows:
>>
>> $ make -s clean; make -s defconfig; make nsdeps
>>    [ snip ]
>> awk: fatal: cannot open file `init/modules.order' for reading (No such file or directory)
>> make: *** [Makefile;1307: modules.order] Error 2
>> make: *** Deleting file 'modules.order'
>> make: *** Waiting for unfinished jobs....
>>
>> The cause of the error is 'make nsdeps' does not build modules at all.
>> Set KBUILD_MODULES to fix it.
>>
>> Reviewed-by: Matthias Maennich <maennich@google.com>
>> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
>> Signed-off-by: Jessica Yu <jeyu@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>nsdeps was introduced in v5.4
>
>Please do not backport this commit.

I've dropped it everywhere, thank you.

-- 
Thanks,
Sasha
