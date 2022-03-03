Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6C54CC090
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 16:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbiCCPCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 10:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiCCPCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 10:02:22 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1775C18FAFB
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 07:01:37 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8E0033200C6B;
        Thu,  3 Mar 2022 10:01:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 03 Mar 2022 10:01:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=PGIAXuxUDA7oqwwwXukmd9RORgRPlXwEI6vQ36
        AAWTw=; b=OCBToIvtaKw8XDBpceipz46ratVZUqRddZGnDtWvTO8zEyOuV0TXu3
        a0fe1Q6VtR5yqo10Fgx4HC26P92kIpYZoXQUHil/yZnhluzYIAWIVXS+1pN31KBx
        Bj7OOM83jLVeGiqYyF+p4VmV6734EoYNdBEgcLoTFsyVgxj3wdZsaKlzDohWJbrF
        LZyloaSd6DN97jOy26rxohxIZnt4giULuxprM7tESEKfKtK3VbXUGQpTL165/FOc
        FzpL3s5xZtrTkiKN2hXhAAlNdzeXLIPAiH3TJ9HyHp1v3dhNRtYn21t6IkXwQu4M
        firEPT/KDyhTURdYcVIuhDu9XCgCow4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PGIAXuxUDA7oqwwwX
        ukmd9RORgRPlXwEI6vQ36AAWTw=; b=GvTqCY2xIhJtKOvqnDJSj1GQAue9HqzSX
        mLpxuDtfN9oBrA7WajPzaZ/EsF/ZuHeaSyvQLO3xC23VUN/nTjJySMk0rf6FUN6f
        j92r42BRxlwS3v44X2TLlu8sBNf+jjF6yWxz4jO87etLLSAE3MdashM9wguXyon5
        dcUf5lgODLWIRRH5FeE14JJAOUOWg0YnBRgFsjnJNkBh4dPYgbmybhyZdvY7Fs2G
        sSbbVE6V/z+qUwsWa8tlh9/Cuy9Y/mSUszgjzrgRTEUWxkCyzO1NsigD+EkXcZZy
        JwExNSkPjvqDH5jafs7UEmR5Wm4pg7eEqWe3t26+QJykiwoKc0cUA==
X-ME-Sender: <xms:TNggYjl19TJO26IcMgwZFHY7XQzO5Qctlk_p5xdOEG1HtkOtps4P_Q>
    <xme:TNggYm07VgB7ZA16bX8G-7e3eb2xebrqP8oCCMvkNC7jSWm77zIKYvLl4feuHxBMk
    HRVqqojaJDspg>
X-ME-Received: <xmr:TNggYpqT9-PRNbBPktl42GuCgAq5aGR4tgBuOX6q4IsRmoanQa-fI-wCXvENBeai-pKE9Vr7oicOMaWfXMLBEq8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:TNggYrmg4WHpYT0oOetJvpsrLmWOpvjHEiUgmdcwHR39BUmEboXlnQ>
    <xmx:TNggYh1pRzjAizkgobL_IywX5rXwjuQjjZ97Gv6I3QQv_mq911VSDg>
    <xmx:TNggYqtreqyd5zE6vAHUIyUCHqoPt8wa4hXL4qWfzXRflT53_yQyUQ>
    <xmx:TdggYrqafgSGbO9mZkHobbM23n1hbYgPPj_wApAF92W-pC0-8F8n8w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Mar 2022 10:01:32 -0500 (EST)
Date:   Thu, 3 Mar 2022 16:01:30 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable <stable@vger.kernel.org>, Hangyu Hua <hbh25y@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [stable] usb: gadget: Fix potential use-after-free
Message-ID: <YiDYSj8XaFdVH/1S@kroah.com>
References: <a4e0a5446a231fd67d1881d68047920918f1be65.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e0a5446a231fd67d1881d68047920918f1be65.camel@decadent.org.uk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 07:47:31PM +0100, Ben Hutchings wrote:
> Please pick these two commits for all stable branches:
> 
> commit 89f3594d0de58e8a57d92d497dea9fee3d4b9cda
> Author: Hangyu Hua <hbh25y@gmail.com>
> Date:   Sat Jan 1 01:21:37 2022 +0800
>  
>     usb: gadget: don't release an existing dev->buf
>  
> commit 501e38a5531efbd77d5c73c0ba838a889bfc1d74
> Author: Hangyu Hua <hbh25y@gmail.com>
> Date:   Sat Jan 1 01:21:38 2022 +0800
>  
>     usb: gadget: clear related members when goto fail
> 

Now queued up, thanks

greg k-h
