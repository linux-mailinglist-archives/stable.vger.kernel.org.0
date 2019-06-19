Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505D04B8B0
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 14:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfFSMfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 08:35:45 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47781 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbfFSMfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 08:35:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1211B2221D;
        Wed, 19 Jun 2019 08:35:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 19 Jun 2019 08:35:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=eEn0kfGUFN+GeBSgyatWVljK3wf
        tPICuJT0hro8WvV0=; b=Zo4flLKbDfghIEPfphh//h4PouMJciYG09i4zbcW2Mb
        mUH4ZvFS5ZAxdkxq8v/L0gUqzGweXA/+IBOr/w+wQj8Bn59/ysnkqnwX3KlNZpsE
        sYuTj/zfIzeN63NGzEzJRa2XByj8+RlwtoHAPehq/uLJipk9cws/VUr0dvilrDxx
        60lVBCOA6vAAAGt/YvnDKo0sMgSJ6zUj9wJcyjt2z7hlFBQseLhvBncMRMi7sM21
        JAa6BA+LmhPOO0STjvTAxk5N3/gb/Fxj8VrlG/qxlNSDHY5tJy8hPz3GePOMsuMr
        bxoInTgE3b2GCNce5vvY3A/9orgDpRS3ERN6rh09o0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eEn0kf
        GUFN+GeBSgyatWVljK3wftPICuJT0hro8WvV0=; b=Mt+OgW8tSVj0Azk/nIUG7G
        7DrK5uyfjzmEatNvI6OCwOQDNb4yInrga3+CSKvlDfsQzHRnfUQ0TVo5ZCUuDx0B
        Wo14QKePkjAy1wBmn8OqRPeo6O62zWAWXQ36kuvS4kgWSWcHNq8S23jTYslXiw3J
        P8ISjk7dDczYocY8aw89rDFWYV/dMUc/VSBH+N2VTtniCyKX9iqVYR9gN5ItujVB
        w/jtIWQr3Wk8Lb4PvNoQuf8ErNlbahCB5QaMCuAA8x/ZhLVlAhvBgo/Xa5tI5nDD
        CDgsYjyLXOnj3obpuNa8aqcVQaopCCBDN4hfvNGyJIVJlSWXyOBYyHCQiQIOzpGQ
        ==
X-ME-Sender: <xms:HSwKXQM7AAyfPV-qqRUPQIL2DtWcf1IXosgioj_mqc-4i-y8TB-FCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddvgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:HSwKXdxEBuaRzxjpjeH4p8O9SFg0jg43r4Zj-klrGvay1FZlYDgeAA>
    <xmx:HSwKXYftc2VmfOgC17-EjM_xUlWbw4mArCUZ3_GMavLUqwdgYpkBNQ>
    <xmx:HSwKXWfHTXjr4yZFOwIB3OKsPHZ3oDX426rbwgxVaTMhh8aKJydyCw>
    <xmx:HiwKXWBsNv1tXy0phPsPcirtHsnnxKkzcN3V2IGW7ZngXXs_M4Eyvg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 480A5380074;
        Wed, 19 Jun 2019 08:35:41 -0400 (EDT)
Date:   Wed, 19 Jun 2019 14:35:39 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190619123539.GA6722@kroah.com>
References: <20190617.212343.443341561831312574.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617.212343.443341561831312574.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 09:23:43PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and v5.1
> -stable, respectively.

All now applied, thanks.

greg k-h
