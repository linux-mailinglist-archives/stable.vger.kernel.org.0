Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAE6B7A05
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbfISNCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 09:02:38 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:44513 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387693AbfISNCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 09:02:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7C14963A;
        Thu, 19 Sep 2019 09:02:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 19 Sep 2019 09:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=rdaXFYORVy3njVAyClo/0JaVH0B
        RSoPGzGhd0DXf1J8=; b=VrmR5bDFmPO6xTxXrPuyQJ5lvHbzQzgVTAWI1o+xwQn
        llj6Oy85tKXNOeJQ7uHyPdr60oriUN/drCw68m7uS/tq3nuW7x9jPj4+AgV8ZjaQ
        JGp528xDtiPlVT2QrrIexaNbnxJJ8VnRPOPTfmNOfQ5QYyuFQUHcini5hUTEFZT2
        E90NHl93LtRFgHyANoqAA7ZJD9A4DvCyZ6ppx2jwRCG3SMwUwocRnYAfMVc9Wjqg
        3c4G0uUWz6mcyDJzE77vSIi1fESwDgbDNXv8B8IeNx7JX76jFVzBpcDtEdYVtUHT
        WVxzTtjkIHDcB/YnqHxqusuEE8PxViScDng5wlngQrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rdaXFY
        ORVy3njVAyClo/0JaVH0BRSoPGzGhd0DXf1J8=; b=DFNhgxbXhdbG31ZlrVVymb
        Zras7SES5bgGPW0FF0Q5EJiEprgedSZTBFKN2xNwXvcS+5Ztfl+FSAOLimjhlveP
        /wLaKPyWfhF55zofcnQ+ApNfrL5xQkTNudVwkvXyM70AH8grbEWmNCKF3b9qVY6c
        wks6SXzfT8uy3CdSr76iJNebiL1guTxLwfNTzMz0Seb4KlC//36w5nMQXtEDXw/n
        s/+EsCqtiNdKybBf6xbXWgUaqkGg8SxDW4TM7qnUQyWOGCF1feHPSotz+JTZxrRz
        Nk7no6JdfIil3OfPnyQLQCDfsThFGABCGPFaAYCODkDnro3IdkeLEdERq6Hz9cSQ
        ==
X-ME-Sender: <xms:bHyDXUiyJLiRnaHZQ6_1K16PzO5uPg5EHeltImzvGn8SZizVCi5vdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:bHyDXS11T65txrnch7ExB0nKyez4NdFFsdg8aXtvn2imgPEuTg-L0A>
    <xmx:bHyDXRJlrKjILosEor7anGxn4KpdBBEhBVw5KFFXVFEaw7f6tMnnSA>
    <xmx:bHyDXUQ7aqqfFSc1MBr2knQNNM22h0SH1ui148BsdeoxgPh1PaGvYw>
    <xmx:bXyDXTANQe58nbW9ZiQJdcu6hQ4gbVzcFnREZm4BjAIU0iPM923L6g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 875A6D60068;
        Thu, 19 Sep 2019 09:02:36 -0400 (EDT)
Date:   Thu, 19 Sep 2019 15:02:21 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190919130221.GA3514792@kroah.com>
References: <20190919.140700.1621589455975591285.davem@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919.140700.1621589455975591285.davem@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 19, 2019 at 02:07:00PM +0200, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.2 and v5.3 -stable,
> respectively.

Thanks, now queued up!

greg k-h
