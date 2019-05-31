Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993393173B
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 00:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfEaWa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 18:30:57 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38951 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726446AbfEaWa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 18:30:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8F42222033;
        Fri, 31 May 2019 18:30:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 31 May 2019 18:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=mNh2FLQPFcskqie4vX+l2d6oafO
        I3h2vXlpI9zCYupA=; b=Wr/DhX1gp6+BSnPCFwuOxC3hDSoeHqnC+yWRyLsHBM/
        aMznvZqpGXeUW265TL8jYqqQ9jshj9ClVeE+EMMOpGkjdcPOz8mFAXGUKvepAlsB
        ndmNcn0LQIiES4700AiUfo5PgQZIowheFmLTiPug+RQi/5NjdH1z66bj75gxZztS
        5KQpEZQ2yOKAXCnLHJwDeTAxK3u+rHkjJOTQf649sJmPoC4TNtSJ09b2iF7XZSrb
        hRMQkqF7YHOkuaS0LdmqLBbNEn2pZ24Jo8LoTEvdVSHVoVqMVp2MQr3bRxCww3R7
        ANHTSs5QfMnBSMrCSpSNLm8rW+mJ8nXyosXeIpHO0LA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mNh2FL
        QPFcskqie4vX+l2d6oafOI3h2vXlpI9zCYupA=; b=zFN19PQLvVzggdzEhX6p5E
        /VzEhQbMWsuVu0/IWyv/oF2+N/n9AiiXTOuH5NF/igyFI4iHbDfnqJpH+kQgpItC
        cxwirVDeHNWUmthhKzkuacOO9tmBEFhs0SBq7cEgWtiPsezmQHh1fU58JhffzNEf
        AjQ10X2fMDFqSSIK+FTYwHT0qZ5neslWJ7xYpHoa3BeOti9RtN23UFq9ab8PlsTu
        bOjzls1N1ZvKcOVBPiLWNJfMZGcaf0U9ckbvpeyh1tkRRTXtIQYfUDIvQV4jkVuN
        b0UaxrNsZUCu7oOsa3s2o8mmB/ahbccnk3It5yZkWaj4Q/W8KlMl7PnZ1EJeTdtA
        ==
X-ME-Sender: <xms:HavxXIzdj8fYvsPODE5Y9BJyIZ4X1JG7br1uvn2h50gMqBIhvWFAzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefvddgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekrdegiedrjeehrddvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhu
    shhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:HavxXAgSgn9YS8j2qve7apzbddRNSoCimeJhTlkmQ2ajYv8qEmQ5Wg>
    <xmx:HavxXFXKn3eLHqOKIez0SAE2JskkUj22Mm7zw83uKgMgC7wyKiJLzw>
    <xmx:HavxXK2NLMq4jhYJgn66ZKj2frxpDLaa5kVIem3kZl3xkLk0C68w1A>
    <xmx:HavxXN-gBu8Dj-BC6s0TJugl8GUncWazJDAltrbkmJxUVaF0Dt8M1Q>
Received: from localhost (unknown [8.46.75.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0133780062;
        Fri, 31 May 2019 18:30:51 -0400 (EDT)
Date:   Fri, 31 May 2019 15:18:10 -0700
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20190531221810.GA7311@kroah.com>
References: <20190531.141626.1051997873999042502.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531.141626.1051997873999042502.davem@davemloft.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 31, 2019 at 02:16:26PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.0 and v5.1
> -stable, respectively.

Now queued up, thanks!

Note, 5.0 will be end-of-life after this next release, so no need to do
any patches for that kernel anymore.

greg k-h
