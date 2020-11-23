Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1092C0282
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgKWJun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:50:43 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:41045 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgKWJun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:50:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 44939FDE;
        Mon, 23 Nov 2020 04:50:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=Zt6xL17Lc7Ssyj/EVKQTWYkHTAL
        1DE+Q5z8Pv0sUS/c=; b=N5f8Ujvo+16LIdGbF0X/63sNEucBDGnQ1h6vdMAOJcE
        aHnoVQ8YmvZlsDizl76shzu8uZANYRLSdQLH+JuQjMzhIH2eiX+HbDxkMYsWvAT3
        7yIS7U7dSB46Bv3BFN5hSUktufy0/gJqWfgqfCZwxkS5OQjEsAal4KGwXEf57I34
        fD7KtbqTBuIQrgRo8FtAUC8H0+FaRMNqAWp0SAVJy9PcNDrmWamDNY62US2hOUFX
        LVkzjNtjss7XJNyg5ESYpcEO090LgDHhth3XWqvopqzSX/ZfKFngp+ygUmqaXRDP
        PuXES9sAk0KZKiCoysFtGfA9KcUNJ5KEWH9MOcJd1tA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Zt6xL1
        7Lc7Ssyj/EVKQTWYkHTAL1DE+Q5z8Pv0sUS/c=; b=GMUvRDxO/Fk9yM1EXVVi/M
        tM6zBJW2dzp+EouzCwysmAFTmKPcavT3gS1Hc+A6AMCvRJJrdawJ+r7zBSMrT6Hr
        f+3/CgVVbsPw57lZo34AO7hcmgWVnFL7M2keKW1pKgVaziwBVh48VHNMvmV6pG4a
        NYhfmO96AfTdk/R6vjUOYU+MVLpwrItcFvI1Aijri8RViq2G0nrfVd+aOaNICpAP
        p8Q9yBwr8lHzbdr6DFlNoepabfDaarXzArbIOdfqZPJ2f6dWppjCdfGp8ZFVY24f
        dyzVD5MAshMZsTkZEkbPtolu67kCnmeZn5wlj9idDEsHc/W9e5sdaAn7JiJ9xybA
        ==
X-ME-Sender: <xms:8YW7X_Rlkl5oBae3Lg5-yaZvICGoMDtr6JqcVOqRuwKaGHWg2xEEcw>
    <xme:8YW7Xwy91Kh7ro_AeFciPrFUC9OzYkiPey7GVcr3y1enO2lymkSA-HzWDpAXL6AQP
    f3oCljXHuNjNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8YW7X02e3ar9UJWygR5Ssj1x_wbxR6Qs1aHQV9GEcji9559qOnASeg>
    <xmx:8YW7X_AAddYijCYbrdJNMiOU-OnGn4kbnAvcxtWHFFUksa1li9C1Rg>
    <xmx:8YW7X4jKLKhwOyta959LZp0gqdTzIGI3v3rcEZs76kJxO7N-QEN0dg>
    <xmx:8YW7XzUw9YVDVK6UL7u63U7AiQUHYgVIuMjqUM9_u-2jUOkGByCkEw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECB2A3280066;
        Mon, 23 Nov 2020 04:50:40 -0500 (EST)
Date:   Mon, 23 Nov 2020 10:51:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Ralph Siemsen <ralph.siemsen@linaro.org>
Cc:     akpm@linux-foundation.org, charante@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, vinmenon@codeaurora.org,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm, page_alloc: skip ->watermark_boost for atomic
 order-0 allocations-fix
Message-ID: <X7uGN78QH8gk2q4P@kroah.com>
References: <20200617171518.96211e345de65c54b9343a3a@linux-foundation.org>
 <20201019184017.6340-1-ralph.siemsen@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019184017.6340-1-ralph.siemsen@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 19, 2020 at 02:40:17PM -0400, Ralph Siemsen wrote:
> Hi,
> 
> Please consider applying the patch from this thread to 5.8.y:
> commit f80b08fc44536a311a9f3182e50f318b79076425

5.8 is end-of-life, sorry.

Now queued up for 5.4.y.

thanks,

greg k-h
