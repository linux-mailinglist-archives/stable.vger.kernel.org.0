Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280981A3310
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 13:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDILR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 07:17:57 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:33185 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbgDILR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 07:17:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 10967764;
        Thu,  9 Apr 2020 07:17:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 09 Apr 2020 07:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=de/lbpEpFyNaHsA18YeQgWJbcM7
        Hi9JtgJjSBMzRoLs=; b=m8w0VTgWpNvaDjs2s0zWW1PFH69r8Mfag/uqGmWSt7g
        oUiAy72i9Q2PMnvUjPFm2K8CYUzYE4aIa7smEoNaIs0NSw2g9v5FST0fiobiv18c
        IVzyhC2w3Tv5l9MzlnlstRo0TJpXGefnDxSCD6Ref2kjt0cMWouhyMv53a3Fu55v
        SyHehqWkP7gaymkjb/upY7tBKbSwgkRck0fmOKXU0VKHVGaK97dFcvbanLoJ2Ofo
        S96uuXYnPLfggjDnZnews2qseprAqLD055m/myA4cT7jEmkyIp9adBhTyxqmVshb
        HLLtkdFvL7HPe4g8PfxEydUM/PwDLbL02e6ZTSvkP+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=de/lbp
        EpFyNaHsA18YeQgWJbcM7Hi9JtgJjSBMzRoLs=; b=KHtMNzg0rHB+NHguyUYaTT
        9u3Mm6O8VXm4zLqnIW8bk2TZq10f6AUsgJLCUkNnFD/lpg8t6c3SJRZ+TMO3SMGg
        upGuWVuGjAP7iiUImR9wysc0yfjbpc9O+tDTrEIdo3llQViYu92p9glETxTdHI51
        fSXZfUfuJsMmjlaRSBj/o5S+7TBfxM5v4YvZltw4jscelcclTACb2UYm/Y+WetdG
        jkayHzafFJGRMYsEkviAxaEPoPNlrxvfb5lQvDSfz3/jq+rj0Rih39HYAmApeCzu
        3N7Kwl2n8nz/h6sKyVCactenPB/3mMMVHm+SXA7SNlT4sFIpBdqG8GnTILG5L7Tw
        ==
X-ME-Sender: <xms:ZASPXszXqJK8h3lep_guAprWxHhlxCCcxvMOdQ5wzmaaaLaawiuQbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ZASPXoBsp9Z3Elw9em0mtSggOqt1wZ9Prvlttc39Ugc6ezYTU0p1fw>
    <xmx:ZASPXjWi1y2UxA-9uCDDl9QJg7ad4YDrcRSLxx3tmbukIFRSbKmOMA>
    <xmx:ZASPXihpPMGo30qfgew_4P0u-gZ2dI4DSJn_XXU3DZ-8M-tyDvEx2Q>
    <xmx:ZASPXjd0rI5Fi1n92rmOtGoKQ2BRA9BVEGBbW_1RpnikmnUYzrl3GA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A551328005E;
        Thu,  9 Apr 2020 07:17:56 -0400 (EDT)
Date:   Thu, 9 Apr 2020 13:17:54 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200409111754.GA1356936@kroah.com>
References: <20200408.150548.292797985737973347.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408.150548.292797985737973347.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 03:05:48PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.5 and v5.6
> -stable, respectively.
> 
> Also, there is a Realtek PHY patch attached which should be queued up
> for v5.4.

All now queued up, thanks!

greg k-h
