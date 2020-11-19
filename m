Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C132B8979
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 02:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgKSBW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 20:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgKSBW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 20:22:56 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39BBC22260;
        Thu, 19 Nov 2020 01:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605748975;
        bh=TFHs4tz0GH5smmJjidG94ZdJq6arZtVL3vG+AwXZJwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2EL27i1nJCdGO7vmS62o6Rl9/3gll45ZbSRA+ShpxGUbVpwC1mcFrGCWavnKHVYC8
         K1U2Mv/pc2gpjn3UazvG9cCs/rpeHhkBbH0rh8TY45tPbVcqjuRnLsb17U3kB0rAY7
         bZvKmZqR7Oau1gg0+Cdic2NQOORDJc8LjKSjmIbU=
Date:   Wed, 18 Nov 2020 20:22:54 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH AUTOSEL 5.9 13/21] lockdep: Avoid to modify chain keys in
 validate_chain()
Message-ID: <20201119012254.GC643756@sasha-vm>
References: <20201117125652.599614-1-sashal@kernel.org>
 <20201117125652.599614-13-sashal@kernel.org>
 <20201118012634.GF286534@boqun-archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201118012634.GF286534@boqun-archlinux>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 18, 2020 at 09:26:34AM +0800, Boqun Feng wrote:
>Hi Sasha,
>
>I don't think this commit should be picked by stable, since the problem
>it fixes is caused by commit f611e8cf98ec ("lockdep: Take read/write
>status in consideration when generate chainkey"), which just got merged
>in the merge window of 5.10. So 5.9 and 5.4 don't have the problem.

I'll drop it, thanks!

-- 
Thanks,
Sasha
