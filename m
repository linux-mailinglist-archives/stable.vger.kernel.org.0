Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32B83C82CD
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 12:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237924AbhGNKax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 06:30:53 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:47389 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhGNKax (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 06:30:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn3.dwd.de (Postfix) with ESMTP id 4GPtxX3n8nz2wlZ
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 10:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1626258480; x=1627468081; bh=yzWLLNTYHL5hK
        hXO7ycHIL/Wes7VmJaRNg+XaDlat5I=; b=L3Y2QY94EG6jmPXSUccMpy52jODJI
        Zp02x4hJNWo7PFIt/IIWAXjGhO/HdniSDKJIWHEbtvxwS5RtjwkOkyKHxAp3RNBP
        aU5NtRKtAaSH19TI/qDJbwP/A75ZL3d45IfX27R5XWUv7Azr+YqI64AUCF4V5iI5
        yiIM3nL/RGHDxi9P+wgPYgGPzCzzyqeJp1sMSAFZj262lvLde2F9kUHlyJPA5tEZ
        q1Bb1qrIJJFKHpqkWAlw0dWr4Ccoqrt3/m+mfyfMG6CsGKqZ2WLG3FuFvQdp+XhP
        aZIaNTtsPZf1LI/r6IPCn8KZd+6mTCt4e4A760GffhBV9zTYPktfXc5pw==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2cteh1.dwd.de ([172.30.232.65])
        by localhost (ofcsg2dn3.dwd.de [172.30.232.26]) (amavisd-new, port 10024)
        with ESMTP id EoDolaB8PYUO for <stable@vger.kernel.org>;
        Wed, 14 Jul 2021 10:28:00 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 58B86C902556
        for <root@ofcsg2dn3.dwd.de>; Wed, 14 Jul 2021 10:28:00 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 4D7D2C902584
        for <root@ofcsg2dn3.dwd.de>; Wed, 14 Jul 2021 10:28:00 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.26])
        by ofcsg2cteh1.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn3.dwd.de>; Wed, 14 Jul 2021 10:28:00 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Wed, 14 Jul 2021 10:28:00 -0000
Received: from ofcsg2dvf1.dwd.de (ofcsg2dvf1.dwd.de [172.30.232.10])
        by ofcsg2dn3.dwd.de (Postfix) with ESMTPS id 4GPtxX1npFz2xjg;
        Wed, 14 Jul 2021 10:28:00 +0000 (UTC)
Received: from ofmailhub.dwd.de (oflxs04.dwd.de [141.38.39.196])
        by ofcsg2dvf1.dwd.de  with ESMTP id 16EARxJC024861-16EARxJD024861;
        Wed, 14 Jul 2021 10:27:59 GMT
Received: from praktifix.dwd.de (praktifix.dwd.de [141.38.44.46])
        by ofmailhub.dwd.de (Postfix) with ESMTP id A002EE27A3;
        Wed, 14 Jul 2021 10:27:59 +0000 (UTC)
Date:   Wed, 14 Jul 2021 10:27:59 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Jiri Slaby <jirislaby@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
In-Reply-To: <a59b73aa-24f6-7395-6b99-d6c62feb0fc4@kernel.org>
Message-ID: <83b8a9a7-a29c-526-d36-78737cb9f56b@praktifix.dwd.de>
References: <20210712060912.995381202@linuxfoundation.org> <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de> <YO56HTE3k95JLeje@kroah.com> <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de> <20653f1-deaa-6fac-1f8-19319e87623a@praktifix.dwd.de>
 <a59b73aa-24f6-7395-6b99-d6c62feb0fc4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-8.6.1018-26280.007
X-TMASE-Result: 10--11.724800-10.000000
X-TMASE-MatchedRID: csPTYAMX1+GWfDtBOz4q28bYuTb6+cQg69aS+7/zbj+qvcIF1TcLYIR4
        RLK5G1ih+5xFZGxCCqj89WDKQGB2Lg6ELeSw1PSqbMGKOuLn5FUB4JHtiamkLOyiG9Aw9qJGS6j
        EzaLelQhA5GooFgjK1/fNFVA4Doasq6H6eyKIRsNZMZ6MZ0H1Ugv/9UzFeXITP4H+2nyK0FPiKq
        oPfA0a+hkNsHcU+86WuC2c3pw4Rj9Dq2SVEk72KAtuKBGekqUpIG4YlbCDECvS3Rxy14J4N4p0C
        7+/C6eQTyCQ6yWirTTnV+U0dx6aYoKeC+afFO7XPpCuffGH9zI=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Wed, 14 Jul 2021, Jiri Slaby wrote:

> On 14. 07. 21, 10:15, Holger Kiehl wrote:
> >> Yes, will try to do that. I think it will take some time ...
> >>
> > Hmm, I am doing something wrong?
> 
> No, you are not: -rcs are not tagged.
> 
> >     git clone
> >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >     linux-5.13.y
> >     cd linux-5.13.y/
> >     git tag|grep v5.13
> >     v5.13
> >     v5.13-rc1
> >     v5.13-rc2
> >     v5.13-rc3
> >     v5.13-rc4
> >     v5.13-rc5
> >     v5.13-rc6
> >     v5.13-rc7
> >     v5.13.1
> > 
> > There is no v5.13.2-rc1. It is my first time with 'git bisect'. Must be
> > doing something wrong. How can I get the correct git kernel rc version?
> 
> So just bisect v5.13.1..linux-5.13.y.
> 
But what do I say for bad?

   git bisect bad linux-5.13.y
   error: Bad rev input: linux-5.13.y

Just saying:

   git bisect bad
   git bisect good v5.13.1
   Bisecting: a merge base must be tested
   [62fb9874f5da54fdb243003b386128037319b219] Linux 5.13

If I read this correctly it now set v5.13 as bad and v5.13.1 as good.
How to set the correct bad?

Holger
