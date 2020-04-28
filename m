Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F01B1BB971
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 11:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgD1JFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 05:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgD1JFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 05:05:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140B620663;
        Tue, 28 Apr 2020 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588064731;
        bh=spllije+lB24qCqooZyvVyKb3dTWK55CU01jamGCRrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KQcFvI4sY8NP5W/zlVxlmq4isGDpRL+V8/Tvj46dFomORmVG69UNcLwiVPWxsJgxL
         92/uBryOyNub5H9eiqa0opD+mJSKQQne1YwP69H3tp/ZTS7oshbTcAVue3/XXknXTZ
         vapOIcnqR37E5oCdiquF4KmbWpz9jsF1CdI5sBI4=
Date:   Tue, 28 Apr 2020 11:05:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/mm: Fix CONFIG_PPC_KUAP_DEBUG on
 PPC32" failed to apply to 5.6-stable tree
Message-ID: <20200428090529.GB1001680@kroah.com>
References: <158800928720169@kroah.com>
 <7c5cc5a7-99e6-6b14-2bcd-ffbdc09ac080@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c5cc5a7-99e6-6b14-2bcd-ffbdc09ac080@c-s.fr>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 27, 2020 at 06:53:22PM +0000, Christophe Leroy wrote:
> 
> 
> On 04/27/2020 05:41 PM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.6-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I think the easiest would be to apply 61da50b76b62 ("powerpc/kuap:
> PPC_KUAP_DEBUG should depend on PPC_KUAP") first.
> 
> Otherwise I can backport.

That worked, thanks!

greg k-h
