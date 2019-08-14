Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4438D689
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 16:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfHNOtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 10:49:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39563 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbfHNOtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 10:49:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4ACA1220C9;
        Wed, 14 Aug 2019 10:49:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 14 Aug 2019 10:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=yTIjQ0TMp/J8tMXt56LoK6zvJ5V
        1nLaQR7MQOjTmVe4=; b=jHVodn5+41sHJYjGHmWaylu1XqyxHKsKRwlNhGRh/Yy
        Eiw2Rnh1utYo6Gx7PXyzdxEEAtHWYelNnOw4FZPxwrmoztlf0Qzmex2bN9Q2Uuvj
        KU692tZBAft+FMscnpwHgoT7V6Dxh2ku5mfwFe8e7r2qEW5hpEYJEsQw/6xKhV2y
        v+E/Sl/Zf+rai7GpklIvdtqqVUbZ9WkMyvk/fmItSq7QvQRfFZfGwJYHDe3Dl0lG
        +MYn2i5/OsclhFWGT8JEbpS8r1YgmieNyMGkj+5glLAqhl01s7n4OAwFvqUJQKhN
        YTH4GuLRp8t7UJiSlAvbpFBV+2VOPCV8zcEJ4jXKFDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yTIjQ0
        TMp/J8tMXt56LoK6zvJ5V1nLaQR7MQOjTmVe4=; b=KA5+P0+oSNBhF/xnVBGLmB
        cgMGlY75KAVsyJghole/hHkQmWjXqcqBJ0iUYgsh1j8dJuxYxvulEFPLugWQH3Fj
        ABKWFdc6MSP5VZ4tt0AvDVI0RR1EM8mrFTk9pVmKbAlrOtj0xz/VJ0F0NQr7B+Za
        QSo4xLuLASRWuYMdlizJBltDwlGGyziGni+sgUCQwNTw0g5nwokihGE1p9tV6ARk
        bhLHCAQwtGw6gnN2sutTpa44xKxcaWVIC2fiznhWBTaYSMHfeNJgmuOJQpVTtMzC
        HjUyP1VPJlcJV2GujNKwWyCe5thbYAmKUhz9LrygLNAPAuzeC8VlbLu5SSiejlbQ
        ==
X-ME-Sender: <xms:Yx9UXVBzpNG2_xO23xBK_7Ni4TKgS-1e4ajqxFMCPmB5J6pwU7m1-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvledgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Yx9UXdJ8qiyxgplVNOsRzJKHL7lTQGkFkcnYtBKgjnjgThdI93Kndg>
    <xmx:Yx9UXUA5uYp3Ca3aqKiMsB5uCMS8ov0utlFxxYKINQ0UpgTklLGubg>
    <xmx:Yx9UXWrAVC8MQ0jhJgfU6xpPEFQAY7oWYLpufEpe95e4DnmuEzbZ6g>
    <xmx:ZB9UXTSxL_vsH7NxCi4u9ZPJ7m66WJFDYbIj3fXky4xleXi8zI6WEg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 45361380074;
        Wed, 14 Aug 2019 10:49:07 -0400 (EDT)
Date:   Wed, 14 Aug 2019 16:49:05 +0200
From:   Greg KH <greg@kroah.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM/nSVM: properly map nested VMCB
Message-ID: <20190814144905.GA8448@kroah.com>
References: <1565786855-15387-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565786855-15387-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 02:47:35PM +0200, Paolo Bonzini wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ upstream commit 8f38302c0be2d2daf3b40f7d2142ec77e35d209e ]
> 
> Commit 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest
> memory") broke nested SVM completely: kvm_vcpu_map()'s second parameter is
> GFN so vmcb_gpa needs to be converted with gpa_to_gfn(), not the other way
> around.
> 
> Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
