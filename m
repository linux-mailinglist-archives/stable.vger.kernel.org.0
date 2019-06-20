Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A644D023
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 16:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbfFTOPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 10:15:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44733 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731943AbfFTOPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 10:15:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 41EE3220EB;
        Thu, 20 Jun 2019 10:15:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 20 Jun 2019 10:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=olGQayuTAXkDyp5Vn6sgCIfCq0O
        50GeQrrkDfRM4POQ=; b=ldbWOywLSz/NsGj53nBBi8XrPt261ZUVEEslcJnflEW
        4Zof7uouBVZl4yFgduIt0wztS4yfWxI2c/Y9CZmkFvOL92ZaYcQlCjbPrGCJSU27
        PU5iPoPAaId4qqhYejYZMQE649BzOkXcU1Ouer4j+frVEaY963UbyZjgvhRhYjza
        7Jsg6yoewbqdbgo8LOZ5TiIRBQXfVxRi1kGMq81SNIrcPji3OlHJuq5XzHeH/Vyt
        w+5N6hqjcqU8yOf8VpJ44JsAtjbZtwgGAIVr3rXvcldbSjEd8spnn73+yFVkD8Lx
        lXEePWwQymJQlv/8AoTMQQ0aEIB6hQnFeIzgpCcuFxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=olGQay
        uTAXkDyp5Vn6sgCIfCq0O50GeQrrkDfRM4POQ=; b=Qs6gNeok3Nj724ceimH1or
        +j7T68TdsaMG/E4QwF4yO5YRuf6ePp/fH41fTv7hiFyVIUZyh8HidI2xsa1MY8AN
        dBntCAyJhSV1t8YVi5FMLIkdVpcO1NEKmfal91aCVcUhhrWGWGVEtHj/QIjinhHu
        hBnfOrF8TQxV3/CgVpcFxH+uoiPrDFM6Ey1PcNV5yqcxoNGz2qt7ZwUqpE7/zJ9F
        v+X1Bj/M0mluvZsZ17Y+gQnrK0OU2Gy95Uczp682dWheL2iM+D0AKefQ6bE2U8KS
        2zzLjMDGssKAbaYiWS6LRSBzCa8SZrDMRk+fA+zEISmPWYb7keo/zkSx+GuuB44w
        ==
X-ME-Sender: <xms:F5ULXcIx6ZNUtGJpzKVrz2ui0NGat3CvauzTJbUnE14_la7MUuK9wA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdeggdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:F5ULXfR9-moLAwy5RMsuKz1uwm_sfUdhirhFG06XQDLH407WrOhw4g>
    <xmx:F5ULXaJqAXN8pwlbzV8tRc9FXDOvuiIqjK3K8Kb_AuT35VHBFifRdg>
    <xmx:F5ULXd9x4hUq24NyRzjigfBIKa-72SemhLlqB9EVX_rh_6heCV5Wmw>
    <xmx:GJULXQjeyH7Ofx6-EX035XJXzyKoo7AW6XsxDcYeMgzo-mPPAnT7Tw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 139448005A;
        Thu, 20 Jun 2019 10:15:50 -0400 (EDT)
Date:   Thu, 20 Jun 2019 16:15:49 +0200
From:   Greg KH <greg@kroah.com>
To:     "Gerecke, Jason" <killertofu@gmail.com>
Cc:     stable@vger.kernel.org, Aaron Armstrong Skomra <skomra@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Subject: Re: [PATCH 1/3] HID: wacom: Don't set tool type until we're in range
Message-ID: <20190620141549.GA9832@kroah.com>
References: <15606126649212@kroah.com>
 <20190617215946.13423-1-jason.gerecke@wacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617215946.13423-1-jason.gerecke@wacom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 02:59:46PM -0700, Gerecke, Jason wrote:
> From: Jason Gerecke <jason.gerecke@wacom.com>
> 
> The serial number and tool type information that is reported by the tablet
> while a pen is merely "in prox" instead of fully "in range" can be stale
> and cause us to report incorrect tool information. Serial number, tool
> type, and other information is only valid once the pen comes fully in range
> so we should be careful to not use this information until that point.
> 
> In particular, this issue may cause the driver to incorectly report
> BTN_TOOL_RUBBER after switching from the eraser tool back to the pen.
> 
> Fixes: a48324de6d4d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handle prox/range")
> Cc: <stable@vger.kernel.org> # 4.11+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> Original commit in Linus' tree: 2cc08800a6b9fcda7c7afbcf2da1a6e8808da725

All 3 patches now applied, thanks.

greg k-h
