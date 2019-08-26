Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353B29D481
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 18:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfHZQvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 12:51:53 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:54175 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732789AbfHZQvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 12:51:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 46D21604;
        Mon, 26 Aug 2019 12:51:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 12:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=tP5fOSLRP57Pf7GNizioPO+n2A1
        sdTx1AwZCaT2DdCQ=; b=Gw0SXnL7tDY0gb0qeN952KLqp4WOViFAFbmT8SMfHPZ
        2JgE3beyldPv/KhfSfIlxMdE6pUgjeXICwVeg951vXgQbnGjhRn+ldUDGLiVQBd2
        ROaVKHU/OrFipWwkThPj1S4/ghIo4qJAWX09l3NktaMd9ozlk0/wpGOxDJoy3JTN
        KZ+TZWQjelzQyQOyjaqYUCPE0MPfogv1jxCg64pX6t4Pt76g10G5bfG1RZmvDhE7
        x5+SSV+fSxvl5KXtXYfmy54dp3HjIrf57Jwj8ZKaGA18m40E85PdgkOpEbqr9vi3
        u+QmK3y6zNzIEKj6wRlj+Fqgww5PQmx9P4PuSWcBGxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=tP5fOS
        LRP57Pf7GNizioPO+n2A1sdTx1AwZCaT2DdCQ=; b=NAD0VB6eSItvnGgYUky2Ah
        NnonEEPBJyqxx/HUPyYBSFTpAP+Zcdluix+HiyBmQm4SCwF409KAEzb7/oJHBcXG
        DbcMwjceNVRu1EnNLIQSyl2gxl8MVHa1Xv3NAgRB8V8qVBvh0bTjBtbb3Bs7yMHX
        2N9F4WN2wm4t7c6uZGrBaCoRwWBX7K+3c9ivZsLt4NKo5A7jOILLbkHOl/Mj7JOs
        /Y7Q53TG7xejZTw7jtSmF9r6L739rkz5JwGJprRh3+yNQ2LEl2Ll47UARcrezzQs
        Izy6dVHQRiLBEtq0KzfIHS2dEHGGdClhI0AUaHLYn/YvFKZy98ITp2T94KSr4pUw
        ==
X-ME-Sender: <xms:Jw5kXSe3SvpOejOazTX1nG16oGShF8_XJbOPd-JzP2zrmgAxDTdyHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Jw5kXaC5pZACY-qs7GqIp_YcWVvUHDQrdRPtMN__N5N3luX29qvSOQ>
    <xmx:Jw5kXRXJZ1Zg_0QOr3GN4uVtTgscegj5FXLjQXQQsUgR7PgqmXX0Ow>
    <xmx:Jw5kXf1ZNwL64hW48JBNhGHzjGibL5WifsxNzL2iM9yem6Q--r7P4Q>
    <xmx:Jw5kXblbQsQ3sOpHA_MhrfcJE19Fxg-z4sbWgLLKOJ_G53nmPLAWoA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D176D8005C;
        Mon, 26 Aug 2019 12:51:50 -0400 (EDT)
Date:   Mon, 26 Aug 2019 18:51:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc:     stable@vger.kernel.org, linux-rdma@vger.kernel.org,
        stable-commits@vger.kernel.org
Subject: Re: [PATCH] IB/hfi1: Drop stale TID RDMA packets
Message-ID: <20190826165148.GA20925@kroah.com>
References: <20190826160149.32208.89081.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826160149.32208.89081.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 12:01:50PM -0400, Mike Marciniszyn wrote:
> From: Kaike Wan <kaike.wan@intel.com>
> 
> Upstream commit d58c1834bf0d218a0bc00f8fb44874551b21da84.
> 
> In a congested fabric with adaptive routing enabled, traces show that
> the sender could receive stale TID RDMA NAK packets that contain newer
> KDETH PSNs and older Verbs PSNs. If not dropped, these packets could
> cause the incorrect rewinding of the software flows and the incorrect
> completion of TID RDMA WRITE requests, and eventually leading to memory
> corruption and kernel crash.
> 
> The current code drops stale TID RDMA ACK/NAK packets solely based
> on KDETH PSNs, which may lead to erroneous processing. This patch
> fixes the issue by also checking the Verbs PSN. Addition checks are
> added before rewinding the TID RDMA WRITE DATA packets.
> 
> [ported to 5.2 from upstream accounting for fspsn replacing flpsn.]

Now applied, thanks.

greg k-h
