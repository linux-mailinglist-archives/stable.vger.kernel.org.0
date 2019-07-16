Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59006A4A2
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 11:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbfGPJL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 05:11:28 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55311 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731581AbfGPJL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 05:11:27 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 87A1D21B34;
        Tue, 16 Jul 2019 05:11:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 16 Jul 2019 05:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=UjMps8MU4/beAaL+NB+ownWlCK/
        mjUB6hBL3P7T9Mxc=; b=OT/BWOlVQOSURtyitLAmU1oCnUR0ijH/+kLr8MXkcmE
        WoP3GxJfaNtq9yVPUymNowgxWcnFHM4AEaKDYmk4K256OscC1mO5l9kvHTssoPg1
        1QX3eQLynDJxK8fgxcknYBDLnw4H6T5RHliSrNmcCv+EL75ZJHp36qHlZ0rEWH6S
        mFAPhwX3ApB0RyFtKVh2ACrMUTwbpkYLcezi/M+L7Xb8GTULt7vIEZBLoXt5OKFY
        eA5nETy8flW0RV66YrQfi83kzcNbinBHsSk/JnPXCTePQeD7J8zL4T76FUN2A6py
        xLP8qWEMfs4vgMK4IAvQTS4hLbpGgLPzR6yaaO4fi0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UjMps8
        MU4/beAaL+NB+ownWlCK/mjUB6hBL3P7T9Mxc=; b=M7EB3P7y10nVbvo1O/XJHP
        rJW6FEDvu7zV1FNaefhEUmJM+VwnVcchLYa6BrZuopMGbuortJMZ8HQJ/YCXqaRu
        tb/xAOp9l3l6n3doaiNQtMc5C3E96Si7XPiTsQzQNLupy8alRazQ9mEw2DxLJZOY
        hui4kNqwKZZNCX6ADcB7fwrPmsIwZN09U12i+4uO6dX5tEUn2fdnOA64T5tetZDw
        N1U4F4NBxS9BX4iNT6RMWrPF98R8hsmyoGbQ6kOu6Xg7wzfEcIH7eGEP2t9Psm98
        n73NoJEbpeSPIR6zD/vBKoWm/QU31BulwfWqn56o12Xj234pokNuh70GavitvwgQ
        ==
X-ME-Sender: <xms:vZQtXbDaEbq4LvqzjlWdPfrHXMmKYW8lhDay_HwDQIVxYvj5zqxYcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddriedtgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeduudefrdduheejrddvudejrdehtdenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:vZQtXVwyeR_OL16WuxnwyczFJXWLJv43ABOFUuOl8oHkeW1xMOm9jg>
    <xmx:vZQtXRkGVECz2Aq8EUCGpQp6QC9ZirQjRREOO2NjKEDvzvt9bMfXcg>
    <xmx:vZQtXSEYTD3_CpGWsmi2_vZrVlZMpFoPb3qUpXZJ0aS7cOwuAsu4bg>
    <xmx:vpQtXfSB42osp-YKdrAz6iIb3yUONBcVHVNnSQV6bDQJF8gurtA_cQ>
Received: from localhost (unknown [113.157.217.50])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4F73380084;
        Tue, 16 Jul 2019 05:11:24 -0400 (EDT)
Date:   Tue, 16 Jul 2019 18:11:22 +0900
From:   Greg KH <greg@kroah.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Cyril Brulebois <cyril@debamax.com>, stable@vger.kernel.org,
        charles.fendt@me.com
Subject: Re: [PATCH 1/3] ARM: dts: add Raspberry Pi Compute Module 3 and IO
 board
Message-ID: <20190716091122.GB11964@kroah.com>
References: <20190715140112.6180-1-cyril@debamax.com>
 <20190715140112.6180-2-cyril@debamax.com>
 <860468a1-df13-cb6a-6951-455cf72ad4a0@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <860468a1-df13-cb6a-6951-455cf72ad4a0@i2se.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 05:26:16PM +0200, Stefan Wahren wrote:
> Hi Cyril,
> 
> On 15.07.19 16:01, Cyril Brulebois wrote:
> > From: Stefan Wahren <stefan.wahren@i2se.com>
> >
> > commit a54fe8a6cf66828499b121c3c39c194b43b8ed94 upstream.
> >
> > The Raspberry Pi Compute Module 3 (CM3) and the Raspberry Pi
> > Compute Module 3 Lite (CM3L) are SoMs which contains a BCM2837 processor,
> > 1 GB RAM and a GPIO expander. The CM3 has a 4 GB eMMC, but on the CM3L
> > the eMMC is unpopulated and it's up to the user to connect their
> > own SD/MMC device. The dtsi file is designed to work for both modules.
> > There is also a matching carrier board which is called
> > Compute Module IO Board V3.
> 
> this patch series doesn't apply to the stable kernel rules.

I'm with Stefan.  Cyril, how do you think this matches up with what:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
says?

thanks,

greg k-h
