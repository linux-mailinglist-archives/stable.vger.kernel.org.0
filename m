Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362A345A262
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhKWMXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:23:18 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:56657 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236352AbhKWMXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 07:23:17 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0124A5806E9;
        Tue, 23 Nov 2021 07:20:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 23 Nov 2021 07:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=J
        QqF4/QtB+OXAbvqSwN8kLplvhC7av1NV0IpBCUCK10=; b=tdlERvGvPLNL0c6zf
        I+CZJ3YvV/VOlcN3FLXVAPT94hmAtAzskMYbiOBCEsSHTFzSav96b3WKKJxj2Md0
        +ykZTh/lkO7JfuF7MmMfUmZq5zvR2dgHih0SXYzEfSNtG98ZxmQBmFjZy8MNOq50
        piQUlnyrvST4eBEgk0dJt9XRsYjT+i77bJAPFgv8n8k1+8rBl6CC7YZo3O3Gfb1O
        rv9T+hDT4dI2PJRqvCDBJcSrUlfZERMe44QystZ/gNPNmkT1docXIq5zboGGK4/Y
        Y1ZB1CBISkDRI+2A1Mrgij0TboYyXwILnPMD/ftMefvRKrLNrcNhr/wrfYGk/c5F
        evQ8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=JQqF4/QtB+OXAbvqSwN8kLplvhC7av1NV0IpBCUCK
        10=; b=ZdM5jD343Yc+/FFi5unO9Kuh+G8UJi3tyeBJ6UhiyS3HxoTRHjXHk25Ho
        3CyNk6ilbCjs5Fe9mE44OO0Um9YXtKlOg0EnWwMweAuea9IEeqGFDLKomLuxHHhX
        HRgfkzq1KynZTmHYz8K2Byh8Cb8z6Tq6IkwSXQri2FNTjfoOceA0N1rXWGu/xRVn
        ESecJtDLFN5HcX291KF9SLPdI+lwGgZhKbk4Gdrp241Pv39PJelvwvJ1M5yhQuhz
        tVibPTfRK47aDF7RUYDcGqGi+AbF5QFoQLG1E3P5yum276tpEVDcEPJaScroCiFS
        NLX4iGz2cUQAFv/zpX9R6KYe0DqHQ==
X-ME-Sender: <xms:eNycYcghHsqJ943ixCy6nhvj3dm4glGGmqixyj5anovNE8ekqqmZrA>
    <xme:eNycYVAuhP31upewmsJd6DwagwGSyjbF1qbSV1bOlXdNK9G3gn14ZnUhCnxFrfFYc
    vVo_an2BITwew>
X-ME-Received: <xmr:eNycYUHwA7zociVFDG67SpV4Duh9oMybOhmXJaj4cieybYDEPmADg2mrPN2LzuR8LYbZ8CU4PKo8NJRWy1pPNs8oikcJA8a3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuheekhe
    elffefieduteefkeejffdvueehjeejffehledugfetkedvleekudduvdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:eNycYdQdV7bEqU90q-xCddTiR5tbRBWDmR9WHfpV7-jg_37j7maPtA>
    <xmx:eNycYZzvl3sPEvSPQ3JM5nS-AYDgEVke0ZH_LA3W72I5jL04waTikA>
    <xmx:eNycYb7Jrc2GFh0wn4FEjOf-I93iqLu0tNjZw3AgDR4fmVqDx7BW2w>
    <xmx:eNycYeqgiTR5eJolMFkjJx5jJXMAlZhbERDHVM6q2sRaSS6S97EB7w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 07:20:08 -0500 (EST)
Date:   Tue, 23 Nov 2021 13:20:06 +0100
From:   Greg KH <greg@kroah.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jordan Vrtanoski <jordan.vrtanoski@gmail.com>,
        stable@vger.kernel.org, mw@semihalf.com,
        linux-arm-kernel@lists.infradead.org, stefanc@marvell.com
Subject: Re: ClearFog GT 8K not initialising SFP-H10GB-CU1M transceiver on
 5.4.150
Message-ID: <YZzcdgvlznKJ1nYr@kroah.com>
References: <3AB36F18-250C-46F5-8135-94C79102B8A5@gmail.com>
 <YZONJC7KhACsq+5m@shell.armlinux.org.uk>
 <A2513E97-0C96-4E16-A9D2-98BB90490229@gmail.com>
 <YZlPeoRLSJKNJZ5F@shell.armlinux.org.uk>
 <256509AE-EE75-40AF-882F-F84A55F98C2D@gmail.com>
 <2F6C75BF-6CD8-4A58-B8AA-4D3A6B5A1008@gmail.com>
 <YZv1SBrYTXmorcLJ@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZv1SBrYTXmorcLJ@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 07:53:44PM +0000, Russell King (Oracle) wrote:
> On Mon, Nov 22, 2021 at 02:51:36PM +0400, Jordan Vrtanoski wrote:
> > Hi,
> >     After bisecting, the regression defect was introduced in 5.4.90 with the following patch:
> > "[PATCH net v3] net: mvpp2: disable force link UP during port init procedure”
> > 
> >     The patch is changing the configuration of the port during the initialisation of MVPP22_XLG_CTRL0_REG, which
> > on ClearFog GT 8K is preventing the MVPP2 to properly start the MAC after the transceiver is detected. After reverting 
> > the patch, the transceiver works properly.
> 
> Right, the problem will be 875082244853 ("net: mvpp2: disable force
> link UP during port init procedure") that has been backported to
> kernels that it shouldn't have been applied to.
> 
> There is a subtle interaction between that commit and development work
> leading up to it that wasn't obvious during the review. Specifically,
> any kernel without fefeae73ac7a ("net: mvpp2: ensure the port is forced
> down while changing modes") will now be broken.
> 
> However, fefeae73ac7a is development work, and so can't be backported.
> 
> Adding stable to this thread so they're aware of the issue.

I've now reverted the commit in the 5.4.y tree.

thanks,

greg k-h
