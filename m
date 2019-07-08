Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD6E61FEE
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 16:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfGHOAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 10:00:17 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57017 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfGHOAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 10:00:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DA0B0220C7;
        Mon,  8 Jul 2019 10:00:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 08 Jul 2019 10:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=vLQH6OReOS/WZJ9XeTJDw26kFTV
        9th50qcbRcIOBSHQ=; b=AL1vqa0tnZ2mCQaiww3WAfOeFrM0BIbMbGfozXSfKNH
        WQvizjXKG9k8id5Z16lzSuyU20n/8RCa4//xWXR2rTwdcriv4K8tV7WsegYs5ZFp
        ZJkec++t13uhqXtHMv2XWXTBFqUMmuAdm0vAhDTh97cqLIb8Zt0fVtkPo8aCIyjx
        qbIUiEr60oVWJ5I2sMhglBbHdZ//QSmbx6cpb5457XQ/MKTQgsn+9A1DRSXQUURO
        unBTlBm+UM0xG3IJNaXW0IkzdtrwXfxMuc24NLqbSQVwL0BLJMwcQTwS52Dm+9fY
        qzAgu5ZVYpUD9uUgNUlag6C+NHOsFsymjCJ7JigGhZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vLQH6O
        ReOS/WZJ9XeTJDw26kFTV9th50qcbRcIOBSHQ=; b=u6rXVs8VR5xOWMJ0OC+6Gw
        PvMZMfDo1ty9rXA4OD52fvbyanG2UwZiu5nF+2oY/2dVcNFoA2hIZCmdnVtMS15T
        12T3qrmtZHItT1r0isOdlnGPryP2g16vaqCrEXr8iYyleL5LtanrkQ6sAovLt275
        N6WQ5bLwWNkw85vIZxxN07V+Hkn8l6D8AaSqqpveAZcdYk3x/vO6bpxAZ+fHqBQe
        Vq+h6EDJM175CtwC8iy0FtF2UkjzB28Cv2vp/ahrsNs4lLed4dVTffkaGuLeQaOb
        WcJJzYyZZk7VVe9UxG7mgHN14wVXFM+jkEIOoHpXMpURMwU60jFecbqxSBdj+QEA
        ==
X-ME-Sender: <xms:b0wjXf1-0pQpxiQfaesxDVzJWPQjYUjq-Kp-r0srPaoAUNKfQQqmlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:b0wjXfnIxDyicltJsfOCtFrBXcbG9v1rSge1OuiJZQTj25_m0aF97A>
    <xmx:b0wjXUen9CN6caLu9QrTVY7wZdZG2ZgGjeNnbgEcrd8c5xj228UE_w>
    <xmx:b0wjXUWt2oiw0gVEaaFYFpK1LVc8CyHp2_mWThO20YvPEJ-oqO3UfQ>
    <xmx:b0wjXWpTXwyC-hGIg9LpmQZLKOB3PFW2KxSSK5_Gmq1_e0VrQx3Gzw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D3B65380074;
        Mon,  8 Jul 2019 10:00:14 -0400 (EDT)
Date:   Mon, 8 Jul 2019 16:00:13 +0200
From:   Greg KH <greg@kroah.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4.14.y] stable/btrfs: fix backport bug in d819d97ea025
 ("btrfs: honor path->skip_locking in backref code")
Message-ID: <20190708140013.GA21679@kroah.com>
References: <20190708120130.GA25587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708120130.GA25587@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 02:01:34PM +0200, Stanislaw Gruszka wrote:
> Upstream commit 38e3eebff643 ("btrfs: honor path->skip_locking in
> backref code") was incorrectly backported to 4.14.y . It misses removal
> of two lines from original commit, what cause deadlock.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203993
> Reported-by: Olivier Mazouffre <olivier.mazouffre@ims-bordeaux.fr>
> Fixes: d819d97ea025 ("btrfs: honor path->skip_locking in backref code")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> I did not test the patch, not even compile, but backport looks
> obviously wrong compared to original commit.

Thanks for catching this!

now queued up,

greg k-h
