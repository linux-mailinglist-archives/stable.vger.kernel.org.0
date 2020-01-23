Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E67146B26
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 15:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgAWOWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 09:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgAWOWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 09:22:54 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3613E20663;
        Thu, 23 Jan 2020 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579789373;
        bh=0CWnS0mRk0JiZEylkp7dGV3u+VibJKmoYuNpjW1icQE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MtYUxOHPLLcfVZY2mgybA2pObRKfRFB+tzMwLkJL5ecLVPWkvIby2UCqJY4rqQmtA
         /iMBTgMNWP9jjRTP12SGza1tcQvigD0441/RS3xJlOYX1nEttGQrQm70c1pTsxRUsl
         Lmao6F5hUlFYkFnmD6a+nRw8qDQ2r6MTLbqBIthM=
Date:   Thu, 23 Jan 2020 09:22:52 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 592/671] USB: usb-skeleton: fix
 use-after-free after driver unbind
Message-ID: <20200123142252.GE1706@sasha-vm>
References: <20200116170509.12787-1-sashal@kernel.org>
 <20200116170509.12787-329-sashal@kernel.org>
 <20200117102116.GS2301@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200117102116.GS2301@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 11:21:16AM +0100, Johan Hovold wrote:
>On Thu, Jan 16, 2020 at 12:03:50PM -0500, Sasha Levin wrote:
>> From: Johan Hovold <johan@kernel.org>
>>
>> [ Upstream commit 6353001852776e7eeaab4da78922d4c6f2b076af ]
>>
>> The driver failed to stop its read URB on disconnect, something which
>> could lead to a use-after-free in the completion handler after driver
>> unbind in case the character device has been closed.
>>
>> Fixes: e7389cc9a7ff ("USB: skel_read really sucks royally")
>> Signed-off-by: Johan Hovold <johan@kernel.org>
>> Link: https://lore.kernel.org/r/20191009170944.30057-3-johan@kernel.org
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This one isn't needed in any stable tree. As we discussed before, the
>skeleton driver is only there for documentation purposes.

I'll drop this, but I'm curious: doesn't this mean that users will build
on buggy example code?

-- 
Thanks,
Sasha
