Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218043ED9F7
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhHPPh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 11:37:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232181AbhHPPh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 11:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629128246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MCKb5wNEJreY5rYURl0Jx8+gKn2jhtc/9sKfMUUw4dc=;
        b=FGNixy/MMJ3/NQhCma883opDFSKg9lRuvhxq4pPIvekgZD+gqCMsC0x2LH1bxBTiGZz/gm
        wusg0laZeXImZ9c55VREMFdCxYQJnRmO0Gkp17Rbki6pdM90y20HFNQl5DnSKYxYZqh0KL
        7bHsrVAIzsjB6JHEhJ4dGAOEYi8+GQU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-sdv1qCl_PaOKismJBz0Puw-1; Mon, 16 Aug 2021 11:37:25 -0400
X-MC-Unique: sdv1qCl_PaOKismJBz0Puw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC9271940920;
        Mon, 16 Aug 2021 15:37:23 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 332546788F;
        Mon, 16 Aug 2021 15:37:21 +0000 (UTC)
Message-ID: <74cf96a9030dc0e996b1814bbf907299e377053e.camel@redhat.com>
Subject: Re: [PATCH 5.12.y] KVM: nSVM: avoid picking up unsupported bits
 from L2 in int_ctl (CVE-2021-3653)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 16 Aug 2021 18:37:20 +0300
In-Reply-To: <YRqAM3gTAscfmr60@kroah.com>
References: <20210816140240.11399-6-pbonzini@redhat.com>
         <YRp1bUv85GWsFsuO@kroah.com>
         <97448bb5-1f58-07f9-1110-96c7ffefd4b2@redhat.com>
         <YRqAM3gTAscfmr60@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-08-16 at 17:11 +0200, Greg KH wrote:
> On Mon, Aug 16, 2021 at 05:04:58PM +0200, Paolo Bonzini wrote:
> > On 16/08/21 16:25, Greg KH wrote:
> > > > [ upstream commit 0f923e07124df069ba68d8bb12324398f4b6b709 ]
> > > 
> > > And 5.12.y is long end-of-life, take a look at the front page of
> > > kernel.org for the active kernels.
> > 
> > Ok, sorry I didn't notice that... it wasn't end of life when the issue was
> > discovered. O:)
> > 
> > (Damn, the one time that we prepare all the backports in advance, we end up
> > doing too many of them!)
> 
> You didn't do a 5.13.y version :(
> 
> Will the 5.12.y patches work for that tree?

5.13 will more likely to work with the upstream version.
I'll check it soon.

Best regards,
	Maxim Levitsky

> 
> thanks,
> 
> greg k-h
> 


