Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E7E355C22
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 21:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241060AbhDFTWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 15:22:53 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48889 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhDFTWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 15:22:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0D4E31567;
        Tue,  6 Apr 2021 15:22:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Apr 2021 15:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=C59toQeGzXwFwjO16nyv9LOjwCU
        SLowD6NlzSgCuGYM=; b=tgX7twj1d1+oYO8cJFbWwea1tCymtZXgbE/WcgFXaA1
        Xt1IoHp0QAizv6rDd/cTtze9JXF1pqcjkAz0LwGhWef5453aS24EQgaBXKVnmYhz
        u/lPkJP6mIl4Fd0jNGkgfD43VTMFmVTRvpDVtmTzPsOycDuZaH6X7AKMFk0DZMLj
        Mw6s9MO7SbLkPOu53/12dahOWfvrB3NxM6k3NcwqYt/Gl6pyAoyX77g10RABf8aG
        DbF9TPBkXEgFAtw8e4gTcUhdfr5zUY43VjaUDDThAMSKFVJeCXAVaZWk0L0Y8Aum
        oIJqv6fMn0oBR/6ha6kBdbwJuRKOFRlYgFBZ+8sCa2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=C59toQ
        eGzXwFwjO16nyv9LOjwCUSLowD6NlzSgCuGYM=; b=ujBs3Otf1069bLZhZThEmT
        dygCQV3SUIk0g58ZOUmU8GbyfuzpevKwMMw2z3g96ryA4Qd65VcKN36+6Xi9Ntvl
        LVFHzRxeOSrPMk5zzJsHWM2VCNhkLIZVLdsKjZa5SfpkA3tNGA1VrqQ2CBF1NCFd
        mOb1GUlyVL/ry95Uny6Pl0Z1+PxpxoadYZCkqJvLC9XJezD0dFGUQAnjILoxNZq7
        JDCKEWoBQGfGIM3dVWwy1V6hIMdsHm/QgzNVueWq++n3r6kbjtcFNuHHCwJ2R771
        dCVmxBDOVK3f20hbkRpvqJyQT0r5KP/A9sCWxfOF/D9qpVWu8N0j5o/WowJp8gKg
        ==
X-ME-Sender: <xms:A7VsYKUjZXWX46AM_a-6KRWcnDVtyZpFWgOKyO0oLft1fo4q_b5xbQ>
    <xme:A7VsYNh_0nLt2cuWibfNEGU2oD7E3XXNey69nrahFi8NRGXw0DGLltQwerHg7bDoE
    uzgnJ8jCRItXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeiieevhf
    ehtddvudefjeehffegtdfghfdvvdektdehueduleeiteffkefffedtheenucffohhmrghi
    nhepuhhrlhguvghfvghnshgvrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrd
    ekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:A7VsYEDqvqlMCv4-0Z9M3nNT18p-qlsUbvs7lBSDtBuZlNojHuAB3w>
    <xmx:A7VsYGe-NKhwxlDDn4m5V2Wy7u2_85277xkaazm8J4WtKVm2klrzZQ>
    <xmx:A7VsYEeRnnsf9XNTuNBiWYOuTvmtVsf_s-tQuAGPY-CQSxtDQzxfSA>
    <xmx:A7VsYOvVZMZDUkl7CYqqGwkrO4pN1Y0QCyEQi8_tA6UOTtSAvEfGIQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AD7824005E;
        Tue,  6 Apr 2021 15:22:43 -0400 (EDT)
Date:   Tue, 6 Apr 2021 21:22:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Gulam Mohamed <gulam.mohamed@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 07/22] scsi: iscsi: Fix race condition
 between login and sync thread
Message-ID: <YGy1AJl1KnymOjHE@kroah.com>
References: <20210405160432.268374-1-sashal@kernel.org>
 <20210405160432.268374-7-sashal@kernel.org>
 <be0783c0-4ca8-d7fd-ce97-c24c2f1d8e84@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be0783c0-4ca8-d7fd-ce97-c24c2f1d8e84@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 12:24:32PM -0500, Mike Christie wrote:
> On 4/5/21 11:04 AM, Sasha Levin wrote:
> > From: Gulam Mohamed <gulam.mohamed@oracle.com>
> > 
> > [ Upstream commit 9e67600ed6b8565da4b85698ec659b5879a6c1c6 ]
> > 
> > A kernel panic was observed due to a timing issue between the sync thread
> > and the initiator processing a login response from the target. The session
> > reopen can be invoked both from the session sync thread when iscsid
> > restarts and from iscsid through the error handler. Before the initiator
> > receives the response to a login, another reopen request can be sent from
> > the error handler/sync session. When the initial login response is
> > subsequently processed, the connection has been closed and the socket has
> > been released.
> > 
> > To fix this a new connection state, ISCSI_CONN_BOUND, is added:
> > 
> >  - Set the connection state value to ISCSI_CONN_DOWN upon
> >    iscsi_if_ep_disconnect() and iscsi_if_stop_conn()
> > 
> >  - Set the connection state to the newly created value ISCSI_CONN_BOUND
> >    after bind connection (transport->bind_conn())
> > 
> >  - In iscsi_set_param(), return -ENOTCONN if the connection state is not
> >    either ISCSI_CONN_BOUND or ISCSI_CONN_UP
> > 
> > Link: https://urldefense.com/v3/__https://lore.kernel.org/r/20210325093248.284678-1-gulam.mohamed@oracle.com__;!!GqivPVa7Brio!Jiqrc6pu3EgrquzpG-KpNQkNebwKUgctkE0MN1MloQ2y5Y4OVOkKN0yCr2_W_CX2oRet$ 
> > Reviewed-by: Mike Christie <michael.christie@oracle.com>
> 
> 
> There was a mistake in my review of this patch. It will also require
> this "[PATCH 1/1] scsi: iscsi: fix iscsi cls conn state":
> 
> https://lore.kernel.org/linux-scsi/20210406171746.5016-1-michael.christie@oracle.com/T/#u
> 
> 

I don't see this in Linus's tree yet, so we can't take it until then :(

thanks,

greg k-h
