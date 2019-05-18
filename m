Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C34221F2
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 09:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbfERHAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 03:00:50 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42861 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbfERHAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 May 2019 03:00:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4D791285D6;
        Sat, 18 May 2019 03:00:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 18 May 2019 03:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=YSpjz4YRnjqLmGyJ87oYpb14qEg
        UB8rCMTxaZ53Pds8=; b=FQRY+lHBXRuLTbRXhGKFB4WRF4fxBC5FyYJ4kA53gv+
        6Cpz2UF3RtucjI49Z+PGJR6MvillUWn4anVllTS2UaDVeJmPY/uOQi8ZxWaEBpfL
        kz4jwuVQxNUOOVayqwtU59rOUMEOEnZs0r9x6Dlyx+NLe2zgEYcsgs5ZNxkebN9g
        msHAB9XoBE681/p69WV02U/c/kCssGHkOZq0xk7jxrLoS9pVSBDk1sDKf44r5XAH
        nTdDtGRV3kG/zhPaJ5OPe9/zFOpQULrxmTncnMYsYylut0CvMoFZ0e8btDjjUPZ/
        rG5Ym3OSSlruCT0n36k+SbrFF6GExuIkmweoIkVCF4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YSpjz4
        YRnjqLmGyJ87oYpb14qEgUB8rCMTxaZ53Pds8=; b=qJNprFgbmnJN4uGRftMr2Q
        d5jLvajN+eSNJk4rNNMXUI4pwv2RFqJ4dhZfzyxvDeRhz1Gy0eWB5p9Zlrz6AKeY
        hT6qgbYuvH3NQ8g/SZAfVMjcQbBMGZtHCFqn4G8ZiZ9czfJC6XHwEO+j9YCghToO
        hwthswGBE0KuckEAebphBNqTCAU2u2VnJ/fgAMXdhUgGCfyUXUsCjj8agEXMAG7x
        8z1EzPu4Hbd8NEZDOJGKy4rMQfeJpmYp5larMK//v0WGjpPMwmPqVHLKUYsGJ1G9
        mE33l4p/C4eM1VcCRyozg/Iq5oOCYcN2+WNUfVyBxt4v8CEZQ8OV+ONQy335W9IQ
        ==
X-ME-Sender: <xms:oK3fXIKDoa-NmQJ424UgHy8bf0yZj9spbgFy98pazfIKVeJlsw1mRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtfedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:oK3fXMa_6HxUnail2BiEPzeewTrOmbhQcPhKqoLZFOYsszyU8W83kQ>
    <xmx:oK3fXDt4mIvkQWKunpSpAKofRCRXikVTZe5fW1uNH5ElOiLtunS3Og>
    <xmx:oK3fXJs8U3sRgpLcEFWGCt0-mr7yvStZLrbph9UVJX3pT1mJeoy12g>
    <xmx:oa3fXDPzHtTqav2O4nnuWOfaHRVZBltJDfj62xthEvSwYBEw9MNq3A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7399680059;
        Sat, 18 May 2019 03:00:48 -0400 (EDT)
Date:   Sat, 18 May 2019 09:00:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.4,4.9] crypto: arm/aes-neonbs - don't access
 already-freed walk.iv
Message-ID: <20190518070046.GH28796@kroah.com>
References: <20190517174458.93755-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517174458.93755-1-ebiggers@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 10:44:58AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 767f015ea0b7ab9d60432ff6cd06b664fd71f50f upstream.
> [Please apply to 4.9-stable and earlier.]

Now queued up, thanks.

greg k-h
