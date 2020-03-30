Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3861976FD
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 10:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgC3IuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 04:50:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53067 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728759AbgC3IuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 04:50:11 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 4ADB35C07F9;
        Mon, 30 Mar 2020 04:50:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 30 Mar 2020 04:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=TAc9BqbPJQRkYjEeHp/KesbVTGc
        OThwXtcE4IBNbdjQ=; b=gVLOl7bPHHI6DCmUw5/tJyzpH8CPXfxKWL0Nh64mV+l
        cbXe/1OnMczhkDBnszyc2jWCHmudyl6FD72IVb9SOln1CcSiurOFAy1u5WLGHXrc
        6agBrZQl3f4p4SHYJzM/yXoZhe4/VG7mR6OqZeBQl2i1Iy5IBbgGOrYACXArfBAF
        QEFQStuieBrF2lcVMOiABtQJ2lmnvmZS3rF6SKyk8ce0z/bQaMCzDE0arDwhP61r
        /aZRfhGh0GZXKYoSBlXODbCUY/hVV/BxAtLB3kJ7hNFttxlUat8/A1CSzNzOr/17
        7+EFa5AugOlD+cjlz4dX0ursqjMCkNRCGsDEJJOVJKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TAc9Bq
        bPJQRkYjEeHp/KesbVTGcOThwXtcE4IBNbdjQ=; b=18N07cyeooU50jb5UTtkaD
        mFnao8sgAoMn/wCirer+j1qt7ZeFjmRYVqe10Zf07hIfYkzZYtHk/t++bVHE5v/M
        l4w9ditc02s/MDwRpk0pgjIw7gepq3AJLPnBD/rGAUY5UOlraBAomjxs2bplFM0B
        3qFpeq0igTyXkv/pqpNoyeNrFBUNFUPSAW8HXqeYLd94BPLNYK8A8mZo91GCvcD3
        iGWZiIfIuFU5dCvTzIIpYJf8uIVzrUUxIfuga93R0GpfgvfvQmcEHXcvdawPBaYh
        NmHG8ADmfZv8j6SrUGns1e0Hhz3k8kCUfkzthQMgoD60fcpA9ZbgZmwq43ar39oA
        ==
X-ME-Sender: <xms:wrKBXlVpMVLxhZdo8Xl7Vb17xgu_z1e5ibSTgE5oAecgjRwouxrKPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:wrKBXo0_hmiOoS4pbo8XZic-Iy2G_QsKhm1x89LNwVECHk4tYq94yA>
    <xmx:wrKBXq1ACOPhKyO2xue325B92LNkOtkFeUC2rDRN0bGc1IwdVB2nkw>
    <xmx:wrKBXj9zfCTPwV6GLgIXHMHGfMo3ruoOI-e-bPgrqi2Sql7zfY9dBw>
    <xmx:wrKBXoGNCVB3KLbJ9-lLkEkm3jOVoDoTdhkM-xdoecIsDGYR47PoCQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C89FF306C975;
        Mon, 30 Mar 2020 04:50:09 -0400 (EDT)
Date:   Mon, 30 Mar 2020 10:50:07 +0200
From:   Greg KH <greg@kroah.com>
To:     Jason Andryuk <jandryuk@gmail.com>
Cc:     stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: Stable request: iwlwifi: mvm: fix non-ACPI function
Message-ID: <20200330085007.GA239298@kroah.com>
References: <20200329184111.17469-1-jandryuk@gmail.com>
 <CAKf6xpub_isHjErmj=7yoxeo=2+CKOm+w8b=AWxE-KLJG5d2Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKf6xpub_isHjErmj=7yoxeo=2+CKOm+w8b=AWxE-KLJG5d2Dg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 29, 2020 at 03:17:32PM -0400, Jason Andryuk wrote:
> On Sun, Mar 29, 2020 at 2:41 PM Jason Andryuk <jandryuk@gmail.com> wrote:
> >
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > commit 7937fd3227055892e169f4b34d21157e57d919e2 upstream.
> >
> > The code now compiles without ACPI, but there's a warning since
> > iwl_mvm_get_ppag_table() isn't used, and iwl_mvm_ppag_init() must
> > not unconditionally fail but return success instead.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > [Drop hunk removing iwl_mvm_get_ppag_table() since it doesn't exist in
> > 5.4]
> > Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> > ---
> > A 5.4 kernel can't "up" an iwlwifi interface when CONFIG_ACPI=n.
> > `wpa_supplicant` or `ip link set wlan0 up` return "No such file or
> > directory".  The non-acpi stub iwl_mvm_ppag_init() always returns
> > -ENOENT which means iwl_mvm_up() always fails.  Backporting the commit
> > lets iwl_mvm_up() succeed.
> 
> This stable request is only applicable to 5.4
> 
> Fixes 6ce1e5c0c207 "iwlwifi: support per-platform antenna gain"

Now queued up, thanks.

greg k-h
