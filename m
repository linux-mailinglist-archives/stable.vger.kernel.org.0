Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE8D1051DE
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 12:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKULyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 06:54:46 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53927 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbfKULyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 06:54:46 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1E2E28FE;
        Thu, 21 Nov 2019 06:54:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 21 Nov 2019 06:54:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=gPqNd2js339z+vnDKsNl5qKWN2o
        kRp0OlfYtbvWMxfY=; b=ZCyBdHfkW38W9fNg6BU/806wjR+qrSyqU2fcyqY7abn
        fcN7vAG1G88vPsTUaEP1wOWo2xaOf0KDYm7sYsmVXzcliDwdc1NHZwwDFxFBdcjN
        AP4mK6SgCkUXnxwW+4k0eNtuFdvjd4L3ntHjFmEDYAyp9gNgXQWQPHdTFhPtOQHg
        Z6e8blDNc3YKZcWsX3Z50uMzS7rSDGq2ttQ+3jA8nRrusMgk9+tKk7KVbfKQolk5
        r1FA1XJaCQkxbNykZiqSXInICt72yvGCqc4RamDYh9A2eyVDDhV6h4nhBAz5yE1O
        vPCVLNM9d0iRF/6NAYoet56CkuUQPlsS1oO8zJIHVcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gPqNd2
        js339z+vnDKsNl5qKWN2okRp0OlfYtbvWMxfY=; b=oAun/aEKX/9aY3L10NJn8T
        HhKDaQ9BH41L7NtCWtfrA8KJ9t5NkaQ2tSZ5JKIK9FasUTN8pI6ercU12Rl9/4eh
        vaofvfYvIOC7FeKyaH9whDosRXVs4okIjH3pfV4O0SWffmzFxYe5YURCCWEbkG6f
        +DzWl76bZKiz50kdNGfl42AkE1Rkb2aHKW6FLPav0QtQh/PwXK2xjhSmKlDSTBPQ
        /M89TM01XTbU1FdTWbeJxhM7uWMQuFXf0eAJToSx4QAl/TIN4ZF645sBHa/bltlm
        BMN/1j8cJqasgwx+xNmt/0Zho/jpHBlHIYtZPncGcls8F0S8DnvHJ8vQOOFnu4zg
        ==
X-ME-Sender: <xms:BHvWXQ3R6CcQumMNaizCIWTVGW9ZyspOUIW6m3uptA-qpPlF4TRORg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehvddgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:BHvWXVy2mwbbR2ljVUacaW_GtE2YZlmjR86zbKgeM-sBhlnDKAi8yA>
    <xmx:BHvWXRkXdUgEaX8SpXdp5-i9fVZNv-t03zrTRajpwWO33q8R6C_w-A>
    <xmx:BHvWXQ_unL-vjhhQHd9uE7mTm_GlUuCPaTHnqDym17wqXpEmqx_SlQ>
    <xmx:BHvWXeF8xnXUx4RF-q5JwgbLuGYg0ugcl49VIN7r332UK9tdi_R1Pw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0029380059;
        Thu, 21 Nov 2019 06:54:43 -0500 (EST)
Date:   Thu, 21 Nov 2019 12:54:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Yama Modo <zero19850401@gmail.com>
Cc:     linus.walleij@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4] gpio: make the gpiochip a real device
Message-ID: <20191121115442.GA428835@kroah.com>
References: <CACgcjHEHxzBkiE6hH3OEUw6V+PZHX7MAKht61OZPbAyAVRDQiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACgcjHEHxzBkiE6hH3OEUw6V+PZHX7MAKht61OZPbAyAVRDQiQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 07:47:37PM +0800, Yama Modo wrote:
> Dear Linus Walleij,
> 
> I want to backport commit ff2b13592299 "gpio: make the gpiochip a real
> device" to linux 4.4.y. Could you please review the following patch? I
> will improve this later if something need to take care. Thanks!

Why do you want to do that?  What does it "fix" and who needs it for the
old 4.4.y kernel tree?

thanks,

greg k-h
