Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA433A421
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 09:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfFIH0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 03:26:14 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:59815 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfFIH0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 03:26:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 67D52346;
        Sun,  9 Jun 2019 03:26:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 03:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=njocpN0aV/QubHMO77udDHOjNsJ
        go/LgZ+XIOdPpaZE=; b=MpRgvpzwqz/996EtGzk2JqiRQ+sqt2px+oTO/VlWrFu
        pWTFPfg0eqGcBv9R08WEKzaxrAraOCgREkln8f5Jr6M0aW5jIRBpFhmMTgLfi7IP
        rAVo9ePVvhAan69wIi+DkXRwO5IS4VLRQJt8M7nXiEj5Yk+W9d03+4rGIPQ9Nxtx
        fjoNaOveXLXI61aRwIr0qrxOO4cgPaVpOFBJ2V1Ux42eoH+XWj/xOfZ/TbSZTpK1
        lgBVsJi2CSUWhoWEFrMM4w4eKsUv5+f1nYyOgNPFGnsjzEkbij/xB4NKvPWcW6IT
        PU280WExYw/ZnFHaD+90HoPr6SyGy+uG2mWWw5YYzGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=njocpN
        0aV/QubHMO77udDHOjNsJgo/LgZ+XIOdPpaZE=; b=LWIAyOYPDmp+XQcTDz7T52
        AuhMDa4xFjrLU6IRFO6qP0cABVu382pE64NHcOrZcflk+f12v0EgQwbj+Enj5TDR
        SOqci0QTl9j2WKKNw42rc3mSIf1GSL7HWDVxa+ZuFhEQVdQGLRjR9YyQl/FsmOGn
        3c1vKFv+2bf+Z0cUtbV6AkUsf+av/mqtCmjgCnFcdrM2d8KEDmh2Cs2FBeyHkY4I
        g2lh2W/OPupnKEDKa50kCtKLdsSRcFfvqlicN/YDbYhxLceC0PwpM5nhaMvfuwXf
        4vC4zfeRsHg0+wMB9YdExSLMFJynt+ikuIn4jNe3PvHRMLFKW86QfmTbZ/SXEdjQ
        ==
X-ME-Sender: <xms:lLT8XAF86I7WK1DmQ0w_LbEk5WTYWyXJelYqNqWp-sejf9Pf1Zc_UA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudegledgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lLT8XLVHVdfGZD1xMsZYLu9n7w-GKnYC27O5njU1kAK6DZZbl60V7A>
    <xmx:lLT8XOYQ-wDsQezlbqtqf86EbkF_jKJIIZGjOVrWH3BkiyjUJqDduw>
    <xmx:lLT8XNCbnpWskOc4MGFzSu3zv09qD-7kRXleNBU8Ara0Ex4L19KbOg>
    <xmx:lbT8XFHtifG2vWe--2kizfAuSOXR0AnDw7iY9Q49wwIQU66nN_GKjg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 595A58005A;
        Sun,  9 Jun 2019 03:26:12 -0400 (EDT)
Date:   Sun, 9 Jun 2019 09:26:10 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190609072610.GA3392@kroah.com>
References: <20190608.162722.431283354419982623.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608.162722.431283354419982623.davem@davemloft.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 08, 2019 at 04:27:22PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and v5.2
> -stable, respectively.

All now queued up, except for the duplicate sparc64 patch that you sent
last week which I already applied :)

thanks,

greg k-h
