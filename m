Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 400CC9D470
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 18:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbfHZQsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 12:48:51 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34981 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731578AbfHZQsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 12:48:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 85968681;
        Mon, 26 Aug 2019 12:48:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 12:48:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ZF1niv0z24OQssaXuS7weto0nCI
        gImSmU4vezoCMtgY=; b=m2sJiP9UxFdmAVizp5j5OyCX6PLvhN0PF83lNEycqwq
        aZIr0XcvsXiCv1DfXI3jizxvOq0dxjJzsTxx6CAPiNUsuyBkIDyU9b52oEabVIyw
        188SEIiGVWHMNcwWseBbk5Xh9clKJUGFvZRJmvNYUcWx0XU7p+5E2xTWED57Oguw
        4d3cAL0sErCBehUSrh5vxi4cfvY751ROaTapn65DfCh5u4MT1VSF3m9Vx0Oje7ek
        yxt3W28gm04Z5D1Vc89xcGMi0m/VChY1927msNO2KVI5VH/W4tLFTxHlGwoizt9P
        moxiZA6cLA52oQazWlHlCT6p52qTyyAOTbmLgAbb/Yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZF1niv
        0z24OQssaXuS7weto0nCIgImSmU4vezoCMtgY=; b=eP+Erj/dRr8yx8C+C94h84
        LXspt9ttu7R9rZchovwyCUzd0igzko0N4WQpXn6e6zgzV955ixxH6vMBC6lxL4oq
        mV18ZKNpW/mJdBnK0woX+aumunSaarRsAgNBGYcw4/fWY6FxnmfPvlfdwTIfRN6P
        cGmikVWzMRVHEwkzwbby742MwFN0noex+uuKQvkiIbnwo4toulnBODyAT750sF7N
        sFK1RWDvoEQEcW9wHhlE+xdEIPKIArjY4KVu7CyWeVNgPswtDk+xtrqXR8AKGbBI
        uhgTBzRkrFuKYWDYE0GTVpPKQuP4Mx1ywtgLHGMe9yLAomWf7/AwjN7rbwGZX/VQ
        ==
X-ME-Sender: <xms:cQ1kXRQ96sk9OnWp9piZRNhVrkfkLM7Uftw7-X_xZCuUBLFAzX-saQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:cQ1kXcZYG1aY8LjS-S47zWtIUixklBWbvTUGFZwmTt-iePnuU19diQ>
    <xmx:cQ1kXVha4Gk1M9IdvQ51Yp8c6j6xIvQURTGwskbIzIhkzwmWkW8VaQ>
    <xmx:cQ1kXRjfyPYYRdwBOK5a57U9tXql8QJXKfhTThL3mSsHv9ZlITO-Nw>
    <xmx:cg1kXeUPNw4dtMlec0jwC5Ndkcw-lavne3dNX9uphbNPQLg0_P967A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 703CAD6005B;
        Mon, 26 Aug 2019 12:48:49 -0400 (EDT)
Date:   Mon, 26 Aug 2019 18:48:47 +0200
From:   Greg KH <greg@kroah.com>
To:     Luca Coelho <luca@coelho.fi>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.1] iwlwifi: mvm: disable TX-AMSDU on older NICs
Message-ID: <20190826164847.GA9305@kroah.com>
References: <20190822180157.22587-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822180157.22587-1-luca@coelho.fi>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 22, 2019 at 09:01:57PM +0300, Luca Coelho wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> commit cfb21b11b891b08b79be07be57c40a85bb926668 upstream.
> 
> On older NICs, we occasionally see issues with A-MSDU support,
> where the commands in the FIFO get confused and then we see an
> assert EDC because the next command in the FIFO isn't TX.
> 
> We've tried to isolate this issue and understand where it comes
> from, but haven't found any errors in building the A-MSDU in
> software.
> 
> At least for now, disable A-MSDU support on older hardware so
> that users can use it again without fearing the assert.
> 
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=203315.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

5.1 is long end-of-life, sorry.
