Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470633751CF
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 11:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhEFJu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 05:50:59 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:50993 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhEFJu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 05:50:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id E2B19580722;
        Thu,  6 May 2021 05:50:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 06 May 2021 05:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=ZSvFMwP2scW534jrzgylOkXMM+D
        rqeNkQQCfs8dEMTQ=; b=TcKzVnVACRyvMQcr0Jpo4kTVxHyvp3ZSRlzVpfpmPoZ
        OrwNbHBm4HjlSXfA8In/HDqugJZbQFlCt/76ctzs2P24OCcTAAiZmdMLkQlsr4Uo
        h4u8uZmAjL2guZekK74CFH4Kn/8JRPA10NVMP3/694q6yhGCWH8Y6C7v5yYA0RXV
        DeznYaCuCDkGecJalBNRjeoJfVkL5aKakO/i3UW1jgNa6dhoYAq+uvOZiUH/Ce8L
        YWNq15w0/ZkzhnNTsm4+6l+Ub7fkShAKbD1QIOVojsQgAZYrbcReCFWfcycNzn6E
        Kv+82JziDZQCYApE+6ZMhXv0tKhbDutH2IN8RCfL/Ww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZSvFMw
        P2scW534jrzgylOkXMM+DrqeNkQQCfs8dEMTQ=; b=Z4FgGOKAMsiG0hn515iB9/
        N4k1v0FpIZ3r+icG+gDnqw/mO2hXbrZd+nLdGPIK0YHeL0EfbmsYr33nAvbtP3vh
        46T6qh2FppQdC//ndjjqqawmU84uEoWfIXA3kklzD1xURYPk1CgpiS8R4rE2pC1s
        +c8k47v9DlNu5uBkwgP5qdpxGkkdM2YfskxR1yc13Gkx4iWUciu9nrpjjFpYqytN
        jJMk/L05JZw7lgnZyROk59Abxj+h9SmiHNLnnDRit316X33xhxulhfWjgSSWCGnM
        W9RJ6Eu/j+O4Cr0LpnTFCLG+5zWzkS8+d0hcr8w5xVsqfFtyY4wblCMfMlrhroBQ
        ==
X-ME-Sender: <xms:x7uTYNEhHygCf-wTl0MiEKz-NtJezo_qZq_3OI_2te-yQ9SLQJE7Mw>
    <xme:x7uTYCVIRcAIXd2Gik-3CgvTEIA4GucEfXLq1Qbq33nxXhU-cT2X7cvURMi9LaHO6
    ZfhT5ZRjQU36A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegtddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:x7uTYPJNzavCrM8BMM9t8yZt4ccn1ClYZtwS1cQ5dl1YgV3UrcY06g>
    <xmx:x7uTYDEIbZaUcHuSrJTSsdWXY9332S6Eel00AqxgbOGX5wo-l17tbQ>
    <xmx:x7uTYDVHOEnicTkS6u_BCm_l6fDV2J71ieNf-2gH3jIr_zZLJ-nRUA>
    <xmx:yLuTYAUMdGfspwgiK17gc1Kd0ZbN8AA6bQ8rXS_u5u_N-hV-gA4RlQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu,  6 May 2021 05:49:59 -0400 (EDT)
Date:   Thu, 6 May 2021 11:49:57 +0200
From:   Greg KH <greg@kroah.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: handling Fixes tags on rebased trees
Message-ID: <YJO7xTZ6GKsvY3X4@kroah.com>
References: <20210504184635.GT21598@kadam>
 <yq1h7jijnxu.fsf@ca-mkp.ca.oracle.com>
 <20210506083905.GB1922@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506083905.GB1922@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 12:39:41PM +0300, Dan Carpenter wrote:
> It turns that rebasing without updating the Fixes tag is sort of common.
> I wrote a script to find the invalid tags from the last month and have
> include the output below.  Two of the patches are in -mm and presumably
> Andrew is going fold the Fixes commit into the original commit when
> these are sent upstream so those aren't a real issue.
> 
> We could probably try catching rebased trees when they are merged in
> linux-next?  I'll play with this and see if it works.  But we're going
> to end up missing some.  Maybe we need a file with a mapping of rebased
> hashes which has something like:
> 
> 28252e08649f 0df68ce4c26a ("iscv: Prepare ptdump for vm layout dynamic addresses")
> 42ae341756da d338ae6ff2d8 ("userfaultfd: add minor fault registration mode")

I thought Stephen's scripts already catch the "this commit isn't in the
tree" issue?  I use them when I take patches, so that logic came from
somewhere :)

thanks,

greg k-h
