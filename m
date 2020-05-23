Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E291DF51C
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 08:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbgEWGK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 02:10:26 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:56035 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387446AbgEWGK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 02:10:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id B27D18CB;
        Sat, 23 May 2020 02:10:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 23 May 2020 02:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        from:date:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=LrrYTVFkm9x5WAtV96l5QFTVfXK
        7jcQpg5sr70HsgwE=; b=kAPKJBbB3e4aBtF2OcbBUICIud8yPLH22RFoStnp4e8
        yDZXaIlUHk0hzMRsWVU1tHFiy4j0L0oLLRjDEWOTmhX/S/kyk3zo4JPIGMqvBvu/
        pVHsRR8shbwejVVYYURo0N2WYAO0gpTmU1ZNWJ2HUmC1oVxu4P8anVPVK5dPa3D3
        VCtDB+/zUbFUwYk4BMaqAjLO9JlrzQtA/2FPzETfMh6ca94xQ5B/gQDe0te1qzXw
        /DdP9SgJLR7qZbBpupaF2rfmz2uUpswbVzE6RAxliD1hVZEC6Cxme/m7h+bltlXo
        sgi1B50yNPN4u/lqaF3ofGVVEz6iGA+UFhvCDk9u8bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LrrYTV
        Fkm9x5WAtV96l5QFTVfXK7jcQpg5sr70HsgwE=; b=o3LniShnRlpl+p+BDDClSJ
        gFgFe65lkZbszodtwx+k48xiTCURwK42S+Fty6srSnJabd4skcMtn27IN77BBB4t
        0m6wvn6WSvufHru66KSihYcVKdZmLEv188Rj/+jHrpJRk7vef08ZiRmu6xJzZeUb
        brmvvzvNucIVMlzSlDVdJOwBLrzodmiQwcIIvPxG2miwdgmgYaS1xK3qbGXy0b/B
        0gwn3JDRJH9RlFMvMAS5WoQy9X9IX7E6Zbaj4Oc+/Nc8SxPoasIiShar3D91kh21
        l8/i2gHtlYm6pgY2gXS1A6QnKUZM07e1CXyuBXaMoKSP1JNtmNR25lY6c3PjWSTg
        ==
X-ME-Sender: <xms:T77IXlv6y-F4jWSN-g0qsuwh-D2FgNmSuQkyix1z2-REyP1dBZ1AQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddugedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhfffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepghhrvghg
    sehkrhhorghhrdgtohhmnecuggftrfgrthhtvghrnheptdehveeuieekuddvjefhlefgke
    dugeeffeffjeetieefgfduveehfedvheeludfhnecukfhppeekfedrkeeirdekledruddt
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrh
    gvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:T77IXud2oWQcXqtjJpYSLzcm7xfysXz80uywdWroCd0IuG6WeZsNvQ>
    <xmx:T77IXoyC589Z7sLJ5OoU5m3ZDXiWXru70tkQEr2CPDnobSrWxGnt4Q>
    <xmx:T77IXsPJz4o-qG0QNang-l9w2SYk8cE6fRSpM7EiEVXr9iU2A99IVg>
    <xmx:UL7IXsVykN8rG8y8fgoGUWZ6glDMhYsF3Sub3bpYfEABCX_YO4a-ML45vUs>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CFB1530664D9;
        Sat, 23 May 2020 02:10:22 -0400 (EDT)
From:   greg@kroah.com
Date:   Sat, 23 May 2020 08:10:18 +0200
To:     Oscar Carter <oscar.carter@gmx.com>
Cc:     stable <stable@vger.kernel.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Kees Cook <keescook@chromium.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        kernel-hardening@lists.openwall.com,
        linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org,
        "Lev R . Oshvang ." <levonshe@gmail.com>
Subject: Re: [PATCH v2] firewire: Remove function callback casts
Message-ID: <20200523061018.GA3131938@kroah.com>
References: <20200519173425.4724-1-oscar.carter@gmx.com>
 <20200520061624.GA25690@workstation>
 <20200522174308.GB3059@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522174308.GB3059@ubuntu>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 07:43:08PM +0200, Oscar Carter wrote:
> Hi,
> 
> On Wed, May 20, 2020 at 03:16:24PM +0900, Takashi Sakamoto wrote:
> > Hi,
> >
> > I'm an author of ALSA firewire stack and thanks for the patch. I agree with
> > your intention to remove the cast of function callback toward CFI build.
> >
> > Practically, the isochronous context with FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL
> > is never used by in-kernel drivers. Here, I propose to leave current
> > kernel API (fw_iso_context_create() with fw_iso_callback_t) as is.

If it's not used by anyone, why is it still there?  Can't we just delete
it?

thanks,

greg k-h
