Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4941BC40A8
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 21:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbfJATIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 15:08:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51879 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbfJATIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 15:08:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B7A2224D2;
        Tue,  1 Oct 2019 15:08:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 15:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ZOYUPCV3y3+2TOk3uiVikTX9xcw
        WOWtnOH6tES9qZcQ=; b=I5RQpO79sn1EzExMjMEKLjTgRGyiX6T+OqTQ5/36giy
        t+ho0JDCs2khsVffvIDKHrLtoBjalorRXG5NgDzJhEpi+GiGuukPA5fN19QUsYrp
        0O/3py2yIZgRj9vFHL+JBLaD9v2jrjQXRVvGgGg/ACJw6QWrjlKjUx1iiq97y4KN
        FFktX7VkfKozMv/4VsiJOJMIwqzPl9TeN/OV2XiwRcLBf4H/BCtb8V5rJCTvmACX
        j3Q6hyqTeCObtVH7DeuQu5CZOZULPPY1KQ83PWLEUCI4JMEzUrPj3QHFFaaQyvOX
        8CndJbA2plPoUu6rXHwXd4dirEDZr06PPZt93f69dXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZOYUPC
        V3y3+2TOk3uiVikTX9xcwWOWtnOH6tES9qZcQ=; b=OCfOhxe5lATYhavLdlOY9x
        Z840DIWvidpA1utcsgQoJgAebiUqd2wDUDDsbY5A3wKBrlnaYJDvV05RsL9/LFHr
        st/kEdkFkHBCVz5VAAfC39X2CDK9DPyYYBvZCuqYaKxexvhRk09hJk3/6I66D1vD
        M1rGzln4di5XZMyGVOzpSIS7XM4T7WYF+QwPJUlX1Lgv8yFw4PDA6JPCUG89Bxk6
        txhYKGWdWYPRz2jBwnHfwE9nemf59i7KGdNSnzUrtXPQAobRpgid1THEaBiH8K7Q
        DpQ0qSfboTIbpA2V90CQ0MyYzXFMr5wrfbQQakLiOL6EIe0yWjrfT8zWvtb4J2mw
        ==
X-ME-Sender: <xms:GqSTXQnKIpqH2vNzHC_9q23Ed7fI5cBg6wP7GG1nn1vbJTGpjT8DZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggddufedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:GqSTXYR2YzmFjPwcUW9_Ld4zwN0aX5yHHZkzZYNdUHFFzn-kv7g6Mw>
    <xmx:GqSTXfF9cWlESA6TeAF47-_BZ0I-1GMLUKdW5ugjlGcVU4prKZCjhQ>
    <xmx:GqSTXdH0GlsWGBK31GmkEXU1yxeB5zyjCXYnpoXcnuoh8Ef6OhlvLQ>
    <xmx:GqSTXZZ8Ng_VJaTi6jqTb8v8v15Z4EubnC-Zfdphm8b1RAGEz7Lt6A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE04580063;
        Tue,  1 Oct 2019 15:08:09 -0400 (EDT)
Date:   Tue, 1 Oct 2019 21:08:08 +0200
From:   Greg KH <greg@kroah.com>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: dts: am3517-evm: Fix missing video
Message-ID: <20191001190808.GB3856882@kroah.com>
References: <CAHCN7xJceePOGJW9UkPpe139rGx9vdOYkSd2e8jGoM9=TaoSCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xJceePOGJW9UkPpe139rGx9vdOYkSd2e8jGoM9=TaoSCg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 01:17:45PM -0500, Adam Ford wrote:
> Could you please apply 24cf23276a54 ("ARM: dts: am3517-evm: Fix
> missing video") to 5.2.y and 5.3.y

Now queued up, thanks.

greg k-h
