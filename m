Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C77AF905
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfIKJfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:35:02 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34497 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfIKJfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 05:35:01 -0400
Received: from neuling.org (localhost [127.0.0.1])
        by ozlabs.org (Postfix) with ESMTP id 46SxZW0115z9s00;
        Wed, 11 Sep 2019 19:34:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuling.org;
        s=201811; t=1568194499;
        bh=uI8zZ+ou+v7v0XtrYxdP7Z5FhZmRjZF9ORPQwVBqyn4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ahggcW/uWjMul7ZLNlWbSCwMP0oYuEOQyOgFL8Fg68GuEfMP5P1Efeh6JQ94+/KyK
         ywGY01w0Xd5ZptpFlpI956+EzS59ZpyDXAdyQ/KeSONuwW4XwV4NGs/rU+dfvphQvG
         Hc5PpCbe1T7k1GCus0LbhzzEP5z2cedNvM1FAZsSYTM2FAIbeDiiOEmCon3c9GePSO
         5+eilQYomNFTGlhADHL+24/4hpm3kDlBJ2t7M5iXXhP5jmIroK474qOM0q8qTm/nnh
         b5R5yRXZsAGrZ01e4VvVhvluBJg9sS9GgEW8txDBfuRLu4hRT5mwIBGU8TwPMfYSg4
         swqTI2E0qCahA==
Received: by neuling.org (Postfix, from userid 1000)
        id BE06E2A01E8; Wed, 11 Sep 2019 19:34:58 +1000 (AEST)
Message-ID: <06d2ec17fbb65d98faba0fb271cf3b03977ec46b.camel@neuling.org>
Subject: Re: [PATCH 4.19] powerpc/tm: Fix restoring FP/VMX facility
 incorrectly on interrupts
From:   Michael Neuling <mikey@neuling.org>
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     gromero@linux.ibm.com, mpe@ellerman.id.au, stable@vger.kernel.org
Date:   Wed, 11 Sep 2019 19:34:58 +1000
In-Reply-To: <20190911092330.GJ2012@sasha-vm>
References: <15681148654568@kroah.com>
         <07d47bd664b13cf5cdc0361a59b26f9e448e2079.camel@neuling.org>
         <20190911090903.GA30714@kroah.com> <20190911092330.GJ2012@sasha-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> > > Fixes: a7771176b439 ("powerpc: Don't enable FP/Altivec if not
> > > checkpointed")
> > > Cc: stable@vger.kernel.org # 4.15+
> > > Signed-off-by: Gustavo Romero <gromero@linux.ibm.com>
> > > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > > Link:=20
> > > https://lore.kernel.org/r/20190904045529.23002-2-gromero@linux.vnet.i=
bm.com
> > > ---
> > > Greg, This is a backport for v4.19 only since the original patch didn=
't
> > > apply.
> > >=20
> > > Commit a8318c13e79badb92bc6640704a64cc022a6eb97 upstream.
> >=20
> > Now queued up, thanks.
>=20
> Michael,
>=20
> Thank you for the backport. Would you have an objection if instead I'd
> just take 5c784c8414fba ("powerpc/tm: Remove msr_tm_active()") as well?

Yep that works.

Thanks,
Mikey
