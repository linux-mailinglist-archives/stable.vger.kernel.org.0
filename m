Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5403F3B6CF8
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 05:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhF2D3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 23:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231719AbhF2D3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 23:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5350361D2B;
        Tue, 29 Jun 2021 03:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624937227;
        bh=vcMDEKhOojqg+3ziV610Lq/x2nLSucpHAQKZ2lVXnNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xtn0q2vgK52VeIPnwX7X4nIpBsgbkaHxbseIouLf4EOrRi+3tbpjAHV4k0sL9CEFS
         TBjsSWzvkq6hvfyaD0RoFGMmbz/9Hd5xrG5AHYCA2VsoTzRif+J56Hvsuh4lgwxp4E
         cT+p0ZqYLqZjCwqn93klhRNeskLzMtcL8fPW58uCG/dKwSjpxdQZy1eK8leHEsD/q7
         9fjJcegQE0dgzNgJszPiSIfUJ3LL/wIWcGG8nh5lyMlgE5FDIisByzmOAvHapiKutl
         8OnUZv0t8LpK43FakWJT1xAaoJ/ScGjCkh9no+kQjMDMg1dxKvfUTywPaRU6kk9hi0
         sfsQ8w3Ftqu4w==
Date:   Mon, 28 Jun 2021 23:27:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Shi <alexs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
Message-ID: <YNqTCV7DmYGZiZ7N@sashalap>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com>
 <YMrU4FRkrQ7AVo5d@kroah.com>
 <YNNMGjoMajhPNyiK@kroah.com>
 <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com>
 <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org>
 <c2bf7b2-a2d9-95a1-e322-4cf4b8613e9@google.com>
 <6b253bc4-2562-d1bb-18f2-517cfad5d5e7@google.com>
 <YNm93fkIPrqMwHzd@kroah.com>
 <366846c0-245a-771e-7a1-4a307ac6e5e1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <366846c0-245a-771e-7a1-4a307ac6e5e1@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:12:57AM -0700, Hugh Dickins wrote:
>On Mon, 28 Jun 2021, Greg Kroah-Hartman wrote:
>> So could you just send a mbox of patches (or tarball), for the 4.19,
>> 4.14, and 4.9 trees?  That would make it much easier to ensure I got
>> them all correct.
>
>At risk of irritating you, sorry, I am resisting: the more data I send
>you, the more likely I am to mess it up in some stupid way.  Please ask
>again and I shall, but I think your success with 5.12, 5.10, 5.4 just
>means that you were right to take a break before 4.19, 4.14, 4.4.

I've tried following the instructions for 4.19, and that worked fine on
my end too.

If no one objects, I can pick up 4.9-4.19 after the current set of
kernels is released.

-- 
Thanks,
Sasha
