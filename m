Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B7626A02D
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgIOHvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:51:21 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39165 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgIOHvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:51:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id BA0427EA;
        Tue, 15 Sep 2020 03:51:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 15 Sep 2020 03:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=/SYl4VU/Mskmg5yDC5KU0DZ3PHl
        lQlrV4+qAjWot7/Y=; b=YZ3OEG51m8cWpSRplSX4vjr93Mn3/GaZj4Rh4LgN6FW
        QEXGzaBhkJB1BMoovEeRstwFtvlTLFOgCAYyYOX0hj9LKcCyCpy6srY77EwKnW04
        I7N2NSuzUoGn1yzrKaEURN69CAjWJ+TNRj9MciMoiHKuFkNJOGaLL/wuL/pmEQVr
        Mf/XJOtYo8dDjFuidbnKuCRYzyq/vjIOxI4s3unAuGiPnKVXqFluERNYGCkFesM6
        fR440z7rOBkHjnQOLhbhy+QISnrnzaA4w06yqFmqREpNW5XYk6bACG/wEnoqO/Wo
        qZSLqcpiY2paXtRjJV0bjngSKgzuGTzXIX/LHrpFWHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/SYl4V
        U/Mskmg5yDC5KU0DZ3PHllQlrV4+qAjWot7/Y=; b=pveAemdrf6Ecg4Vgcbrgn0
        IAxQ1Ib010+qWT6+XloCD+ndtjVVNprw77o4xA5imn0qciVs8ZxI4eL5si6z2RWo
        rwAwkKFVIasJazeBvLWOdEsUaaOAF9cOasKvJMKedhyUBg5wy7EKNjC3jy006+Tr
        E8VfI1A+qVHqCsGbq+FWd5SWqUcBOB19niBGYys6Z9v1zaqP1dUi4VpBZ9PPso7S
        7hA9HNuT+zd4NY7ixNnuNvKSL1s8iV5GNxoL279Eopbu6tsLOFwmt6OldI63bbhv
        BG3AjisO7Y6d9WTx6RUw5Z6k58AMJCGW57IRmwQz6y+v0KcB0k6GCsRB8heqQEXw
        ==
X-ME-Sender: <xms:a3JgX-4GHiigKTNUiPchhy7Zf4Gd9VDHGauvUFRJn_YEH7pdAReeTw>
    <xme:a3JgX37jYB7_chKMPSl-h_JEvDSZNaY7DeZihtt58dPLtccjs7BQ5oru_cNaHjMWN
    5ndokOhqe4mGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeijedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgfduvd
    fhvdeugeeiuedvudeltdegvdetheethfekveekhefgtdelvdfhfedvieegnecuffhomhgr
    ihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrkeeirdejgedrieegne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghg
    sehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:a3JgX9doLO-Z4pkjVMeyjdyszjmnJyYxXXEP3NKdG11DBpVH51o9Wg>
    <xmx:a3JgX7I5MRka4DXkhyan_TEYkPAP7goaqrNXtCuKWenBzPQ2CQ4htA>
    <xmx:a3JgXyJBJ7xQ-W5bNKLWISsg2rFrufdcDNxDVedMoAL1Lop_hYuNDg>
    <xmx:bHJgX0gJP9Ly0-sLbMG7bxfMc9Y1ruZ42f__Xg83NE1YjX_080ye0g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F9C5328005A;
        Tue, 15 Sep 2020 03:51:07 -0400 (EDT)
Date:   Tue, 15 Sep 2020 09:51:05 +0200
From:   Greg KH <greg@kroah.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     stable@vger.kernel.org, zhenyuw@linux.intel.com, julien@sroos.eu
Subject: Re: [PATCH] drm/i915/gvt: do not check len & max_len for lri
Message-ID: <20200915075105.GA4066435@kroah.com>
References: <20200811071651.3446-1-yan.y.zhao@intel.com>
 <20200915023522.GA15082@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915023522.GA15082@joy-OptiPlex-7040>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 10:35:23AM +0800, Yan Zhao wrote:
> ping for backport.
> 
> On Tue, Aug 11, 2020 at 03:16:51PM +0800, Yan Zhao wrote:
> > hi
> > This is the upstream commit dbafc67307ec06036b25b223a251af03fe07969a,
> > and we'd like to backport it to v5.4.
> > have done the code rebase for the attached patch.
> > 
> > lri usually of variable len and far exceeding 127 dwords.
> > 
> > Fixes: 00a33be40634 ("drm/i915/gvt: Add valid length check for MI variable commands")
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Link: http://patchwork.freedesktop.org/patch/msgid/20200304095121.21609-1-yan.y.zhao@intel.com
> > ---
> >  drivers/gpu/drm/i915/gvt/cmd_parser.c | 12 ------------
> >  1 file changed, 12 deletions(-)

Now queued up, thanks.

greg k-h
