Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D75F29E9F5
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgJ2LEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:04:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59283 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbgJ2LEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 07:04:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1E44A5C0172;
        Thu, 29 Oct 2020 07:04:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 07:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=fcUTHlI0YXoRRSufhXhW2Gk3Txj
        GQ2RXt7LzqobeGeA=; b=JY+FH2LGaP9fJXSu8pxCkQhzoAJ7aKORPd9PD17GWKh
        O73naJSonRmM2TlG0DQDOz+4TOv0KRZRB7FxeLlBXy68z+zaQmOv1wkPET77OcZU
        mc4fyldOJ29TYtWggEc3+PJJ4pch9ItlI4qllohS2wfNdmB+sjQRbzJnXdO1qxqV
        8vhfINjUq0sWMxrEV0sZbAa5oCBVWLjnWws33mnbXDeBOqgbQQWpw9aOH6EjjayU
        h0g2ZOyKMVcjDEHjmJ5j8Vpk+qQz6oLH3t4F+rQmXQP9oaKev8a8TCoB0bjUJLVv
        9d9dvyHog+u9t3TPzBUan2JJSidHqSTnEYXywO69NmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fcUTHl
        I0YXoRRSufhXhW2Gk3TxjGQ2RXt7LzqobeGeA=; b=cWXOO2mwWykEfJ84ae4v22
        qRUfypIZwrW+OQ5uTw98qHFzfyaGihB2ztbbyy62SzRp+gpZqoy78+GxDS/uxTL7
        gE3IFUHPATYtaYyQN/6C5YkxdMvaIrv5dbEtQO5eaGLVAVkrNFvIYKLIPDfJEuUA
        8WphxFjqWWeK6iUnE6cjT4VHEVbfy2NQuxZ+ZDgF8D/8CyU3n3AkyHVvRaIdjJKk
        PfRxcP6RZO5pyfj0plgPQ9u9Kcp5xLqfbUrVPBB/T4DGfmXjaUD4+3HFAuksjOev
        btxke1NtRjpRe2LVGOcljEwpZnLb6xW0cncqzFD5c2UDHLVwpQwYLRSmgbdEoWEw
        ==
X-ME-Sender: <xms:0qGaX4bcs23oOkWKmEGiAWzhhFKg8CexyKcUZbgA7oi-v4JTLr_IXg>
    <xme:0qGaXzZlMxXOJ4qu16Owfm5c_z7Mypdg4ksbn7n2AZ3sGMXIBpArLdTPjbhJkKvzn
    5__38Is9t7MOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0qGaXy_0-EzflJMBJUNi_vbf4daQAboPJW_Gyfzm4SxEukXD3KpePg>
    <xmx:0qGaXyqemZN67CcZCfevKr5rLuODJs4iQzZfdEC4O4-FLARKkdKejg>
    <xmx:0qGaXzrYfVMi7ix9TeT7BKnM0aNq6ombRgUxAjjK0cZASH__IER3Kw>
    <xmx:06GaX8CEcn2sBv7KDbSsDUT5ZyyVhpSmZQw0zJGnbHJALJS3VrJPAQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 837A63064687;
        Thu, 29 Oct 2020 07:04:50 -0400 (EDT)
Date:   Thu, 29 Oct 2020 12:05:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Calum Mackay <calum.mackay@oracle.com>
Cc:     stable@vger.kernel.org, linux-nfs@vger.kernel.org,
        NeilBrown <neilb@suse.com>
Subject: Re: please cherry-pick for stable --- fd01b2597941 SUNRPC:
 ECONNREFUSED should cause a rebind.
Message-ID: <20201029110537.GF3840801@kroah.com>
References: <380083cd-f5f5-73fa-33ff-c5dde2e7bd02@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <380083cd-f5f5-73fa-33ff-c5dde2e7bd02@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 11:42:27PM +0000, Calum Mackay wrote:
> This commit:
> 
> 	fd01b2597941 SUNRPC: ECONNREFUSED should cause a rebind.
> 
> (originally applied to v4.14-rc1) didn't appear to get a stable cc, perhaps
> because it wasn't considered a common problem at the time.
> 
> A patch I'm shortly about to post, cc stable, depends on the above, so could
> it please be cherry-picked for stable?
> 
> It applies cleanly to both v4.4.240 & v4.9.240

Now queued up, thanks.

greg k-h
