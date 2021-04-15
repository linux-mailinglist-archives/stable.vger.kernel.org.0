Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29357360B0F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhDONx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 09:53:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39321 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233059AbhDONxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 09:53:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 96A455C0160;
        Thu, 15 Apr 2021 09:53:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 15 Apr 2021 09:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=z9XkYCm8HOjIYhcWASUjOTPp1E1
        JupswHFiRaRRGAsw=; b=PE5+QkjNwpSkVo+qPmYmBkFDC301m1u0iVC+nfawBiJ
        BF+OJbf/husYzO+YNAqE2fGepylr7LQxNC4favGplvgUo1+ag5P/JiLQtMFhRNnG
        GyTqgw1gbHysWaUngQBNE9ExSJ34M+88IqTOukU2XwDU6l6QdTdI0NAeOJbCLj9G
        btv5sTH3ywgYcX5r7HR/JAnTzIbila46T22OSx4PphYi2uobHNaF4PbQFy1rL9+a
        GylY6YI+lxk77KooP4N81dR+kCel3O97wcNjH0vYnUf+L61pnJAA6NSvjltAh0Wm
        GmtkDJGdEnNG9XCqW9QxeeEg36WxPTk0oRdjX+xwNCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=z9XkYC
        m8HOjIYhcWASUjOTPp1E1JupswHFiRaRRGAsw=; b=n2Ddsnw76bI3G+q1/SvPOG
        Cayz3CIqLDlQCHHZlg1wcfzx3uvbEwDeRWVA/ig372f0LSCEPhwxnbUS/cDLdrsd
        tGr3LO7cZBUqLYeiv21NFKtxqk6wSzA09l2wO7yENF4Riee0GQqkpR8L79muyzf6
        0rBAAGRMYFY5VK1bT7JlI2nI5vnbTzFcmBu58tHwotcGswXEFNRIoM8osfIPK0vb
        DGHOagxTshunVtyD2LhjztQMa8BMmpTx58/HrrExTF4Z7/jZ8jzYza2HJl98Bytn
        XI2CaTqGN0YAiORWB4xNVTJj8MhvzyrUUoFdxiwdBeT3ickfkunGXFeiKWooE3uw
        ==
X-ME-Sender: <xms:VkV4YBOmGy4R-ghZ3wgumtevfQk-3Se4k3qwVKoVhSQaq9slkthxug>
    <xme:VkV4YD5J9HQktQko9q1aXr5cJa8px3dgVjpTULdTK3BIBa1uL1Z_O-5ZqkFJP1dtf
    OnTVzLGtSXPGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelfedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VkV4YNLYHTAhZHXt3HPidQ_vspU8BYHLvs_O5WjdVu_PcPzzUf2TkQ>
    <xmx:VkV4YFfqxAyVyMrH3GoA11VDC8nx9u0nTVH7xsiWjsSgkuPIBP63cA>
    <xmx:VkV4YIf6lONd3IIfYQXQkPVGs3Q3KhGxRFMrdoRpldQveX_zgph_EQ>
    <xmx:V0V4YGYezkn_vR9nUnfzsvnV5H27KmI6HXa1LsCz81HdWloj972zeA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C5FF240065;
        Thu, 15 Apr 2021 09:53:26 -0400 (EDT)
Date:   Thu, 15 Apr 2021 15:53:23 +0200
From:   Greg KH <greg@kroah.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        acme@redhat.com, ravi.bangoria@linux.ibm.com
Subject: Re: backport patches to linux-5.4.y
Message-ID: <YHhFU0khjvEprp4z@kroah.com>
References: <CADYN=9+JDiZarjWUZKT9P27UgDYfR4afGbH9CMd3jtxQi=8ZyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9+JDiZarjWUZKT9P27UgDYfR4afGbH9CMd3jtxQi=8ZyA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 02:11:54PM +0200, Anders Roxell wrote:
> Hi,
> 
> Can these patches be backported to linux-5.4.y, I've tried to build
> perf on arm and it failed without these patches.
> fc8c0a992233 ("perf tools: Use %define api.pure full instead of %pure-parser")
> 20befbb10803 ("perf tools: Use %zd for size_t printf formats on 32-bit")
> 77d02bd00cea ("perf map: Tighten snprintf() string precision to pass
> gcc check on some 32-bit arches")
> 
> 
> 
> Commit fc8c0a992233 ("perf tools: Use %define api.pure full instead of
> %pure-parser") fixes:
> 
> util/parse-events.y:1.1-12: warning: deprecated directive:
> '%pure-parser', use '%define api.pure' [-Wdeprecated]
>     1 | %pure-parser
>       | ^~~~~~~~~~~~
>       | %define api.pure
> 
> Commit 20befbb10803 ("perf tools: Use %zd for size_t printf formats on
> 32-bit") fixes:
> 
> In file included from util/session.c:17:
> util/session.c: In function 'perf_session__process_compressed_event':
> util/session.c:91:11: error: format '%ld' expects argument of type
> 'long int', but argument 4 has type 'size_t' {aka 'unsigned int'}
> [-Werror=format=]
>    91 |  pr_debug("decomp (B): %ld to %ld\n", src_size, decomp_size);
>       |           ^~~~~~~~~~~~~~~~~~~~~~~~~~
> util/debug.h:16:21: note: in definition of macro 'pr_fmt'
>    16 | #define pr_fmt(fmt) fmt
>       |                     ^~~
> util/session.c:91:2: note: in expansion of macro 'pr_debug'
>    91 |  pr_debug("decomp (B): %ld to %ld\n", src_size, decomp_size);
>       |  ^~~~~~~~
> 
> Commit 77d02bd00cea ("perf map: Tighten snprintf() string precision to
> pass gcc check on some 32-bit arches") fixes:
> 
> util/map.c: In function 'map__new':
> util/map.c:125:5: error: '%s' directive output may be truncated
> writing between 1 and 2147483645 bytes into a region of size 4096
> [-Werror=format-truncation=]
>   125 |    "%s/platforms/%s/arch-%s/usr/lib/%s",
>       |     ^~
> In file included from /usr/arm-linux-gnueabihf/include/stdio.h:867,
>                  from util/symbol.h:11,
>                  from util/map.c:2:
> /usr/arm-linux-gnueabihf/include/bits/stdio2.h:67:10: note:
> '__builtin___snprintf_chk' output 32 or more bytes (assuming
> 4294967321) into a destination of size 4096
>    67 |   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    68 |        __bos (__s), __fmt, __va_arg_pack ());
>       |        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now queued up, thanks.

greg k-h
