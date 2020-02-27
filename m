Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A14A171411
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgB0JVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:21:47 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60633 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728614AbgB0JVr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:21:47 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id DDB4D634;
        Thu, 27 Feb 2020 04:21:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=6
        LYEYj/FVbzGUs8yDEBIBgZBLVaR/NpIUgdqhUtefjw=; b=OpIzUx6kEUxDx7eHP
        i2h73sXrxqrsnshYXBUCxq4Jd3Tpp6rCdKLiJ99CWzHieU4KwhRDao+awFWu2Ifg
        Vn3rFRlM9JRNckGRbpiztGJv39ClJIyUfnEpN9z9NKzVOOgvJeQjcUTGQQWEQJ/r
        RM7cbogsGKqQFH6LXhi0c1qVA1u2q9WsBw6noqey0P4vS1Ec4QxcZMEt3npgG/+4
        WAtfeRGSsRTiwXSJ0s0oUI+UMXd8wJ4Pb0PpKqUjblWcAmatJCo9xZ1diLSGagMK
        PzSvuEIzQVKh6e0xfe/1swRniXOmV1KO/VRlGuhKKia7+FOC8W0FYPdPhZlVOFxV
        Z9CbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=6LYEYj/FVbzGUs8yDEBIBgZBLVaR/NpIUgdqhUtef
        jw=; b=ot09DhDhvcVnrWy4XbNrfBb5SttpnxSp8lL1qjPhLYzOjKxJyI0F2X67N
        WDQp0zFsCj+zR2c2y7sXceYOqsNMqXGon6mLWwZfwhYsQon67dVpQrk000aw9c9d
        NYLzdcAOjJa7oZJjwZX8fM8Hgse6BlZJz4hpiD3caU9MYy1P1CYRFMUWy37T/zMz
        ejDpujL0EujOSSOrR0TW7lHJjqR88/GJlJ8ljcpeEwIZHMz4icblct4nVJ7h/mcz
        ylDukq5Z8R5DmSXTrRsBg5/wHK+KLjjZt5KTCCiE8kjn2OFPUYvma7c1FBHN+sCu
        MYwiG5DMWt0x0u90Aw4JyKToVVfjQ==
X-ME-Sender: <xms:KIpXXkfpJvlSCOVac87zHim9WzsjuX5YgfkOzXRSnwbA0ax0f51E-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KIpXXnc59SVKuu9aEPTiVsVCy-5NczG8Pnc2FlTdmqcsLSrITbq-YA>
    <xmx:KIpXXt9lhil00DZr_z71Lmv2s9mkKbmGPwgEPs7EYkUDcS8_E-Bz1A>
    <xmx:KIpXXgLLxAtltqq60Rj0DOBdVQE9vZecC1mSDOETyPYtW3O1kkhGFQ>
    <xmx:KYpXXpdYjriQuIpC3nH8EWdVnvQZf5iuAhvWxf7qQy4J8Tmudiw_kA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A44293060FD3;
        Thu, 27 Feb 2020 04:21:44 -0500 (EST)
Date:   Thu, 27 Feb 2020 10:21:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: 5.4-stable request: 52e29e331070cd ('btrfs: don't set
 path->leave_spinning for truncate')
Message-ID: <20200227092142.GA520306@kroah.com>
References: <e56ac6c0-2bae-62a1-a22d-d7374a98ab43@applied-asynchrony.com>
 <20200218161426.GM1734@sasha-vm>
 <b7e8d6da-087a-b7e4-7be2-8a9a6ef1e9a1@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7e8d6da-087a-b7e4-7be2-8a9a6ef1e9a1@applied-asynchrony.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 04:12:24PM +0100, Holger Hoffstätte wrote:
> 
> Hi Sasha,
> 
> On 2/18/20 5:14 PM, Sasha Levin wrote:
> > On Tue, Feb 18, 2020 at 01:01:40PM +0100, Holger Hoffstätte wrote:
> > > Hi,
> > > 
> > > I was just looking throught the current 5.4-stable queue and saw that
> > > 28553fa992cb28 ('Btrfs: fix race between shrinking truncate and fiemap')
> > > is queued. Upstream has a follow-up fix for this: 52e29e331070cd aka
> > > 'btrfs: don't set path->leave_spinning for truncate'.
> > > 
> > > Would be nice to get those in together. I only looked at 5.4, don't
> > > know about other queues.
> > 
> > Since that fix just hit upstream, I'm going to remove 28553fa992cb28
> > from the queue now and work on getting both patches in the next release.
> 
> Thanks, but maybe wait until [1] has also hit mainline? It's another fix
> for 28553fa992cb28.
> 
> thanks,
> Holger
> 
> [1] https://patchwork.kernel.org/patch/11394171/

Ok, I think I have this all now queued up properly for 5.4.y and 5.5.y,
but older kernels will need backports.  Can someone send those series of
patches to stable@vger.kernel.org if it is needed in older kernels like
the commit says they are needed?

thanks,

greg k-h
