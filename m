Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1BE3EDC5A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 19:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhHPRYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 13:24:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232249AbhHPRYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 13:24:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629134650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEQJkUefnZjxA0TCNJnaRlrLdPOtguMacFV9l7CCnRc=;
        b=E+iTDWMKh80mo6+fcZ71lqgNx7jzdHqL5j9C660SJaA5/+Hn/4Eps6ovpm4R8Y8WoWej7z
        gmrGSPZrWMNj6vK3/XZepDvfms7VbbVK0R8vQNNesIo6W43b+pkUQT2aJhPrh4hjfHt93N
        EiRtxjixys90fhvAZG2ObPZRxapt0ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-vAeMF8ntPHO61QOPD_c9LQ-1; Mon, 16 Aug 2021 13:24:09 -0400
X-MC-Unique: vAeMF8ntPHO61QOPD_c9LQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE8468799EC;
        Mon, 16 Aug 2021 17:24:07 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 393335DA2D;
        Mon, 16 Aug 2021 17:24:06 +0000 (UTC)
Message-ID: <9dfced5840e39a829827481c5fc5c70bf3f1bc79.camel@redhat.com>
Subject: Re: [PATCH 5.12.y] KVM: nSVM: avoid picking up unsupported bits
 from L2 in int_ctl (CVE-2021-3653)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 16 Aug 2021 20:24:05 +0300
In-Reply-To: <ad855723-fe97-6916-8d96-013021e19fc7@redhat.com>
References: <20210816140240.11399-6-pbonzini@redhat.com>
         <YRp1bUv85GWsFsuO@kroah.com>
         <97448bb5-1f58-07f9-1110-96c7ffefd4b2@redhat.com>
         <YRqAM3gTAscfmr60@kroah.com>
         <74cf96a9030dc0e996b1814bbf907299e377053e.camel@redhat.com>
         <ad855723-fe97-6916-8d96-013021e19fc7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-08-16 at 17:56 +0200, Paolo Bonzini wrote:
> On 16/08/21 17:37, Maxim Levitsky wrote:
> > 5.13 will more likely to work with the upstream version.
> > I'll check it soon.
> 
> There are a couple context differences so I've already tested it and 
> sent it out.

Thank you!
Best regards,
	Maxim Levitsky

> 
> Paolo
> 


