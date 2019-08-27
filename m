Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4258E9F120
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 19:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfH0RFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 13:05:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53763 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727887AbfH0RFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 13:05:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2102622131;
        Tue, 27 Aug 2019 13:05:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 27 Aug 2019 13:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=T
        NBagrg/a7bq5LGkChH/gz1BptkFYic2Ws8EiAGIiog=; b=K6jKHUuv8rmEU5uZk
        Bk9P/969rudoDrC5Kvoqpm06DwZSwytDiF35Nd1egJPnjPwuQ3M5ceDjkoz0eqAO
        2qIMKga3+5HeWwq/tJ00Zh5L5AiWGtWApVrVzRBNd8gReJ1I3PGrG8N7YjAbS2kp
        UXidB0QTZphTZS8Z6jM2KQpAMqZoGIS4BRNr8bWSDdtXdZ+dNJqbwgaN6vv1a99W
        VtaoCA8GNLz8Ju23l6yEhFwwojkQzsjgCpJzunjftgjxyCPF7d1++x7VUNvjMZoJ
        E4Z2cSJioD16hnr72E/VwJx21gpzSPJ+Q/5sblQv23HpuOCRej/WAFC4TosX1Dgs
        Bp02g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=TNBagrg/a7bq5LGkChH/gz1BptkFYic2Ws8EiAGIi
        og=; b=IvhjME2B4Ngzy3alBFlU03+pg7Okp8R6yTZx6RhXjAgZ+ub218bDdLHqw
        l9P9YX6XOQFbFjJP8EkJGnyMJKzNAsvsdK7/XFWsKgsvUo++YUqkp7kYLYpo1o/z
        gyPindtpPfG4Jiszr8bih0dgZfeV7910XOrfUHgJg8CmkIPZqLW8fP697rkP/YRX
        Y4XlfFKrsFRLKYZ8VKGag+YRkO5/C0aYrJs89YdZMsMa6HEyDl0hbsfDRiSiIssB
        IPKn9PMov5+6qkE/7plUZqPEA93Hyni0vc/D+R6EIJnf3FxY3rb+4R2qb3PVBP7Z
        fv/T7lXTFAp7DLO4/aNaNvEhajefw==
X-ME-Sender: <xms:0GJlXV046SBV2hWdkQFbnO1bvUhtr0vIonarDs3Nf_EjtkwbSbU1Og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehkedgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:0GJlXTDrjzzQO3I3nMxcnw4CRJaIzR8qwWi6i4DFPITtM-Crdytdfw>
    <xmx:0GJlXa-Vwzit5Wk9OuM37VnCMb51rz8Y4MGFTyBDMImJszlFVs76fQ>
    <xmx:0GJlXZ8tzMcHbXzcCswePQFWAMENlzv0bF2e85iGbz2GW5uno9fcww>
    <xmx:0WJlXV8lxkKAF6ElNkU4nFvztSigBD8b3JzD6LxtUWCnyY0dIA30cg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6EBACD60063;
        Tue, 27 Aug 2019 13:05:20 -0400 (EDT)
Date:   Tue, 27 Aug 2019 19:05:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Major Hayden <major@mhtx.net>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Yi Zhang <yi.zhang@redhat.com>, Xiumei Mu <xmu@redhat.com>,
        Hangbin Liu <haliu@redhat.com>, Ying Xu <yinxu@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.2.11-rc1-9f63171.cki (stable)
Message-ID: <20190827170518.GB21369@kroah.com>
References: <cki.98AD376375.DJWRK5AJEY@redhat.com>
 <291770ce-273a-68aa-a4a2-7655cbea2bcc@mhtx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <291770ce-273a-68aa-a4a2-7655cbea2bcc@mhtx.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 09:35:30AM -0500, Major Hayden wrote:
> On 8/27/19 7:31 AM, CKI Project wrote:
> >   x86_64:
> >       Host 2:
> >          ❌ Networking socket: fuzz [9]
> >          ❌ Networking sctp-auth: sockopts test [10]
> 
> It looks like there was an oops when these tests ran on 5.2.11-rc1 and the last set of patches in stable-queue:

Can you bisect?

thanks,

greg k-h
