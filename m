Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878FD1AD0E7
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 22:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgDPUNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 16:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDPUNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 16:13:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E20F321841;
        Thu, 16 Apr 2020 20:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587068010;
        bh=LyH9cHiVsHhYNaY8doBcGxuSdbtSiTmUFJcreEJc7dI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=he9cyi9U6qNaI++P4yCtou68OtfJj0xa0yu9eO1qYXQ1+RZUP6SNUIDA8c4tpI1x7
         ROTa+l+WyFq7FbIeME4zKIxrIRqh0spV4dXEZBEQxFGhVQEHQkW0/VgGE8tx85M39A
         BjqBeLISgOkfBcSVeZ8aj67Hq/kN1LV4SVppD++k=
Date:   Thu, 16 Apr 2020 16:13:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4.19 003/146] rxrpc: Abstract out the calculation of
 whether theres Tx space
Message-ID: <20200416201328.GQ1068@sasha-vm>
References: <20200416131242.353444678@linuxfoundation.org>
 <20200416131242.886803103@linuxfoundation.org>
 <20200416170515.GA29803@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200416170515.GA29803@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 07:05:15PM +0200, Pavel Machek wrote:
>Hi!
>
>> Abstract out the calculation of there being sufficient Tx buffer space.
>> This is reproduced several times in the rxrpc sendmsg code.
>
>I don't think this is suitable for stable. It does not fix anything.

You're right - I've grabbed it so that I could also take e138aa7d3271
("rxrpc: Fix call interruptibility handling").

-- 
Thanks,
Sasha
