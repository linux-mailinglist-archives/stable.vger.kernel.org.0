Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B279E33AFB7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 11:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhCOKPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 06:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhCOKO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 06:14:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997EF60249;
        Mon, 15 Mar 2021 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615803296;
        bh=BPipDBmfI+e8E+YVHKc4PDSWDgRpGDEoLSbxTniUXow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jndvdS6Mc2lGaNs7DCiF2nwzKL4uSJHC9CYpqEeiNlfEnvsevR+W33I2R7xoToJsz
         1xMawdTZr9DyM7No6ts3b370oZ6nMrL3TWDejdTYohUWtUknoaInDS8U7DSn+jnFQ2
         YB2CAL1mBp1VZrYxe9D6jedDe0FrpWdZIkgoD9H9Gn8SZ6ljZ4B0GQlENtXtpkwqtj
         QhgtImR5YRfsg6evVhulvWddnTHnXQPEwMfKETp0mpzikBECiDwDfX/AR8jktJluGj
         4V6kKjIccia2dRRxaG6h0Mssrk+3Z3ZcE3O9FJJaDviCbrkwC0oQUmx7kFBrG4VKWP
         F34NTxLCm+6Dg==
Received: by pali.im (Postfix)
        id 3575E828; Mon, 15 Mar 2021 11:14:54 +0100 (CET)
Date:   Mon, 15 Mar 2021 11:14:54 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mvebu + mvebu/dt64 4/4] arm64: dts: marvell: armada-37xx:
 move firmware node to generic dtsi file
Message-ID: <20210315101454.dpyfdwk43poirxlw@pali>
References: <20210308153703.23097-1-kabel@kernel.org>
 <20210308153703.23097-4-kabel@kernel.org>
 <87czw4kath.fsf@BL-laptop>
 <20210312101027.1997ec75@kernel.org>
 <YEt/Ll08M1cwgGR/@lunn.ch>
 <20210312161704.5e575906@kernel.org>
 <YEuOfI5FKLYgdQV+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEuOfI5FKLYgdQV+@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday 12 March 2021 16:53:32 Andrew Lunn wrote:
> > So theoretically the turris-mox-rwtm driver can be renamed into
> > something else and we can add a different compatible in order not to
> > sound so turris-mox specific.
> 
> That would be a good idea. And if possible, try to push the hardware
> random number code upstream in the firmware repos, so everybody gets
> it by default, not just those using your build. Who is responsible for
> upstream? Marvell?
> 
> 	  Andrew

Hello Andrew!

I do not think that renaming driver is the best option. For future it
would complicate backporting patches to stable kernel and also it would
make usage of 'gitk' harder as this tool cannot automatically track file
renames.

I saw that kernel drivers lot of times got support for a new HW but
driver name was not changed (maybe for backward compatibility, maybe to
simplify things).

Andrew, now when you got a full picture of this problem, would you
be willing to accept these patches? Or do you require some changes?
