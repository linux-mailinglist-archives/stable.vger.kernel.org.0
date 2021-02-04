Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB52130F7AB
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbhBDQYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 11:24:09 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37983 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237098AbhBDPGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 10:06:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 74D375C0197;
        Thu,  4 Feb 2021 10:05:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 04 Feb 2021 10:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=XAPF9FBmIXeDJr9bYFXnsQFEEzY
        4LEyNqEnOtiA+vHE=; b=R1xflX42E50MN84SSAEEBJ6IT7D9S4iGQ7AXV4KpOA/
        4QZOUIPg49Cn2/3m5voMSAGaz83hk7FZVpKfzab/pv3C8yBBRtwaz8ArlK6RLInt
        PrS1m6qoN5rYRLLSz8nmdp+pW+/u2UMH/TP08VsBnpTLgYkZGACN0xrj9+gX13Q8
        w1gbtyQznmCdx5Tt/SaUjED4uXd9wPlpCp50YYvRgc12fP9f1vMjl7mSkKj73Q32
        In9FwsqxBIjv99tiuiaEfq6xLO3xR/a/wX0JCZsCUnGfFb17WBRUG0+8w4lKRQQ8
        IAJg1+A2vAK2VowXl0CDaleXcftNOEmfzkd1G5TGFkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XAPF9F
        BmIXeDJr9bYFXnsQFEEzY4LEyNqEnOtiA+vHE=; b=AFElQIx4LYNR5mKXMtgnyr
        6W8BkMbn5AMi0fSiFpT2bmEJzvUzJL2ghIOwzkQzPwXoVNX66n/5nQDsxBLQ1jlV
        Vr1JkCFI5FrSIQXHNkVAQRvi8ObQEYuMTG/jD6sSQudLog3t/N7fdwpyjUkLUqJs
        cp48Kl7Dq8eyTy+FwqVydlb+SAYFoahZtu20IKVNMKxWltxfjEN2cCkTr7LKQ5Xp
        nBVJouK1nMuKE2OV1DifGBDkroCJ9iITGz2bPgS57ix1EUgWaxslKHBs1+HEr4xq
        tJMnPoC4m8Y+xf0dgGg3nY0+Ntl8tNtnVZsDU4B+CWJnv3jDpULlPBTb8gMQJcvQ
        ==
X-ME-Sender: <xms:LQ0cYEC_DCxk0Cjask7vX8Qurp7nOrIM-u5yDJYlJFmkevqMjmuVIw>
    <xme:LQ0cYGgKN0zpXfkyP_gfiZfqPiWApRArtr2DFSgvU3WTtZQ-m6N0xIhMTmrPPNGnq
    90FjbLndhdEsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeeggdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeen
    ucggtffrrghtthgvrhhnpeevueehjefgfffgiedvudekvdektdelleelgefhleejieeuge
    egveeuuddukedvteenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LQ0cYHk2CaYycfMaQiw41uMjBSn0nQ8fGd2Z6-OS2GcVWn4uBIHbYA>
    <xmx:LQ0cYKxTTGPSRetgYfyt4H18nCsktd1-BAAmvFdE7rFlF4bMf0_jtQ>
    <xmx:LQ0cYJTsf2ED8lXVWmw_bAXXOaDPpswHPBy9kZVio71_E_ypPshCIQ>
    <xmx:LQ0cYIKoATy5xMt-s_OGRVP8Y48QnuhxDGbvd84svOSFDmV4mIOHng>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B34B51080064;
        Thu,  4 Feb 2021 10:05:16 -0500 (EST)
Date:   Thu, 4 Feb 2021 16:05:15 +0100
From:   Greg KH <greg@kroah.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     stable@vger.kernel.org, rafael.j.wysocki@intel.com,
        stephen.berman@gmx.net
Subject: Re: [PATCH] ACPI: thermal: Do not call  acpi_thermal_check() directly
Message-ID: <YBwNK+NmLJOEoNtP@kroah.com>
References: <161202010810462@kroah.com>
 <20210204123218.xrmfwekiacgzpirj@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204123218.xrmfwekiacgzpirj@linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 01:32:18PM +0100, Sebastian Andrzej Siewior wrote:
> Upstream commit 81b704d3e4674e09781d331df73d76675d5ad8cb
> 
> Applies to 5.4-stable tree                     
> Applies to 4.19-stable tree
> Applies to 4.14-stable tree

Now applied, thanks.

greg k-h
