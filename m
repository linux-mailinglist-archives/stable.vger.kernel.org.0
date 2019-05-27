Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8806E2B481
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 14:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfE0MMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 08:12:02 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60167 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbfE0MMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 08:12:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 73DC44B6;
        Mon, 27 May 2019 08:12:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 May 2019 08:12:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=igi5jOHudzHsQVB/gHrGY+DJZkT
        HuwbK/g/xsUuW8c4=; b=qn5vE6Zh3xBrGS8gJeCef7vw05IjMyT9QhOsIeyBhDZ
        qCbSGZeN0ZN8vngM/lla4ETs8Lp2Va24bCroP0Y8brZUY4d+0LBR/MU6B4KSKIz+
        Sr7+Ls+Rm5D+R2asW3GWC4Uh783OHiTjcTcf2fwId8o0uXOGhQSqEN9EF+0a71EC
        RoOiWhLSyyRjW7B4q1JeY4YinIPmm17K6iNnmYwr4xBgo3GcHzBTLU3+FgiDri3c
        TCqSAvBTL86Q7u6kcxaclQiVW1mQXXB4sqehGNBNyzQE+1MFP4S03gwfP113s8f1
        37h5dt8Zuj6Hjd82xlxXnto4keSjjpw10X4IyZZtROg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=igi5jO
        HudzHsQVB/gHrGY+DJZkTHuwbK/g/xsUuW8c4=; b=NyKw+nuprS/y+nR+K7OUIu
        U0Gtd2afSJPYbNPIe+ZERXy/sgX8zNYS+bkS2b6vGTXOAGnuzb04YDE2O3tZyFH3
        T7EnEjZHvPA+4fi3PmyNO9voRbwMIH73z+A756gaJ96grfhHWk40tr7DDQCxTfEj
        gbvguG502pjPC4nIzpYwW/zFIuIkycaJp0ck2YzJoUaRg6VB97wY2XFiFnRITaLo
        bGl1f0kkV6j6RqcdcHy9QsVMCNjWhrVC3E0WYyA3z1kkwMVCy/SjZIAVbwBdlVMY
        5EaR3ZhpRc+mWx7uh8F3M97HBLtOzAbFtUBYKxsl7DrO0gPdIZK+a2fVR4NT5PNQ
        ==
X-ME-Sender: <xms:DtTrXI7yrP9u7SMKxrA2V8vQaBC9Gk1IHJ2x2Ik5ujwbJ5oT0R5q4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvvddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:DtTrXPLtU7TrWPfT_SRie-hHJ4MChgB7YIYOYmsgriObDtgnve9ioA>
    <xmx:DtTrXKEL6IrIfht1sFEDebRNp9alK-SsqRBpfb9SMl19_Y-kErA3yA>
    <xmx:DtTrXM21cre86uyxsMi496seUvt0az7z30O6BpvqzEz5ijoWryoWEQ>
    <xmx:ENTrXFtHSp8O-4GiV18Qde_EWszXUc7dcZnUb5KJ8-tMIKnKUZyvNw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 758DE80059;
        Mon, 27 May 2019 08:11:58 -0400 (EDT)
Date:   Mon, 27 May 2019 14:11:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Erwin Tsaur <erwin.tsaur@oracle.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-nvdimm@lists.01.org
Subject: Re: [for-4.14.y PATCH] libnvdimm/namespace: Fix label tracking error
Message-ID: <20190527121156.GB607@kroah.com>
References: <155882542900.2471091.11258089584930875450.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155882542900.2471091.11258089584930875450.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 25, 2019 at 04:03:49PM -0700, Dan Williams wrote:
> commit c4703ce11c23423d4b46e3d59aef7979814fd608 upstream.
> 

Thanks for both of these, now queued up.

greg k-h
