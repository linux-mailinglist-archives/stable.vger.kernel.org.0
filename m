Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C738F3C9E17
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhGOMCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:02:19 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55961 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231338AbhGOMCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 08:02:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5E6D85C0246;
        Thu, 15 Jul 2021 07:59:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 15 Jul 2021 07:59:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=a8uhbqnZKOALPLls5flXNvrthFH
        5PhukzKOQKOHHgz8=; b=M+NcrrpG6MlHpxNiE56Wx/1PFYAA6zM/oy78HBj1Y2e
        0J8qSg3PJdtu5h+AnR4sAGJC8TBp8AUW0LuqpoA2p/UwQ5sXtLTCxd3aLhjMus3C
        B61obXsfslMIldTJsKKFHV2gp/+3VYZ8cby5U4B7scDhDsojvdC1O3v7Zbr55dWb
        n+je7ovRd3RnHSYtqkywVLmmXJsPqScOJ3qcPgL2Q6ztkDzfMeoIYRtznoYlvxJL
        PQEg4gR1zGkybuuo8nyg3SRWjtScuQHFWgsWOu+LfCGnqyPekk7x4924eIXySwlf
        ZEVlb3OFcgVzKe5tWdD+m8yq7wj0nV/1hTu1cUY4lwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=a8uhbq
        nZKOALPLls5flXNvrthFH5PhukzKOQKOHHgz8=; b=kwgGhl5TIy04JikflmffGZ
        TVmHtBS8HN2WmNEKdspZgTEKI09ivSqAqJf3tJ2lCspLXneYqUjfRs0c0xchicbK
        NvZrZSdWk58ctVoZ5F8XtxjBEULm/QV63wr+LYFDAx0O8kJ7z7MlIxGBzzkYbjx6
        sReiBSPoqqqd/Cty9YocLjMYrxORMXjo19s4yl3Wl4TJ+RUG3BQMUF3OFlG0rlwr
        WFaiSk22d57d2bViRQyKWPr1oDSQDlgyycmpIQykAsWHJFkaU2yFDrMf0y0A0NUu
        zwwjch30vTP07h9d+i1HHHoLmC0AA3AFxUFibWtFceOXR2gYdndK7GL7luBjJE0Q
        ==
X-ME-Sender: <xms:HCPwYAGlqA66aNDiWCjbDf5IzBMl2JmkqUDRiQMiSFYzl3Lh_wOfnQ>
    <xme:HCPwYJVD7wQZ_ABGGvLzLAkMkI40LDCsFmmtLy9Mhr9C8Atm7WTPawhHsQCqIKTTp
    5_17hT-53o90w>
X-ME-Received: <xmr:HCPwYKL8U4sCjQbbVBQpxC31sHe_Nme777AQPFViPRYrTNzFAq91qBMcpFkdYM7aZpPUsKV6j-OAFiC0HkVR7o4eMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:HCPwYCGJ923k030XzJF8dWSTlXiHwWbYWHepZvdWPJKj-od2wR3aPw>
    <xmx:HCPwYGXNSHzBnpZPMvw8vgAslhPwcNphHQNvpyH5hblmzyByB0hO9w>
    <xmx:HCPwYFPOisPPpP8XEoXn6QuSXGTOixlQTvJORv1EuZ4YDnqjmn34Iw>
    <xmx:HSPwYIJM_dlRhhvo8D4uE2jScQ0FRtLvU7lr_Vvu8xekNjXp_UC2Fg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jul 2021 07:59:24 -0400 (EDT)
Date:   Thu, 15 Jul 2021 13:55:02 +0200
From:   Greg KH <greg@kroah.com>
To:     Davis Mosenkovs <davis@mosenkovs.lv>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4] mac80211: fix memory corruption in EAPOL handling
Message-ID: <YPAiFsEncZ95Oomx@kroah.com>
References: <20210710183710.5687-1-davis@mosenkovs.lv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710183710.5687-1-davis@mosenkovs.lv>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 10, 2021 at 09:37:10PM +0300, Davis Mosenkovs wrote:
> Commit e3d4030498c3 ("mac80211: do not accept/forward invalid EAPOL
> frames") uses skb_mac_header() before eth_type_trans() is called
> leading to incorrect pointer, the pointer gets written to. This issue
> has appeared during backporting to 4.4, 4.9 and 4.14.

So this is also needed in 4.9 and 4.14, right?  If so, now queued up
everywhere.  If not, please let me know so I can drop it from the other
trees.

thanks,

greg k-h
