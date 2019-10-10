Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9ADD3400
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 00:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfJJWih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 18:38:37 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:50819 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbfJJWih (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 18:38:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 720405EE;
        Thu, 10 Oct 2019 18:38:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 10 Oct 2019 18:38:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=mwrnj/CzTIgVt4Kr1G7g/SxuG4k
        CBRcWy0UBkxS1tpA=; b=uogqERlMCs2lh4s7xZG3F8yxehrCI3336BsVimOFgzK
        Eb5LyrBtULDq1PI48Oz+q5PmHD5vuaqP/9Q1Jm+bucGsB8burnaTWwWTfBe9yHfP
        9rDmacKbXWJqLQ9jiBTxv4JkpXZnyyUnUpZjmdr6ij77JwHT3mwohtTfsg5AoY94
        iGJaZ66LE/KXWla+6OWedyGBmEjgDN0a3Io1w3TtVXZ7mAExqoHUkxx0pu9LzzpG
        kKxsj4d633g8dwa8cMjfHI4xzn86A0OydQEoEXPQXG5mYK/SenctUwJv1gTmlct6
        btDDC1ltycXxrdx4jlQyZVt82E71n60kHQPnzcm0Pcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mwrnj/
        CzTIgVt4Kr1G7g/SxuG4kCBRcWy0UBkxS1tpA=; b=hTPS+D4GrcXMfEu7sxMSs8
        Op6TwPVXHhOanpsqyFEygwyEWGfgTAQpTl7jgRNuqIDzhiiqE4u3dHS/1wxtuTpx
        KjOs/e6+zqWxz7lR2BcNUSOqQgxhlqTlnO7s7muyaQUEI04op7e6Qat8CSiP2L0Q
        0ZNUVmfsoOX5DEvD1P7uQJi9cmKF/K0ojgKF5aW5XJDmm8RXJLum/hazGSBmTRiA
        X8OWr96L3Lsqk2ggJEH0uKxfligEVJZkvzbIaBDVftoix3xofJ1MAy3aPjnj9L4/
        jje5RhRRLSelzbNUbXust6jA1gp31hrjMbnwEvQr5AbBkttR2j3XW4VVzRzZMGeQ
        ==
X-ME-Sender: <xms:6rKfXZ6-HrlRVhc__6TafUKDG5uelVwp37TwlfIsczLFB6qB7IHf8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieeggdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepufgrmhcuuegr
    iihlvgihuceoshgrmhgsrgiilhgvhiesfhgrshhtmhgrihhlrdgtohhmqeenucfkphepke
    eirddviedrvddvgedrudehfeenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhgsrgii
    lhgvhiesfhgrshhtmhgrihhlrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6rKfXe2CaWThgm4MVQ6sFQwDZgZLvEGC8hbh3ELRkN8SDJjEFCdYUA>
    <xmx:6rKfXWz0Y4K8EMsmqWhroX_txuqvUR8GnydffwKNMK9FLHqB1GHYrA>
    <xmx:6rKfXaq2w9FZ3odjdmO4YID37_m92ajDT_K4UBCDP3BGirJtVdymug>
    <xmx:67KfXec_mip_iBgjRM7-rbt80myPeDtFsmrqTAJBWdeIX2sDhnLdrQ>
Received: from localhost (cpc88620-newt36-2-0-cust152.19-3.cable.virginm.net [86.26.224.153])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A2DAD60057;
        Thu, 10 Oct 2019 18:38:34 -0400 (EDT)
Date:   Thu, 10 Oct 2019 23:38:33 +0100
From:   Sam Bazley <sambazley@fastmail.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/3] Logitech G920 fixes
Message-ID: <20191010223833.axroklxlo2lkdzo6@SamLinux>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007051240.4410-1-andrew.smirnov@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 06, 2019 at 10:12:37PM -0700, Andrey Smirnov wrote:
> Everyone:
> 
> This series contains patches to fix a couple of regressions in G920
> wheel support by hid-logitech-hidpp driver. Without the patches the
> wheel remains stuck in autocentering mode ("resisting" any attempt to
> trun) as well as missing support for any FF action.
> 
> Thanks,
> Andrey Smirnov
> 
> Andrey Smirnov (3):
>   HID: logitech-hidpp: use devres to manage FF private data
>   HID: logitech-hidpp: split g920_get_config()
>   HID: logitech-hidpp: add G920 device validation quirk
> 
>  drivers/hid/hid-logitech-hidpp.c | 193 +++++++++++++++++++------------
>  1 file changed, 120 insertions(+), 73 deletions(-)
> 
> -- 
> 2.21.0
> 

All seems to work now. Thanks again Andrey!

Tested-by: Sam Bazley <sambazley@fastmail.com>
