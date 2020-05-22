Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2051DE689
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 14:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgEVMPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 08:15:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58987 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729526AbgEVMPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 08:15:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D93785C017D;
        Fri, 22 May 2020 08:15:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 22 May 2020 08:15:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=ZCA7usxtrtqYxh6AxlKJ+gyRLCT
        0ybLNhpl9NWEoW4E=; b=XH7hRxMdsX+LjmufRbwPx5WUEJCmu167uy3m+CX5FGq
        y/WXMCMeMAdY/UyMkGismTIIz2JAhoplLIJ/HzsapEoLatle0ODsEn59aSRHT61r
        0vydQoZH7SRP+YyxyIohAygI0qTF+LOLLdWVyR6xOJbF48OtCv++Cie4tUQ4IlMt
        k2F4DZWPWSBnH6QewTCRA8JJmcJkeygyHELYt2IoFxBJ//vaq16rbmor/4o5ocCZ
        zWXgKSR0yLsPUYkSHRB/BOeA1N13liwSacbb1ot5Oj7TiRgOchjLX3rzf86WsCAk
        t4vWVnVneDYcoRUniHJNVz/Bdr2TJEXTAMLGmPa3rIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZCA7us
        xtrtqYxh6AxlKJ+gyRLCT0ybLNhpl9NWEoW4E=; b=fif0u8a/dt/y8EX/6HwR5X
        7oSlsYcXuVc8au8hBqJpoXjmsghZ2Eubeu7rx4ai9g7SQEbx0x8jCCKyVY7/Blkk
        btMSLPlF2lW4RJ1lmPAXsJxPc06q9aCmQ55ToQdJJli0EDKE/tClkz/NLD/nk8fd
        QmGOOpleYTVqITyB/Js60Ec38VZVZc6d+KUx/AMrXyUYXCxYjLsk07r3/NL8IqLT
        /IRPpRcjjiZVyWpgu9QCXbT+RnxydhDRETsGWtZkiDDDRpkLzAzGHC//4VGWEvqZ
        ug3wOSXOdJ7aaCjKIGWH0HXIbwBT5ac3DNU8FW4U4WFdAhNngnQ0o5eshuY5kHnQ
        ==
X-ME-Sender: <xms:dsLHXoYuUxEsM9QkRNMS2AnAllVeAiX54g-iOL-BQU17Dn96DfWH3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddufedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dsLHXjZPtXvDHVEc1srgC_9fUXTjaYKzNF7Zw1GX7Pi-dpQr1KdAuQ>
    <xmx:dsLHXi-WhWI1O3SlSzD7oEOd5S-Mk2OMYuGCSHe6-iB7_yO-R9FAUQ>
    <xmx:dsLHXiqYBnImJ8GTtTx_BPmgO1zKQwQ8Kv4j9BN-TpZFDpwiTxCPrQ>
    <xmx:dsLHXg2kTGWyMGxc8mb844W_sTlCMASFVj4eZY8PRtVex8MMUAPWeQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67A5F30664C4;
        Fri, 22 May 2020 08:15:50 -0400 (EDT)
Date:   Fri, 22 May 2020 14:15:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 00/22] l2tp locking and ordering fixes
Message-ID: <20200522121503.GA1557037@kroah.com>
References: <20200521144100.128936-1-gprocida@google.com>
 <20200521233937.175182-1-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 22, 2020 at 12:39:15AM +0100, Giuliano Procida wrote:
> Hi Greg.
> 
> *Now with better spelling of "upstream".*
> 
> This is for 4.9.
> 
> This is a follow-up to "fix l2tp use-after-free in pppol2tp_sendmsg"
> for 4.14. Pulling on the thread pulled in many other earlier locking
> fixes in between 4.9 and 4.14.
> 
> I've done some minor rework on a few of these to avoid pulling in
> refcount as a replacement for atomic which would have meant 10+ more
> patches (I still had compilation errors at 10).
> 
> Some minor other patch commutation was needed and where it wasn't
> completely trivial, I've added a note to the commit messages.
> 
> The series does include a few non-fixes, but they look safe and mean
> that the fixes (and other backports) apply more cleanly.

All now queued up, thanks.

greg k-h
