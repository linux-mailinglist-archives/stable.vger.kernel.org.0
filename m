Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAA91A442B
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 11:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgDJJEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 05:04:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42537 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgDJJEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 05:04:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4A9705C0216;
        Fri, 10 Apr 2020 05:04:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 10 Apr 2020 05:04:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=yl69GJCc9Fg+3Dly0WaT1jBhxeM
        LKjHCjpmcnWnXEHw=; b=Q9EIwDvbjLFSsUFv1kAZq06sdHdm7Iao3GltaFuXYn2
        W6vgkXy0Bh2McQjHCY9K6yuJSfEPzdLrcVNyjqovimwS91tmP2DB5GveG6Z4INdb
        NnIa6ogiRb8+mSyT+x4o6zD1foQSZtvqxppF7KIpLEjYduqJqGkvBFWiogWyiTzg
        EYtoLCUDARAvH3Y9OGMS9mi5JltmVxBu7rWcrOG2VWQUbtvESFE0kryRPBewki3E
        UgFaf983jYxgjmPKCHHrE7zDRvDP27hvzE0lUITHVUPhWjC55XMRuei1L25qITOu
        mCbWWGxAudI7WFwaKWc3tlOAUMquntdme0D/YmH7+bA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yl69GJ
        Cc9Fg+3Dly0WaT1jBhxeMLKjHCjpmcnWnXEHw=; b=ERB5XF0HXDKTq8+5/v19li
        E5GKr4jSwxb1zUGqai/v72RfILH0ltctVsQSdTxlR8Hykuo0m2V8QQN/XHScuNae
        VfDu8Sg6QPLiJuDfj8cr0QONwjT5oSij8zWRTtd2BBIMiNgHkHEQ4/DqhrtfBlQf
        5jWlkgUflEQ3D5DMgwwVpyydxi83XOeYw3RE13fDTcI8wP4kb87RLcF6B6G2UeQE
        YgDqaEwYaVgawhYOSovK9ns+jYy1YKGi3NC5TGR7JVdLW/+lkq+E17VkwARuGBG6
        9TnWJOZTD9RXO8/ApQx5c4J9dRHDrbzxfi8yht+80XzB4c3dbtxLEAIoaijta5nw
        ==
X-ME-Sender: <xms:pzaQXkst4gk29N_4Bk6_5Wh5YfPbRSsQetPOse6MzXUB-gRNgaY6yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvddvgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pzaQXppn0g_5gp2lqGpmKgrFh0WYBpACswwpnbft7w-2_RJDc7NEog>
    <xmx:pzaQXlpnQunBimxVBBYNKJwul0HVePoRtYFd-Uk1bFVTegLUuSHYiw>
    <xmx:pzaQXgTc6u8hcuZlYszFjaAp41R2S3WWr0cGeQan6tQTmvXwNJ5iwQ>
    <xmx:pzaQXi-XtmQ8zaR9lCi5OI_yYiStT8qZeoSY0ir9o3CRQRGi8jrp2g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9D84328005D;
        Fri, 10 Apr 2020 05:04:38 -0400 (EDT)
Date:   Fri, 10 Apr 2020 11:04:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/4] backport request for use-after-free
 blk_mq_queue_tag_busy_iter
Message-ID: <20200410090437.GB1691838@kroah.com>
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
 <20200407165539.161505-1-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407165539.161505-1-gprocida@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 05:55:35PM +0100, Giuliano Procida wrote:
> Here are the patches for linux-4.4.y. Untested.

Can you fix up patch 1/4 as noted, and test them before resending them?

thanks,

greg k-h
