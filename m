Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AB33CD4FB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbhGSMDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:03:04 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59653 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236742AbhGSMDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:03:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 3171E32007F9;
        Mon, 19 Jul 2021 08:43:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 19 Jul 2021 08:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=s
        F/0xGA/p9Rha0wLlqreyeRBkMoANCsLU6lLyGBPnY8=; b=wT8k6KXyvNiDc9LWv
        7bprDbaOQjMtpDn8LtZcmYM5yFyN5M0cTXghTqSiAE9Ll0MPWskY2tulTOWaGGb6
        tTX98mHJRQVJhI1IZIN5FXh+VA6DE+gO1Dv3VvoX6TVyuv5TCFF7LFci7sNuvAlj
        h/1QKQOqudmoPJIS379XXbjoUYs3T0qllSTy85tHHhH7yL9DkVjQEwGeUh0CccHW
        qG7qeUMgmwGtXrQI+Gruo2t3N9sWBp2RgT+cwq2Ii5xIIiYN1lWxl5yWMZxc8dM2
        XmO9LjxhIfkBHPqJdp9kq7hcBi401RiRdt0t/lCi/N9PKeqRLUcSnjrOtGVf6RKs
        AX2Uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=sF/0xGA/p9Rha0wLlqreyeRBkMoANCsLU6lLyGBPn
        Y8=; b=QGwpSMyMN9Qx1d1O/zdvhsv7mBjFeaYwWMCyamS6yO2hAL9nzedSyfC9B
        fZKfYougPoVvw02yP2Yb9HlqvMZetxtoRtYX1CP+VSdmXT807xlAJCek3xNorAZF
        g99Orq6D8/QVd/JiksJTt0VYVz+mEEFPJUUp/or1z9cKuITbnBr0B367O4uhTxOU
        T7+DRI+lVUApBEmBi3Td5FxS7EpI8OZmbwSPQxxUZ7a6cR5FHG+CUKdMJg5vRYbZ
        kQu3kMykLrDoAXaOi4GgacRz5MqCogXwtydc37m2NaoFSpQseokMOnIxDoGwsWaO
        Z3xUdSXhOZcMnIrVUtjn7oA1pPyNw==
X-ME-Sender: <xms:f3P1YM58Z0S5uhDWjfvJ1GgfLDkZS2Y1MptaybM6GsRWrJTVCWs8XQ>
    <xme:f3P1YN5TDxQfgNavuyAECN4DOpTDpl2HV6PqR4HrhO_3pCutF9SVqeeYiO9CJiXyX
    1KsWHEMOopQOg>
X-ME-Received: <xmr:f3P1YLeB6Bveu8vnOxLHQPaQ3_xFdIbdQZjVJUsCkiyhRBkIP0UQ3QCQ2Az90MCLIfonhhC1qUV9Axl3Zj6JwGdkR_HvQ0tf>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedtgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevtdeile
    euteeggefgueefhfevgfdttefgtefgtddvgeejheeiuddvtdekffehffenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:f3P1YBIRIVI-xX19bl98PzXmnBcORhTHpYAldd0A0HaRyFn8LSzzpQ>
    <xmx:f3P1YAI1RkKJBKo-1-w7_WLSWGctvEGqtj9xKt4ZH78yVqPYAfr2Qg>
    <xmx:f3P1YCz6Qmaso1Si3E6tt9rlmZ4M9jv1OWQXrFdvK-FZXvFENWeedw>
    <xmx:f3P1YHUgDsr7CZRinEzUTeierQ368BY2YNQAPomuiDINyCjLVFXaHw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jul 2021 08:43:43 -0400 (EDT)
Date:   Mon, 19 Jul 2021 14:43:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-4.14] PCI: aardvark: Don't rely on jiffies while
 holding spinlock
Message-ID: <YPVzeay+kONm6sUv@kroah.com>
References: <20210716122033.22568-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210716122033.22568-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 02:20:33PM +0200, Pali Rohár wrote:
> From: Remi Pommarel <repk@triplefau.lt>
> 
> commit 7fbcb5da811be7d47468417c7795405058abb3da upstream.
> 
> advk_pcie_wait_pio() can be called while holding a spinlock (from
> pci_bus_read_config_dword()), then depends on jiffies in order to
> timeout while polling on PIO state registers. In the case the PIO
> transaction failed, the timeout will never happen and will also cause
> the cpu to stall.
> 
> This decrements a variable and wait instead of using jiffies.
> 
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Andrew Murray <andrew.murray@arm.com>
> Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> ---
> This is backport to 4.14 kernel. Backport of upstream commit can be done
> automatically by git cherry-pick command if merge.renamelimit variable is
> set to at least 12711.
> ---
>  drivers/pci/host/pci-aardvark.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Also queued up to 4.19, thanks.

greg k-h
