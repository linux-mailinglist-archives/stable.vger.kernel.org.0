Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AE645071B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 15:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbhKOOgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 09:36:47 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:55429 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236534AbhKOOgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 09:36:07 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6872D3200681;
        Mon, 15 Nov 2021 09:33:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 15 Nov 2021 09:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=LO+umul5f6YQGLvFTyOS9gF+wZv
        E5vc3mWHilDM9p6w=; b=KkdPxv92Gl/pqQgnX/msOCtnzsag3HMv0/0ylya0u63
        +P0p/Wbr3Xv/BnS/9bCp/ktEerLHFbn6xt3S5N7AASE/ETccybwvblRG2QSURL1t
        Crnp6unuUZnelIHtQznKXzHNWPGERq+rHRuF7Oaszs09bFudGsl4X3WndkKEXpha
        dm2lB/eDK5Go+KBZ0bfUMYQzFXvTJ3/WiAwV9leVyDxM/PxJdX6VzRimzFYywyDu
        Kp5ZCnjf/o8SKbCzOSlRdtxkWPHgOtYtK2j/KYBDZx8CzopJuCQWwGVTylWm7BU5
        89NtN5WRqex8pw0Ze7azt9yDamTnvuofxNajgSs4tng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LO+umu
        l5f6YQGLvFTyOS9gF+wZvE5vc3mWHilDM9p6w=; b=mA7+k72AnIQ3whAj4fn+yK
        7qNV+qwdSffoInpehBz4gMnp7KHMDDMLejlRaIftjeCHV+Ek5cR9FgggawGXjRA/
        5ZOt4H0TrIJnMIS2AkRi5WGvxZtAI62v8b7deJnUjtxJNq9TIbxNR97pIvwxICY5
        JswURnEJp9o2VlIjVx9qo3q0dyZY0Ir+U0OxH4YdBG+1n2LysJjAHxiwUk+D5N7n
        tW+eapSPV7Cp1Eik6oCMHaGHsmDuWSiot2Kv3SHLo2yHnPtr/gBYH9PajBh5vNLY
        kmDoX3SH82RBYAH6R52eYQZ4byxHDDyuxxKpJ0LPvHsh7LvqUpbwG4gw7B+97mjg
        ==
X-ME-Sender: <xms:pG-SYaMtbQE3IuE4gql15t3tQLIXVmGg5vutm1dlREUXnPb7VMN_Qg>
    <xme:pG-SYY_8tmb1UTiutDNhJAak_fWcPG9l5Z822B3fHGjLKLegDzRZCPNYMsWldBoY_
    OFSk1t3VQNoFw>
X-ME-Received: <xmr:pG-SYRRbBvD8ns95CHw51MM8EA-CG8hj64b2JBLCndhLAkYvhY1pmCYgGxB9I8KMVQ5wR1eJdHN_fyDYCgprXjaalCZiHA47>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfedtgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pG-SYasr3HtF8nI_bZP_ENt5q6bULZL3QiDufelKzR3ywdkGCXK0Gg>
    <xmx:pG-SYSf-4VOSQLSjkpKAw9yYOViPKqe-7T2HJyb6Uk6ppJuFMuGigQ>
    <xmx:pG-SYe3camAZBYCCl_o8zM68nIjQHRDEAsuoNsYw5WJjGikGDXxNsA>
    <xmx:pW-SYaRBXbBvlHKIWkPeLcGAhNS9rWQIHK2b_PUsNWia_ZfgfNaMwg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Nov 2021 09:33:07 -0500 (EST)
Date:   Mon, 15 Nov 2021 15:33:05 +0100
From:   Greg KH <greg@kroah.com>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 5.10 0/4] powerpc/bpf: Various fixes
Message-ID: <YZJvoT6w1dFz2NN0@kroah.com>
References: <cover.1636963563.git.naveen.n.rao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1636963563.git.naveen.n.rao@linux.vnet.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 04:36:26PM +0530, Naveen N. Rao wrote:
> This is a backport of the remaining patches from the below series:
> https://lore.kernel.org/all/cover.1633464148.git.naveen.n.rao@linux.vnet.ibm.com/
> 
> Kindly apply to the longterm tree for v5.10

All patches now queued up, thanks.

greg k-h
