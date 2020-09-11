Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10398265C29
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgIKJGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 05:06:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44091 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbgIKJF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 05:05:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D5A65C00B0;
        Fri, 11 Sep 2020 05:05:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 11 Sep 2020 05:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=JF+S3kPY2HmoBsgQhe9S1JLsaGf
        7ut/5OC9AOM74jTM=; b=VLdLAm1UDks2hlSwcIkJmXU7AjOcgHlouBhk/zTznoe
        nt3OMkV7LRfocCZwaqTS7j2wrBju8OGhqIBK/TZVer9ZxKJGCNGdznG6LmFI23zo
        CFQPi5gvRzE7f7c36/n2RL9Z2QAhR9q5+Mvpaq7tCD1+Gi2SvtIEX4pJIkldmxZg
        3FP+MDY/h5aW7dOJZnGjWpz7/SVGXTRt+JfMWQm6jbNQXmCVjnOHPW+YWpT6y+Hv
        amAnSohdc9lq8DPhC6VJbzEhXlxTzho+F87iueivD8SzUHF2iy4OdfbXnvbGYhCE
        lniIEfn2dmo6OdyN0IsveTsVBehzJTgaqw9VljCuY+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JF+S3k
        PY2HmoBsgQhe9S1JLsaGf7ut/5OC9AOM74jTM=; b=mhDQXPpw91KL5dqxfKz96N
        NWW4IuiE0DITz02cO06mpJ2dw5XuKG6/FNo//H0euAY4Nv/4TlII96AnksF/EEqw
        Vqu5rSkllmsKroOJmTSRjBlIO0ywVQkyDJgUt+j6oBeO6fr36h82fOEGlMLIShfL
        1ISoJDiDu5TLk1WSFyn0GFZNw67R05NibaaD6i1CMo6LuYxKhdcmxO/Sv6PIpWL8
        rSeyfKt3yd8bR1XbQn5gxkU9OKGwYAJEwQd0e2VaJqMNjwCRJJiTF6C4fsZhWgBe
        NEdSqdA+slpsNEJdZiNr6Lx/ertYCm8rh7j5mwSFPHt5w1mJdIZA+SB+ocad7IcA
        ==
X-ME-Sender: <xms:8z1bX3JUXG0peWsOrGPs_3HLPZmFhb6DBQlcqcIIgksn1Y8wwvDsbA>
    <xme:8z1bX7J8PIG3TD-qF486F6TF2JG3fyRV_-r3VoHoTWGmhhD3VTpwJvdkC1R12MKJG
    K9jv1DUe7V_uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8z1bX_tbQaYYPPXnoZ_gAq6momwFsxEFuAWm59WPREXwDCauCHctoQ>
    <xmx:8z1bXwYYvzwc37RynrprETpjD93V9L2sUE5Fjc7nblUszxDMUcbzxg>
    <xmx:8z1bX-ZiviIUfLTX-7Wd9YFRHI4MS6MQe6kdQH2spc_iI6-8NPALzg>
    <xmx:8z1bX83TvD3Zaqi603b6A0GsdSDsxOPyDYXN5DE68oYPpk3eGUl3_Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D00F73280059;
        Fri, 11 Sep 2020 05:05:54 -0400 (EDT)
Date:   Fri, 11 Sep 2020 11:06:01 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PACTHES] Networking
Message-ID: <20200911090601.GA3593160@kroah.com>
References: <20200910.185905.2218188790669127157.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910.185905.2218188790669127157.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 10, 2020 at 06:59:05PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.8 -stable, respectively.
> 
> Thank you!


All now queued up, thanks!

greg k-h
