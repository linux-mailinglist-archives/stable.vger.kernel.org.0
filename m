Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D06F149E1
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 14:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfEFMgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 08:36:44 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:43237 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbfEFMgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 08:36:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 6F2EE40A;
        Mon,  6 May 2019 08:36:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 06 May 2019 08:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=Q
        rHTMAg8l2luUxoU0HaOEPpd4SLXQqYaEWda/xLtjEc=; b=mW5eH1+0qnIzchmjU
        4kWB+MjS2mH5JGOGGaW3vGO+e1ioZERgfvL2mFMxYRrv3DKlrBhrx3ky20Dqsnmv
        S3VrUFhSxjOEfARGg9aoPVUo1mnfTjj1nIB5fms43V5ok+YNO5S6SMWdrSDhxYhd
        j8pF4pnMIBTSeDRClK/QeUa63x9A5mRqAQDw+GZDldayRzeG3mw4p4/hZzYhFETZ
        XCxyF7wCZTSLp0m1BcTWaAn7Yg1UtKHqiS1d5sqfyThr4ansCB2dTnEDCspTWDk0
        8pbpLH6/rxl7QmbSGgMbixXEvkVoMHYSh3TVuyO6unn3yeulnyHkOS81q6xs+0Fm
        HWmEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=QrHTMAg8l2luUxoU0HaOEPpd4SLXQqYaEWda/xLtj
        Ec=; b=uSmNwr0u68Jurz8HFKa7LpMpTKfUZBeB7jcXDNScGSSZfkliMsOUjl8Ku
        9ELRoc/HQ3GySAymP3PP/Po0ByI98uPiMrIRhUj4dvOBpufTEjb2DXSvdxibS+iA
        GkA87ORuKuisFyfb1btRZctp4ByvEj6WXwO2C9ynd8ippssmxZbTlL45pWGFIHaY
        CHkuk/5Z2REqZzM2cwt9ynP4Kcjq/JS6SolYaeuCNL4iv58zy9x+auNRDTlkBxT0
        tg9rti4+xSw5f29OIxG6P/MpjIX8OKy8gTzL2TpKlcooNXeu+f2kDzmxceWrxRgf
        qI7vX+SM+cVXl3icVoPzXgYJUD7VA==
X-ME-Sender: <xms:WSrQXBoe1hLSYdYnF7qba38RNx9iIjkZMhmJkkiHR2m8GA2nrLrObQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeejgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghdpghhithhhuhgsrdgtohhmnecukfhppeekfedrkeeirdekledruddtjeenucfr
    rghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:WSrQXI42Lb9SDZOZsCx0QjZGLtJQ67BPFDWXQ7QcjfoxhxPxOP1Z-Q>
    <xmx:WSrQXP5tv0xFi-ym-56gcMwSFl6Tx1bvIvH1LZyJKath6cEeMmCcCg>
    <xmx:WSrQXFH_xIiEv4yR9D_0IPmhzyQs44OyCwXuXMsBuVkV-TtFzoH5kg>
    <xmx:WirQXP9V8vltoNTcXbbXPI75fCvV97X4P2TWVOlDqM9WENtAyW9T0A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18BEE103CF;
        Mon,  6 May 2019 08:36:40 -0400 (EDT)
Date:   Mon, 6 May 2019 14:36:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190506123637.GC26360@kroah.com>
References: <cki.7E6F9B004D.B5E2BOYZ3L@redhat.com>
 <190144458.18224981.1557141968068.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <190144458.18224981.1557141968068.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 07:26:08AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "CKI Project" <cki-project@redhat.com>
> > To: "Linux Stable maillist" <stable@vger.kernel.org>
> > Cc: "Memory Management" <mm-qe@redhat.com>, "Jan Stancek" <jstancek@redhat.com>
> > Sent: Monday, May 6, 2019 1:16:03 PM
> > Subject: ❎ FAIL: Stable queue: queue-5.0
> > 
> > Hello,
> > 
> > We ran automated tests on a patchset that was proposed for merging into this
> > kernel tree. The patches were applied to:
> > 
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: e5b9547b1aa3 - Linux 5.0.13
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> > 
> 
> Hi,
> 
> we have recently started seeing an mtest06 LTP failure on aarch64. The failure
> is reproducible, as you can see in both reports. Jan Stancek took care of
> debugging it (we weren't sure if it's a test or kernel problem at first) and
> thinks it's a kernel issue.
> 
> You can find his findings and failure log here for more info:
> 
> https://github.com/linux-test-project/ltp/issues/528
> https://lore.kernel.org/linux-mm/1817839533.20996552.1557065445233.JavaMail.zimbra@redhat.com/T/#u

Thanks for the link, hopefully we can get this resolved in Linus's tree
and then we can backport the needed fix here as well.

thanks,

greg k-h
