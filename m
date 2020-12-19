Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868B52DEEDA
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgLSMpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:45:40 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41995 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbgLSMpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 07:45:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B49305BC;
        Sat, 19 Dec 2020 07:44:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 19 Dec 2020 07:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=NrxrFEeftK5SEyWxieqEkdybKx2
        8bAmQY0MRbiwbMrY=; b=cFUFCQuQh6rJ6EYk0GPqTE8o2K0PkW/H2PjkJAE0ZtI
        oI7WHJrCAmY71ixOSPouA52v6pbAB46ZiDO24LcWPRGACj14J/I2Pj7UH+D1zMqB
        dWsm1zblhb+Jwe4G0NE8+Oh+AeSWz/qEH/9er7ZX77E+FqdtMDMamri2ZEgdvBfm
        XNjawNMwKXoRVUltE9qjFBMzRA24j+jXLPfu7EsrkKmXJ7u8nP7FEaepe5XeBqKS
        loAoGQFzzpeSmd1Q2mACDAoBuccFioO2CR/KpGKozIyylct8zFpwe58j49Y3de2K
        xwA8xe/mdlIKXnzaQWDYWpLFS3fKxKEarqYj7shz5uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NrxrFE
        eftK5SEyWxieqEkdybKx28bAmQY0MRbiwbMrY=; b=FynPPEvLKSnXLn9RTHWjKh
        ao3DhwqJQ+okSzLPhZOE/L6fq26b2XoH1OIezezFXtSiQDMMcRr0+mIITeXox4Cr
        V+nZrA97yLHikfbZ8LBIDPgnNEL0BNAUV3+OEgmbw/pyLj2HWJ+j7qbre5grfTVN
        dV2XCqCM4hwjqhgcgDhNDtVDSXlofPzIFLmIxXAzmJucLBWFUGcWPbYpuQgAl7K1
        6OHwhk95+gKMYjQ2kUQG2n/WXQLYXhsdYKU+oY/uP1z3lrUauN3knsvSwxmCSAHL
        Pi4SSJtOLihU2NdXCT0JiYoD6z7bD1DmuLNrPHR6PtVRVpUQp8CaZOaQnJe4+Obg
        ==
X-ME-Sender: <xms:v_XdX8d1cZbXqikal8DecO9c0TVqLaADNSpLsKi3QES0-IZ2nxG_vw>
    <xme:v_XdX-MLimv85_pUBM2erTtw_5_uTk4tbIYA3Ns3MLpel3VL3gACB7JIHk2aTx4Cj
    NUM30Ym0s-QEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudelkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:v_XdX9hZGZcUw2RorIIpkK2SZrdty28PEU0NDoc24KG9TpiSwB06Bw>
    <xmx:v_XdXx-9hoTx0NyiXBETLpLpaRgfg6pmNzaKrWxdSLLjeW66cjC4mQ>
    <xmx:v_XdX4skIPKfTH5KQtyKxKn8zIYr6TU3EK5xWj0z22Cs-N5Rs8rwkw>
    <xmx:wfXdX8jaU79pCPYNdpA_JTna5fmNW6pmncTjQx73-njCeMPeMdiV0g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6AA021080059;
        Sat, 19 Dec 2020 07:44:47 -0500 (EST)
Date:   Sat, 19 Dec 2020 13:46:08 +0100
From:   Greg KH <greg@kroah.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH backport] membarrier: Explicitly sync remote cores when
 SYNC_CORE is requested
Message-ID: <X932EI8RN90rRjyP@kroah.com>
References: <b0ddbb1195c5b9851cb3e9d079870b4752fdadb6.1607968697.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0ddbb1195c5b9851cb3e9d079870b4752fdadb6.1607968697.git.luto@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 10:00:43AM -0800, Andy Lutomirski wrote:
> commit 758c9373d84168dc7d039cf85a0e920046b17b41 upstream
> 
> membarrier() does not explicitly sync_core() remote CPUs; instead, it
> relies on the assumption that an IPI will result in a core sync.  On x86,
> this may be true in practice, but it's not architecturally reliable.  In
> particular, the SDM and APM do not appear to guarantee that interrupt
> delivery is serializing.  While IRET does serialize, IPI return can
> schedule, thereby switching to another task in the same mm that was
> sleeping in a syscall.  The new task could then SYSRET back to usermode
> without ever executing IRET.
> 
> Make this more robust by explicitly calling sync_core_before_usermode()
> on remote cores.  (This also helps people who search the kernel tree for
> instances of sync_core() and sync_core_before_usermode() -- one might be
> surprised that the core membarrier code doesn't currently show up in a
> such a search.)
> 
> Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org
> ---
> 
> My stable membarrier series depends on commit 2a36ab717e8f
> ("rseq/membarrier: Add MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ").  I don't
> think it makes much sense to backport that feature, so here's a backport of
> the patch that doesn't need it.

Now queued up to 5.4.y and 5.9.y, thanks.

greg k-h
