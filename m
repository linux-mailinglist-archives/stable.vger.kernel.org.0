Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BB6146B49
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 15:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgAWO3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 09:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgAWO3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 09:29:24 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B1802077C;
        Thu, 23 Jan 2020 14:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579789763;
        bh=ez/6JX2xGbOJsnIuQVPOf4+j+91L5ey1MQH6rdwQxkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=faslfbwzBXBUjetdZ/tFitSEXFA8mssSeblKbisXfD3QOEDYM4bstH4QzWKYtayQJ
         nx77Rjj5TokMdEAqBD4FBcjRqCsaz8Dmu71oi7NQLhletqMfc3UFsoZ+cDAy1nAkVI
         GEfEcYaXT6Gm/cbR+agA6MPeA3Jz1pHQVCCz2v4w=
Date:   Thu, 23 Jan 2020 09:29:22 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH AUTOSEL 4.4 064/174] m68k: mac: Fix VIA timer counter
 accesses
Message-ID: <20200123142922.GF1706@sasha-vm>
References: <20200116174251.24326-1-sashal@kernel.org>
 <20200116174251.24326-64-sashal@kernel.org>
 <alpine.LNX.2.21.1.2001170929550.255@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1.2001170929550.255@nippy.intranet>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 10:21:26AM +1100, Finn Thain wrote:
>
>On Thu, 16 Jan 2020, Sasha Levin wrote:
>
>> From: Finn Thain <fthain@telegraphics.com.au>
>>
>> [ Upstream commit 0ca7ce7db771580433bf24454f7a1542bd326078 ]
>>
>
>This commit has been selected for 4.4, 4.9, 4.14 and 4.19. But this commit
>has questionable value without it's parent, commit 1efdd4bd2543 ("m68k:
>Call timer_interrupt() with interrupts disabled").
>
>For all stable branches, I'd prefer you selected both commits or neither,
>because I periodically backport to a branch based on stable/linux-4.14.y.

I've queued up 1efdd4bd2543 for all branches, thanks.

-- 
Thanks,
Sasha
