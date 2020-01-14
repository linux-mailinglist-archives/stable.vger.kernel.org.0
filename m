Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49355139E23
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 01:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgANAZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 19:25:29 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34495 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgANAZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 19:25:29 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7F7657699;
        Mon, 13 Jan 2020 19:25:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 13 Jan 2020 19:25:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        XFMTDBtfZHyOed7ZfNLbmx3RNw8tsdJDO4d09AfyreM=; b=I2KNDFPfO4++5woh
        Cv9+FYDbg0wzwLTavX3kLx+EHn8Q18NuIs+jqQWuarjw1NE+Zr5ih3Aqffp5KVvZ
        kDOiTi6mlgNgi2nc9al6pJgd+oLGc0vkHEREjILC+Va3hddW/B98Mg4b9DqBXQGZ
        ashy5rq75a3k85pz3ZxNirx/Sih4BWJhq8ck4j+LeFyHum/4jHodx2gXZdTJHyyF
        DYBJMTKR4x0Jz5WY3jCeiDSEmRMGh0KK3Ji3CGXQ8s0RYEV6KPX4FYMMre05AAqi
        D6Y5h5R7wxUt1oztN99McV+kgUrg82l+XrLd+0TaAvk2j1KL4ahYlpGewQQsrTJ9
        hdix3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=XFMTDBtfZHyOed7ZfNLbmx3RNw8tsdJDO4d09Afyr
        eM=; b=FvAfXkVhBHwCnEjEnIhffwPCShG13/kCORFDhQUOK8FfZVCXc3t4co4rU
        kwFyOB7c3TSO347gZaoWx6HiCp/hSHVnGtixPTiM75Cv3RHuC5R4uYXOZHl1+cqX
        oaAEF/1RWSCvuXqnM7JkyubPOrN5vDHeDo2sDzfFvFH3yX1LylQLMIemTnvofyW5
        khaaXwkhBL3U9BE4tL60xIJXYCTojno+VysAQ90vHEAYNcH8/cgVQNXTuUjpKMd6
        M9Ukdh4ZTi6+6lXUrBw04KyMavKgBOYNfN6Ii+QHcetTfv6xjbW0E84eisU4euOt
        FHIjykuHyaccKrUitVlB1qjxwIyrQ==
X-ME-Sender: <xms:dwodXpWP-PAZ8T_JYYRYRU5ZMicpYKidZXY3DZlDytKoUsePwM5oDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdejuddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtle
    drudejhedrvdehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:dwodXsAsuu8nva3t4h-3fEN2U5lV_ZCnBr8eIrbfceQMO4BDdzz1Lg>
    <xmx:dwodXjFvriQIKE7K-SUPP8Ps_oonmO-5papqb1mtcOMHocMhw2ZHhA>
    <xmx:dwodXrdOPsxQaFwEHjUakg6WPVod0GWiD2M_YPTQq2ZEcTySZggaCg>
    <xmx:eAodXivqthC1ZIwAIcCOasT42x8LlItV_-Uw9j_7c7lwa7hFyX1giA>
Received: from mickey.themaw.net (unknown [118.209.175.25])
        by mail.messagingengine.com (Postfix) with ESMTPA id B008E30607B4;
        Mon, 13 Jan 2020 19:25:22 -0500 (EST)
Message-ID: <19fa114ef619057c0d14dc1a587d0ae9ad67dc6d.camel@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
From:   Ian Kent <raven@themaw.net>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Tue, 14 Jan 2020 08:25:19 +0800
In-Reply-To: <800d36a0dccd43f1b61cab6332a6252ab9aab73c.camel@themaw.net>
References: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
         <20200101234009.GB8904@ZenIV.linux.org.uk>
         <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
         <20200103014901.GC8904@ZenIV.linux.org.uk>
         <20200108031314.GE8904@ZenIV.linux.org.uk>
         <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
         <20200108213444.GF8904@ZenIV.linux.org.uk>
         <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
         <20200110041523.GK8904@ZenIV.linux.org.uk>
         <979cf680b0fbdce515293a3449d564690cde6a3f.camel@themaw.net>
         <20200112213352.GP8904@ZenIV.linux.org.uk>
         <800d36a0dccd43f1b61cab6332a6252ab9aab73c.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-01-13 at 10:59 +0800, Ian Kent wrote:
> 
> > 3) is _anything_ besides root directory ever created in direct
> > autofs
> > superblocks by anyone?  If not, why does autofs_lookup() even
> > bother
> > to
> > do anything there?  IOW, why not have it return ERR_PTR(-ENOENT)
> > immediately
> > for direct ones?  Or am I missing something and it is, in fact,
> > possible
> > to have the daemon create something in those?
> 
> Short answer is no, longer answer is directories "shouldn't" ever
> be created inside direct mount points.
> 
> The thing is that the multi-mount map construct can be used with
> direct mounts too, but they must always have a real mount at the
> base because they are direct mounts. So processes should not be
> able to walk into them while they are being mounted (constructed).
> 
> But I'm pretty sure it's rare (maybe not done at all) that this
> map construct is used with direct mounts.

This isn't right.

There's actually nothing stopping a user from using a direct map
entry that's a multi-mount without an actual mount at its root.
So there could be directories created under these, it's just not
usually done.

I'm pretty sure I don't check and disallow this.

Ian

