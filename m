Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B990B17146C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgB0Jx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:53:26 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39111 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728454AbgB0Jx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:53:26 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 191F468C;
        Thu, 27 Feb 2020 04:53:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:53:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=wxHj0Fq4MNcP52+U/djs15J/lHh
        CM6d+xlBj7QvpwBA=; b=O+8ej+499RZ2zIc+mhbxmt8ULkml1M0i2EZNJD7YHWh
        CvWGAMoXZfr+avyw3aHv7AFWYI0KdGPdlFlp/93BA03+Qt6pyIYFQOCu5LFfJGyS
        WOybJdwztPJroFKfJpNUDDjZk/J22idwGmJpddSjJvrdCVxczAwhD8q2Yu7hxlV1
        kOu/OG2I4ouFe6OLf59r9UI1+dR46oxpYbIL7a72Vmu/RsaboRkpuWEG+DDQ9Kae
        QfOWs4LILqfdBE5FU8OCo6bGf2dpaqJJJ8jLDv881NwNW+fCKFM72i86jmSmPGoz
        oK0MbjAWedXOTasirV3Ftyegjg4nekPfWkWIdxGH3Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wxHj0F
        q4MNcP52+U/djs15J/lHhCM6d+xlBj7QvpwBA=; b=iHyMZoCMciN/yhG63swjI1
        Epg6K+R6saem5xJ0nlBVDHHKqMCLcl5RghNvsbIKaKFAh3WKWSKR21ElzbJkxrE1
        EI3MxAxiFlqjJMYYAGD86gxJzf9C0zmjxH2dc/7vUGKIVSbBDcAJCd1uvuwGQlbP
        VYEgNB7ASierQWpOrL7lmHDu3/muzmt0zC8ycVBpjJ4jLXO6/yuukDFgwHlItjie
        wgFfB5pWkzGa2XDarROcKEXRmWWsPt9xP6tRgCeJYyDI4HPWV9BIwlwjVALj5emN
        pt7BFjjyTzLVMWPouIve7UrK2XVp6pQVYvMDpa7RK3P6TgBXFH0Y7C+11EtrMQ0Q
        ==
X-ME-Sender: <xms:lZFXXs--rJG1QwSYRPacxpQWOFvSgrBgdSlPzgZcd93tVdzFWl8TaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lZFXXnm19XHdGaUH9-xwXeutFRHG_32282MQ5i4Hf-vh2yoOqTXZoA>
    <xmx:lZFXXrAtXgTaLB7n-d6KZtclQxbTTNooFImdA_gmQjF2_UMnyTSL2Q>
    <xmx:lZFXXr-i1NTJMf4ivCaPJ4X9HM_lQZ-Ttm3riAdkGK3YR5aZGoDDnw>
    <xmx:lZFXXslPS36bMqrS7Bmi9n_046Ts99nNbN1txdc_p_KL4cYMQJ7Bmw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EDA2A328005D;
        Thu, 27 Feb 2020 04:53:24 -0500 (EST)
Date:   Thu, 27 Feb 2020 10:53:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915/execlists: Always force a context reload
 when rewinding RING_TAIL
Message-ID: <20200227095323.GC579982@kroah.com>
References: <20200220160319.1919629-1-chris@chris-wilson.co.uk>
 <20200220160319.1919629-2-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220160319.1919629-2-chris@chris-wilson.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 04:03:19PM +0000, Chris Wilson wrote:
> Upstream: b1339ecac661 ("drm/i915/execlists: Always force a context reload when rewinding RING_TAIL")

Both n ow queued up, thanks.

greg k-h
