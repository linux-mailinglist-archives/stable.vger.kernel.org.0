Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E542B1265F3
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 16:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfLSPmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 10:42:11 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54609 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbfLSPmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 10:42:10 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B64BF6EC;
        Thu, 19 Dec 2019 10:42:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 19 Dec 2019 10:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=CwxePWmK8wkNHoomtKemYunZdwl
        dy77H9hVCVfnOpv4=; b=T9AaKuHKNRCixbNVxz/e4jTr2+glM4ij1XvF2sRINY1
        Y6NhZcG+wYUOOh5MvqvUp1H7Z3c5l8MUuBi6IktEtszPcBaPZrX+EyD+nbPGYnvo
        KS5vnEvNQ3G87RuWNUyOfbWprWfNz21vgEQp0PGc91DSKMq3F8p9yKM4Lgwn/vc6
        fEgdshL1/NLtOyfn+k4qfzHjX+yxcxu5JuBaIh/6wTL0Y72lWXbGQhyLuhURQg/E
        MpdbwoNnpIgVw1sBpqvJr/dwbLRuKVcd2X4hf+Bqg1gQ/mbU1SiFYhKogDz3qbkz
        Y7xXEiGppBeGJATAngWL8w3H5kuSiOVLfhLfYBXs2VQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CwxePW
        mK8wkNHoomtKemYunZdwldy77H9hVCVfnOpv4=; b=iQiIYl2p/XfF8oxE3qBc5P
        Qn4Iht3UKKpT0FHSplDGmYczGZGOX6YZIUWWA9hzrVnM50Jru5zS5oUTmwKlCo3X
        4oX9ELsTJNvP6w9ZOhdO9OlygqLo4H+NfhurqvxJYxBFS0szNVsLEvWXA8o3UnlQ
        HPA5F4VvXBXa8IBQh20yP8Z276AQNjndW/mNZ2lE+7rFayEIOhuzshpRpWP9hm7e
        Rj24spZFWk6HB26yep0+47YfwWpUzAOnxJ9MTR8Mw4XyiEVfo3bxITTiqgyUW8IE
        hdb70Bs9tRWwGzd+QEetN2O8lB51CU1wtD2zkyaa9D4IPdzjzgX/CU/DzvpwnXew
        ==
X-ME-Sender: <xms:UZr7XSkLq9GuTXCkLkr6CNqlzo24ACG3mM_trjfD8Z4DuRZYXThCEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdduuddgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:UZr7XSrTZtSB27-mr0tujKItWWBQCh_Na86dEWB1GDzmmQIweKYb2A>
    <xmx:UZr7XW_toHvi1LBYm8EsQSy53pavwz1C64D8uHE4lnUbl1w7W_q77A>
    <xmx:UZr7XdNHt042m7HTZvt9tYcsV1Pst9TEffG1VIu8nh4X5xX1g3_ZFw>
    <xmx:UZr7XVkfML4mb_vWrIAjQrLKXtMDYOXxW38JetXwP0VWZXYnkauetA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4AD080063;
        Thu, 19 Dec 2019 10:42:08 -0500 (EST)
Date:   Thu, 19 Dec 2019 16:42:06 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191219154206.GB1969379@kroah.com>
References: <20191216.141009.1431387601178097325.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216.141009.1431387601178097325.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 02:10:09PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.3 and
> v5.4 -stable, respectively.

All now queued up.

greg k-h
