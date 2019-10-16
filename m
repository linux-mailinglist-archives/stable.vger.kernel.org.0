Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5EDD9926
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 20:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390941AbfJPS3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 14:29:17 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37557 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390895AbfJPS3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 14:29:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E9A9A22015;
        Wed, 16 Oct 2019 14:29:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 16 Oct 2019 14:29:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=/dPJeN3qcd2821F5+ryjhEQ1Ltw
        rJQFaMJ/wU2vJmIs=; b=PzgU36oUlBb4KB3xuQq0NPnGKfdI3xljI/gFaLhlnRm
        JGHcanu1NPwMN4EgYgrPZmeD28f1vj1fw59A9mVpw38ZqZ/ks5z9Um7SHypC4PX/
        mwrHmssuvPFklRUvY8nEoHB2GwE6FZJNrVhtrdPAKRfN39eJJuaH84Y5iyCbUzg7
        QM+DMaSrW4g1uo2QJw0Ao9ybBEwbcSq3ROvu1MbX8qItKCTIhvS9SeFSJKAR58HO
        kfqTlPL4XOwsiC4/sTTpKi2+rSiML8RGehXhlhoCKTAT7OwFed1llszOFdxe7loU
        gmqVbSyRkbGGcgwonA4U4asHux3YqIVmigav80yyZDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/dPJeN
        3qcd2821F5+ryjhEQ1LtwrJQFaMJ/wU2vJmIs=; b=pPhvH9l/my5VrEbOTNLLzz
        8UsDA4TcYnekfiY214sfRt1BN472KA/2o0rdaZ3Lw5EWLEAhwXJEnVK28W9A2WfM
        7634w5IgZW37cAhpGc2IbyUD2WqcSJ7w/MxMzZD7GXXHzwxdnHtrm8Ak4xL1xweI
        a7kjZRg2qXxl/nMQj2t7JdefavEiz93m8WttI5l8Jui8vZ5zhEfjBy5IS43Wl3M7
        5l+2adgeFHPLrugWHwMQlBZbzpFlKV4XwWF/b436ctrklSHoJqWZkQwh8iUQqTJo
        kAOqEh5f9uz3OZXMJ6kEAJAg6vIxHFKqxga2H7VgVFBp2nbH+hcWIBK46j6WwnAw
        ==
X-ME-Sender: <xms:e2GnXYtMw9pIeEp23zP1Kdr8jUjtV6qzhQBpERVOlgnkjj8_xPScjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeehgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppedujedvrddutdegrddvge
    ekrdeggeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:e2GnXW0QKxgyGmS6Sgc5xCg-iVixltoyfjzonTENvGsw_16hoUbxOA>
    <xmx:e2GnXdCrSkFyXcRqJFIBzDurxvxn3ytGGDPivNVNli7DIOpgXOxvSA>
    <xmx:e2GnXTe-3qo9WKltBViJMGX5cIcTkwiukaE1Ck1rmZUZ410uZh1ShQ>
    <xmx:e2GnXf9ldL5sykFup0A2_lRzywdIaB8841KRjbV57-Uq6swZqSJgMQ>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACA6FD6005D;
        Wed, 16 Oct 2019 14:29:14 -0400 (EDT)
Date:   Wed, 16 Oct 2019 11:29:11 -0700
From:   Greg KH <greg@kroah.com>
To:     Sushma Kalakota <sushmax.kalakota@intel.com>
Cc:     stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [BACKPORT v4.19] PCI: vmd: Fix config addressing when using bus
 offsets
Message-ID: <20191016182911.GB801860@kroah.com>
References: <20191015230607.5330-1-sushmax.kalakota@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015230607.5330-1-sushmax.kalakota@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 05:06:07PM -0600, Sushma Kalakota wrote:
> From: Jon Derrick <jonathan.derrick@intel.com>
> 
> commit e3dffa4f6c3612dea337c9c59191bd418afc941b upstream
> 
> This is a backport due to feature dependencies preventing
> the upstream patch from applying cleanly.
> 
> VMD maps child device config spaces to the VMD Config BAR linearly
> regardless of the starting bus offset. Because of this, the config
> address decode must ignore starting bus offsets when mapping the BDF to
> the config space address.
> 
> Fixes: 2a5a9c9a20f9 ("PCI: vmd: Add offset to bus numbers if necessary")
> Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
> Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
> ---
>  drivers/pci/controller/vmd.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

Now queued up.

thanks,

greg k-h
