Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6932459EA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 00:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgHPWh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Aug 2020 18:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgHPWh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 16 Aug 2020 18:37:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294682078A;
        Sun, 16 Aug 2020 22:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597617448;
        bh=iw7rkOJ5MJ2VZtpaZrOjB3dq76JLxfzWWBILwdqFzWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCloMlBbG7vdiJaQWMW5H0OM3AiNfx8nfZHTu7wkAsJEsqeaii06nPuXRPwkbDcRI
         CNYG5JjYu3Mbd+krRH+Wbn2kDUPFRqsb+kxLrsicXbRRCjrmphuH3kj2mlMjZhwi9D
         pfm7hDpWPksx1SA4GYLawPnMSyZURu27rtlIPAt0=
Date:   Sun, 16 Aug 2020 18:37:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     stable kernel team <stable@vger.kernel.org>
Subject: Re: [edumazet@google.com: Re: [PATCH] x86/fsgsbase/64: Fix NULL
 deref in 86_fsgsbase_read_task]
Message-ID: <20200816223727.GB4122976@sasha-vm>
References: <20200815174640.GA2718256@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200815174640.GA2718256@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 15, 2020 at 07:46:40PM +0200, Ingo Molnar wrote:
>
>hi Greg,
>
>Please apply upstream 8ab49526b53d to all stable kernels containing
>07e1d88adaae, which should be v4.20 and higher stable kernels.

I've picked it all the way up to 4.14, as 07e1d88adaae was backported
that far.

-- 
Thanks,
Sasha
