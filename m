Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DE33C8594
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 15:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhGNNzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 09:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231478AbhGNNzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 09:55:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B47E661374;
        Wed, 14 Jul 2021 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626270774;
        bh=OycTVQYaz4qZE3b0K8hY2CwdLFbGN3IgcJG4GWpdzyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iV9fmieb2VM6vRI2wSniHEk9q3GJYCB2uB0EWs83aHFRQGCWJouajGxtVfuu/jx1T
         66DGdvNcbEzrQ3489b3pe5ZhQzvkHzYmaXVqryeeoGn1YXOi0UkpPwmkS47Z5HRznp
         DMDF7QwOAWnrI5KtkccuaM8sFPhyX0nmVL3at+OFqA5xl266UKbGE3HgWChEbpdinT
         oSM+/AoXxNlpt+3YZcbF7oNb8hWeyOItqWfVe5UbvD07VEXJwSMMbR28PCyWWekTtt
         bmT+IKyL7gLeJlDVYsON42sVtgnyRgcvHQtMWxgnwtIaHa66Fjq745Gz+5c8jowNt+
         stq9sP+2BngrQ==
Date:   Wed, 14 Jul 2021 09:52:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO7sNd+6Vlw+hw3y@sashalap>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YO6r1k7CIl16o61z@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 11:18:14AM +0200, Greg Kroah-Hartman wrote:
>On Tue, Jul 13, 2021 at 06:28:13PM -0700, Andrew Morton wrote:
>> Alternatively I could just invent a new tag to replace the "Fixes:"
>> ("Fixes-no-backport?") to be used on patches which fix a known previous
>> commit but which we don't want backported.
>
>No please, that's not needed, I'll just ignore these types of patches
>now, and will go drop these from the queues.
>
>Sasha, can you also add these to your "do not apply" script as well?

Sure, but I don't see how this is viable in the long term. Look at
distros that don't follow LTS trees and cherry pick only important
fixes, and see how many of those don't have a stable@ tag.

-- 
Thanks,
Sasha
