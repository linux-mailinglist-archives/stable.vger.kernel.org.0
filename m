Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EA61FAA3E
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 09:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgFPHoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 03:44:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34267 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgFPHoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 03:44:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 6F68A5C00A5;
        Tue, 16 Jun 2020 03:44:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 03:44:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=uqKf1MVvUa+A1sK7vTPbXqAWtlM
        UzkyT6RIds8db5Ew=; b=cvHleMehRIx/7zQ06akHrefAiSVxHSyW5jXrUu0CMYT
        0g8Q9v8XvEvvEA7zVHcSwO6GSvRMjJwyIwkhm0UOrW2hFKzgO6R+b/sdoXH46IUE
        bREgu7LRcEMh3YOuIfLsMOkPqtY/CGfZwociy3HAQsToJZsuAuYkzsnxTl8jvPx3
        RtbaTHoxcm12MLM/R2OYUjss4iKb6HUi9LiwtAs3f3GDKJOdfQX0c7v+5fNkSG9s
        14eE7wZdnOqp24d53QOwR8SnCVw3cZgcm+/RAk5aC5N8QQVUWve7KfIcZfOmmqjD
        VsJc3kwJpmZXR/0TJI7SKzc7RDQ90V88mW5airtoD8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uqKf1M
        VvUa+A1sK7vTPbXqAWtlMUzkyT6RIds8db5Ew=; b=OHngr8u/x4FUans/nrmcnR
        iMW1fTx3bORhdiLvTurOT1RPt/a/UlMAGgdTU9cdPoyIPK8xNmGse1KHUP/bINOF
        JDtr/9ouT1hi6VvhTcxyWzProOzFK86oFY6HdqOD/tKfPvH2gB54MBSZisKyJzrj
        pDi8LtJzdd1Sjp1JOoqvXBUdRyO/dPP156xji0nElHGiZgeP8U1NJ6KR89L4PcZY
        lXzX/PEl3opQT0ngq6bZ6nX+iqkUxb4ZroM8sGAdHvs51yEwpBL4uNQ11ehgqJo2
        T9Cw6ZJ3lUXPiCx1TvBHUlE8WXtiQ43ed06VtSPdAX7Fzh3FY6GXENf3AOV7XQ9w
        ==
X-ME-Sender: <xms:UXjoXsphXe2AE1-aXqJJfWlVEi7Q_I4N2FDOPIRjI6tx-RttXMg1YQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeiledguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UXjoXio7zJCdCseBmjFgfkqUf9QnbRKGi_0KdTp0Dmri6Kf8yu67hA>
    <xmx:UXjoXhNFNRIFMD4tPZmMf2bzpFr5W84zrgjE8ZHiEKNUIuwvS0r6dA>
    <xmx:UXjoXj7nJAkLQcD_0y7mN-wDrW4S1VIi8KNS2CKzN9FkLBWCy4VnOQ>
    <xmx:UXjoXtF7SL29yVFd5M6q02OfFPfNvfnG-QSbVA2MI2-MK-jy-7DVDQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD5E030618B7;
        Tue, 16 Jun 2020 03:44:16 -0400 (EDT)
Date:   Tue, 16 Jun 2020 09:43:56 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200616074356.GA2253721@kroah.com>
References: <20200615.182706.1005238769928076763.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615.182706.1005238769928076763.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 06:27:06PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.6 and
> v5.7 -stable, respectively.

All queued up now, thanks!

greg k-h
