Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3BDCA11D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbfJCPYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:24:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36935 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727302AbfJCPYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 11:24:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1560C21FA9;
        Thu,  3 Oct 2019 11:24:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 11:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=wxwbZrBVLmCV/6x5xA/QEnCBye4
        85D+44+PoHhHJyiw=; b=ZLQr7DvcwhxjtnKCaQkQLfUT9BN8Wrudri+Ww0dS5gg
        KK/y+OadR23tEVA4w84bS3qrz8AMSPKLVWMAgmB8UItp+3OlhZL44zOwyJwRpZPY
        okQcefJDs3q9iLsqtQz988/78SPPyyx3BKawUZeQxHILkMTO87U0qVy5xquMcjdn
        HNrOSq2tA7upTUXlZXaMo55LNOpIS5PfCYPJik/H9sJ3+2F2CO1PGgIPnH0TrDCJ
        wGG3svo6kaUY6EnINCkeGbNN7DY73ba6j4xU5wByiY3k14wKFZT06RoOU1HLlLao
        oGleuoRiPTwBJ9WGaB79ZOaqwBpKnnwgLNooddUGpFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wxwbZr
        BVLmCV/6x5xA/QEnCBye485D+44+PoHhHJyiw=; b=LwO7W2fmc8T/wtb7Q2Ilar
        Yy2h9tHdI3FBmoLmAynLmgBdoegiC9NcIxoZVnQDBgpIUUF+Lyfxd8wID4um7mA0
        43NoaD0xIJdE9vdfWIxpuKSSpRLzQyzXcvWFA63NvZfgddywbL6Zz8bM5+rMgXFF
        oz0R0YO0ByZ4ALONW1VqfWu29AdxRckH8CaNFfzgk+azyff/ssjwCsKi6P/Se1Q/
        Jj655xrfmcl4OMB2CUaz9EMxNbY7jTq98HPr69bWU5/GAje6f9B4zn6igmnOaVal
        buwF+RDhmKxA2roxuvJHcPC3kxgdOGjc/WmyXlK/L7WvbDcQKA6tsiCTu7ZwdP8g
        ==
X-ME-Sender: <xms:phKWXfonIdUnLANP0QwMrQ5Tfrvm1cyVGpFAIHagzQOunvrRBnzZhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdeklecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:phKWXTWEDQ0OXFy3XOGuQwBcE6HfPRYRtl1S_oSNS95_yxnyPauA4A>
    <xmx:phKWXbgpxolMHAAkH9rAamcA5D3GIAHT7Offt1GCIUSbvWpG-bwOhw>
    <xmx:phKWXa8xfMjFRzIgS9elp6HFpHbMzwRqSzoCwqj1PsxWjCQfprC_kA>
    <xmx:pxKWXfoeSW5e1_yyqc5jzhAPV2mdHvoXL32RNkUJteL7wk-VNzImMA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30B568005C;
        Thu,  3 Oct 2019 11:24:22 -0400 (EDT)
Date:   Thu, 3 Oct 2019 17:24:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 0/3] amdgpu display fixes for 5.3
Message-ID: <20191003152418.GA3187656@kroah.com>
References: <20191002184219.4011-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002184219.4011-1-alexander.deucher@amd.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 01:42:16PM -0500, Alex Deucher wrote:
> Some display fixes for vega20 for stable.  Fixes
> stability issues with certain combinations of monitors.
> Cherry-picked from master.
> 
> Alex Deucher (1):
>   drm/amdgpu/display: fix 64 bit divide
> 
> Charlene Liu (1):
>   drm/amd/display: dce11.x /dce12 update formula input
> 
> Zhan Liu (1):
>   drm/amd/display: Add missing HBM support and raise Vega20's uclk.
> 
>  .../dc/clk_mgr/dce110/dce110_clk_mgr.c        | 27 ++++++++++++++++---
>  .../drm/amd/display/dc/dce/dce_mem_input.c    |  4 +--
>  .../amd/display/dc/dce112/dce112_resource.c   | 16 ++++++-----
>  .../amd/display/dc/dce120/dce120_resource.c   | 11 +++++---
>  drivers/gpu/drm/amd/display/dc/inc/resource.h |  2 ++
>  5 files changed, 45 insertions(+), 15 deletions(-)

All now queued up, thanks.

greg k-h
