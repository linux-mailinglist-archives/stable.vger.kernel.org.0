Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA04A10E780
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfLBJRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:17:05 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47577 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbfLBJRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:17:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2321DA4F;
        Mon,  2 Dec 2019 04:17:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Dec 2019 04:17:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=W7a3KdhPczjg8NMYuM/PmlU09nB
        q9GRo029XzNn1e/s=; b=RQdrCpY5+JRRNDRubW6wzwWcuzn+2cgHcpxj5MllShN
        w/M3ioxhv7GeuRNydSSbJfkvbSVZp9nJ19HNIUQN+sbU+hLZ71HF6nhqyioSrqcV
        piMRsZXQBnw8X0A37LNMQEuhawm0+smvSgHdER58AsPP0bZstYnyOqjrjnxUukwu
        rw2euPGY74HJ/Vtch5SJZf+0J2KbrzKXxj8yi2WOckZn8opQMQsMAjQzZyrAhWtg
        U9IRY68l7K7hacetijgzrJ5dQmmJzDIYj7AHry5RBQ15it8iEJZ4plTZrbYxP+A1
        WSIZAOMAKNQmOvaX86jiHrGI55ckjKmloE1RRYBXJcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=W7a3Kd
        hPczjg8NMYuM/PmlU09nBq9GRo029XzNn1e/s=; b=Fh1ljw2GMOjhwH03q/RhOd
        9avLpfHDE9NxATinY+dCBqemAPsb72lvqguht/oEO4KAuPTSpC8m2hRs3LkMBdg1
        OjHy9JVAoWEkY72SJg7z/Lu9y3frC51RnG9sMYOxZoL4DV6Zsvx1VTxHh2dZEFwe
        JPDojV8jcUlMcwSBkwYP1Gh+YK99AzZn6tTJY+3QJ6fVBI/FeleDtCq3HxZj2MZr
        QH3mIWOx1wuvaeqP33yexRyTVJsa6jucU9X2MilvMq7aTYMQqAFwkhjatXrmVIV1
        ZJnr9yosWwS5HNFF50co74wsGb9I42NpeVCoqSMXsttpXjYwFFWWfEFn4hpj544Q
        ==
X-ME-Sender: <xms:j9bkXal3ZW1p6bwWUzmyp5j0uBC0rz8b17STvxPVfoiBWtMjIrBpOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudejhedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:j9bkXeK1LF3XSPm4gXqizJ_Hu5ebWBy0RWa-5P1Fggm4ppBE_4aCHQ>
    <xmx:j9bkXbaGyY7xe6KUAI-RKn0-w6FL_nk7NPzt-dsALzPftpVOT5-ulA>
    <xmx:j9bkXQZ_MbcZWK6DBK7QUHjdAwdQ1PgQbr6Tx-Ip-iEjyI7c_jNl5A>
    <xmx:j9bkXd0BDfcS6VKnzbG82BjlLNe08seDexfzce0T0dem_Y2YsMoFDA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14F798005B;
        Mon,  2 Dec 2019 04:17:02 -0500 (EST)
Date:   Mon, 2 Dec 2019 10:17:00 +0100
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1)
 detection
Message-ID: <20191202091700.GC3945609@kroah.com>
References: <5688116.JcRxOpqE2I@debian64>
 <20191201170245.GU5861@sasha-vm>
 <20191202091431.GA3945609@kroah.com>
 <20191202091529.GB3945609@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202091529.GB3945609@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 10:15:29AM +0100, Greg KH wrote:
> On Mon, Dec 02, 2019 at 10:14:31AM +0100, Greg KH wrote:
> > On Sun, Dec 01, 2019 at 12:02:45PM -0500, Sasha Levin wrote:
> > > On Fri, Nov 29, 2019 at 09:52:14PM +0100, Christian Lamparter wrote:
> > > > commit f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 upstream
> > > > ---
> > > > > From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
> > > > From: Christian Lamparter <chunkeey@gmail.com>
> > > > Date: Mon, 25 Mar 2019 13:50:19 +0100
> > > > Subject: [PATCH for-4.19-stable] ath10k: restore QCA9880-AR1A (v1) detection
> > > > To: linux-wireless@vger.kernel.org,
> > > >    ath10k@lists.infradead.org
> > > > Cc: Kalle Valo <kvalo@codeaurora.org>
> > > > 
> > > > This patch restores the old behavior that read
> > > > the chip_id on the QCA988x before resetting the
> > > > chip. This needs to be done in this order since
> > > > the unsupported QCA988x AR1A chips fall off the
> > > > bus when resetted. Otherwise the next MMIO Op
> > > > after the reset causes a BUS ERROR and panic.
> > > > 
> > > > Cc: stable@vger.kernel.org # 4.19
> > > > Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
> > > > Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> > > 
> > > Queued up for all branches, thanks!
> > 
> > This broke the 4.4 build :(
> 
> And it broke the 4.9 build :(

And 4.14.y :(
