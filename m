Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 924E8F0AEB
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 01:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfKFALE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 19:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbfKFALE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 19:11:04 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95474214D8;
        Wed,  6 Nov 2019 00:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572999063;
        bh=pwG035XBTNJljG7dGDhIzaTt2nzJPF29wevhqOQlZ5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WLmSFSxTBbrsuzrG/1i4DH02eHKStX8CKvyUXvCAKNTl1rxI7lJYIpkSPhOUsLzmq
         2s8EImcyWznJmmKYjNvObX22jcZVVelqAN5Ap2sBhzfEVOYI2OJSmmXPuu5SbwVdwp
         HhCWFHyX8jWR3CW61n7RCemcpf49TexTp+tv89Nc=
Date:   Tue, 5 Nov 2019 19:11:02 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.9 37/62] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
Message-ID: <20191106001102.GI4787@sasha-vm>
References: <20191104211901.387893698@linuxfoundation.org>
 <20191104211940.713506931@linuxfoundation.org>
 <1572964268.2921.19.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1572964268.2921.19.camel@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 03:31:08PM +0100, Oliver Neukum wrote:
>Am Montag, den 04.11.2019, 22:44 +0100 schrieb Greg Kroah-Hartman:
>>         All the host controllers capable of SuperSpeed operation can
>>         handle fully general SG;
>>
>>         Since commit ea44d190764b ("usbip: Implement SG support to
>>         vhci-hcd and stub driver") was merged, the USB/IP driver can
>>         also handle SG.
>
>Not in 4.9.x. AFAICT the same story as 4.4.x
>The patch is not strictly needed, but breaks UAS over usbip.

It's in 4.9 since April this year... Same story for 4.4.

-- 
Thanks,
Sasha
