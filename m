Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5B979215
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbfG2R2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 13:28:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33301 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725934AbfG2R2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 13:28:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7303920F5C;
        Mon, 29 Jul 2019 13:28:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 13:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=BfT1kwVnDm8QQXSpmi6sJhypCO6
        Y4+Cf2C8ekSA850w=; b=nfnMvHsSfLKIExdotuYg8jcoNsfAiqLd9IlVPF0SOJp
        juwF7KOfhB8+NqZ615gzjZ1yZnRdwdn0/Uc81klXIQwWNRqauGNU4H090fTXqtme
        1ZO7L/76RXxTo9eGzXm8NqZSpPJhzxPZIBtCUnoJ83OqOJgm15XFs2S8Q83i7hYs
        qGZpZ6sXzEUIbU7MVFQqPzWzJkl+p+49vbFI7mTJnfYrlC2BJlIdQ+JAF8lX/8pI
        1PIplgOE/8jxXTWm7I2cAiMNnYqh11EYgiZPpeIxu2MwAE0v0T6A1WQ+s3LOO7fn
        qEnAaW6nPkx1z7jbCPTBCjaNOZroQMvWTrJvzJ+zlfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BfT1kw
        VnDm8QQXSpmi6sJhypCO6Y4+Cf2C8ekSA850w=; b=f9sSuLSiOw9wxasIxsZj8e
        2YQjMUMnei7p0E3PuoCKEITU2LM0iMVg06LjrSdA815voKAC25Yq+LlJMKaDK/ts
        AHSx7SdWfLbbyG60XIkI72Cqp4DxE86jnTGwv91+nWh8FsaflqlKMrZ3qkEqPBhN
        2J9YUbR093vXXRe7fVYoIRGE+hn+bIo5Wd2vt4vAL7APoxIN7HVPnmg+0rAdyQd7
        Au3Su6KiiaNbIWPhWzwMTEzTotx2qE+10v+r71LDjqAzeCon2XtDvTAZc7Re1qqf
        kOhLKjBgpBOEbRyCMv9AyCvTf2w0AlGCK/5c5SNTUhWE6cCne7lkt27388nmIH4Q
        ==
X-ME-Sender: <xms:tiw_Xc2QSR19kGqPhgeOudj-M0rkbtI4J-wK_G6I_wYSYg1uWIxezA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:tiw_XWE28FP0zdIHKh8_WcoCEIrB1T1VNuE8TKovfU0gAEwtQcYjEA>
    <xmx:tiw_XdLkNP1C5stZWi04vwun7DFKfPIptmlgp2BAadVXTogEkjmsEg>
    <xmx:tiw_XSMvJIgCsck8UAlLzlefDAuYLydcQts1o3YUukgNbYZB-V7poA>
    <xmx:tyw_XcLvzPEaGopJpTRw5j_5BW7fbs_58g6lSZa4Zm8lvxjefxCL-w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 42E1380059;
        Mon, 29 Jul 2019 13:28:22 -0400 (EDT)
Date:   Mon, 29 Jul 2019 19:28:20 +0200
From:   Greg KH <greg@kroah.com>
To:     "Gopal, Saranya" <saranya.gopal@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Yang, Fei" <fei.yang@intel.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH 4.19.y 2/3] usb: dwc3: gadget: prevent dwc3_request from
 being queued twice
Message-ID: <20190729172820.GA17093@kroah.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
 <1564407819-10746-3-git-send-email-saranya.gopal@intel.com>
 <20190729165649.GB14160@kroah.com>
 <C672AA6DAAC36042A98BAD0B0B25BDA94CC82DDD@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C672AA6DAAC36042A98BAD0B0B25BDA94CC82DDD@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 05:06:13PM +0000, Gopal, Saranya wrote:
> > On Mon, Jul 29, 2019 at 07:13:38PM +0530, Saranya Gopal wrote:
> > > From: Felipe Balbi <felipe.balbi@linux.intel.com>
> > >
> > > [Upstream commit b2b6d601365a1acb90b87c85197d79]
> > >
> > > Queueing the same request twice can introduce hard-to-debug
> > > problems. At least one function driver - Android's f_mtp.c - is known
> > > to cause this problem.
> > >
> > > While that function is out-of-tree, this is a problem that's easy
> > > enough to avoid.
> > >
> > > Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> > > Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
> > > ---
> > >  drivers/usb/dwc3/gadget.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > index 3f337a0..a56a92a 100644
> > > --- a/drivers/usb/dwc3/gadget.c
> > > +++ b/drivers/usb/dwc3/gadget.c
> > > @@ -1291,6 +1291,11 @@ static int __dwc3_gadget_ep_queue(struct
> > dwc3_ep *dep, struct dwc3_request *req)
> > >  				&req->request, req->dep->name))
> > >  		return -EINVAL;
> > >
> > > +	if (WARN(req->status < DWC3_REQUEST_STATUS_COMPLETED,
> > > +				"%s: request %pK already in flight\n",
> > > +				dep->name, &req->request))
> > > +		return -EINVAL;
> > 
> > So we are going to trip syzbot up on this out-of-tree driver?  Brave...
> 
> I had retained the commit message from the upstream commit.
> However, without this patch, I see issues with adb as well.
> Adb will hang after adb root/unroot command and needs a reboot to recover.

So you see huge WARN dumps in the log?

That's fine, but be aware, if userspace can trigger this, then syzbot
will trigger it, and any system running 'panic on warn' will crash.

If this is something that we normally have to catch and handle, WARN()
is not how to do it.  But we should fix that upstream, not here.

thanks,

greg k-h
