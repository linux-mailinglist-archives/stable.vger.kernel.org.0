Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EB62A0D30
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 19:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgJ3SPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 14:15:14 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4549 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJ3SPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 14:15:14 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9c58360002>; Fri, 30 Oct 2020 11:15:18 -0700
Received: from [10.2.173.19] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Oct
 2020 18:15:12 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] mm/compaction: count pages and stop correctly
 during page isolation.
Date:   Fri, 30 Oct 2020 14:15:09 -0400
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <DCB4BD99-5351-40AD-8F74-2BCCEAC496D1@nvidia.com>
In-Reply-To: <20201030181246.GM27442@casper.infradead.org>
References: <20201030155716.3614401-1-zi.yan@sent.com>
 <20201030181246.GM27442@casper.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
        boundary="=_MailMate_573EF8E1-1214-4432-98D9-A4F76B6C57F8_=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604081718; bh=/6wp6v+qawImNCBcm3218WQBNLGDLuVE3WspHkP/EhA=;
        h=From:To:CC:Subject:Date:X-Mailer:Message-ID:In-Reply-To:
         References:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=ZdT3Mg+f0Ae5f+9hwXiaj8nnuLLALFDwDy0UHpQNn5KwpmPFz9TxpNcba0Sd5wwyi
         wAIpd6uGdh5+BT1fJpkE4bJsFlOH43h1NMiakoZ1z7m27C7K/hffEj7w1t2XxPTtn1
         3uhIdu9SuBioBB46ZHd95wynBC+6vnw5uBsWDDDdUa/Cmg/3ryq9DKgDlcQoNvaHGu
         fL4ieO7XmGkXS75ym5xQ9oIrkzJEcf4harWs0aIRXSmtO+rd5naRtSt1f1B+E/yjss
         VaQIGF7pfRMO8pvHrNMt0hZbH0kar217l50UXzpTi3CrFfc6Ce4tu1oYn791stGf/q
         lU8a4/o3nMK/g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_573EF8E1-1214-4432-98D9-A4F76B6C57F8_=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 30 Oct 2020, at 14:12, Matthew Wilcox wrote:

> On Fri, Oct 30, 2020 at 11:57:15AM -0400, Zi Yan wrote:
>> In isolate_migratepages_block, when cc->alloc_contig is true, we are
>> able to isolate compound pages, nr_migratepages and nr_isolated did no=
t
>> count compound pages correctly, causing us to isolate more pages than =
we
>> thought. Use thp_nr_pages to count pages. Otherwise, we might be trapp=
ed
>                ^^^^^^^^^^^^
> Maybe replace that sentence with "Count compound pages as the number of=

> base pages they contain"?

Sure. And compound_nr is used instead of thp_nr_pages in fact.

OK. V3 is coming.

=E2=80=94
Best Regards,
Yan Zi

--=_MailMate_573EF8E1-1214-4432-98D9-A4F76B6C57F8_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAl+cWC0PHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqK0+UP/A38KGcVHP+cTsJ91NYNXaCKVkiFmJwnt3l6
K4y+2ZfE2KtHh4uDZMex/WT20P9p6ktqHtYdG57Rdppi4bbMpUPQX6whffeHUdlq
d/EkPss31sAUl32VpC81HJeEjoCpDUCcUATCMs//0jl2zMHUzTegHzIZL4INmosy
b7tlN1APNY/xA9JIs/X1yITEp3aBjHnnG4nLKp6U2NdhDWo/AsQFiPppkBbL5fUI
1GgTb67HwKMZuYfja0/wrmhP7M2CxslcyimweojegjXGiL3lU9l91hSlH1l73PWc
ievwOYghyY+EV38zgTZu0JNdR+uYTLTWTn//uRAbXGzPzjEqMAWliqIVQ2aUF1Ht
KxtngTbB6ZQDdUpjNgE2Por8yoIYE7vL0Cw/sWpE410RuhBQ8QSQrrcK8KJLmI7y
hMcOAE0OjrN/FJRacXPO0a7MPTa0zdM7JcGUmKFylsW8Z3swQP6OXKU2iutrpH8h
CSnovLZxKfwINrepfbjYOVCknvDY5FLMQ/AHgqzxreYJVaZhgeqmzUC6a2AiOAuw
m9VmRxFuXGfa0qcHrCsr8+1wdNXtUux/TFeO7TLlkTOxECwSHqqcDLY1bPOaVyqm
ru++Z9qT4nni3ChedR8hsvdIxxHMriTaFC8XFWsFJXzfAfvCNyk8gBUuJbLKah3T
f9o5SAye
=DMW2
-----END PGP SIGNATURE-----

--=_MailMate_573EF8E1-1214-4432-98D9-A4F76B6C57F8_=--
