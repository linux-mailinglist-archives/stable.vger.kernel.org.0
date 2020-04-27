Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6324D1BA28A
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 13:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgD0LkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 07:40:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40533 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgD0LkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 07:40:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F7FC5C010E;
        Mon, 27 Apr 2020 07:40:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 07:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=e3XCdztppkm3SsvKyUHfrf5XXgW
        T9y1jZi2gf+uJbnA=; b=n90CU6Xx2ZNCGVnwEoIVuJ8zRF9cVF3tNzWC/cw8AtJ
        31sRelyf/Uif9lup3vkWrnTTmuQJCZdFLnKCSkH7i3ZDt8CtsDhLxiP4zj6SapiD
        4uYhCWKXrmbZXleCUs5HUHNN3RdGFJdsJc0Mg5jUeZ0EgMRf0seOShpzszLakOpu
        sQWTO69YF32f+W5KHA/MQN9z4QGIE2NSPKoMLpMwdyFxu0O6As665tm/KWXq/Nm3
        uOCpXsQN8bEbMYaEo4pPhElI0CdoXhO3bfgtIoCkJWAqHSnHyO+FRi02BFjnPisD
        +kDnF87bsYrwYtToo/OIQqtcr7gCkS3EvLEc+TBciIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e3XCdz
        tppkm3SsvKyUHfrf5XXgWT9y1jZi2gf+uJbnA=; b=1TxVDVAZ2KDNZXCjg+iLN3
        xjdnjekhZ2OY+ts/x3rZJk0j0PU5GklwDo/B8t9PzyV+ofFQnmzj3OsATZNy4QXe
        qy+SoIhMT4WtUha2fL6gFK1DtynzDOuPSShDNhP/0wu6ITnaR8olimmB8aV8Zp/G
        0DqL70Qpq2UCosXnpe8Lxta4cKQ7l3hfIEuR0yDk+tLZmKpTPRhYNbmk/Jh9WAho
        5DIuyuL8BiDsxFJrjbR7jk7nV02y21rv3U8CAUWhdjoGNEuoexpWYsmY2VByJqFt
        ZNlxrg3EDX2MJz5yFKR/dZCutvlT+hWMfpT/OsdP2scB6VkEGT9rNMHqIBSa+YDw
        ==
X-ME-Sender: <xms:nMSmXlhskUA7VLIQZBxAA43x-KnnTI0PiwSACPPnqAi6Nw173ISjCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:nMSmXsTdplOvzRN0SCtm_C-Ddgwl8JrajCTRR3in8ITsCleHkXdozQ>
    <xmx:nMSmXlKjORCQqOARMLq9ZDIkMf4YQOoFpq7MbfkmEltG1nV0Bm-Xsg>
    <xmx:nMSmXjM8j4ke1uqjVm-QkK3qXr4qeFwE5lvxwRDbI7xLczDbYzu8dQ>
    <xmx:nMSmXvvx1I4sPzRLXU4cTGjJ2R6CKP0EuSA1egBr9cZrP-V_1WW_6w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3747328005D;
        Mon, 27 Apr 2020 07:40:11 -0400 (EDT)
Date:   Mon, 27 Apr 2020 13:40:10 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200427114010.GA2533191@kroah.com>
References: <20200426.181046.1756266788444278379.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426.181046.1756266788444278379.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 26, 2020 at 06:10:46PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.6 -stable, respectively.

All now queued up, thanks!

greg k-h
