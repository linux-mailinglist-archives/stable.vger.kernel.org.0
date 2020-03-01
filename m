Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71D4174C65
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 10:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCAJ22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 04:28:28 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:32831 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbgCAJ21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Mar 2020 04:28:27 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D6B075D2;
        Sun,  1 Mar 2020 04:28:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 01 Mar 2020 04:28:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=56Qgz+gFnK1dlEMm1W/92t7Kw51
        D6V4ufwZdMscJlqM=; b=gSZ62F7stwcdSAhdqIkqeP7sQaRMaRyMjvTLJY8bKvr
        VYVq75k45iodLeNA5gMztxZZbfAUiRbADOpfZ/jtYqs6q6UI+0aeZCCliyclCpjS
        IdCWIqqk0KdK04QaQgXXH92y7zgrzZAEKs6YsGXjmUkEsJSbQoHzu3Jr5wIVy0d3
        0miYqgtl1KbwS0TWq3h4QkrAbTs5SCqgPkTMZtvDsctultoaTswki5DZKmX/F+/L
        1K36s3dch6RfULw0BWW2X1lvj2wS9+oLlf0HgBBR/S5qUzCdR0b+MoshVSio4Rg0
        V4irPHDI7S3qG0PCJvkCO66ZVAh3B0oF0NqYDeEdpUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=56Qgz+
        gFnK1dlEMm1W/92t7Kw51D6V4ufwZdMscJlqM=; b=UPxz0kapaI35nITlbxFIO+
        p/jBDXrLGEF98awTuDIQgTaSOTAnehTSSHr9SgXFuFILn7C8I+WpGbxMOIFQyvlN
        7uysGGze1BlnS6N3s24LFJD8xkX+q1Gv6+rieCQ7YF2GwsgTJIRZmBQP5aMAECLt
        6RzOb5yht8y9JZx63k9OYdEA+CSSR8j04wjmbLXp0QKCqnmTsu06BVmoVYqq2BjB
        F93AtEjvClxmtQ6d+1odpSEDx3TLvoPRNdoB+MvxwJ4gS99em3P8m6W41Rb0GqMs
        CpKUXnoBvULNhrSJ4u/8840IdGyq6oOq5xjBW0HWTf4/lLzinbQ4rGaKPUnJ2HvA
        ==
X-ME-Sender: <xms:OoBbXsuQiHSzfitXg0JEqCve-l5ZZasTCna7S-tThUN7cyM29Nwl7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtvddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OoBbXnt7y4q9llMqTeyDO-4NO7QnWIgT4dm9zzZNVz3i2CrOZI-0dQ>
    <xmx:OoBbXh6Z5G859ULoLGAYzmecqBuVEx2Q8BWnRfus76dxO2GXlIvTUw>
    <xmx:OoBbXrmAcAFSmkJgE7ytqz_WB5GiII-03BxFPhCmuaSgK1RskY9LDg>
    <xmx:OoBbXmJiLxmtXr2PQzEepf9kJzFkHBK9oxFtecuiF_LnyHJM8sa9qw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CAE0328005E;
        Sun,  1 Mar 2020 04:28:25 -0500 (EST)
Date:   Sun, 1 Mar 2020 10:27:12 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200301092712.GA950017@kroah.com>
References: <20200229.211136.1909836750637702408.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229.211136.1909836750637702408.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 29, 2020 at 09:11:36PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for
> v5.4 and v5.5 -stable, respectively.

All now queued up, thanks.

greg k-h
