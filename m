Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282FF49735
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 03:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfFRB7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 21:59:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37066 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfFRB7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 21:59:08 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hd3Om-0004se-Gu; Tue, 18 Jun 2019 01:59:00 +0000
Date:   Tue, 18 Jun 2019 02:59:00 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <jmorris@namei.org>,
        David Howells <dhowells@redhat.com>,
        stable <stable@vger.kernel.org>, Jose Bollo <jose.bollo@iot.bzh>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: Restore the smackfsdef mount option and add
 missing prefixes
Message-ID: <20190618015900.GZ17978@ZenIV.linux.org.uk>
References: <155930001303.17253.2447519598157285098.stgit@warthog.procyon.org.uk>
 <17467.1559300202@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1906040842110.13657@namei.org>
 <6cfd5113-8473-f962-dee7-e490e6f76f9c@schaufler-ca.com>
 <cb3749a6-e45b-3e07-27f9-841adf6f4640@schaufler-ca.com>
 <CAHk-=wj8VCxjwyd_BDgRtDigik5UdizCZP7PU4wUtj4vHsEWNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj8VCxjwyd_BDgRtDigik5UdizCZP7PU4wUtj4vHsEWNw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 02:24:09PM -1000, Linus Torvalds wrote:
> On Fri, Jun 14, 2019 at 1:08 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >
> > Al, are you going to take this, or should I find another way
> > to get it in for 5.2?
> 
> I guess I can take it directly.
> 
> I was assuming it would come through either Al (which is how I got the
> commit it fixes) or Casey (as smack maintainer), so I ignored the
> patch.

FWIW, (belated) ACK...
