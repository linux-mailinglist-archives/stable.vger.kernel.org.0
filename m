Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688D8400A10
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 08:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbhIDG1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Sep 2021 02:27:52 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:38241 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236031AbhIDG1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Sep 2021 02:27:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4282D32006F5;
        Sat,  4 Sep 2021 02:26:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 04 Sep 2021 02:26:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=gKOyjhg9rJNTM58ByVEg1kBVaUW
        vU7wyrXEzfhhiASw=; b=Q7Oys5NEIn6gJy4sxhBgr5rdDgkaaTFsfxqS3r1BJ1G
        cg7flbZaSNByTFM08W9uX6hDKNfWVJxZ3Hvz9eMuBqTX7gS8/zUvfjPYyziQ/P+T
        MBLYKPzSETNTcy6hQVqJjR7vDg6JnYRQ5lw4NPEPB3HhJzpWeC1d/PSNoL54D+dm
        nIpFJ2dchLraJapc1zgFJNoBgN9vM90nOc/tRVGLQu7G3/qSl/K6DFG6VhvJpPsk
        YdlUR/uINiAkQoLQR90zVCM9uljXBKZns6JMqYhQdn8NDKKTpvHPaQ4Kbtj/YDPC
        gprh4Umjus2Q6HMA5QOtfBo7Twel090wwDzp7CLj3Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gKOyjh
        g9rJNTM58ByVEg1kBVaUWvU7wyrXEzfhhiASw=; b=pe+GMnhAfqM60BdTsEE+4L
        p6AsPWnOes3KyK8cCGMMdP8bFInJVoNEA46/qdW4ffKvWO8XMAtYzlms8qvxhHmJ
        iAloARZGobADOrMKetc11WDK5WNfoErg6KfVCMJlooVMRUwheZzthzEHyAVQHEE1
        jEPy91kEa0so0oWqhYmoip5YaqAti5BavAwZX7YVqN2OZNBBV6CKjDULs7ZkxSRx
        lH8lLG2i6OW4OljtQFEhV8Gz8ACTi7YFebLR3QT5V8LYjRv4Uca69FIqDnEWkTut
        inNdJeEdBcgtpM9NBro3efOKcE1jkkBnI5TB80+uqlMMoWTcPjpRmnW+U2vRfbdg
        ==
X-ME-Sender: <xms:qBEzYYmBrCx9-jOG9m4cmyVdP7D6PlqdEr5y6oYv3tzAhEsGyj_1nA>
    <xme:qBEzYX1ZFoLP8XNrt1yshU5o5GH_cWHBLSU3h353i4FjmZ8tNHQ0k80M9P_Bkz3lr
    QjBBnncJRgBuw>
X-ME-Received: <xmr:qBEzYWrAhlQIMhAtBLnslzVv6o36SpdWdLzTI8t_iKPc5J-HKmSVfsHS3c_7fVuONjYjJ-bjBN4s6zeSVlnXBK_w_ZjDrPZJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvkedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qBEzYUmV2qCgHAvjpz4fq1xmJdIA78Y97DAvlybq86Pb-o20x4gR_w>
    <xmx:qBEzYW3qwAg7itRQRrt8dgpMmCAPLC82fFoCrmfmDK5Kgplzw2OzZw>
    <xmx:qBEzYbtaJDAQeId5fw-vJnvOnHrGVeWQE-aCIu-eLdC0JGNHVeqTzA>
    <xmx:qREzYQpbUW7XCMIy9Tt63ALDwAwbF7ekYj9SdXTY1Av9VkOYtlGWow>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 4 Sep 2021 02:26:48 -0400 (EDT)
Date:   Sat, 4 Sep 2021 08:26:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Patrick Schaaf <bof@bof.de>
Cc:     Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] for 5.4 : kthread: Fix PF_KTHREAD vs to_kthread() race
Message-ID: <YTMRplNI5NzMHKwj@kroah.com>
References: <61323e54.evOabX7OaRBtxnNj%bof@bof.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61323e54.evOabX7OaRBtxnNj%bof@bof.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 03, 2021 at 05:25:08PM +0200, Patrick Schaaf wrote:
> (second try, sending with mailx...)
> 
> After 3 days of successfully running 5.4.143 with this patch attached
> and no issues, on a production workload (host + vms) of a busy
> webserver and mysql database, I request queueing this for a future 5.4
> stable, like the 5.10 one requested by Borislav; copying his mail text
> in the hope that this is best form.
> 
> please queue for 5.4 stable
> 
> See https://bugzilla.kernel.org/show_bug.cgi?id=214159 for more info.
> 

This worked, thanks!

greg k-h
