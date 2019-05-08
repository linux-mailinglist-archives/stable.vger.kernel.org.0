Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C463517513
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfEHJYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:24:13 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48141 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbfEHJYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 05:24:12 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id ACCD02B2;
        Wed,  8 May 2019 05:24:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 08 May 2019 05:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=BmvGOTAi+9LRQ5jfHYVfNTSjRYj
        +62PCwxWHv82du/I=; b=EGOssfkdQd7wGZPAMw/MYCr4gacNCYxY3kyVOvF3m80
        hGQKAujA1wcOv+O5eRLg1D4mU2AomP4/FvFHQsnYkEH2Hvf8W2grDbbM0sQG5qaH
        9XC3jxJ0n0CRfMdRJDYuIDLHtz2PWRWPh16d2APowywjwbdvps2fHbnCRYoHMvcM
        jarDGK+wO4khY/qg1gIlO0//81r55H6j5Cme67d+VimlWvB+gXZNhbIVh21MdNYC
        q+VtQ4jqyX9wpur/QqSNx9Sf/tLTLc4qedRcLy0d7ryQF4Ctwb1565ZM7xUOwR/+
        VqXX8nkk0yT3pOloHBe2N0h3tCjcFZ58tz4bxVXF7Mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BmvGOT
        Ai+9LRQ5jfHYVfNTSjRYj+62PCwxWHv82du/I=; b=tRjU7PDjJa+WQwN5j/n/c3
        1xeO6Pigr5i+fD8SCBnpZCUL6ZW4SHTtS/HrgP3E0RpDrlXoO2LMIcxLx/A3EsWx
        fGXTP6yjKQ1A8pSOStOrL+ryJLa0LlVPULrrNRGc3soPpMtAySWsCP8dUKfFTVGC
        zyL/GtkaC74SoPNLJ6Zjpe+w47F1xwICFcl0AZcQlwtEzqi6WO6SwirEE1cifNZ5
        QLm+CrTEjOsQNRO/AutbmA1bEYpLAlLvx6ektVZqVaavZWxIT8fALXXH5QoI43L7
        zhiX5ZMwlTfwImMO/fPJwTqTTHXWaXNkOQpB1QVgBo7NjkWr2N2UHI3C/nyXnDRQ
        ==
X-ME-Sender: <xms:OqDSXMSLWNalFshJ5YQ85EysQimoD4CeNJeyXRjAqxo3tIwB_rYOxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeefgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekgedrvdeguddrudeliedrleeinecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:OqDSXPX5qFUD337sMOTbO-x0IbaEUaGgf_-6GNJmzrENh96rzRnzbg>
    <xmx:OqDSXDYTskHTpCIk2wPbublsuQe0gqWQ3-Wt6UQoXKjGdOwQRGr49A>
    <xmx:OqDSXA7wYl9dT8of75smTlMjP-1ThXmVW6dmNyQ1h1zMPnG_9N4kdA>
    <xmx:O6DSXGgGgW29NYyKPpvnjn1MKSgYhs2iGQIMbq8ynyQ0sYW7SjOV5g>
Received: from localhost (unknown [84.241.196.96])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CE4C103CA;
        Wed,  8 May 2019 05:24:04 -0400 (EDT)
Date:   Wed, 8 May 2019 11:23:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Yihao Wu <wuyihao@linux.alibaba.com>
Cc:     linux-nfs@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, stable@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        caspar@linux.alibaba.com
Subject: Re: [PATCH 2/2] NFSv4.1: Fix bug only the first CB_NOTIFY_LOCK is
 handled
Message-ID: <20190508092359.GA2361@kroah.com>
References: <d0b6fc01-0a73-e4f7-b393-3ecc9aacffb0@linux.alibaba.com>
 <2a1cebca-1efb-1686-475b-a581e50e61b4@linux.alibaba.com>
 <cdba66b5-29a3-e37b-1e0f-808c171d09c3@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdba66b5-29a3-e37b-1e0f-808c171d09c3@linux.alibaba.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 05:15:03PM +0800, Yihao Wu wrote:
> When the first CB_NOTIFY_LOCK wakes a waiter, it can still fail to
> acquire the lock. Then it might goes to sleep again. However it's removed
> from the wait queue and not put back. So when the CB_NOTIFY_LOCK comes
> again, it fails to wake this waiter.
> 
> Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
> ---
>  fs/nfs/nfs4proc.c | 4 ++++
>  1 file changed, 4 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
