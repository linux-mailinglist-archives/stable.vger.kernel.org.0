Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC97F1C325E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 07:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgEDFvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 01:51:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49321 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725859AbgEDFvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 01:51:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 09A0F5C00B0;
        Mon,  4 May 2020 01:51:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 May 2020 01:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=fvVVdXz4Bm0BIR5jB0igXYKsM3W
        4NkQQAY0YSQQpoe0=; b=hZObGZB4Vh8E+pm+VVyCOxuRQltsQJDcr3rs1CluCoq
        kd+uCy2uswsKNF4S54IBq35N8eY6Ye6gbhRCNyXAvNfQGaqzZog6pZsvwoWw6umu
        hPawfmLt/Fg7822k1PgWmtzRWBm3O9bKZMerEXHmQ45wzFgIrjKGIiG8dD7djP0r
        DSxuBOgLYfJGdvuzqpPBwq9CK+/ts+zwVgWnmm+kRNMJmzAwfRaGAubQx7qmlk2l
        oAOQBaHYbezzvD+MMo7jtR9RbomAopplpYBs8vnaMsGq9eCqIkMBbPDkHiHVWi6E
        xBYkVo1n25r5Sg1ecKDzZxloEzT1COPPui0mQKDZYeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fvVVdX
        z4Bm0BIR5jB0igXYKsM3W4NkQQAY0YSQQpoe0=; b=bDvbyqK/vCrAf9pmkV3etd
        ijPiUQT1kqNO+vBQAOFUl6ZaLEN9+0VpuJa91C+OVKLzbbVpaPKezoxtM8fo00zP
        +vQNQQOq1I4Vmsqiyq3KiGWkhhg7hpv9upItK8C1MHXPFPGXF0VcwLfMADPlf8fl
        PSU5LKtmyMf3EERSlqif8HW1+4pbQ6SX2Rbjmc86FzST8+ToHkL+PT03DyFgjfQU
        Ua1bbVGPIm6FiS10w+od8O+/D4zglC6AvW/Z1nxxaOqRPo5KE2Ho62JkxUsIDzL1
        naUhgZST6aZzwnICIkrOBOfJJxCqRTFOaL/rCnkyWD5jqaoJJd3zg/4PsT4HI50w
        ==
X-ME-Sender: <xms:Za2vXvKL_S4YAsC8DmiGS30j7H_z7ChE9d2hcoTHN5fHnS1GX7hb4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeefgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:Za2vXvL_f42bR-zxvF-0YHSLI0JaGSDDvbwJ--ri79TEi15tlvGvrg>
    <xmx:Za2vXp62TpHTRUJ547_dCvCjCkslUZukxdVdx7_1eQzRwO0jqXcHIg>
    <xmx:Za2vXpeV8SZNjVEagLwnS4tCc9kk2Ry0RG3YKN3rll_qy_zycQ0vHg>
    <xmx:Zq2vXtpVEtw4F1R8D6P4OVN21qglN96-QaTa4-ifIZhIDEBNyPKxWg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A9933280064;
        Mon,  4 May 2020 01:51:33 -0400 (EDT)
Date:   Mon, 4 May 2020 07:51:28 +0200
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: DRM broke for AMDGPU in 5.6.10
Message-ID: <20200504055128.GA730506@kroah.com>
References: <CAHk-=wi6dw+Hu95GvcF=vdFbAp+H4NUWkUxG0N9VFRJBU0Xv=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi6dw+Hu95GvcF=vdFbAp+H4NUWkUxG0N9VFRJBU0Xv=Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 03, 2020 at 02:49:04PM -0700, Linus Torvalds wrote:
> See
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=207561
> 
> and the fix seems to be to back-port commit 8623b5255ae7
> ("drm/scheduler: fix drm_sched_get_cleanup_job").
> 
> I think Artem will (has?) make a report too, but I thought I'd just
> mention it to make sure since I was on the bugzilla.

Thanks, now queued up.

greg k-h
