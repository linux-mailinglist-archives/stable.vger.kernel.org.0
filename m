Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6041199F
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 15:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfEBNAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 09:00:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBNAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 09:00:16 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EB5B20449;
        Thu,  2 May 2019 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556802015;
        bh=AB8PxNisNU5ClJBfJqv7NcYp3vkyF+A18H85xfGkbro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aJSMVLh7p0l71cF2ADm3uI+py6eXbn9SQKZrMTXznbeHGZkuboKq9HzSaEC6DoAGp
         bY5VNnLEEIwjQNCrdTyfbbx3FcrHgiG4M7tN1qsWetRqu7VIvyl32Re90KD2zP1E7w
         K65E6mE7CEHw7Bfjc70M4gW2knlh62VVk1M0YZb4=
Date:   Thu, 2 May 2019 08:53:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@st.com>
Subject: Re: [PATCH AUTOSEL 5.0 70/98] tty: fix NULL pointer issue when
 tty_port ops is not set
Message-ID: <20190502125327.GD11584@sasha-vm>
References: <20190422194205.10404-1-sashal@kernel.org>
 <20190422194205.10404-70-sashal@kernel.org>
 <20190422204002.GA5474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190422204002.GA5474@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 22, 2019 at 10:40:02PM +0200, Greg Kroah-Hartman wrote:
>On Mon, Apr 22, 2019 at 03:41:37PM -0400, Sasha Levin wrote:
>> From: Fabien Dessenne <fabien.dessenne@st.com>
>>
>> [ Upstream commit f4e68d58cf2b20a581759bbc7228052534652673 ]
>>
>> Unlike 'client_ops' which is initialized to 'default_client_ops', the
>> port operations 'ops' may be left to NULL.
>> Check the 'ops' value before checking the 'ops->x' value.
>>
>> Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
>> ---
>>  drivers/tty/tty_port.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>
>Nope, I have a revert for this in my tree for 5.2-rc1, no need for this
>in any stable tree, it doesn't do anything :)
>
>Please drop it from all branches, thanks.

Dropped from my queue, thanks!

--
Thanks,
Sasha
