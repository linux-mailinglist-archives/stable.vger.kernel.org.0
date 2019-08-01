Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110F07DD65
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 16:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbfHAOGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 10:06:46 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59327 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731792AbfHAOGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 10:06:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 99EB12E0;
        Thu,  1 Aug 2019 10:06:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 01 Aug 2019 10:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=OwjNxed1/eosTSz35AtX9UqZUQ6
        s0aNR7jdam/lf6+0=; b=XfsBuEknEkwE5RYIe817eO4n8kHjT44WbNjhVAII1TN
        +ZdOBYK9GyjCjMF6/IHIxHOm94lJUIGacVIKjIxqTtOM0BQ6hqTWbbv6V/gD5Sx4
        DSiM3C/uqW4n3ARizYv19xhZze7eI8RDBK4wKi8+3Y2IamUz6nkC8glShO8LdDAz
        tlcRiOrAfhx6WwfPmNM3Cx0B7kY9GYfsUygSf21UNhYYuzxPWmsIFQ8nDBWQx6RP
        x/Ut+412bbdNaKX8ok5AjtR3TtihMt9BaMhtyqxqGNl/TVfD6496cLA5qtG4cEfj
        2SKF3iFMbkwlV0F5EialBLzXax1dl0hcxXTFknjddkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OwjNxe
        d1/eosTSz35AtX9UqZUQ6s0aNR7jdam/lf6+0=; b=RFhhxwlzu3hUM3ScV2mwDz
        a8IfsUWqi6rvE+sIdtJrOzJoI6TwVlqTlErfyEMf5Xxao3zX04gKH/w4hwSIZ3EZ
        ZsU1ax4sBqw1dFLEDgxOMAlTUrbStJNmbZD7YfY42OGAIZZAVGr4bcAuDw2XTTSC
        sQA8g9YoJKfg5TZhe9T0YMzFBR52GV/jvjdsBZAGci6wItps8z6x08cWCHKlbvrI
        ZDwVZJyE45uq8vnNZawaLKXuaF405DtVOeIPxs1LdCPF05Uc8vsQ/Ded8SGcB7DX
        33QE8BlsTn1Oq1VrOkTyxNPU+rNj8PTRjR63H64Dmi55/7/Fp5poEnAXANGGDiJg
        ==
X-ME-Sender: <xms:8_FCXa6fsSAhCiDCNUADIblcYyCIs__J2Yv-4JFNDuav4F0f9ndb4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleejgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:8_FCXVLSWDWYU8Z-z_rz487Qt2GhyaLexhLOYsFpJgv1ITUglvHcjA>
    <xmx:8_FCXezz_tBzEvG2K33tDxzqFeEyzNUX-ZkG5jBMFaoASPEeXsbxoA>
    <xmx:8_FCXVF1fGCSuhTpB0nQTL2s-IGYXZpDo630d4T5120LPaLtjNFuKA>
    <xmx:9PFCXUYoZMa_V7SydWeIpGWcFa160jEz0XQaMwF_hLvL5dC6IvJKiw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B8A1380075;
        Thu,  1 Aug 2019 10:06:42 -0400 (EDT)
Date:   Thu, 1 Aug 2019 16:06:39 +0200
From:   Greg KH <greg@kroah.com>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5.3-rc2] Bluetooth: hci_uart: check for missing tty
 operations
Message-ID: <20190801140639.GB31375@kroah.com>
References: <20190730093345.25573-1-marcel@holtmann.org>
 <20190801133132.6BF30206A3@mail.kernel.org>
 <20190801135044.GB24791@kroah.com>
 <1983583259.6283500.1564667755023.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1983583259.6283500.1564667755023.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 09:55:55AM -0400, Vladis Dronov wrote:
> Thank you, Greg!
> 
> I've just noticed the patch landed in the upstream and was going to start stable
> backports, but it appeared you've already done this.

Verifying that I got the 4.4.y and 4.9.y and 4.14.y backports done
properly would be good, as I took a guess at them :)

thanks,

greg k-h
