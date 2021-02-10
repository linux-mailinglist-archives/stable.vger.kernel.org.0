Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CDF3168AD
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhBJOHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:07:44 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:60629 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230376AbhBJOHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 09:07:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8398F58023E;
        Wed, 10 Feb 2021 09:06:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 10 Feb 2021 09:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=l5u4BR58ii0Rtlvkm1LcKTg4vDo
        3rxiz5sSs57woe04=; b=GWadpoLWa5oK1qyT9kAKnkuk4z3HMK8EyLv+f8LXr8N
        BV74nI99cnQr2yRLHCmqYtZVPQbGUaRRzcid7awA5zFdLV6grl3vI4BQIaqf4987
        xjxHfLQnZso4hvDdLxm/LQrsi6sjBKnxVV2azXxNi/Kcc7ObUupCBVefEXx91uzy
        dtbHiZ0mCLLzWGMnpPSVrr6TGHtv4MejweI00W3GjkZM58/vI2gi6awtOnoPFBoo
        9Nm7M7unF/WAg8dde/WBzioAvGJ5eg3qpG5iJcEgA43Tgj9cn366l5NRxCiED+qe
        HZmssUAZ+0YJ3XzHrKeUhMbKucZqYRd6QKXWp/m9O4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=l5u4BR
        58ii0Rtlvkm1LcKTg4vDo3rxiz5sSs57woe04=; b=gqAmFjY+0aXFv7N7KpV6Wy
        XWmV0P2Modn9HcYWUFf4uK9XgfgCyWhP1S8uWmLBRNGtBe64NQHQkerYwQLFEMMU
        73pd79/iYaugbLtVasRuJsuYlBlOhATesE7MFKG9yuSlNUPDZg4XbCDDD/FYT2fe
        NSkIJ4uGe7/2RghrtX1LNh/XpBhju3fgA5bJTJozP1CCu1oKN05aNQZIpqOAyudd
        6O6cya6Lx49lLlb5rSqv62SAtUDYoLQ3ldwooCfppA8YRYHIFqz3yRiQjo4bcFzD
        e2HCcHAv21ZFJ5+uyM1F1pAwSjx7HUtS614pWLpkCcEQglXs0vvb+z8tZvbCKDCg
        ==
X-ME-Sender: <xms:fOgjYDoFmn1Qn2F-1eEGOWd2lDfPNpxS8WXigqOYQtMhySlOJcZ9cA>
    <xme:fOgjYNpxtECkBqqbZazmmA5J-rcJPCoh6ZRI4vRR_ppBJfX-itCsxjAPYGdWKiQse
    45l8MaPbUC5nw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheejgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepfeevfedtte
    eikeevhfevveegjeefhfdvgefgffejheekleelffehteeuvdejudevnecuffhomhgrihhn
    pehmtgifhhhirhhtvghrrdhiohenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:fOgjYAOudqOIDxM9owXZHWBuFVfanz-2J053rWZ8_ZFzqyO0yH8cuA>
    <xmx:fOgjYG41hoP_DFpfZ9PpA9OH23lW_RipXX0XmDuyZGa6EaNL33Y95w>
    <xmx:fOgjYC5Y0XU3p0OAFcs1F7NuL_Hyp5yNUY1WSTwRYSj4iEqSeWoTSg>
    <xmx:fegjYCwzonPQVKpUj3ww1wVD-tjjosoI4uig9R8I-kALaNoPlRU2Hw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DEAB81080057;
        Wed, 10 Feb 2021 09:06:51 -0500 (EST)
Date:   Wed, 10 Feb 2021 15:06:49 +0100
From:   Greg KH <greg@kroah.com>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bradley Bolen <bradleybolen@gmail.com>,
        Vladimir Davydov <vdavydov@virtuozzo.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Prakash Gupta <guptap@codeaurora.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" 
        <cgroups@vger.kernel.org>,
        "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" 
        <linux-mm@kvack.org>
Subject: Re: [PATCH stable 4.9] mm: memcontrol: fix NULL pointer crash in
 test_clear_page_writeback()
Message-ID: <YCPoeaVXuQt8oX/c@kroah.com>
References: <20210209202616.2257512-1-f.fainelli@gmail.com>
 <YCL8cnXFtpdnAAUj@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCL8cnXFtpdnAAUj@cmpxchg.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 04:19:46PM -0500, Johannes Weiner wrote:
> On Tue, Feb 09, 2021 at 12:26:15PM -0800, Florian Fainelli wrote:
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > commit 739f79fc9db1b38f96b5a5109b247a650fbebf6d upstream
> 
> ...
> 
> > This patch is present in a downstream Android tree:
> > 
> > https://source.mcwhirter.io/craige/bluecross/commit/d4a742865c6b69ef931694745ef54965d7c9966c
> > 
> > and I happened to have stumbled across the same problem too.
> > 
> > Johannes can you review it for correctness with respect to the 4.9
> > kernel? Thanks!
> 
> Looks good to me.

Applied, thanks.

greg k-h
