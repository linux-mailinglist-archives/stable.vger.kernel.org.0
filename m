Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D591EEA68
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 20:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgFDSkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 14:40:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33987 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgFDSkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 14:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591296034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5L6MBW/7l1c3aqJuiD8NksILnbfOSCR/bc4wTe/D8ic=;
        b=d+pppVRjBKrrJxpqhrlnRA0K9Z8GG/Y4woViHrlI6zrOisloY/kcCfpOjTvqUI77qSCIy9
        0klHre4TXeXFdKTlbm2ajMvo1etqW0J91f+NlONUN9PU9aznBPCbI8LovT+zOWICAuRq7H
        ZbOr2WDte0yCKpevEFAP6CjPUFpkGqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-P7U2_xIlNom1HEX7dbnMTg-1; Thu, 04 Jun 2020 14:40:22 -0400
X-MC-Unique: P7U2_xIlNom1HEX7dbnMTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43E16EC1A8;
        Thu,  4 Jun 2020 18:40:19 +0000 (UTC)
Received: from localhost (unknown [10.36.110.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38A1D10013D5;
        Thu,  4 Jun 2020 18:40:16 +0000 (UTC)
Date:   Thu, 4 Jun 2020 20:40:03 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Mike Dillinger <miked@softtalker.com>
Cc:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Don't account for expired elements
 on insertion
Message-ID: <20200604204003.2b07d03a@redhat.com>
In-Reply-To: <79640a97-b164-42c4-cc24-2be1c2265e44@softtalker.com>
References: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
        <20200603153531.GS31506@orbyte.nwl.cc>
        <79640a97-b164-42c4-cc24-2be1c2265e44@softtalker.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mike,

On Thu, 4 Jun 2020 11:16:09 -0700
Mike Dillinger <miked@softtalker.com> wrote:

>  [...] =20
>=20
> Hello All,
>=20
> Is there any way I can track this change so I know what kernel
> version to expect it in?=C3=82=C2=A0 Pardon my ignorance, but I'm new to =
Linux
> kernel changes.=C3=82=C2=A0 I have familiarity with change requests, so i=
f I
> can follow this on GitHub or some other tracking system, that would
> be great.

Pablo, the maintainer, will answer to the original patch email once
(and if) it gets applied to the netfilter (nf.git) tree. For that part,
you can also track it here:
	http://patchwork.ozlabs.org/project/netfilter-devel/list/

That should be applied to the main tree, though, before the stable team
picks it, there are several ways to track that... but you're using
Debian kernels, so I guess you're rather interested in:
	https://tracker.debian.org/pkg/linux
	https://tracker.debian.org/pkg/linux/rss

Changelog links are available from there too.

--=20
Stefano

