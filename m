Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6632511C95A
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbfLLJi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:38:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbfLLJi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 04:38:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E1E2173E;
        Thu, 12 Dec 2019 09:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576143507;
        bh=SCx2aHIHnGKQeu51wkPP5+yUZX5L+tGE8Aw6VOd/jEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mR0Xvn8p38pStI8WQqtP8rPS5QCEWGAwI1QP4LbokIxY7In2z/GDy1kbgcoyP06xA
         JJHI7AG5DYg29QZGkP7g7liD5Sm7HaCX1J+LKBx9ZOa1/kfM2lkZRvhoWIHguQ343/
         iPZKUk7h81/kflW3HOjA/D3daDZp69C2a5zX+zJI=
Date:   Thu, 12 Dec 2019 10:36:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] KVM: x86: fix out-of-bounds write in
 KVM_GET_EMULATED_CPUID (CVE-2019-19332)
Message-ID: <20191212093625.GG1378792@kroah.com>
References: <6be50392b6128f7cd654c342dc6157a97ccb3d8d.camel@decadent.org.uk>
 <cc8b829f-ca2d-5b8c-c880-567bab77a1c2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc8b829f-ca2d-5b8c-c880-567bab77a1c2@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 12:29:19AM +0100, Paolo Bonzini wrote:
> On 11/12/19 23:25, Ben Hutchings wrote:
> > Please pick:
> > 
> > commit 433f4ba1904100da65a311033f17a9bf586b287e
> > Author: Paolo Bonzini <pbonzini@redhat.com>
> > Date:   Wed Dec 4 10:28:54 2019 +0100
> > 
> >     KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)
> > 
> > for all stable branches.
> > 
> > Ben.
> > 
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Now queued up, thanks.

greg k-h
