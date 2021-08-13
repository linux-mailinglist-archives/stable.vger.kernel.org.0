Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FF43EB2EF
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhHMIvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:51:36 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:42539 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239486AbhHMIvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 04:51:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 576FF320028E;
        Fri, 13 Aug 2021 04:51:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 13 Aug 2021 04:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=p/+saRqqetlifXcfm9JvNc6N4cM
        ukwRN6U3FKPo9b2U=; b=INhD6XiYdIc5P6ciIagvlrYrtPuUBb8z+CN7NrgCGvU
        139mAJQJ+v4EBHgmkuOUuaYQjKLvz8rbiGnoIhwYP1hIXTBHO7DLm+s04h9FxroY
        KTwGvpxhrGYV2MymSMxuO0sfAx+b/8uNPgq9K358b83Fko8qZP85ADQlfWNxPyg4
        ZO8fkNu+KYXzllsBYgZe8/2g+W+o5gVoLANjkYMwuRky/cky1Yc4GakoMi3/nj9U
        lvnfl3zxVeEa4cdsE+SP845QmpQLb2aceHIgZHCxUupEhNQ/v8xvMj2bLXa1+9Ms
        Qu2YDdl2NjqNqA2uVguYDvkjHZoHewJ/zuUz6wyHyNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=p/+saR
        qqetlifXcfm9JvNc6N4cMukwRN6U3FKPo9b2U=; b=Y7eRvW866bCqsmA5opWeIt
        h5XDMnl/B8PuZt3loPrEv57tLBeoX3dNs/ntGfKoJA/iy/QWehABa8GYSQnbFyRJ
        1YYzHB9VcHA3SOWxX9/0I4XVWQsbxnwmOOupG/Q12nHyMB5IuCsRCPxCQ+g6kFV4
        1mA0Qywzv3o+z89jOMlhfkYRmjPJJif6LqWu/EWdSvJyBUFU0et38IKPB+YZqhvx
        33mdlHqyDifid/RyvfohtiMN7GqOPTKPRPCDM40g4nAEJmvghdsKwLVikYnvMBgc
        sJWVaeOB2nyczPgxBfjTyW41RoKyakB7yJj4paLBzknhgE5JM9u0GgRkQH4Kkxtg
        ==
X-ME-Sender: <xms:fDIWYYqHl1Iwg4iRvdiAiCnkrtltqMcqICGs63XZdDHQ05WE3ZIk-Q>
    <xme:fDIWYerNeDU4F6yeVPKeWqPLu6nigF6bv-HhWZJCAPq5lLjVlZ6X8kjtUX_iu8n_U
    g0v95-gDk1m5A>
X-ME-Received: <xmr:fDIWYdNAiATmXuwUREC4tZMRVW-gnlDI2ToorqeKn_aKNADABBVtBtSMVSHx4gamEQlF-EaFvFCAYqLLOGTPt0U5m2JVi1Vp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeehgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:fDIWYf6XqFlfA4SySjPAFGZTucGUQTRihhn94qlIRv5yB3UB0UoQZQ>
    <xmx:fDIWYX6vwkOOKiRNdn2m3LoWgSoibHGz7RAZv5N6jkCTPpntnJiyOw>
    <xmx:fDIWYfiInlAsomwvwSx9egcjV-CWyoJDmbBlPK58WGV0YC-egQNZvQ>
    <xmx:fDIWYUvjff2Ell4gaFSPtdWlVa7yjkFnfeUjAH0SAtafIFbBu2_aLQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Aug 2021 04:51:07 -0400 (EDT)
Date:   Fri, 13 Aug 2021 10:51:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, pbonzini@redhat.com,
        laijs@linux.alibaba.com
Subject: Re: [PATCH 5.4 0/1] KVM: backport fix for CVE-2021-38198
Message-ID: <YRYyd1KM1PMRXc8g@kroah.com>
References: <20210811154629.2104425-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811154629.2104425-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 06:46:28PM +0300, Ovidiu Panait wrote:
> The backport was validated by running the kvm-unit-tests testcase [1] mentioned
> in the commit message.
> 

Now queued up, thanks.

greg k-h
