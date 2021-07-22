Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E9D3D2514
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhGVNWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 09:22:03 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:33557 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232177AbhGVNWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 09:22:00 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.west.internal (Postfix) with ESMTP id 7B83E2B00BA0;
        Thu, 22 Jul 2021 10:02:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 22 Jul 2021 10:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=C6CbgvrWGhTSu1mJtUQtOVibztV
        iE1SUbR/gHueA4Ec=; b=cn/4EYJ/72loKaRLF/QhNBFjZ6M/iTZKsxYyiRNfmUW
        /bjTttv/sGLHT5WhCnB1cf1xLWBnq0v/76gYOSwvqVj0DOhCHrO7x5a1jYUXC0vi
        ZmPNispxN7PG7HQIA+zTy/9Gv1BW6S6p5zzkyZUGR2sTq8kYLpIwwzHdjQqcznte
        d3wnUPojh20p/rTNjnth2Ffyr5JOfxf2fCblYIfQ0s7mgwyDBCyNCCUtAfD/rUHN
        VpqrSf/zcOX86IjfVohj7kiz9WXVOrSqyed1v8jrvrpAIEESQmaQptHVD8SW1fuA
        EptwgfhFB9NMQYEx5PPPd9+HflXPMl+BtGUVooiVwIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C6Cbgv
        rWGhTSu1mJtUQtOVibztViE1SUbR/gHueA4Ec=; b=JctVrWUEhlKVgRiSy8dNS3
        sb9GpI2BSiBqqsmmzJpVg8sDzKFxF3YRBtMNpC1zgu7q+N1g6EtylLL8HehitVwg
        KxqpwpM5ZEf+tvJEGdEz04FyOzakg5AOAYW8bs7O+28BipdP9O9/J8dWdHYloD7D
        iORaCnlDKgfi9jST/I38U747CM83PxPAmhQxu3qO2ygWDtd000mRWyn211+MT30N
        s1JxxMry2ac6OKTqtYmmZtmO9ZAB3tmK+UlKDgkpPzkp6kN/QgYGfE+I4D9pl6sm
        X42TFVzHZZdVV53ebFyQMOBZolUpFWB3j7IAk5Y82mhNRtBHFcPY7UDgnX9sGSaw
        ==
X-ME-Sender: <xms:b3r5YBEGXNbUbunn0Erl3Ne-pCJXaRUdUoVMIBFFltyCkAq6-P3ksQ>
    <xme:b3r5YGX3Q5CYNgyCwZPpomKFF0SLB5ZgNRpiM-TAgTw6J2IWygA14otib8SdI4MFg
    mcHnmn3UXq-ig>
X-ME-Received: <xmr:b3r5YDJssRth_o-PDkQWus9RobylSNNE8w7kidtB9N3JX0SLcBErx8wNghNLxzverRtDiQI2cOlcGk1W--XeBLYTk5a_9gtt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeigdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:b3r5YHFpu5AwD4syxJbefWI2MgXysHPhfcsd_TfzXMAPrO9gbfW1-g>
    <xmx:b3r5YHUv92422nvmLxLtsEezvLZ6uBVaNZrzkNpux8vtqV-_zU0yjQ>
    <xmx:b3r5YCPvpAqX0H2QyHWieYr94Vcon8CACNcfBt7TgYXV0o4GTfalQg>
    <xmx:cHr5YLncO5kq_whLMPR5tUxILMUGV1KlR6fkMenA0kVL4m3tpMMe0FGlJkU>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jul 2021 10:02:22 -0400 (EDT)
Date:   Thu, 22 Jul 2021 16:02:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Hugh Dickins <hughd@google.com>
Cc:     Peter Xu <peterx@redhat.com>, stable <stable@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <hdanton@sina.com>, Igor Raits <igor@gooddata.com>
Subject: Re: [PATCH stable 5.13.y/5.12.y 0/2] mm/thp: Fix uffd-wp with
 fork(); crash on pmd migration entry on fork
Message-ID: <YPl6aimUo8XiBAcF@kroah.com>
References: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
 <20210720155150.497148-1-peterx@redhat.com>
 <CANsGZ6aEW8pEncdoh_mGxKF-Se0_-O=E124EywULWvJ3qC0aVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANsGZ6aEW8pEncdoh_mGxKF-Se0_-O=E124EywULWvJ3qC0aVA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 20, 2021 at 01:32:19PM -0700, Hugh Dickins wrote:
> On Tue, Jul 20, 2021 at 8:52 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > In summary: this series should be needed for 5.10/5.12/5.13. This is the
> > 5.13.y/5.12.y backport of the series, and it should be able to be applied on
> > both of the branches.  Patch 1 is a dependency of patch 2, while patch 2 should
> > be the real fix.
> >
> > This series should be able to fix a rare race that mentioned in thread:
> >
> > https://lore.kernel.org/linux-mm/796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com/
> >
> > This fact wasn't discovered when the fix got proposed and merged, because the
> > fix was originally about uffd-wp and its fork event.  However it turns out that
> > the problematic commit b569a1760782f3d is also causing crashing on fork() of
> > pmd migration entries which is even more severe than the original uffd-wp
> > problem.
> >
> > Stable kernels at least on 5.12.y has the crash reproduced, and it's possible
> > 5.13.y and 5.10.y could hit it due to having the problematic commit
> > b569a1760782f3d but lacking of the uffd-wp fix patch (8f34f1eac382, which is
> > also patch 2 of this series).
> >
> > The pmd entry crash problem was reported by Igor Raits <igor@gooddata.com> and
> > debugged by Hugh Dickins <hughd@google.com>.
> >
> > Please review, thanks.
> 
> These two 5.13.y patches look just right to me, thank you Peter (and
> 5.12.19 announced EOL overnight, so nothing more wanted for that).
> 
> But these do just amount to asking stable@vger.kernel.org to
> cherry-pick the two commits
> 5fc7a5f6fd04bc18f309d9f979b32ef7d1d0a997
> 8f34f1eac3820fc2722e5159acceb22545b30b0d

Thanks for the review, both now queued up to 5.13.y.

greg k-h
