Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A64E18A65
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 15:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEINO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 09:14:58 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59957 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbfEINO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 09:14:58 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ACA9121E92;
        Thu,  9 May 2019 09:14:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 09 May 2019 09:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=NK8Ku5ztCV8GJzsPqf2QvMpwRRT
        WZXhWukZnuXwhy70=; b=q6vtObarfbDLpNpAvFKs2tJOqYVOQvuHNja4JRFMX5z
        +U98zMJUEtHFqXrC6Ne7zj9wxDXDwkwGY9s0zzomz+89C20Oe1qWrPRpHlSYQetz
        7eJ4T89yESTJRUc0WzTQm74ACcLS2qzrNN/uU6nJyYgOO+u6iaY6AeWWT6K9A3vp
        N4jNeR2KRJjFgma9lu3NKueM1q3JTMEVx5mzGWtcgDz2WJ3aBIESEMDlcSlwDRZ2
        cqNP4xSLoy3JWc17Yzs5PH4zW+QFwt36h5F/PGNpACon4mF3hFOdQD5pRhxw10qJ
        SB15vYSiW9+e96JKcyjJ3/PDslqwf8fMfEt/GKkDqnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NK8Ku5
        ztCV8GJzsPqf2QvMpwRRTWZXhWukZnuXwhy70=; b=6uvWH5eX52b7imOlnClA7H
        Ghvz4VqZjWpw+3KPa2Sxct2E65lReIS4Sb4zWwosm1dXiq5WNjSKixWut8PkWrkv
        0Yq/gYb8D32hMCVn6oEqx9ZbhNYXUJ7m15zc6Z5YR6dxBjfI/Vy9LNhYRuDvPLvl
        8g49rEbhxBnFWAogd+vUxTKCj1IWOFvqNIYEFvuqhWMa3yg2h8qgDfe2yivicw0O
        arvZQvstYoc3qMzgwV5lqI7LwFpLTKw2viXPIvblyMXi6sehFVd+e9WO5XjqStUd
        zhf5Z7RLV2sf4AwVBCwuw9mGUO9oCEOk8g2jHHaC5tjB7jbNDqEcm3rGGZIKMyGg
        ==
X-ME-Sender: <xms:0SfUXJtlha_1020rEXotMU_Ssvxvwe44QXJ_dXHMtFNfucJ3D8ObMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeehgdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:0SfUXDA5qrzft2J0UIquYCd4ptp5A4hXTfXegNS_OBmiuYUsjU-iAw>
    <xmx:0SfUXIKMLQfhp3ekbCLsRYlLBpgV-0fPE60jz3IvXvtb1q9JnrvORg>
    <xmx:0SfUXC2sE39ktQ0DURdOVZeERfb1PIzzNiWxzu_rB9dGviyIPpFwzg>
    <xmx:0SfUXHcNukrq7wRx-x87Vcev-JIQzi9AabIUpfHGrvQ0g_GxFi5H1Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9A4BF103D0;
        Thu,  9 May 2019 09:14:56 -0400 (EDT)
Date:   Thu, 9 May 2019 15:14:54 +0200
From:   Greg KH <greg@kroah.com>
To:     Major Hayden <major@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.1
Message-ID: <20190509131454.GA19094@kroah.com>
References: <cki.3BBF192F8F.43W986GZZQ@redhat.com>
 <8eb2f12e-818e-caf9-ac64-6652ec6beaf6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eb2f12e-818e-caf9-ac64-6652ec6beaf6@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 09, 2019 at 07:49:52AM -0500, Major Hayden wrote:
> On 5/9/19 7:47 AM, CKI Project wrote:
> > We ran automated tests on a patchset that was proposed for merging into this
> > kernel tree. The patches were applied to:
> > 
> >        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: e93c9c99a629 - Linux 5.1
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: FAILED
> > 
> > When we attempted to merge the patchset, we received an error:
> > 
> >   Patch is empty.
> > 
> > We hope that these logs can help you find the problem quickly. For the full
> > detail on our testing procedures, please scroll to the bottom of this message.
> > 
> > Please reply to this email if you have any questions about the tests that we
> > ran or if you have any suggestions on how to make future tests more effective.
> > 
> >         ,-.   ,-.
> >        ( C ) ( K )  Continuous
> >         `-',-.`-'   Kernel
> >           ( I )     Integration
> >            `-'
> > ______________________________________________________________________________
> > 
> > Merge testing
> > -------------
> > 
> > We cloned this repository and checked out the following commit:
> > 
> >   Repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >   Commit: e93c9c99a629 - Linux 5.1
> > 
> > We then merged the patchset with `git am`:
> 
> It looks like one of the patches moved away between the time our test began and when we tried to merge the patches. :)

Moved on the kernel.org side?  I haven't removed any 5.1 patches from
the queue.

