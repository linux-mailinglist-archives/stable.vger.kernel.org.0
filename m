Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1172D33C82B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 22:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhCOVGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 17:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229746AbhCOVGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 17:06:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BB8064E99;
        Mon, 15 Mar 2021 21:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615842377;
        bh=Gh3bCfJLOnCQytiwwVzryrz8z/8CPerrsKfGDmGTEqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GSkpFdT5WVMerCRPnBlqQbH5QPMv1pdGrc30jHS6bVFJH316NLDxiVEjmKexEeBzz
         d9Bz37BBg9y618s+CGNuLfeuNf+1dApTAogOrMWa1o18q1TqtRcosPeIZ3e6IGw59J
         j5IUWHj8riT0K9a1W//lJ8nJvoEYLlWfbe3/eV69FCor/GnVaZ6ZCT30K8k+xcV1dJ
         0b0rjvPdXW+f4hXS1RQJrqpZIrG7O+HQ1BP+xhRZ+DW7umiQt3pa6ipLrCyRsE303d
         XqRdDN/Swt7ZWpKSuXSBliqXJ3poQptigzR+qV8PjRtO/VdNc46gJDkHiM6iRNJSWz
         EiwD09NzwzFlA==
Date:   Mon, 15 Mar 2021 17:06:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: Re: [PATCH 5.10 113/290] net: dsa: implement a central TX
 reallocation procedure
Message-ID: <YE/MSHkyR0PXSUox@sashalap>
References: <20210315135541.921894249@linuxfoundation.org>
 <20210315135545.737069480@linuxfoundation.org>
 <20210315195601.auhfy5uafjafgczs@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210315195601.auhfy5uafjafgczs@skbuf>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 07:56:02PM +0000, Vladimir Oltean wrote:
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers only
>> Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>For context, Sasha explains here:
>https://www.spinics.net/lists/stable-commits/msg190151.html
>(the conversation is somewhat truncated, unfortunately, because
>stable-commits@vger.kernel.org ate my replies)
>that 13 patches were backported to get the unrelated commit 9200f515c41f
>("net: dsa: tag_mtk: fix 802.1ad VLAN egress") to apply cleanly with git-am.
>
>I am not strictly against this, even though I would have liked to know
>that the maintainers were explicitly informed about it.
>
>Greg, could you make your stable backporting emails include the output
>of ./get_maintainer.pl into the list of recipients? Thanks.

Did it not happen here? I've looked at Greg's script[1] and it seemed to
me like it does go through get_maintainer.pl.


[1] https://github.com/gregkh/gregkh-linux/blob/master/scripts/generate_cc_list

-- 
Thanks,
Sasha
