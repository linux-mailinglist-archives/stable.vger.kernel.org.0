Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015172B5CBE
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 11:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKQKTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 05:19:06 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38613 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgKQKTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 05:19:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7AEF75C01AE;
        Tue, 17 Nov 2020 05:19:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Nov 2020 05:19:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=lrBqZxutbQQC0r7tQ5EGoI5qW4I
        F9ABXIiHc5BSaioQ=; b=qTl85RhIqC+SA3u/pSEo+hSR7DriCwSbHf9YLMih4QM
        KSYGzSkE7Z1ndvfRneNhh20qU6zFk75luqgVzs655SQ2Lmd6JSxVooon2YJFG/bp
        iUbNvk9FEa/Yvi4z5FBMtwVwqQdZdu7MM1v5R+Zl7bbemRtZC92EIu6q1kEhzDAO
        0TU0z57yr1ijmJL2EqzROLA5CGEU6fdP9fQKPwxGXm2bPx8c0vN5vXiByHXTHO05
        tILT/eustv/VTuzrhfw2TumFCVDO5KmuayWjOev3rLK0SFAeWpurAZ81N0a9RBfK
        jO4XO2u3J8D40byo9r47V+zDTXYSxTRycpjM6wDTYZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lrBqZx
        utbQQC0r7tQ5EGoI5qW4IF9ABXIiHc5BSaioQ=; b=LgRnk9qsQi+TKjcXyHbEWp
        OYI/IqY622PoHx8RsJ8MRGrvVFjKa5h6sXbcPNpyjFhBKQ1q89elu81jVUWuOegS
        bIY9/tGE6TWn6W7pvrIMrGszScUZCm4eRqaR26ygbwNqQasY0f9Bhz5gYyE8cJmk
        2FbHYREFUbFJC1+EbNBmKuN45tQxLnLc0NYEzRJTMVqQ0C5xc7WTA6QWPTSqFgFy
        9SrBcHuZx1FI5NZKUG/cvrB7hMXU6AcO++JJZwjqFJZoInePrJaMPKAC3ODbvLlN
        lswHZz//25YNwjGlYx6NKNW5AJv/gl+7pqCBDfuceYariL7CS09ZSmr09HUGxWVA
        ==
X-ME-Sender: <xms:maOzXyj-2Gv5zM9NwAD1If4iMdLK6l4F8xbRh4LT_WS1p38jlx3QGg>
    <xme:maOzXzBDkiQs_R21M19UWyS-NixpPJqAW86ysJzYqcBnRb2m7k5I1UOW7tAvw1NM-
    48LTXihm_wqvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:maOzX6ETRIKkCQXP6HLzn1-N5JASE9S6dol5XQHlqlsXCZ3OI97oqw>
    <xmx:maOzX7Rt7ptZroZhr4oUOYq_FqwSlyY3vWaqxauaPHC-F7bAfhpvyA>
    <xmx:maOzX_wxSBGiDSSB4s65qwtv4FrPhf-VMqFm74BgNCOwE0wq6FYzzg>
    <xmx:maOzX6qwvOrCNhY3LYVwDZUdVxqeL-tukBrvC1KsEwkuC2HGAmW9UQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA8373064AB7;
        Tue, 17 Nov 2020 05:19:04 -0500 (EST)
Date:   Tue, 17 Nov 2020 11:19:52 +0100
From:   Greg KH <greg@kroah.com>
To:     Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH stable-5.4] drm/i915: Correctly set SFC capability for
 video engines
Message-ID: <X7OjyFVyzNESwPfT@kroah.com>
References: <20201117000326.3138-1-daniele.ceraolospurio@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117000326.3138-1-daniele.ceraolospurio@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 04:03:26PM -0800, Daniele Ceraolo Spurio wrote:
> From: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>
> 
> Commit 5ce6861d36ed5207aff9e5eead4c7cc38a986586 upstream.
> 
> This backport targets stable version 5.4, since the original patch fails
> to apply there, due to a variable having moved from one struct to another.
> The only change required for the patch to apply to 5.4 is to use the
> correct structure:

Now queued up, thanks.

greg k-h
