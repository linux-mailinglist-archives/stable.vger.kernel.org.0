Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD0D2E21B
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 18:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfE2QNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 12:13:31 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:44065 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbfE2QNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 12:13:31 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id E222961E;
        Wed, 29 May 2019 12:13:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 29 May 2019 12:13:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=EiBk9WgT5jhapte0zGFwRA6Svwh
        jQL4faQV9mcE4mek=; b=s+gOKNptth2H04QNemaVWBfU+qTqjTFzEpiOpdGq7ty
        nd/PZXK1NzyBjfremVcHN2ngxyzJgPz858MKEZJ2IWWjPs9KpIbl/5yq0T/O/2rv
        ezs3vFSH6IAbZzWgjNYBllBEHVdJef3gww3l3RWS6Y8GaTBgCjzprWDPLbOdarGm
        fpZWUuONx2IG91Y1yn4pqToeMo84ZFcJ8b/naPO0KbWecUhswZitG7LuZyBJexr+
        KK49gjb93dPCmU885P5LEN0470OO5UkepqEerjdqzg1VOI6u7SBZlVdmKGz2xooi
        SVS5se94xyUrhevQGat/ZlT0yHGc2UNfRwfDPLKGa0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EiBk9W
        gT5jhapte0zGFwRA6SvwhjQL4faQV9mcE4mek=; b=KM/Z2GBBCSzCqUuPbApAAv
        lJAb67kqcTDpwZz1RiGvY2zNUCNwZr9dCJxJo+R1tsOGyh18UAOHJY4J4qjGmY+z
        i6iga2n3xBLs5TjXqtRO3vEGepfOVY9rkUYYQtvj2GxSsxkRmbNwBP5Kn6gDLWfa
        fwWirfsSwaCIZ0gu8FW6/bRQIUnIu7CXH5BwlT3/fGrYt8GcR5q/OCXMIEhrbzB2
        qG0UOns2NyOVcRwTwJ7uSsKG51M5cOt6E1gfIYfd2Vu/rVj9OpcpTJ9VWjNuuTFQ
        EPgMj276bG/COzyiwXaXYEf2QqZl82GKo0YKpuyjDjeXq7+s2pz5hnHcKli3MAdQ
        ==
X-ME-Sender: <xms:qK_uXNuZgz46WLK6JzCxhI2Z6sOCgIk4F7hCvC1baOFnS8w2qPku0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgnecukfhppedvtdejrddvvdehrdeiledrudduheenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:qK_uXKs5TDtr6m1beB4ua8bo07yONvLeBRjRCBBNIIojXLniWxHvLA>
    <xmx:qK_uXLwck_CqfKQZw2ADz6MHIw1iMZdRh-NilBd7pfTkwfWuTjMeZw>
    <xmx:qK_uXIgtwy4j2yxCEB1edcNIilEo1DIUZlU-xWMnBf22l58Mbltrew>
    <xmx:qa_uXFofdbpmCBtU0Ufpc_KzWJxB6z2Qu870gOEgye3htJpQAcEIxEudC00>
Received: from localhost (unknown [207.225.69.115])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60001380084;
        Wed, 29 May 2019 12:13:28 -0400 (EDT)
Date:   Wed, 29 May 2019 09:13:27 -0700
From:   Greg KH <greg@kroah.com>
To:     Jan Beulich <JBeulich@suse.com>
Cc:     Ian Jackson <ian.jackson@citrix.com>,
        Lars Kurth <lars.kurth@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>,
        Wei Liu <wei.liu2@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Juergen Gross <jgross@suse.com>, stable@vger.kernel.org
Subject: Re: Linux 3.18 no longer boots under Xen, Xen CI dropping it
Message-ID: <20190529161327.GA16496@kroah.com>
References: <E1hSRQF-0006xk-BS@osstest.test-lab.xenproject.org>
 <23778.34168.78221.110803@mariner.uk.xensource.com>
 <20190520114147.GU2798@zion.uk.xensource.com>
 <5CE2B0DA0200007800230A08@prv1-mh.provo.novell.com>
 <23790.44034.186393.25330@mariner.uk.xensource.com>
 <5CEEADE80200007800233811@prv1-mh.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5CEEADE80200007800233811@prv1-mh.provo.novell.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 10:06:00AM -0600, Jan Beulich wrote:
> >>> On 29.05.19 at 17:57, <ian.jackson@citrix.com> wrote:
> > Linux 3.18 no longer boots under Xen.
> > 
> > This has been true for over half a year.  The Xen project CI has been
> > sending automatic mails including bisection reports (see below).
> > I emailed Xen kernel folks and got no takers for fixing this.
> > 
> > Unless this is fixed soon, or at least someone shows some inclination
> > to investigate this regression, I intend to drop all testing of this
> > "stable" branch.  It has rotted and no-one is fixing it.
> 
> Afaics 3.18 has been marked EOL upstream.

Yes, there will not be any more 3.18.y releases on kernel.org anymore.

I don't think I recall any people complaining about 3.18 breaking on
Xen as the only users that I know of for that kernel are some SoC-based
devices, and they do not use Xen.

thanks,

greg k-h
