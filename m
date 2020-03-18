Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAC618A221
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 19:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgCRSJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 14:09:48 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43161 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726845AbgCRSJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 14:09:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 506205F8;
        Wed, 18 Mar 2020 14:09:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 18 Mar 2020 14:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=BaF/AmkdasImaw/ofxKY2yRm4EA
        idm3KEyzRDXsySvg=; b=BvHUVEr9fvAs2xBL9U32NTdAOMT0LvlElB+og3aw6/c
        iVYvNYrZLK0+iy8tFfsWAXOJePTEIlDzROg/bqDJqAxF+DLCANHHfD7JQaW2DuMv
        YXa0M6eWLScfeVPgq3u+vVyaZaoDtjp54Wmv57+YErAAKnyDppkYQBoIRgLi9VS0
        WEc/n0BmUPAFqRjI6MKs3DvYDo5AiPfR0zcj77DZH0xtq6F0M2JP4BDzj0lUBUO8
        tyDeNzuRvTxJ3An+nkO0hHmLVJDeAYovsY1x7mAXUaqjKB7vlnRDFCcvBZL6rOAl
        otMprHUfhJB/6TZHgTKwseRK3ObZrYLNDRET93k4w2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BaF/Am
        kdasImaw/ofxKY2yRm4EAidm3KEyzRDXsySvg=; b=B4gMeK++w6hxSrkhTJ0do4
        2hygv9nubRDsCXDrgcWcOQ54szLTqzucZ0R1D6QPPMF1OcWirhuC4vu6bSor2BR2
        23nvsNZ9YajyOAIz5dYCvqs4P7XuQbKVxJoFhkf3yiWMb+5JPETitvc3sc3rrc8P
        X6tzxD4CnATT8IDr4g3ndTAo1Gz2ZG/pf8EISqlVHn8nkzK/WbKdtG+WM5LFSOJl
        JSikCjYKSkZyoYVMj8WJtpbnisPHrIrrOA4LnxFYN0nv1f5zVmKC7tKOK8fH2cjA
        AufSQ7FplueWPDLOxdEc01vSZVboN9ToFBYzenZXiSdMpZkQJ7XbynTjm5x1SWIw
        ==
X-ME-Sender: <xms:6mNyXqG7HyX7rSmjkxNlPXRJ6eLHlN3M1kSpv3A_cjTaCW5O2he1tw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6mNyXtaPMhRGeqKmCoOHs1KtvBurY6PqPxp52rYkfNVODoZ4TYJh0w>
    <xmx:6mNyXuPJdKfk-PY6xxIea0o-J_m9daRPkwJHfwYlAubBOQOFDVhK-w>
    <xmx:6mNyXuzSCDc6asfQtgJyXt-9sX6LwdZf8UdfSYNAVJSzHvBZckgTXQ>
    <xmx:6mNyXlF4BQ_JFNyv7jg5rxLV6ClQhWqemNcgcE8fglEUDHUJmRsytg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BB03D30618C1;
        Wed, 18 Mar 2020 14:09:45 -0400 (EDT)
Date:   Wed, 18 Mar 2020 19:07:44 +0100
From:   Greg KH <greg@kroah.com>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/48] batman-adv: Pending fixes
Message-ID: <20200318180744.GA3234196@kroah.com>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 12:26:46AM +0100, Sven Eckelmann wrote:
> Hi,
> 
> we were asked by Greg KH to check the failed backport of some recent fix to
> linux 4.4.y and provide backports for it when required. I've found a lot more
> missing patches than I've expected in this process and queued them up here.

All now queued up, thanks!

greg k-h
