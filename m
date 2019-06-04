Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DA93412D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfFDIHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:07:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34459 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbfFDIHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:07:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 708AC222BD;
        Tue,  4 Jun 2019 04:07:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 04:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=qZ4b9k7ZZ86pktm8nNepPSPCVrh
        +WAFXDzmofnE1s6c=; b=JjwFDusnlK3BMebunvaS/zmwWkiSPNlQvj+dIgyzLnc
        W5D+uW5qdr0+Hyv7UeMJt6dSZ1tdgnrK8hWZftqa/0NVALo0i6yOOWgf2GbciR4M
        PYtbFB2wzl5qt/WG6suLHNN9yQNezNZMWOoqTxDiQBO601/Z0Udv7Qid+eLHF9V7
        uGH41EKWPvzeWhKsiIGA4fEimK8Aje+cvMfPGEMFYprhmA+9uG1y+AuxerauqN4v
        j4A0lOuuy2m2Mgyeb0F/GKICggglfSDcfkFdMneUHOylSEZtNlZVBaxVm6lnPY6W
        tpIRAWyoN6YEuYaKwReYYKEuCC72CDGKjH24oZfGtQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qZ4b9k
        7ZZ86pktm8nNepPSPCVrh+WAFXDzmofnE1s6c=; b=xMEzi9dgLocVELFVcY1ebz
        1o6gesrIdXKqQhTajLyJUnTbFaTHR2HCwIRa87ZOF0TEALelKTvBq3UtUKheeeS+
        JELoWkyHi+jJTEgKwiQ+uWGa6oCBQZjXcjtkjsHmSGnROgm6VheIB/kxYxDB6s/1
        HaEswq1U5JzlXrotWj/XV4yfcOqc3PZlvddTTfmnyaWyDOYravTPJDtj29MWa2c+
        nZ4ou2IqDJi8c6djXSreFXXcdI0vqVEmhJ+wCLDs0BUpm0OdVGSvCOjRXzYhkokK
        8NsQ4If4jqyxDHIt/KXl6nXXOJ5ew6FbklWwdZYb64ZEJNa13jl1kEXheQchRxoA
        ==
X-ME-Sender: <xms:ySb2XLavjAZTci_T07hOt0LZNzlOVbRCAbhtOfV3BQc8zbRVZYBE0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefkedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ySb2XBYNLS-wMQLa51yQGkpaTWKlcyM5GsUErSpHFVvtDyJwn6B6YQ>
    <xmx:ySb2XKCQzm9QOsQCnpRb_zpo1hVv6Q5Ac586MgkFkO4msQ8_HVYitg>
    <xmx:ySb2XJi65vmzjTMSXD5RhvAAclcn-KLbt-iWw7UffoCaXxrb2Faqqw>
    <xmx:yib2XGnJnqVXe7kBJdftPRTWztU9b7cdhPAWw1bnuqN26F55zUog4w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 58B1138008F;
        Tue,  4 Jun 2019 04:07:37 -0400 (EDT)
Date:   Tue, 4 Jun 2019 10:07:34 +0200
From:   Greg KH <greg@kroah.com>
To:     Piotr Figiel <p.figiel@camlintechnologies.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Subject: Re: Patch "brcmfmac: fix Oops when bringing up interface during USB
 disconnect" has been added to the 4.19-stable tree
Message-ID: <20190604080734.GF6840@kroah.com>
References: <20190529235228.38C9E2054F@mail.kernel.org>
 <20190530054518.GA31931@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530054518.GA31931@phoenix>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 05:45:22AM +0000, Piotr Figiel wrote:
> Hi Sasha,
> 
> On Wed, May 29, 2019 at 07:52:27PM -0400, Sasha Levin wrote:
> >     brcmfmac: fix Oops when bringing up interface during USB disconnect
> 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> I see you taken the brcmfmac fixes to stable, if I recall correctly the
> following commit was also pretty relevant and I don't think it was picked-up.
> It's in the upstream:
> 
> commit 5cdb0ef6144f47440850553579aa923c20a63f23
> Author: Piotr Figiel <p.figiel@camlintechnologies.com>
> Date:   Mon Mar 4 15:42:52 2019 +0000
> 
>     brcmfmac: fix NULL pointer derefence during USB disconnect
> 
> Maybe you could consider also taking this.

Now queued up, thanks.

greg k-h
