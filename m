Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28041CF51E
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgELM7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 08:59:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45905 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729436AbgELM7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 08:59:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 086005C01A6;
        Tue, 12 May 2020 08:59:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 12 May 2020 08:59:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=NF51Lpfdg7IvTcr1xw1Qv8Pyq/d
        sXYb7+YVKwNRbjlE=; b=H0yTo1KxMg8PIn7Vxa8aVG+D8ki0PQ5aC+AncZGp4+I
        XBSJ88U6lDbZyFYg2+Jjyu01Alpi9m/JG4D2uUWpzvUBrUnVGWhHVuaYmNre2mVM
        Y0SbGTNcLChCuL0Hh4esMZg4NvNrL6uS1e0/E4gh5ZKKnBJ06d3i5NK0NaLRz8Hc
        eusv0QCCekw0IMLT/nAXeUvzwPQbTAeBueAlRCw1PjHpqDerf42S8wec45NMq3ib
        5a2vdGfnt6CCSOHy+HqTzYzF/cYliF6m230CcNZx2UrhPVc9D8n6iMZbrilMvIYd
        Z8XlCW5MJGcb+lQMfPV5BUZWGiRSiBRPTssXnbAYjow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NF51Lp
        fdg7IvTcr1xw1Qv8Pyq/dsXYb7+YVKwNRbjlE=; b=3drGxOOc9yOS6RMvFvGgiw
        XkkPvO3w/+TYCHVlEfhadT2+GkiChBf7h3gSwk4K3GYNjEUxrQ2VbPFByUvJ3SiM
        vsRTBS5lGg8m/g9SYk1C/OKZnLlzVqIrfBTYIz65nGkIbQ1w3tF/4hWDD6swc5ah
        46DjcqbEuIsCXDoytkf9zNPONetiw8FrAhbdgdscjhjpDo/0Rsfd254Ck41zpwIW
        z0pA5frMiJXYj+FJsKRGiNC4MiJYUOBIzrxE0YqINECvoGQizhmsRS0ct6cS3XAB
        n03wGQFDHTxYDLWrYwFLGcp9lL45VmKAklwJm5tUgSVIFcqjeY8o/j6OrdzVa4YA
        ==
X-ME-Sender: <xms:tp26XvD8ONCrqviGk3yfFapkQ3gMc5m6mKgsU-N7Ry9Dmto6X34Bkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:tp26XlhuuXCjqx_0FyhHY_oOIQSOcpXabxankCuEv7FLNYBYRHiiyg>
    <xmx:tp26Xqljl5hpCjDRG-aKhg7m79ynhV0WvPl0zqTqCLN7Zj7NYLAkYw>
    <xmx:tp26Xhyxrq6tYYBARiJ3r854APXMNxka4ZZzohOLjXyhRH4P4pwJ3w>
    <xmx:t526Xqcqypb2S5t8JCZPLbZMYSJrbAnSbQtaeorbj4JhnBMTeL1RBg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21C0D30662C2;
        Tue, 12 May 2020 08:59:34 -0400 (EDT)
Date:   Tue, 12 May 2020 14:59:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     stable@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] ext4: Don't set dioread_nolock by default for blocksize
 < pagesize
Message-ID: <20200512125931.GA435853@kroah.com>
References: <87pndagw7s.fsf@linux.ibm.com>
 <20200327200744.12473-1-riteshh@linux.ibm.com>
 <20200329021728.GI53396@mit.edu>
 <e61fe76d-687f-3e34-6091-c501071b8a9a@gmail.com>
 <20200512114533.GA54730@kroah.com>
 <61fb772b-75e2-f391-1a5f-044e573b38f7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61fb772b-75e2-f391-1a5f-044e573b38f7@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 06:20:05PM +0530, Ritesh Harjani wrote:
> Hello Greg,
> 
> On 5/12/20 5:15 PM, Greg KH wrote:
> > On Mon, May 11, 2020 at 01:37:59PM +0530, Ritesh Harjani wrote:
> > > Hello stable-list,
> > > 
> > > I think this subjected patch [1] missed the below fixes tag.
> > > I guess the subjected patch is only picked for 5.7. And
> > > AFAIU, this patch will be needed for 5.6 as well.
> > > 
> > > Could you please do the needful.
> > > 
> > > Fixes: 244adf6426ee31a (ext4: make dioread_nolock the default)
> > > 
> > > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=626b035b816b61a7a7b4d2205a6807e2f11a18c1
> > 
> > This patch does not apply to the 5.6 kernel tree at all.  Please provide
> > a working backport if you wish to see it present there.
> 
> Sorry if that's the case.
> I tried both "git cherry-pick" and "git am" with patch mentioned @ [1]
> to apply on branch "remotes/linux-stable/linux-5.6.y" of tree
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> and it applied cleanly.
> 
> Also, just noticed this patch in the queue. Is it that maybe you are
> trying to apply it twice?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.6/ext4-don-t-set-dioread_nolock-by-default-for-blocksi.patch

Odd, it didn't have the "upstream" commit id, which is why I didn't see
that it was applied already.

Sasha, something went wrong with your scripts, you didn't sign-off on it
either :(

greg k-h
