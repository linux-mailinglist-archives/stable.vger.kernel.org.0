Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCFA12E16F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 02:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbgABBON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 20:14:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727497AbgABBON (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 20:14:13 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD21208C3;
        Thu,  2 Jan 2020 01:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577927653;
        bh=CvpLcb9a6+ZDcSlIAaIddjipQZnklXgZnw/0wNfKV/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pvjnbMfcQth8R/Ep644niUB4WteLA5xy42kPv2sYIsyrLhwTJubZXGNkGQ3ubBfBI
         U6MkWc2/U9US3oMOa916Og1n/YHHgDgtmJNsRxKhcb697D36fMaHstDs3fSS/jQya8
         vtQz6REaPrZABqqgLXH/DmR8Re68XxOTDWMri2nY=
Date:   Wed, 1 Jan 2020 20:14:11 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     gregkh@linuxfoundation.org, jschoenh@amazon.de,
        Yazen.Ghannam@amd.com, hpa@zytor.com, linux-edac@vger.kernel.org,
        mingo@kernel.org, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, x86@kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/mce: Fix possibly incorrect severity
 calculation on AMD" failed to apply to 4.19-stable tree
Message-ID: <20200102011411.GF16372@sasha-vm>
References: <157763491612458@kroah.com>
 <20191230155621.GA30811@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191230155621.GA30811@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 04:56:21PM +0100, Borislav Petkov wrote:
>On Sun, Dec 29, 2019 at 04:55:16PM +0100, gregkh@linuxfoundation.org wrote:
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>
>Here's a backport for all 4.x stable series. It only needed a
>file-rename.

This ended up getting picked up by AUTOSEL which did the right thing
with regards to filename changes as confirmed with the provided
backport, thank you :)

-- 
Thanks,
Sasha
