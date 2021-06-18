Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED143AC56F
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 09:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhFRH4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 03:56:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233632AbhFRH4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 03:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624002865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XEI/OJuAXTvuVxb5V4DRXijOpx4ZP6VR6Dmgwu8ekGM=;
        b=J5nEAXf+H+uKUGUb1E6zNRSbeV/mTpv4j+e4cRJPLxDf9tD7AJr/m1LNgWUAcxDXSHAIes
        DF5u8eZ1NKpZ81cZSZGyT9TgIqg23kJy7HJYJQN3ULtreP5w7QKInGxS0hzaZdJ/z3b6/4
        2UIrwiRtwGFug6ULF3CC2CSzk99STh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-4ZOc-eldMOu6mw9E-qvxUw-1; Fri, 18 Jun 2021 03:54:23 -0400
X-MC-Unique: 4ZOc-eldMOu6mw9E-qvxUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6F0C8186F1;
        Fri, 18 Jun 2021 07:54:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B0F419D61;
        Fri, 18 Jun 2021 07:54:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210614234802.sTWMIG-eE%akpm@linux-foundation.org>
References: <20210614234802.sTWMIG-eE%akpm@linux-foundation.org>
To:     akpm@linux-foundation.org
Cc:     dhowells@redhat.com, adobriyan@gmail.com, andi@firstfloor.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: + afs-fix-tracepoint-string-placement-with-built-in-afs.patch added to -mm tree
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1765928.1624002859.1@warthog.procyon.org.uk>
Date:   Fri, 18 Jun 2021 08:54:19 +0100
Message-ID: <1765929.1624002859@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

I have a preferred alternative to this patch, so don't send this to Linus,
please.

Thanks,
David

