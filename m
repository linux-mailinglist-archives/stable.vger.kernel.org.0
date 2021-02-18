Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1BC31F240
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 23:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBRWWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 17:22:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230174AbhBRWWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 17:22:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2003A6186A;
        Thu, 18 Feb 2021 22:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613686917;
        bh=pKv6I7CRWLU1affMrs82tjDD/cxkwtt2bVAkPyzke1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aiK7UiaadUWsQGfALQe9KXlAg90HQiBeAVeBjNp7VAc51KXjOnrRGW1plvswTO51K
         E4c/qiHSmaaPjfJcJAX+pzZV1ul5pMhFaCJ0GimvIvgzXNZckeTONnZgU3nlltcnVL
         1PYL6zry9D/hmJGnkjpyI+Qst5A1qKj68fNM1k3KbH0yzo0jTfhOI2Kb+qwBO7YLH+
         2KdEg0d4r1arlDkuqhAoOZpRJbtrigUET0LiJLSJYhh8TU1ihAMCnehh2HTUtgpZ2B
         bXVTRRAzMunPuxecE7jYyyuv843zZWdE/0rIbFExZhsPcoL6Unjs9R6k/OkndS3Cyj
         SWU+WDjRExiww==
Date:   Thu, 18 Feb 2021 17:21:55 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Krishnamraju Eraparaju <krishna2@chelsio.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>, bharat@chelsio.com
Subject: Re: backport of IB/isert commit to '5.10.y' stable release
Message-ID: <20210218222155.GF2013@sasha-vm>
References: <20210218071914.GA17349@chelsio.com>
 <20210218160857.GB2013@sasha-vm>
 <20210218174155.GA20270@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218174155.GA20270@chelsio.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 11:11:56PM +0530, Krishnamraju Eraparaju wrote:
>On Thursday, February 02/18/21, 2021 at 11:08:57 -0500, Sasha Levin wrote:
>> On Thu, Feb 18, 2021 at 12:49:16PM +0530, Krishnamraju Eraparaju wrote:
>> >
>> >Hi Greg,
>> >
>> >Could you please backport the below commit to "5.10.y" stable release.
>> >
>> >Looks like this commit was already pulled to "5.10.y" stable tree weeks
>> >ago.
>> >
>> >This fix is required for Chelsio adapters. Without this fix the number
>> >of connections supported by isert(over Chelsio adapter) will be significantly less.
>>
>> This reads like a performane improvement rather than a bug?
>Hi Sasha Levin,
>
>This is not a performance improvement.
>Earlier, commit:317000b926b07c has introduced a side effect, where no.of
>supported isert connections, over Chelsio adapters, had come down to
>9(prior to this commit it was 250).
>
>And this side effect got fixed with commit:dae7a75f1f19bf
>
>Hence, please apply this commit(dae7a75f1f19bf) to '5.10.y' stable release.

Okay, I've queued it up, thanks!

-- 
Thanks,
Sasha
