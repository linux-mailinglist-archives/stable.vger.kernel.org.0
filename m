Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08FB414F92
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 20:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbhIVSH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 14:07:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44121 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236996AbhIVSHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 14:07:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8863F5C00AC;
        Wed, 22 Sep 2021 14:05:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 22 Sep 2021 14:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=tGbWm4Xw1D8aSEwSQLZaY465Fk3
        YPbrFVRZybdsF96k=; b=tmOgGq8OvqH6C1LZmoHr5l2CM4y0H8oatiGSl6dil7W
        DE9S/21RIXCtj7eE5h517h1fgDOFJBldwsAmep5C7gx3/cLW+L3HHT7FoRe3Lmwd
        DuQNJPnoikTOwQBvJGmUyAonjbgXJSwH5HrkEuIFEDQOlPoDZ1UTr9O+SeFwY6ui
        pE5L7tvMyKijsMZl5ZKAjX+xgNLsLiSLM2piMnyIYtOS9CiQHQ0cVHm9isORuODh
        Egz8T1Eo4MgGyvcExxaacwMGVs1j/vD0+PxH/nhai8ClZGj5l47hgQkSiB8A1v23
        Z5NMR8fsvgTyXGVRDeUHCUM3xqj3yoWl4RYWEvmDlsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tGbWm4
        Xw1D8aSEwSQLZaY465Fk3YPbrFVRZybdsF96k=; b=pVTLVfxSKrSQfQJq1xzY+B
        +x+J4jEFhlcpk8rCMH7Y0WnTENOwOsP59Lbqp7850nSQN5c5SANMMNR5CJI/ZM9w
        ZaGurfhJ4AmBftBTXUMWGSO5l2rPfOY6RShWw6kKyXjmpdxh+84x3NrQjPwoXYR7
        XOOus57FLH+A1shWlUgHPqIfOgHUDqKYNPePiVK62WvZGzj9FlZtfvm+zV4LQ26y
        DLNPPWiUZmWF3Ph4RDCpDZUkW/xFkyQrBceqgYSe40fdTjMx8nHXbGj6Bn9On+uT
        pqI2+8G6vYBZLzDGvvgweJFq3f9zb+hGlYedkRomWAKUc/EWo17IRpwGgcyChJHA
        ==
X-ME-Sender: <xms:g3BLYfwPYKqetRrmERPRy8JdOqg34uSbddRSmedwjNdKwDSqu_X0xA>
    <xme:g3BLYXRSiWWdeGLbl2qN9Xasf9WQRt-OAaC6TOcARxcqf2U_q5M9mgAzeDxfbkfRs
    lgYmOEPmVJeYg>
X-ME-Received: <xmr:g3BLYZWr3C25TknY8it3hqf3NEurbkvDuOH4ch5AAk5Kr4tE6WiQGMuK8te6uN8BAiEzYoPVNmhHHMjk9N7PTtWMJEioL7Mg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeijedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepuddtie
    dvjeegudffgfdvhfdtjeeugffhhedvjeehgffgleduuefgfeekgedvlefhnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:g3BLYZhYXHGEQkA9KPUdw9Z6pMdUrlSwqUd9nqE22Vsnj1yLpmMuiw>
    <xmx:g3BLYRANTvTIwZ-gyZ2SlGTRJTk5asXAXkM3bK6rotqbpHJrdmabRw>
    <xmx:g3BLYSKMnpB1NMZxl2g8ET7evvX-hYZdeIiy8prmkDANcsuPT0T_ng>
    <xmx:g3BLYT1sIWxWVMS_mesJaM_nR6Jgmimks6eWaTety6Ha1mwBps75aQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Sep 2021 14:05:54 -0400 (EDT)
Date:   Wed, 22 Sep 2021 20:05:52 +0200
From:   Greg KH <greg@kroah.com>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     stable@vger.kernel.org,
        Tuan Phan <tuanphan@os.amperecomputing.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.4] PCI/ACPI: Add Ampere Altra SOC MCFG quirk
Message-ID: <YUtwgDwgQtOaaXVh@kroah.com>
References: <20210921192038.3024844-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921192038.3024844-1-dann.frazier@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 01:20:38PM -0600, dann frazier wrote:
> From: Tuan Phan <tuanphan@os.amperecomputing.com>
> 
> commit 877c1a5f79c6984bbe3f2924234c08e2f4f1acd5 upstream.
> 
> Ampere Altra SOC supports only 32-bit ECAM reads.  Add an MCFG quirk for
> the platform.
> 
> Link: https://lore.kernel.org/r/1596751055-12316-1-git-send-email-tuanphan@os.amperecomputing.com
> Signed-off-by: Tuan Phan <tuanphan@os.amperecomputing.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> [ dannf: backport drops const qualifier from pci_32b_read_ops for
>   consistency with the other quirks that weren't yet constified in v5.4 ]
> Signed-off-by: dann frazier <dann.frazier@canonical.com>

Now queued up, thanks.

greg k-h
