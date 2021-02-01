Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10C330A934
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 14:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbhBAN6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 08:58:34 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:36211 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231284AbhBAN6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 08:58:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 606A6700;
        Mon,  1 Feb 2021 08:57:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 08:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=/WbbSYzmuwJ/weHeowBD5BlC0fI
        PxX86SPNb0fC8mSk=; b=qLKWDWqzYVqb/LORAMCpnjxu4CfomiFlk+pxvr7IwiK
        xhl1dlu/6J2MuUDeXFZg1T0bK/BR/LC7UNQMJ3Z60ZVDsG+bVauTz8lh/wM1AA1A
        hCBFalLav5NSZqMcxpf7nXIF6LBjNW14GGzLv02sMYeCufIbiULnG2Rj0CqRhhoQ
        HFoG1NAyx4gNXMyN7x+zBiU2Boj4k/F9jZ13VYOdVv+CCsfL/P2yhgG2xiL8nt5F
        2vVLw2KcMFEmzNAt4f0nChW+cYhCjHhJrn4n4NlFEAt8cZ5Ojek2dYh+/y/VUlX6
        W5Pp5JBTDbFhHDWY+zVpSmIYBqWzEeoe0NitkgFZTAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/WbbSY
        zmuwJ/weHeowBD5BlC0fIPxX86SPNb0fC8mSk=; b=PXKsvS8RC4fCpqt+1NCZi2
        atFUZU6IKKmgzm1IrSE94fhEF97TePioWuaLuxmigQnQC0ioBAm+UsJ13oggn7wQ
        QVWjC6VPsxwrXNKmhTm+EfcHZSh9IfKeSt9tZftRnup+8lAvEJEua3VvZvAcwdAU
        VA6aJ8Ong5RFtHusDi3X0ZZ414FpGXXcppj9liwfMIYL4IEywD0fT3TBy94kotmj
        xgopAyZJRhNRjzVW7YDW5tblgeV3gERZlm0VU5b8+ZRtaByrxLbhVoPskNtYRSIM
        uXFXcRoRp82STRmfKjygVtMYKaBAjVtiNTfS35bs42fRl3JIYoT2mL4r7Fzd6elw
        ==
X-ME-Sender: <xms:vggYYOdQIBFOOpNcKJ4H8RD1Vt6jZc5mDGSwAVE8KpK_0sMURGOqag>
    <xme:vggYYIMYXILKTiKFbt1jV0453-pVsqHahHHrCgnXMjHWFTjfdriUXdc-5qKlEiETr
    Asw4-8D6_3ceQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vggYYPh5YGnnAq7kp2ph5imM8maBX8H7EzsAOx3ksW-G8Lvlu0QsOg>
    <xmx:vggYYL8qLFF1pF-sWDmsYRHoMW2fDCnEC1I43qr0S4QisNZ9XPRV8w>
    <xmx:vggYYKuRjYQ9RPZwMgEXoM8sPcjXh3-mBDzQqsCErYAJ-lVaDbxkiA>
    <xmx:vggYYIDQgf4dAiZll_554tYZE-hX_wICLpiPD0wq-BzKw4l3MzBW3YR83ZM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52A81108005B;
        Mon,  1 Feb 2021 08:57:18 -0500 (EST)
Date:   Mon, 1 Feb 2021 14:57:16 +0100
From:   Greg KH <greg@kroah.com>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Jason Andryuk <jandryuk@gmail.com>, stable@vger.kernel.org,
        Michael Labriola <michael.d.labriola@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sasha Levin <sashal@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, Juergen Gross <jgross@suse.com>
Subject: Re: Request: xen: Fix XenStore initialisation for XS_LOCAL
Message-ID: <YBgIvEO/ZF09smN2@kroah.com>
References: <CAKf6xptBwdnhgVYgXhXRvUg9jL3TOf9hT4EcnkZFLJsVVp2M-Q@mail.gmail.com>
 <YBcU3/cl/j4ppLJY@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBcU3/cl/j4ppLJY@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 31, 2021 at 09:36:47PM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Sun, Jan 31, 2021 at 12:20:18PM -0500, Jason Andryuk wrote:
> > xen: Fix XenStore initialisation for XS_LOCAL
> > 
> > commit 5f46400f7a6a4fad635d5a79e2aa5a04a30ffea1 upstream
> > 
> > The requested patch fixes Xen Dom0 xenstore support.  It has a "Fixes:
> > 3499ba8198ca ("xen: Fix event channel callback via INTX/GSI")" in the
> > commit - that patch was introduced to stable in 5.4.93 and 5.10.11
> > (didn't check other branches).
> 
> Confirmed it is needed as well for older branches as well. The commit
> was backported to 4.14.218, 4.19.171, 5.4.93 and 5.10.11. At least for
> 4.19.y I could confirm (by a report of a user in Debian) that it is
> broken in 4.19.171 and fixed by cherry-picking the above mentioned
> commit. 

All queued up, thanks.

greg k-h
