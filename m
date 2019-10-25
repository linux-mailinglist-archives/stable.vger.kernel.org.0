Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7552AE413D
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 03:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389409AbfJYBqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 21:46:15 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41811 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389344AbfJYBqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 21:46:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C285621BBF;
        Thu, 24 Oct 2019 21:46:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 24 Oct 2019 21:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=r6eN4XO9JJEoHBGm+ZD0E1bX3mP
        GcRauy2mPzjH+360=; b=dnQROhbo/Fg11jglD5JNIuxTG5PHIpn+jNUNnS49uPG
        2tUy1br+1a7mXZCL5CSS43X67QwPjfoPKXi1WOIwf62qJyHUnhWuD+vkVja8icvL
        BbJzo0v1h/9rZY//JHZcc8lnmnQrnSVELIUc4UCImQYzFuU3q1XuXvvYDmzZNSPY
        eJQwK5VdPbPkdN+olmn79WzDZ0hClE/upsIsW10WD8H/RycWlt1I8cEnPg4/in4r
        OT5Zx6rVY65mUCcI/6CvP+exHI7TBYQqPGagNO6V9U6X3na2ERH9zo5Yce726LsK
        gLsQrX6BxsTQN5a4PHh9xL+fE3PirB0vM41+Bybw59g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=r6eN4X
        O9JJEoHBGm+ZD0E1bX3mPGcRauy2mPzjH+360=; b=loS/+k8G2LMzJIRQ0vbvrQ
        JbgHtuGUr8vm7U5ITBlV30GaO2w/MLfFMFqhWrpEQjyc9PK1JpAC17eaK4MP5lcp
        CasMFipTOKfvh4LPkG+mJaH6JOVv3R9vR7QbHCPLbezgxAHw44xf+64p4pK5ukc4
        3Uh0CFCKOjdZ2pgWbKQyzPZ6ypuuIz4UMXt+E51eJzChxWcRXdPqdAAW3ARegwC2
        uCIufTf41Jc1GxCl+W03BDmOVDu1sRmasXZ3RpfW428Dsa9kTD4A5MNxsmH8Pmoh
        o2rN85V+oH9fmtBqp+VqQH2vyIweTAJEy3ehmj1njdboz+WTFAXjaFBmNjvMaW2Q
        ==
X-ME-Sender: <xms:5lOyXdWMRlkGVpTtinRXOwG9FRDcW8MXtJEMCGafwrRY42rQoClTRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrledvgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepfeekrdelkedrfeejrddufe
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:5lOyXR1KEpFPIpdAKMKpUluVif5NUtPkqAc6CuNCIPjzActgj0jmGA>
    <xmx:5lOyXUaJxm0Bs9Phy91uYXwir3dBewLllqqbghqoGOkxrJXcTp6JAQ>
    <xmx:5lOyXUpgZGwJTrMV8HypZu8TZty8jY1r7jgbsk3pdgeMbzCv_XH2mQ>
    <xmx:5lOyXUiQ_tpPSfn_5tJ_RhnMwFEKxn-NRYXcfpYk-8x7Q1c5BCG2wg>
Received: from localhost (unknown [38.98.37.137])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B16F8005C;
        Thu, 24 Oct 2019 21:46:13 -0400 (EDT)
Date:   Thu, 24 Oct 2019 21:38:21 -0400
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191025013821.GA276472@kroah.com>
References: <20191024.143018.729229159969899587.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024.143018.729229159969899587.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 02:30:18PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for 4.19.x and
> 5.3.x -stable, respectively.

All now queued up, thanks!

greg k-h
