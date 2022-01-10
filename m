Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9B348974D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 12:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244622AbiAJLWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 06:22:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244598AbiAJLWr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 06:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641813766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hL1GhauzxZu1k+5VqcQ9k59DG3JeTB3f6in9zNn0rkc=;
        b=IpkGNTGBCqCIt0rrPjHecTmMCuPtRum0Hi/HmnL2G0DksjyrPEY10qkzWzfwVSL34RKhgZ
        CsW0zTVCl1HqjXEWqLcmv/KIn6NhQWql+S1KSa0ArTWa45YM4eFsCop+ySV4WPFU4Fgoyn
        sGcy+EtEbIOhzTGaoPNicV2rM5wbo4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-CosvGu5aPlmRKxA0mF372w-1; Mon, 10 Jan 2022 06:22:43 -0500
X-MC-Unique: CosvGu5aPlmRKxA0mF372w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04E711898290;
        Mon, 10 Jan 2022 11:22:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF7FA7B6C0;
        Mon, 10 Jan 2022 11:22:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <3730531.1641813522@warthog.procyon.org.uk>
References: <3730531.1641813522@warthog.procyon.org.uk> <20220110111444.926753-1-asmadeus@codewreck.org>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     dhowells@redhat.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, lucho@ionkov.net, ericvh@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] 9p: fix enodata when reading growing file
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3735218.1641813759.1@warthog.procyon.org.uk>
Date:   Mon, 10 Jan 2022 11:22:39 +0000
Message-ID: <3735219.1641813759@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Reviewed-by: David Howells <dhowells@redhat.com>

Make that:

Reviewed-and-tested-by: David Howells <dhowells@redhat.com>

