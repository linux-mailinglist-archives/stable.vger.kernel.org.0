Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0A89BE89
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 17:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfHXPdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 11:33:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45505 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727440AbfHXPdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Aug 2019 11:33:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 902E92148D;
        Sat, 24 Aug 2019 11:33:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 24 Aug 2019 11:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=WiYOyVIiMwqhzO9eWUtNV9AIwtH
        ZGm7B1tlKGhsX/Fg=; b=JdvjUl5hDSAdr74HnyB3LL2szfbdmZrDQ7vsDXtLL3j
        ZZf7id6oCWezzsCvcfwFH0WppnGtpJfmI3CHX130gwXwceOTlHQBG3nuEbtqDS1r
        OU+V6lcWKXGA/YxTF/6xXUsY/3NQR+quRbBPn5p+O1UthLGmSQnSU3U1ktRoOwfB
        tr104YchZP9QQKHXt/0kGrbfmCy6Xb4CkSXWbFmrK5iake2rWaE/NZX1jLSQZkP5
        3b6H75nStu8EtI6jLFMGUS50xesoDF/SsX+XWnakVlZEWjki/ZGmMCKV2jTn+zEC
        aexEoNlTjF/nOshbe6wACPHmPikdkXH6ujtj255gSvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WiYOyV
        IiMwqhzO9eWUtNV9AIwtHZGm7B1tlKGhsX/Fg=; b=BhA60vGqdUO6rpSKxZVDJS
        GX04MVxNqm1bf/cAc0jkBVY8QQzkH7T5gm3IgUSCLE8FRyPA7lNmrOfVg6p5v74D
        FaIcyqC+9Qrg/jlWNW5Qxhx71pMZ/vFMN4AkMw5Vc2pZBFYBiLzXd8GTXb5FI6Qi
        eIPEhxcDkttFNFuLkpQRF40tw0h2iXa0QMalg8k7GFHnMppcdfh9H6o5G4djxEiB
        FagRX9gyoSo8MrQICznnAyTs4r3njYQJjL762N6MWJM2u6/qpXf0vVhmxlAKRUiZ
        smr3e86P4pto9bYIr7SvZaYSBkYdICnMK5CHfzVqIw1/j/Use3EPpjBci6g35m2w
        ==
X-ME-Sender: <xms:31hhXUKYkCfkPLKbkxdkQd7As2rsxhTlc6l3-lp6VY8xNav-ZBNbjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehtddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeelrddvtdehrddufeegrdekgeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:31hhXTKBvdo41qQlKjzWixYHG0HrTvD8eHsZeZY4Tc0iJhiekvXFNw>
    <xmx:31hhXc-FgQpDqkHHR86H3myXBVKqE-5Y2NQWszs0sjITsxZ7PfcdGw>
    <xmx:31hhXdwIpNnEz8y2G4EeuYoU5IyGDl_AmuMp-uZP7t1BzS1v83ub9w>
    <xmx:31hhXfUPZE7cBhlTWvcse7RZLMJx4YdiWq6wYX2AA7CAYfbLDuv8YQ>
Received: from localhost (unknown [89.205.134.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id B50E7D60057;
        Sat, 24 Aug 2019 11:33:50 -0400 (EDT)
Date:   Sat, 24 Aug 2019 17:33:48 +0200
From:   Greg KH <greg@kroah.com>
To:     shuah <shuah@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190824153348.GA27505@kroah.com>
References: <20190822170811.13303-1-sashal@kernel.org>
 <00216731-a088-7d47-eafb-70409f876bda@kernel.org>
 <20190824023829.GE9862@kroah.com>
 <e4d5ba59-8e38-a267-8a14-3c6bc03f77bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4d5ba59-8e38-a267-8a14-3c6bc03f77bd@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 24, 2019 at 09:21:53AM -0600, shuah wrote:
> On 8/23/19 8:38 PM, Greg KH wrote:
> > On Fri, Aug 23, 2019 at 12:41:03PM -0600, shuah wrote:
> > > On 8/22/19 11:05 AM, Sasha Levin wrote:
> > > > 
> > > > This is the start of the stable review cycle for the 5.2.10 release.
> > > > There are 135 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat 24 Aug 2019 05:07:10 PM UTC.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >           https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.10-rc1.gz
> > > 
> > > I am seeing "Sorry I can't find your kernels". Is this posted?
> > 
> > Ah, Sasha didn't generate the patch but it was still listed here, oops.
> > He copied my format and we didn't notice this, sorry about that.
> > 
> > As the thread shows, we didn't generate this file this time to see what
> > would happen.  If your test process requires it, we can generate it as I
> > don't want to break it.
> > 
> 
> It will make it lot easier for me to have continued support for patch
> generation. My scripts do "wget" to pull the patch and apply.

Ok, we will get this back and working, sorry about that.

greg k-h
