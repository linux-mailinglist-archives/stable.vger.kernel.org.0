Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63ACB1553FD
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 09:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgBGIvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 03:51:46 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53301 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbgBGIvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 03:51:46 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9320321F14;
        Fri,  7 Feb 2020 03:51:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 07 Feb 2020 03:51:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=EfuCvNO6K0xXegPdAuiWsLh56zn
        Hg8uRI1ju5cXxy44=; b=nWBXfc5EHnURnLem8t2sKbpuUMkYSVtiNRqEJqqz91C
        1E+ibUsKlmmtY4VGa2ujR0oYCKl51vdyn+g3bxXS1wnFgtC5gCGbZ+5gXo5URQCR
        /bvGj54x+1AvKlyfyBDMneJbBgGZKKGSjHmMshQDtB7HC915EwxrPpd+prE90z5s
        Lwb9sC3cL6Yn+rL4/SDI6zt015TG01nvKqa1dCe6PW2YjCNlVjRnsK75MxADXGXe
        SR/4fasqv5dZa/JEZbgjDg1KW969RfCs4pX4gwHXuSfb8WRwZdYKT9L16roXazWm
        5l+qAVsev7XfnMTiQXdYpy8RLfkELsVDDcUQmYSgYjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EfuCvN
        O6K0xXegPdAuiWsLh56znHg8uRI1ju5cXxy44=; b=OHboP3PachXx1uXjPvIovs
        MlJGuR17yUnAp0w/Reg/iQdRqAoRYLt0b/xP9TjiJMhiKYg2TmuNqP/AlZOEu6Df
        kxU+Us3D84WKzTT8POnUfWNOFFRyW8c5ZktmCvRSeZvt0baMC66M6/T1e5VNmFED
        NV0admgwKQGL7npViHslu73qRRgSUKONUo7j/5MnlmrCRCNKFdD3OV8w/Lx4jBiU
        lHv9RywLNU10g173lmDIvjE7bVNvmrn4vxqpCznBpW/jTLAX5GAcryOMJBGl9E+K
        VLrONMS1f6xZfBqF/c4ZqW1NCARRPqm67rZy4ZTIiSDca3hwca2mzdiFhmcfm66Q
        ==
X-ME-Sender: <xms:ISU9Xo2RNovNSjbfbdher1wB7VFG227Wpuch-phNkvJ9Cfm-pKCHwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheeggdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ISU9Xmyawl4hcG2dGnbM3Qz_emOpIX-qGFQlBYm4IRqsDPdS-BfP3Q>
    <xmx:ISU9XpgVoPoQndMwGU4mvBqSLIRohPQRHpjbV9HVLzWcyc0l7UpHJw>
    <xmx:ISU9XjMJMHJx3tI8ft6yz8mweygKmIAeI0LQN4eAARgM04pbwpRrzA>
    <xmx:ISU9XocrDB4v3jlAn6C5TbC8CrPM6b3RHXNDsrkSKlg_Hrin9pW7sg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EAA9E30605C8;
        Fri,  7 Feb 2020 03:51:44 -0500 (EST)
Date:   Fri, 7 Feb 2020 09:51:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.4 v1] power: supply: ltc2941-battery-gauge: fix
 use-after-free
Message-ID: <20200207085142.GA312310@kroah.com>
References: <20190919151137.9960-1-TheSven73@gmail.com>
 <20190919190208.13648-1-TheSven73@gmail.com>
 <20191202184349.GC734264@kroah.com>
 <CAGngYiVPbS9zNXPLGqWSs_=b6QbsX97u5bd=5GUMwtGedZ=fqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiVPbS9zNXPLGqWSs_=b6QbsX97u5bd=5GUMwtGedZ=fqQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 02:59:26PM -0500, Sven Van Asbroeck wrote:
> On Mon, Dec 2, 2019 at 1:43 PM Greg KH <greg@kroah.com> wrote:
> >
> > What is the git commit id of this patch in Linus's tree?
> 
> As far as I know, the mainline version of this patch is still queued up
> in Sebastian's 'fixes' branch, and has not made it out to Linus's
> tree yet.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply.git/log/?h=fixes

Now queued up, thanks!

greg k-h
