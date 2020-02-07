Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2D2154FD0
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 01:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgBGAlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 19:41:06 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:40649 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgBGAlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 19:41:06 -0500
Received: from neuling.org (localhost [127.0.0.1])
        by ozlabs.org (Postfix) with ESMTP id 48DGgg6Kwjz9sRK;
        Fri,  7 Feb 2020 11:41:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuling.org;
        s=201811; t=1581036063;
        bh=R+EdOB9Mr3TGXAVnLpWryHFyUDLgOMO50OZKLjJYU/o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I8KiOdszLieL2f6wCI90fpEw4P5GfRnA6ACn0yT6ED2aK5jNROx/VDGnAePfsKx5Z
         zUoyJ2Jqf7o3947v7Ya22DRHK++LYJIU21GphnwzxN3NfRhDoO9M0nI+xDfJ3dj9v4
         erOSPut1ZoaOOBaPN3KV0RsYSDUTY2739hm0jouv0DqRta6qyvXcuO2KU2sQDUdoYM
         HerrzV+7ombG+uP+7/9QvP1+LBnfbTZGlp2+sx5VI16NonQ6zSCBLA40hi2ziDyuim
         lj+n2aCvPbqCDomta1z0Q/eCFEqDdaCpL+zawb90duCzxJ6KuTBNqyFMxS8P1yogmR
         m7glyScn/eFaA==
Received: by neuling.org (Postfix, from userid 1000)
        id B8EAB2C019C; Fri,  7 Feb 2020 11:41:03 +1100 (AEDT)
Message-ID: <591eeed830ff58e9b01e3be18003e5751767cc15.camel@neuling.org>
Subject: Re: [PATCH v2 1/3] powerpc/tm: Clear the current thread's MSR[TS]
 after treclaim
From:   Michael Neuling <mikey@neuling.org>
To:     Gustavo Luiz Duarte <gustavold@linux.vnet.ibm.com>,
        Gustavo Luiz Duarte <gustavold@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     gromero@linux.ibm.com, stable@vger.kernel.org
Date:   Fri, 07 Feb 2020 11:41:03 +1100
In-Reply-To: <3cc875cb-a149-1d9b-5a4d-57c8c370d60e@linux.vnet.ibm.com>
References: <20200203160906.24482-1-gustavold@linux.ibm.com>
         <0af388c6a08d83ee7816fc3fc6053c905dc58344.camel@neuling.org>
         <3cc875cb-a149-1d9b-5a4d-57c8c370d60e@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-02-06 at 19:13 -0300, Gustavo Luiz Duarte wrote:
>=20
> On 2/5/20 1:58 AM, Michael Neuling wrote:
> > Other than the minor things below that I think you need, the patch good=
 with
> > me.
> >=20
> > Acked-by: Michael Neuling <mikey@neuling.org>
> >=20
> > > Subject: Re: [PATCH v2 1/3] powerpc/tm: Clear the current thread's MS=
R[TS]
> > > after treclaim
> >=20
> > The subject should mention "signals".
>=20
> How about "powerpc/tm: Clear the current thread's MSR[TS] when=20
> transaction is reclaimed on signal delivery"  ?

mpe also likes the word "fix" in the subject if it's a fix. So maybe:

 powerpc/tm: Fix clearing MSR[TS] in current when reclaiming on signal deli=
very

Thanks,
Mikey
