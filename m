Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C8613A061
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 06:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgANFBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 00:01:38 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:57697 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgANFBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 00:01:38 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7018C21A6;
        Tue, 14 Jan 2020 00:01:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Jan 2020 00:01:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        vdVJ/qGMQ6cdSxqPixnqXi60LNSIWvCeNhmImcuGw84=; b=J8Yhp3j/A6ABj/HA
        IvWUqeMY+JZuDI3sbeKDcCFJOd8Nfg+hloXKvDYJT7/DjfpOaeqI4bO9LCB6aDdS
        bioCJ9Jpj8kSKOr3srV+68SugsV6OpO5ieOW/3PGKOnDaiTn/QFTIab00ZWFbnu5
        g5FNdNA5xWz4aclCy5LOoqQZ51Tg9QqbsFl8JXeYVdJIpQUfnPIJSb4ydehiQe3l
        WGcxUigaqylXfojailLtdzneEymOfi8tivJ6lPqpFZgf38EbPY0GkS4hyVQfwkGx
        Qbm5IZ7Nv93+chqbGt+4nfXVIRCgP2ioBBnCQp5zzRXil7s2u/mrFYNJfA0kqKKq
        ryFNBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=vdVJ/qGMQ6cdSxqPixnqXi60LNSIWvCeNhmImcuGw
        84=; b=yH4LYP2dW1XYMLgYLFh3/Wu7ic3nyx9iyr/ycFbNK6zRe1U3YRQPbfcvW
        DMeYae3qeO5RVk5bbzzcpALfSabk+ks2QVIkMfpZ8CxepSPO/wmJxpMxdHHuCtOj
        4O5kQD7AVtz9DoNTQZT30P+qgER1xs/xOTY4F/uW3gfNbKoeIa75dteK9klyDfpt
        C/Umjb+Ekv2+I9PTxAZwfht6bOWWPRuw8FnFHho8WxVEBCzX8Rjzpx9kA46X9phb
        eHJrDWW7uklWYQDELJhaFmmVXtpDzNRp3ZmSZG96JhIk4cU4cZySYv6eZkot6D8Z
        y6HZzDjg7VD7+ufY+Vok5kLzEk4Ew==
X-ME-Sender: <xms:MEsdXhJhS3NUflfPNB_1N63CecCT-Ao15uh0SR_GlF26hu7NK-da_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdejuddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtle
    drudejhedrvdehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:MEsdXptnsmA3QmIBN0RoFQvItOVSM2JT_1NbFwjr6utfn_gISxn2kQ>
    <xmx:MEsdXuKXldVL4IxLsUQ3h4GVpo3M-14cCCoJGhcCI5hAIMZbPo32iw>
    <xmx:MEsdXpO484cdrSaIRAkD-KLW85-CnIuXljE9dn_Xb8o-A-0enKNKYw>
    <xmx:MUsdXunD9PYin4lC_JG3-2HXFNa_k9hxhIELHJ0TbAjOttHE3gSbhw>
Received: from mickey.themaw.net (unknown [118.209.175.25])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F8E430600A8;
        Tue, 14 Jan 2020 00:01:31 -0500 (EST)
Message-ID: <d6cad1552171da1eb38c55d1d7b1ff45902b101f.camel@themaw.net>
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
Date:   Tue, 14 Jan 2020 13:01:28 +0800
In-Reply-To: <20200114043924.GV8904@ZenIV.linux.org.uk>
References: <20200103014901.GC8904@ZenIV.linux.org.uk>
         <20200108031314.GE8904@ZenIV.linux.org.uk>
         <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
         <20200108213444.GF8904@ZenIV.linux.org.uk>
         <CAHk-=wiq11+thoe60qhsSHk_nbRF2TRL1Wnf6eHcYObjhJmsww@mail.gmail.com>
         <20200110041523.GK8904@ZenIV.linux.org.uk>
         <979cf680b0fbdce515293a3449d564690cde6a3f.camel@themaw.net>
         <20200112213352.GP8904@ZenIV.linux.org.uk>
         <800d36a0dccd43f1b61cab6332a6252ab9aab73c.camel@themaw.net>
         <19fa114ef619057c0d14dc1a587d0ae9ad67dc6d.camel@themaw.net>
         <20200114043924.GV8904@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-01-14 at 04:39 +0000, Al Viro wrote:
> On Tue, Jan 14, 2020 at 08:25:19AM +0800, Ian Kent wrote:
> 
> > This isn't right.
> > 
> > There's actually nothing stopping a user from using a direct map
> > entry that's a multi-mount without an actual mount at its root.
> > So there could be directories created under these, it's just not
> > usually done.
> > 
> > I'm pretty sure I don't check and disallow this.
> 
> IDGI...  How the hell will that work in v5?  Who will set _any_
> traps outside the one in root in that scenario?  autofs_lookup()
> won't (there it's conditional upon indirect mount).  Neither
> will autofs_dir_mkdir() (conditional upon version being less
> than 5).  Who will, then?
> 
> Confused...

It's easy to miss.

For autofs type direct and offset mounts the flags are set at fill
super time.

They have to be set then because they are direct mounts and offset
mounts behave the same as direct mounts so they need to be set then
too. So, like direct mounts, offset mounts are each distinct autofs
(trigger) mounts.

I could check for this construct and refuse it if that's really
needed. I'm pretty sure this map construct isn't much used by
people using direct mounts.

Ian

