Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEC3137C53
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 09:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgAKIYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 03:24:08 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35907 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728625AbgAKIYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 03:24:07 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1E08D21FE5;
        Sat, 11 Jan 2020 03:24:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 11 Jan 2020 03:24:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=wgRf/aUZs4exMZpE8de+6bHMYyt
        zq/9Vk0aY8Ywgp80=; b=aYpyl/XTA4G/jea7fmj72zQihrex5JvrLTuwlvOytVv
        iveHVBBNeeSywR6LSZkp8tDVSbVv1Y3z303T6vTT6uf3YNHYnZfWJmwdwcxDXEQv
        YcxjOIG0O5ZSWfOTjOcj7XMSEHP5ssQa37cqMXbubcM4OSIW9m2QTCIg08cnMyMp
        eYFxlRYVifM11qr+Z5lDr0XvY69/bH2IdOmdXSfuATv3XdA3xcveHAq+2pGlWOCW
        4BQauwhs2TRi8rQtoh6JMNz+MquuZJdzTmqkxXN1QYI+4bns79JSLsw67p/9ZYyQ
        NiNU2ojEL+oMg4gHh8PeqxoCwJ7e3ku4WcpDdwKRT5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wgRf/a
        UZs4exMZpE8de+6bHMYytzq/9Vk0aY8Ywgp80=; b=JgeGnJZnruSunGwkxb72dd
        k66am/uanQPN+1F7p3hFM6UdeYwS7/fySju+G2bS56kJ4eOIaRIZbfPxPpMzPqd8
        8Vl2j1Ueq1HbkHF+y2pYnXePseUTU2U1G2dP3/9rcg0DANV2PzHccgLD6i1tt2fX
        MxnB6u3PhpPSfKBEfWJ1fRhkdDLGVRJ0ljSLR5woMFYdBta39SzYKNJ/Himg9iCk
        cX9ipdQjttC4yQWD9xkbMD/rztOmHeX72EO6wBy4wIfX7OrV7dREz7XukeRGSapt
        WW9tUPHVkHNrJnNBl5q4Mzi3UcGruQiQgNfcL/8RTh/owtLNQXuAcSqypkX3dEpQ
        ==
X-ME-Sender: <xms:JoYZXt_WNkYGbh_sZyRE9vW5Xga_9W3FHl8_LVb4NggfDSfTd9OOfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeigedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeeivddrudduledrudeiie
    drleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:J4YZXo9D02MYLXnEVOSqoFIelNuWNg2hvWBPHTKfijIyXpBS_581RQ>
    <xmx:J4YZXqgC2sXnve-Ab6PTwySOSBr0ZQbN_A1_uCPUfp8OKEZ1HcvdVA>
    <xmx:J4YZXqmZd0vPZ7zOuiHaWcFKwjZF7ZHo5wa1BZInx34bagBc_w4x_w>
    <xmx:J4YZXp3I0TpUDZ6dfFBxXxu1af3niiF-X8OE49ML82JehYWkPzrQ5A>
Received: from localhost (unknown [62.119.166.9])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5086E80060;
        Sat, 11 Jan 2020 03:24:06 -0500 (EST)
Date:   Sat, 11 Jan 2020 09:19:09 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200111081909.GB39772@kroah.com>
References: <20200110.163316.2257822100900159460.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110.163316.2257822100900159460.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 10, 2020 at 04:33:16PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19
> and v5.4 -stable, respectively.

All now queued up, thanks!

greg k-h
