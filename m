Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34AFC35EB
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 15:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbfJANij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 09:38:39 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:57103 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387790AbfJANij (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 09:38:39 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0EC1A4E9;
        Tue,  1 Oct 2019 09:38:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 09:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=pqOjdycimrjZZFZvPbLhp+rZyaF
        fSlTOymNngLJRXUY=; b=HbThXucihml996uKwqabkWXRUdnKRI/wsWQ1vyfnCbZ
        frTXK9etl92eU+THXHjWvcneV6fycDGhUKNhR1Z0BpFX0P4SbFErHK18WhyLgBal
        rBklWXTbiudNr+5JRSON5DzYdclIFCWytvj2Q41On3kw1qoMvlUxF+FhuTEYUkHZ
        aHofpiNnwZ0SCxxDB1DVECmpdGsK0MBII6BwZYj41s5R+/dot1RiFwQtC02sO80i
        l0uuTeK0H3oorcw/pPx2rmJyWWFmOEJpTf+umKe3OkuXXuPr7BdogT/xBrH2N1gr
        olADdJTWkAy4CvDhu+1FVZ2LOGS2tjVU1d6O6rRuadA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pqOjdy
        cimrjZZFZvPbLhp+rZyaFfSlTOymNngLJRXUY=; b=cpMGp5smiLO/x+4ITG/Mq7
        I4Q0yuKteKPzn+NkdgCbuRK2pUb7/NWjqY3IESaScvK2GZVHUf++Vxpn9/gvVbmX
        tJ29dH9kh5N2rnW87pKWlYvqgwdj1nsJ97w8Gbm57KUmnrpU/NSp030+dWLPYUj6
        Ayi6hu80GtumBTc52LAwDtvG+wbV6yMESTknmyyskTda0tqev4zUBzO1RIZq8lnj
        TJrwVMLEcximT6TyOjeuaxSPY08y1GzWEzFCNdLxR29Cl+9nY1r1cKIR4ZBF8W9F
        mVCkzgfQff8TgONKicAV+WVyp38m8R0ocYB+YsnvYdKSGFVrC5bWDs2y8xFrPrqg
        ==
X-ME-Sender: <xms:3FaTXRHWPpy9evKdy_5f5UuVY2k59-0-Wn2Qf1XJ6_yDm9oOuZXMUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:3FaTXfUwN2jHyeTAXDIREeZd93s-VMOuDolZVhW2AMd4XdEGW5Y5hQ>
    <xmx:3FaTXc0JNUSjryfYT8XtcsIP53uMAWQ01rm1D51mBKWBrsUYCl48tw>
    <xmx:3FaTXeCpq6SJdT5k7W4CBNJSh0HgKW2E75MEepaMBsmzm-ogfSlk6g>
    <xmx:3VaTXZD10EaTQIgcLMFZ80MeIuXUVHUaT9wm1Bc46GpSD_uHmilIXA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8223FD60065;
        Tue,  1 Oct 2019 09:38:36 -0400 (EDT)
Date:   Tue, 1 Oct 2019 15:38:31 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org, kubakici@wp.pl
Subject: Re: [PATCHES] Networking
Message-ID: <20191001133831.GA3002050@kroah.com>
References: <20190929.153952.922829744666703199.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929.153952.922829744666703199.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 03:39:52PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.2
> and v5.3 -stable, respectively.

Now queued up, thanks!

greg k-h
