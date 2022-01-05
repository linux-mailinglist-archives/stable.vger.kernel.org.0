Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9999D485525
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 15:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbiAEO6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 09:58:51 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36373 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236073AbiAEO6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 09:58:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 48E1C5C0125;
        Wed,  5 Jan 2022 09:58:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 05 Jan 2022 09:58:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=s
        t6fZtdj4ukXBxBxlYKWJ2Xs+4oe4wH5UsAyXJlDaMs=; b=wlpwzDErtmHsRXywt
        9+b80byXvnv0KBcFm3f0i7rr1hl9O8Yq15ZeK4Zag3JG0jAJws3T/N2jx7OgVmaa
        Oiu8RSCOmkzND5r9f+w6X6xynKRywi4U/GHTgIhrfG3HtMXHeJtUCVLqwltDBYiq
        QzAwJpjXoQHmxuDfJaSzg24YnrYKtueaTso14T85mfzo2fnVWDemwHkhrSPbuDzA
        mzmyVg7XT918Cz8Ij4W7zRvZ0VQYb+Y5sr5iP79w3bzt38uHAxF+ebSKNWs3Fy6H
        jeIILFP5IXPVzdDfEMHT52oDltSxIW3JLLaS7i41BOnXMJVQerX8c9PwjberS8bk
        CzBWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=st6fZtdj4ukXBxBxlYKWJ2Xs+4oe4wH5UsAyXJlDa
        Ms=; b=Vds24gYVEZpb/JEzCA4po4eg1U1FsgLlwl9MLHdwF8yflZCQSdUVHtIS3
        vKuHT65PN/xLdRsowTpYg7Hxkhq0iEohyLdVteBC/EdAyGQOohCYjr6k6ds2lsJL
        FWwEOTgZ6/8v6W0qSMVao8XiE2D7OxDjjENvauli5aOTID1b2TIrQc+jG/UEjC/J
        Dz0OVjQMGH8m3lV7EgfKigxR1rxoyPLWVMcxlB12SYDY3uKg8BYHITDYaO8sf4YZ
        1EH986l2dKd/BZc2VV0Ft6TwLqitCMCeFRTQwO2l8PehIVVv9DqluVYKkJvKlZxQ
        VcPKSXzLD66Z1Qr1XzeSr6f3x0meQ==
X-ME-Sender: <xms:KrLVYaRKL7ZkNPJSW1Ps5u8REYNim2GkE0GaCdvt8JgT6gNjrpL6LA>
    <xme:KrLVYfw7WF6tU-BgVXJhQkH4C8SE9mkfYlUMOeuztnwgsXf8V-15bNjo3Q-uijkCh
    0DjnQ4ds5zvXg>
X-ME-Received: <xmr:KrLVYX1KJj3lNbRN1htgP3ZnGqrH0QIBApohfQ9-RgiBLt5PhqjB_0a6w4lEthL34powoWmwhk0aitKP860w4wlwr9wlT_n4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudefiedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepieevke
    egjeeufeelkeeujeegueffhefgkefghfeuudethefgteefheevjeelleevnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghdpudeiqdhrtgdurdhnohifnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:KrLVYWBxWcagSen6F9e3yHXX1uXrG68v8DUP6I1l-hDSED2Z_Vsaaw>
    <xmx:KrLVYThKtdC_qp8Cn67BLVEq0O3m3awvx2lpSv75RNnlavpT6N4DFw>
    <xmx:KrLVYSqGZTo444MF6EhjV9Q18BzXMn-svXsdhDf0JbzsUgh7ZXZgRg>
    <xmx:KrLVYTdBNEyjXvVVxtzivrNAm3lvuvCUDRGys1gUZHNGOAj0Tmlg_Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Jan 2022 09:58:49 -0500 (EST)
Date:   Wed, 5 Jan 2022 15:58:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Jeffrey E Altman <jaltman@auristor.com>
Cc:     stable@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: Backport request: commit 0dc54bd4d6e0 ("fscache_cookie_enabled:
 check cookie is valid before accessing it")
Message-ID: <YdWyJuRus3zknfak@kroah.com>
References: <8b47354f-ff8f-4dfe-6c1e-813ffefbcf79@auristor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b47354f-ff8f-4dfe-6c1e-813ffefbcf79@auristor.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 04, 2022 at 05:29:34PM -0500, Jeffrey E Altman wrote:
> Please backport commit 0dc54bd4d6e03be1f0b678c4297170b79f1a44ab
> ("fscache_cookie_enabled: check cookie is valid before accessing it") to
> the 5.13, 5.14, and 5.15 kernel series.

Only 5.15 is still alive, see the front page of kernel.org to see the
active kernel verisons.

> Commit 0dc54bd4d6e03be1f0b678c4297170b79f1a44ab fixes a bug introduced
> by 3003bbd0697b659944237f3459489cb596ba196c ("afs: Use the
> netfs_write_begin() helper") that results in a NULL pointer dereference
> observed in Fedora 35 when accessing afs volumes from Kubernetes.
> 
> [ 3627.403829] BUG: kernel NULL pointer dereference, address:
> 0000000000000068
> [ 3627.411649] RIP: 0010:afs_is_cache_enabled+0xc/0x30 [kafs]
> [ 3627.419900] Call Trace:
> [ 3627.420432]  <TASK>
> [ 3627.420957]  netfs_write_begin+0x1ff/0x810 [netfs]
> [ 3627.421498]  ? lock_timer_base+0x61/0x80
> [ 3627.422124]  afs_write_begin+0x58/0x240 [kafs]
> [ 3627.422738]  generic_perform_write+0xae/0x1d0
> [ 3627.423325]  ? file_update_time+0xd2/0x120
> [ 3627.423806]  __generic_file_write_iter+0x101/0x1d0
> [ 3627.424275]  generic_file_write_iter+0x5d/0xb0
> [ 3627.424741]  afs_file_write+0x73/0xa0 [kafs]
> [ 3627.425270]  new_sync_write+0x10b/0x180
> [ 3627.425708]  vfs_write+0x1ce/0x260
> [ 3627.426160]  ksys_write+0x4f/0xc0
> [ 3627.426606]  do_syscall_64+0x3b/0x90
> [ 3627.427086]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The defect was introduced in v5.13-rc1 and fixed in v5.16-rc1.


Now queued up, thanks.

greg k-h
