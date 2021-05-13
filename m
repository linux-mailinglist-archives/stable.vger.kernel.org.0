Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA72937FF86
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 22:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhEMU7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:59:01 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:43021 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbhEMU7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:59:00 -0400
Received: from leknes.fjasle.eu ([92.116.101.148]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MhlXE-1l3Xjr23yC-00drD7 for <stable@vger.kernel.org>; Thu, 13 May 2021
 22:57:43 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id 2DAB33C490; Thu, 13 May 2021 22:57:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
        t=1620939462; bh=Szo7XxmURTYInxWc6QAMjRPHfMokZhu95kUhCXnXGXo=;
        h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
         References:In-Reply-To:From;
        b=iCLfCBja6WTjcR9VnHuExlPTybXWkxPDzveC00KK/zUu+uujA0i1Yv46y19C1eCBV
         JnEIri7mYxx65pmHAlkl3DU9XrxWS1MtzlZK3cD/vr6HY5U82pmUA2ITL3Bx0xwYDG
         Eujsmoyw3H/o+2f63F/Zh9QR4ecXekuaWy7WzNR0=
X-Spam-Checker-Version: SpamAssassin 3.4.5-pre1 (2020-06-20) on leknes
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.5-pre1
X-Original-To: nicolas@fjasle.eu
Received: from lillesand.fjasle.eu (unknown [IPv6:fd00::ba:f4ff:fe3b:a745])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "lillesand.fjasle.eu", Issuer "Fake LE Intermediate X1" (not verified))
        by leknes.fjasle.eu (Postfix) with ESMTPS id C49843C056;
        Thu, 13 May 2021 22:03:24 +0200 (CEST)
Authentication-Results: leknes.fjasle.eu; dkim=none; dkim-atps=neutral
Received: by lillesand.fjasle.eu (Postfix, from userid 1000)
        id 57CC9101535; Thu, 13 May 2021 22:03:24 +0200 (CEST)
Date:   Thu, 13 May 2021 22:03:24 +0200
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Finn Behrens <me@kloenk.de>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v2 1/2] tweewide: Fix most Shebang lines
Message-ID: <YJ2GDOt48sjlMFtD@lillesand.fjasle.eu>
References: <20210511185817.2695437-1-nicolas@fjasle.eu>
 <20210511185817.2695437-2-nicolas@fjasle.eu>
 <YJvC2W9QTpc9JBp1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YJvC2W9QTpc9JBp1@kroah.com>
X-Operating-System: Debian GNU/Linux 11.0
Jabber-ID: nicolas@fjasle.eu
X-Provags-ID: V03:K1:Ux/eGMFtBttLhzt+7YDcDWvw/MCnYCbpeZvEA2NTxp341VRig7c
 gzwd8l9mbTLYBRxQeUdOCfDutkABj/qMDvmUJXL3P6ptNUYpzBQ/3ZIa8GKlgknf8Zyl2Wy
 Dn2g591iN0kT8TU8bs0IfjHmIC6X0+XHF8VeTdwJhHyyt46Cz4Fhzi0n3ZQwrfo6wj1h+6g
 5TQaZJvNMY3et7riWHs7g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tZESmEaVSN4=:2k27hZNw/SNISsColo8irS
 zRmQKjL6PwRws7poP4IZn/mRMHa7b4LGNfLqTLvljO4ZCdUvlz3mD4R+pXh0X6q4XzOOgP5nQ
 JstAip1D7I5f3Rj54YdHH/fXifuyMUuYaWF6v6uLzUercf1Z/wKbLyQWta6wDtSuRgfXhTgRs
 y3Rg66/SDKAm6W0Ti2fDZfQCOPahFlK55CP6AuT5Ky/MJjb4r1QVSHtqmLlYVP8Ih5ab0PY3+
 oX2f5UGDtgWGRB6SAUzXuxPincsVfD/0dr0yQ1QTDb4WaQDmU8smS6o8AgZCob1xcuplmpszI
 w7jxU/BDs1OWzeIX3QENiMzHw4D59u/YFL2Wgy/Xwys0TimAXVsxoyG8Qr3vYt4ktccAIldUb
 BpsBKKYtZ17pKuM2Hq5+varDY7EMKod5+tPaWME5Hcal2zkAhY6YHQ9NA/thGFgxccOem/lsk
 HLjiSi50ZLKZ3xAqVxXpgiH8RP4/YcEZ1KxmuYL9+y6E3qBIbks+4YBMVRXa8WrnDyDQLBLbW
 YTXokbRO/dfXnUytSgX4+M=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 01:58PM +0000, Greg KH wrote:
> On Tue, May 11, 2021 at 08:58:16PM +0200, Nicolas Schier wrote:
> > From: Finn Behrens <me@kloenk.de>
> > 
> > commit c25ce589dca10d64dde139ae093abc258a32869c upstream.
> > 
> > Change every shebang which does not need an argument to use /usr/bin/env.
> > This is needed as not every distro has everything under /usr/bin,
> > sometimes not even bash.
> > 
> > Signed-off-by: Finn Behrens <me@kloenk.de>
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > [nicolas@fjasle.eu: ported to v4.9, updated contexts, adapt for old
> >  scripts]
> 
> What about 4.14, 4.19, 5.4, and 5.10?  We can't add patches only to one
> stable tree and not all of the newer ones as well.

Hi Greg,

yes, that makes sense obviously, I did not have that in mind.  If there 
is a chance for acceptance, I will gladly provide the patches for the 
newer stable tree as well.

> And what problem is this solving?  What distro has problems with this
> for this old kernel tree?
> 
> thanks,
> 
> greg k-h

my concrete problem is that I work with several 4.9 kernel trees and 
that our build system uses diffconfig (for consistency checking) which 
does not run anymore on a current Debian testing (/usr/bin/python is 
not more available).  As the corresponding upstream "fix" commit 
51839e29cb59544 (cp. patch 2/2) technically bases on commit
c25ce589dca10d64dde, I thought backporting both should be the cleaner 
way.

I would not mind to drop this patch, but I would like to see commit 
51839e29cb59544 in the stable trees.  Does it make sense to prepare 
backports of it for all current stable trees?

Thanks and kind regards,
Nicolas

-- 
epost: nicolas@fjasle.eu               irc://oftc.net/nsc
↳ gpg: 18ed 52db e34f 860e e9fb  c82b 7d97 0932 55a0 ce7f
     -- frykten for herren er opphav til kunnskap --
