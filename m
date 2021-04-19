Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7F0364622
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 16:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbhDSObw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 10:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhDSObw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 10:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FE59611CE;
        Mon, 19 Apr 2021 14:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618842680;
        bh=ohDXpAlegv1BKE8F31+1OlpLGktvndibPJVQ6pEos2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VZQcRmZCNwueusZ4m6Gn7CrKK7ImPG8ag8B0t0TxZL4sTeF5DWTwhE5YczwRu6Ufn
         nGip+RnMn/9WTVkaYv9jhtl9zQQ3ciXEsWDeuYpVARxqeTiw35Ychf2AhdVGpHmgy7
         eZcKvANtlvpptr65PpNtplxOhpEqCRWqTzdqNlOd4MMh+qKLueSQebvnjfvRpeMZK2
         B7opL+gmjvMjdG3xQQwGSGH+kSxWcU/rnfx0FVVrijiJvQLIkcO+FfO8MPUHzI5QJQ
         kFFiynvUWwkHW0ndzbqEDHfyE0JbUQsq/NvawoacJrbLEFD/OGUdTs6b68hfuPI3Ho
         99fFDkmD2JwNA==
Date:   Mon, 19 Apr 2021 10:31:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        stable@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        kabel@kernel.org
Subject: Re: [PATCH] net: phy: marvell: fix detection of PHY on Topaz switches
Message-ID: <YH2UN0zBc0Oeykkj@sashalap>
References: <16187482432842@kroah.com>
 <161874858144103@kroah.com>
 <20210418131344.21024-1-pali@kernel.org>
 <YH1x/qt8wpOh0bvj@kroah.com>
 <20210419120856.xtym4nhplgwrtoot@pali>
 <YH15B/ZwuXg4R9lw@kroah.com>
 <20210419124711.h55orlwpgjizjmuf@pali>
 <YH1+FoK4eScCnIAq@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YH1+FoK4eScCnIAq@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 02:56:54PM +0200, Greg KH wrote:
>On Mon, Apr 19, 2021 at 02:47:11PM +0200, Pali Rohár wrote:
>> Ok! I will prepare it, no problem. I just did not know that it failed
>> also for 5.10 as I have not received any email about it.
>
>Odd, I must have forgotten to add that version to the command line
>script I run to tell people that a patch failed, sorry about that.

Not sure what happened, but there are 2 "FAILED" mails for 5.4, one of
them must have been for 5.10 :)

-- 
Thanks,
Sasha
