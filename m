Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0877719D349
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 11:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgDCJNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 05:13:42 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:38197 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727803AbgDCJNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 05:13:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D0C82632;
        Fri,  3 Apr 2020 05:13:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 03 Apr 2020 05:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=iW6uQ8A9tNvL/XStQfJYoh6WrDE
        hqGA0/Bg4CiZJ09k=; b=EH/TbpZBelPl5GvtHeunW7yDUjwoUB4YLS1lncUDPBe
        ptfXBa4F0krOrCqr6a/VVh8Rqq9N9TfOS2acXPpxgMT4UFbFEapM4oRBtF3bJeGi
        eM/Ro3WMznn91nZRCNxPY8cqHILKse5ktNQmDWo+qhU5ThFf2boeyU5D3v9qrrL4
        OtME8xX0jgfMDfbs7GTEFy45QO480kZHF3F0B6A4Tgk1McpLxMm+k5rvCr61cElP
        OCqlAnv1m5xJ6DJUmqE35anLtZxhnSWuXbhA44jy3RXurJpPNW4WHLLmw/WCIZ+Z
        /a+uTLIhREKwCuwzUbLf4mWNscDiRMULmlvY9Xemt9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iW6uQ8
        A9tNvL/XStQfJYoh6WrDEhqGA0/Bg4CiZJ09k=; b=3O1gF0co2xDQKQehUjYDcl
        7dagT9GDNW4cHFLIFAIUbFcT5mw11c4x9UTAz4kK4alw5/TXnp1Z6vacMkkKWNHS
        qZS3pzRESCb8yDH/duYjbY12Pd0ErzxmKUU4sDlVveh7uiId+0XAtLPrm1iPuSqJ
        HD7A3wvBtd9d77xjInPjCthGG/fq/vTfH4uirazBmrFxE6NDTYgyov7xRc7bZ95s
        pNTNlhxJBnqU1XQPVU5AjKDE818BgZoa2jF5UdtOMr2L3jQiimZfl8NKropJJac8
        iQzeQax9B9oClbLmZis/+RXE30yOrcU4zE2PAPxA1K78ns8J31/Q6hco/SRZiSIA
        ==
X-ME-Sender: <xms:RP6GXke1i-VHNcmDvRYBeSJhUuDhT3An9O8B1X9HMH5IcrcFHLPn4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RP6GXvgTWBuNRZ1NUkCTXTkjRINgX8EKQQwDs4QIaMKCR_-z4mKayQ>
    <xmx:RP6GXh4QVz_pwGN2bWmC6I_aGfuSj-uH0ULPnxoZp3ukEzXSx5CBCg>
    <xmx:RP6GXhjx_Kt2Ci7V4LlgQFNWmvFqVxjk1NM0xbzch-NIbNRonCBDzA>
    <xmx:RP6GXt-agzQ1RfsP6UBZCz30ufGYDuSZn__KAmdNv9ySgjw4PtNdZg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC853306CF56;
        Fri,  3 Apr 2020 05:13:39 -0400 (EDT)
Date:   Fri, 3 Apr 2020 11:13:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 14/14] lib/list_sort: simplify and remove
 MAX_LIST_LENGTH_BITS
Message-ID: <20200403091337.GB3739689@kroah.com>
References: <20200402191220.787381-1-lee.jones@linaro.org>
 <20200402191220.787381-14-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402191220.787381-14-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 08:12:20PM +0100, Lee Jones wrote:
> From: George Spelvin <lkml@sdf.org>
> 
> [ Upstream commit 043b3f7b6388fca6be86ca82979f66c5723a0d10 ]
> 
> Rather than a fixed-size array of pending sorted runs, use the ->prev
> links to keep track of things.  This reduces stack usage, eliminates
> some ugly overflow handling, and reduces the code size.
> 
> Also:
> * merge() no longer needs to handle NULL inputs, so simplify.
> * The same applies to merge_and_restore_back_links(), which is renamed
>   to the less ponderous merge_final().  (It's a static helper function,
>   so we don't need a super-descriptive name; comments will do.)
> * Document the actual return value requirements on the (*cmp)()
>   function; some callers are already using this feature.
> 
> x86-64 code size 1086 -> 739 bytes (-347)
> 
> (Yes, I see checkpatch complaining about no space after comma in
> "__attribute__((nonnull(2,3,4,5)))".  Checkpatch is wrong.)
> 
> Feedback from Rasmus Villemoes, Andy Shevchenko and Geert Uytterhoeven.

Random patch chosen from the list, why is this needed?  What issue does
this fix?  Where did it come from?

Also, you need to cc: all of the people involved in a patch for when you
submit them to the stable trees, to give them a chance to weigh in and
say "no, that should not go there."

Please do that for all of these series, and provide a 00/XX email.  I'm
dropping them all from my queue for now, thanks.

greg k-h
