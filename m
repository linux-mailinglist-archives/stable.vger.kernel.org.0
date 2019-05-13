Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441A01B960
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 17:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfEMPBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 11:01:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38519 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728882AbfEMPBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 11:01:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7BC4E2201F;
        Mon, 13 May 2019 11:01:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 13 May 2019 11:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=X
        P/JjF7bszBkltLTFx3h5gfoAOxPj0NEsfhkqFhxnNM=; b=Ljvz1C5/7m5ZzJS5N
        qqRJD7J9VTHzXt2zTGfnuoyk7RvO8pnOj4Cm9kClZPEnUIyHrPOLDChjfQxv1r8B
        5zp5tMDskzyhVL8ey57yt2Opl/cnxWN1P3GMeIxldK22Ga+Chi2QnHh39clS/Xh3
        iYFPfAJGs8OsM/69KXTCOuLZV+8ofaXGx1TRL+hlXTfAypz6riCr+r3QYdz5Y1G6
        P5zMgNKer81lCo3Ts0O0WWE/q9YWlP7ITp+PJdSUG05ZthtvXrRGwni0emyev/Ve
        gDwLsgklW0MxVNILK68vEOkgF71xF+M5VhVzELCoAUhwjTybfczt27HPY9aGFOTN
        IS1Eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=XP/JjF7bszBkltLTFx3h5gfoAOxPj0NEsfhkqFhxn
        NM=; b=bR2p+c5hNat6Jcs2SlFZt51QLQ5RWtDPzZbcZhOPQvgPIVX2aXl2SQzUY
        RYW/HsGhbSQaIFvNjVKLDG1ly+jhUbEYsuHrm3Ew43YFgaT15UvoH39OeQDRu/aA
        DHw9c94PIaLlmfp+hmAMKSGX0BkR7VQA64hr1Ii/KdaU/U30BC1DzjjSrjvB5ajP
        8FvvGwkuDmDpDsMFyPdL4rWh/ZhwRH1rjhdsSJLKKy5atezLXL39aqFd4/EJi1RG
        vfqlDxGq2jxavIDUuQC7qRu7CT9Tori/SeDVkW0O73354XEn+CykWUHEN9MYKsC6
        0Tobb9IzmIpMzNUrbIEMVD15CsQOg==
X-ME-Sender: <xms:3obZXFCdeJ385UxRR4OyW46y0xybNz7ZIHcODvs-19bfOIoIBmMZuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:3obZXLeRZ9MclGSs8OGk32roM__NiQlEd9Cr8IS2XsDclGom8JRBSA>
    <xmx:3obZXHx-XSyWibFB-MVslvmQ7MnvLJdgeyVVsaVYmoy7DNv1D45bkQ>
    <xmx:3obZXGOgpRqiahDTt9tswBtY5JuD5ZdCwQ9frsxIMUHNzMQ9GYAfsw>
    <xmx:34bZXOyQ0kSKkE4SSyGqNOKVpsPAwA8XxwCNxABIBBJ6YU5H6LNEhw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22A4980063;
        Mon, 13 May 2019 11:01:50 -0400 (EDT)
Date:   Mon, 13 May 2019 17:01:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-4.19
Message-ID: <20190513150148.GA17341@kroah.com>
References: <cki.02CC569AE1.DRJSZO3WAQ@redhat.com>
 <26765947.19325359.1557756086279.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26765947.19325359.1557756086279.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 10:01:26AM -0400, Veronika Kabatova wrote:
> 
> 
> ----- Original Message -----
> > From: "CKI Project" <cki-project@redhat.com>
> > To: "Linux Stable maillist" <stable@vger.kernel.org>
> > Cc: "Jakub Krysl" <jkrysl@redhat.com>
> > Sent: Monday, May 13, 2019 3:22:19 PM
> > Subject: ❎ FAIL: Stable queue: queue-4.19
> > 
> > Hello,
> > 
> > We ran automated tests on a patchset that was proposed for merging into this
> > kernel tree. The patches were applied to:
> > 
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: 9c2556f428cf - Linux 4.19.42
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> > 
> > 
> > One or more kernel tests failed:
> > 
> >   s390x:
> >     ❎ lvm thinp sanity
> > 
> 
> Hi,
> 
> please ignore this failure -- we discussed this with the test developer and 
> he confirmed this is a setup problem and not kernel failure.
> 
> The test was not happy with insufficient disk space on the machine (required
> for proper execution). We'll fix the problem and let you know in case another
> run happens on a tiny machine before we manage to fix it.
> 
> 
> Thanks and sorry for the noise,

Not noise, thanks for testing and finding out the problem here.

greg k-h
