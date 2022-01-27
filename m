Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA7A49E541
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 15:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242717AbiA0OzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 09:55:07 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38357 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242722AbiA0OzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 09:55:07 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C3D3C5C00B6;
        Thu, 27 Jan 2022 09:55:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 27 Jan 2022 09:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=2UwNMNfp6ieUzDyoWijdcAxXZmyqP7r8kCyLg2
        wqtPg=; b=kSsIp1tqZG8LdBrLyUTUeZYXp+2thsut4XDq0FfLT1HBUemzV1WZIV
        OCyTFFuQUC3imTfJc9gc6IXnnbiWzP4+jn8AXycKVqnS4pXgUknyT43XtFsXfTfG
        fLoEQIIT/bkJJd7tevsjjU4tnSuOPqebmKDQxWOMGLeQ15GT/9kKqoDIh/ChWAq0
        wvD1kPYQfAhXUfYEGU+vQxCkp3lVtdil3DJd/zb+RD8fpDgQaY+hpyw6JhZZs9vP
        CusFE6iLfzQ/RzLKV/S05mqMIEIBhQb87qe6TEo/lyt2vk8usWgd+YPWI8Hzc0Pd
        tqfwIxmmtVmYXqEv96E482//bTCRztIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2UwNMNfp6ieUzDyoW
        ijdcAxXZmyqP7r8kCyLg2wqtPg=; b=ONmHj50CfIpEnxn2gyEbgWFGA/8/bEC+H
        A/JcrT86bzFn+5kxhQiE1Q0Madup9Twe7ul69cG4s3taq59FvmxByuaPYwWqzhrw
        1cGhURV+b22NQhWjpGjutlXzWceWm+rg/KR062/FrP8RnVdDn2UGwWy+iZvlw1ks
        dKbOyAtFxvfY+yONmZfhMPJKXUkodGF76uxIO5GkwoT3Icd93d/Y7LeJH5BVE4TM
        J/1K4Ynf36XGHt4jKNHjHJvvDc+Wix5UdmxKgjTl4IyUSGP/ybMn1E9tG3dfvKd2
        nXGh8qGpP0xO9+czeOzWPzkNTdtLoKeawKdy+jVLjnmOA/6chCC7g==
X-ME-Sender: <xms:SrLyYa3nvJLh61VbSDvgMmsEDH5sZ5BFOkuQUqqHuqp1fn4T2ZMFsA>
    <xme:SrLyYdEuBhSN6jb2ZTqVPvRRYcA-owabH3tJPRtS76KhzM4jHFH8OrfjVohIaYvPs
    Vub30X96o4biw>
X-ME-Received: <xmr:SrLyYS4NvnIxilMX_rmoixZDtFqwkBYqNNguCP6R2pyqMbzVjGleM-J35vNHg93hGFg_WFV5aTRjQE68W5cgneGZbzXClOWx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeefgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:SrLyYb1cDupN_Rwt7nS6xLEIKnZ1n7zah4u-nioWSnF8Ipy5LLSGew>
    <xmx:SrLyYdEO7y--eXOYp5_xuVIJouN4vDScGyqekcHq_ncgGkP5mjqdmQ>
    <xmx:SrLyYU-xq5cCgdnzMdD2JWihljCvgX43tkZGatC4zr1g6Zu479EirA>
    <xmx:SrLyYSTFBFhe0YT6eVk5b4ekC6LKdeWscPod82qsC_qLeAxX5822NA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Jan 2022 09:55:06 -0500 (EST)
Date:   Thu, 27 Jan 2022 15:55:03 +0100
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org
Subject: Re: SMU "failures" on s0i3 for DCN31
Message-ID: <YfKyR7BlXhFZCjxI@kroah.com>
References: <1df3a6ae-b6c1-adb4-48b8-49139cab8772@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1df3a6ae-b6c1-adb4-48b8-49139cab8772@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 01:02:57PM -0600, Limonciello, Mario wrote:
> Hi,
> 
> Can commit 83293f7f3d15fc56e86bd5067a2c88b6b233ac3a ("drm/amd/display: reset
> dcn31 SMU mailbox on failures") please come back to 5.15.y and 5.16.y?  This
> will make identifying and recovering potential FW problems easier.

Now queued up, thanks.

greg k-h
