Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898A2366C8E
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhDUNTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:19:53 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:53031 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241959AbhDUNS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:18:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B511F25D9;
        Wed, 21 Apr 2021 09:18:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 21 Apr 2021 09:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Ow0gcqhHVQ1TyhN9QUQubEGODDJ
        WjqEtsRrtlRaUkf4=; b=PLU4bRCkm0UuW9BLnLhUwhZ7HSS5ZHx4HWbQNI6H7+j
        2ef08PWc5EhTAeBpSYDRMZnNLaSqeC+zs5EauJw5wRMA9kiK98xcz66j8RFrUmV4
        9QQAUFvEqZiAIfGZbyxmTqw+J4KcNbx+Uz/JtCF3EQ5uod0QafHsDg039OO2nzPT
        +1AgMsUsiJXEPkRmR0hDjvUDY8WdhlVr2f0tc9n3rAQf30UyKz9SxdMOGKFIQ2gX
        GEXCIDhGoL/bz4tKCqsWZLSY0KUaWA9FR08zVBxffPLkYlzQeObrVmNw0lYAsVS3
        I/WKZacsJOd2PMWNdx5rJ/Ewo4S3cM4t+8FEFjkG5QQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ow0gcq
        hHVQ1TyhN9QUQubEGODDJWjqEtsRrtlRaUkf4=; b=QhG0g7+WoemzHwDNiV3y06
        xSW7Ie1YpBL9WC0rmtqz0cSkzQhqMpWNh5mUzsRX79sREv7PKKslbJ5IgEUaXf9n
        Zr7qyvtUgzMkfV4jE8+FCa4JixvtUUVKJs2FIu+4KhuX0u08wwlb/EfggTo0dcfW
        EU79xp3fWfrk2Ef0yO0uRM9nsDRl7NUuXim17aUTv1uUtGJtixDjc2eI1EJj8biZ
        TjkG4v/OvovHmOVd9+lWaSKRAO53vGnCSJ2oOqdEcLCCC952cJ0SKhCqE1TP7WP+
        i6WrJ9QORjEQLpxhuSUTWt81YQ/SSoRhnOLOWivVhAsMvjKA4ySLBp/9W16CM//A
        ==
X-ME-Sender: <xms:HyaAYH5XJsER8PXGiq_yOAzI0Bpb5nQ0rdQSiy0xH1TEbVOH1tDPig>
    <xme:HyaAYFXP2eRvvqGbYMqVT7uBAtbNbctoRybzsHkv4rHtNnJr01k0mb9QrsNsjBRIQ
    ZhH8_tm0WTQoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtkedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepudejledvieejtddvfeejleejhfduffekvdevgeegvdegue
    fhjedugeeuudfhhedvnecuffhomhgrihhnpehsphhinhhitghsrdhnvghtnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:HyaAYO4UTd3D3MJk64qYs2HWi6uFe6ol0fx1_FftBsU9tBn0BAYmow>
    <xmx:HyaAYIqMfZDqe69rZRZTCH4fbp2hBAoFkl5R8yLjumBnGqJurTabWw>
    <xmx:HyaAYJnxIBzvSgjc3aRfXWtgKFKwdMOPv5HeH8w86vSAWTUMqb0DEw>
    <xmx:HyaAYDTmvuQCxqdaPTLC2DXT_2w35-5DUTKvjUh8gJwTaTjP3nIftQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08771108005B;
        Wed, 21 Apr 2021 09:18:22 -0400 (EDT)
Date:   Wed, 21 Apr 2021 15:18:20 +0200
From:   Greg KH <greg@kroah.com>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix bpf: fix userspace access for
 bpf_probe_read{,str}()
Message-ID: <YIAmHIzn2eW+II3R@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 04:05:32PM +0300, Zidenberg, Tsahi wrote:
> In arm64, kernelspace address accessors cannot be used to access
> userspace addresses, which means bpf_probe_read{,str}() cannot access
> userspace addresses. That causes e.g. command-line parameters to not
> appear when snooping execve using bpf.
> 
> This patch series takes the upstream solution. This solution also
> changes user API in the following ways:
> * Add probe_read_{user, kernel}{,_str} bpf helpers
> * Add skb_output helper to the enum only (calling it not supported)
> * Add support for %pks, %pus specifiers
> 
> An alternative fix only takes the required logic to existing API without
> adding new API, was suggested here:
> https://www.spinics.net/lists/stable/msg454945.html
> 
> Another option is to only take patches [1-4] of this patchset, and add
> on top of them commit 8d92db5c04d1 ("bpf: rework the compat kernel probe
> handling"). In that case, the last patch would require function renames
> and conflict resolutions that were avoided in this patchset by pulling
> patches [5-7].

What stable tree(s) are you expecting these to be relevant for?

thanks,

greg k-h
