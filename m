Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3FA141FAA
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 19:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgASSxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 13:53:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgASSxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 13:53:30 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D77320679;
        Sun, 19 Jan 2020 18:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579460010;
        bh=g54lcafQeBdaVWsOI3myQqqk/Q/dyMCJvoQVweioQYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K59+gbrCvo80P5lh+L+HzZx6lMzWdgL9bwQfeVkxUve5sf755LE2qy4/JW7dziCXU
         nWWmGD3NlxIo7aSACCHlaMWqTYN5NREU6vjyursXawhR3gX9VHf81pGCtujcrSsWIe
         Yeyu1perivdP+zG6zQMKtCufyYPPZ0WtSdED72XU=
Date:   Sun, 19 Jan 2020 13:53:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: serial: keyspan: handle unbound
 ports" failed to apply to 4.9-stable tree
Message-ID: <20200119185326.GW1706@sasha-vm>
References: <157944127621242@kroah.com>
 <20200119154733.GR1706@sasha-vm>
 <20200119160136.GB2301@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200119160136.GB2301@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 05:01:36PM +0100, Johan Hovold wrote:
>On Sun, Jan 19, 2020 at 10:47:33AM -0500, Sasha Levin wrote:
>> On Sun, Jan 19, 2020 at 02:41:16PM +0100, gregkh@linuxfoundation.org wrote:
>> >
>> >The patch below does not apply to the 4.9-stable tree.
>> >If someone wants it applied there, or to any other stable or longterm
>> >tree, then please email the backport, including the original git commit
>> >id to <stable@vger.kernel.org>.
>> >
>> >thanks,
>> >
>> >greg k-h
>> >
>> >------------------ original commit in Linus's tree ------------------
>> >
>> >From 3018dd3fa114b13261e9599ddb5656ef97a1fa17 Mon Sep 17 00:00:00 2001
>> >From: Johan Hovold <johan@kernel.org>
>> >Date: Fri, 17 Jan 2020 10:50:25 +0100
>> >Subject: [PATCH] USB: serial: keyspan: handle unbound ports
>> >
>> >Check for NULL port data in the control URB completion handlers to avoid
>> >dereferencing a NULL pointer in the unlikely case where a port device
>> >isn't bound to a driver (e.g. after an allocation failure on port
>> >probe()).
>> >
>> >Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
>> >Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> >Cc: stable <stable@vger.kernel.org>
>> >Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >Signed-off-by: Johan Hovold <johan@kernel.org>
>>
>> Grabbing the prerequisite for the other USB patch also resolved the
>> conflict here, now queued for 4.9 and 4.4.
>
>Just curious; which prerequisite are referring to here? I can't seem to
>understand why this one failed to apply to 4.9 in the first place as
>there hasn't really been any changes to that code in the keyspan driver.

I thought that it was either dd1fae527612 ("USB: serial: io_edgeport:
use irqsave() in USB's complete callback") or the stable commit that was
applied on top, but you're right -  it doesn't seem to be either of
those.

-- 
Thanks,
Sasha
