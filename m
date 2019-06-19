Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507FE4AEE0
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 02:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfFSAE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 20:04:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42103 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfFSAE5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 20:04:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45T4vT61ykz9sCJ;
        Wed, 19 Jun 2019 10:04:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560902694;
        bh=gqYMTl+alz3vCwp2SdrGYR9nhdCyJlvrQA4NpZQyrwM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eL52hdoeZ8i6hR2FXuJy64L9vI0RIzGWGpXfsZBAKNDmyP7zqCRIeIV28MtLC688J
         5Y7tA9RaUzJF+IeLmF7KcIsg/xYO7kqe8NIh72cK0P7aA8w6MWGEZnpNZZ6KobbDzq
         28nzsaBgBPyM1Rqo+Kj/SpJOPnUf6MdWn8p0Rga2OO776YNSlRWbiS+asHspvBcv+D
         kpnylZMm+XdzSAN7eRVaFehgGLeq4bArMfyKNRNltNj2p95xP3H7izqFOL3ePWUvmi
         edxmptdcahX1rn4wB5jPomCye/+zIEET4h0YVrrf6tWxpkbgrlIOsOYLcHJFcib37X
         9m+PPdlRoJpFw==
Date:   Wed, 19 Jun 2019 10:04:48 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        stable@vger.kernel.org, rppt@linux.vnet.ibm.com, mhocko@suse.com,
        mgorman@techsingularity.net, aryabinin@virtuozzo.com,
        colin.king@canonical.com
Subject: Re: +
 mm-idle-page-fix-oops-because-end_pfn-is-larger-than-max_pfn.patch added to
 -mm tree
Message-ID: <20190619100448.014a245a@canb.auug.org.au>
In-Reply-To: <20190618194507.lwgft%akpm@linux-foundation.org>
References: <20190618194507.lwgft%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LeiKJJ5V9=HNHhXVKBHm9vK"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/LeiKJJ5V9=HNHhXVKBHm9vK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 18 Jun 2019 12:45:07 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/page_idle.c: fix oops because end_pfn is larger than max=
_pfn
> has been added to the -mm tree.  Its filename is
>      mm-idle-page-fix-oops-because-end_pfn-is-larger-than-max_pfn.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/LeiKJJ5V9=HNHhXVKBHm9vK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0JfCAACgkQAVBC80lX
0Gyx4Af9HLSaCFdoRPp22+aKDOpWC3wwE9AXskW85N40/yZiC1pIGo7NaMv+oT2m
DORKs+TVXU8YsXi3izq/rymTzQSlQWVLWyseQy+uFNPEPD14cZKOHFtIB7cqB1+D
wDEJMqOliawM8v5mk/3FciDCitZKwU6E4t5B0S5kMtSEL2T2+AMP0CiAQ0BTjCSc
T9IqoNwOWVjuR0721Tv+MuSXygGbW62PmKZC2DyglGb5SDTQ8eE4bqNxygYGpydS
MJTTRIYvPOLlQ3P/zFIC+6nQ2SrnIEtLvkH+ZekDI1misuuz1LHogRKif3VRsNUm
BWzvDeAiH2X1ucXw9tmqnse0SXJb0A==
=J66P
-----END PGP SIGNATURE-----

--Sig_/LeiKJJ5V9=HNHhXVKBHm9vK--
