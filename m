Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2224C1CFE5B
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 21:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgELTco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 15:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgELTcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 15:32:43 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 538CE20731;
        Tue, 12 May 2020 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589311963;
        bh=Kzc0yUceH4b0coQKjmjdqrUBetwLuP/PTERlft3Y9gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qwzmGjAQ9AiUETuBjwPxJ0OZGuyPvquGp7tGRIlgAM7g7+3DdhKDirZvEeekZ1G1v
         i0j8fFBZ3aE4lTOAYRl1iq0+ZGQ7DBcYoGyqIGkA528CllKStKjYMp2+lhDsDXHryo
         EXSgGt8cHVPLsL6cutN8c6rT973c3NeZy+6G6ciU=
Date:   Tue, 12 May 2020 15:32:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.9-stable] Security fixes
Message-ID: <20200512193242.GS13035@sasha-vm>
References: <48426ffc013c1f59df8357ae6f9d5b5ffa5d6812.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <48426ffc013c1f59df8357ae6f9d5b5ffa5d6812.camel@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 07:46:35PM +0100, Ben Hutchings wrote:
>Here are some fixes that required backporting for 4.9.  All of them
>are already present in (or queued for) later stable branches.

I've queued it up, thanks Ben!

-- 
Thanks,
Sasha
