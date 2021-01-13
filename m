Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BC32F4BEE
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 14:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbhAMM7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 07:59:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725681AbhAMM7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 07:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610542690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAPeX5/ZEkCepmyGIJNpQYxJzy5jX84g3ceqEJc7zVU=;
        b=NJW2H4YXQfdiQYq0KNufC+P2mKyNjiEqhitXVC0KqEHkiRRRwoXAZUX5TDprgAa0bSwdGi
        NZ5xDAN/yuDTEVZ4uZuF99Jcv3x3WXtwzGHZa6QBlY0jznU7BYfBQOYn2vGP2eYmxZQjAV
        uY6xoCrxenceWsIs6+J+bqbKUKXbYxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588--Sv83cdvNIWJZIXoVRqY1A-1; Wed, 13 Jan 2021 07:58:06 -0500
X-MC-Unique: -Sv83cdvNIWJZIXoVRqY1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B71168066E4;
        Wed, 13 Jan 2021 12:58:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A2255D6A8;
        Wed, 13 Jan 2021 12:58:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <875z419ihk.fsf@toke.dk>
References: <875z419ihk.fsf@toke.dk> <20210112161044.3101-1-toke@redhat.com> <2648795.1610536273@warthog.procyon.org.uk>
To:     Toke
         =?us-ascii?Q?=3D=3Futf-8=3FQ=3FH=3DC3=3DB8iland-J=3DC3=3DB8rgense?=
         =?us-ascii?Q?n=3F=3D?= <toke@redhat.com>
Cc:     dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL before passing it to strcmp()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 13 Jan 2021 12:57:59 +0000
Message-ID: <2656681.1610542679@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
> and also, if you like:
>=20
> Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Thanks!

David

