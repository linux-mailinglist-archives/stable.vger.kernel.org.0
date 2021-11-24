Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5754A45B5BF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 08:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhKXHqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 02:46:07 -0500
Received: from mout.gmx.net ([212.227.15.19]:59301 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhKXHqH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 02:46:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637739770;
        bh=EbW0IA+n4AgWB8WIQE5+yMPYcOyTZmvC9QoUVDdQMCU=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=RMU/D6TLqe2qgyqKVV2cpgiXOmE5sOeCodDvDFejPBkGpVrYMaGAI1iR9em7Ch42R
         87d2+mbk9bp3Di0rDqMjbeHhZ9S6d0mQaVHZkdY8cN8l/X0ok+YrR9+wAhXOpDWjPy
         BMIvvFLSICafhn+0P7v9c7WUT7VFVlS6VmKwv9BY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from machineone ([84.190.131.218]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MMXQ5-1n6UZB18LP-00JYPa; Wed, 24
 Nov 2021 08:42:50 +0100
Message-ID: <18d27a9a8fec36bdc56f879f80bc57a7d7fe7493.camel@gmx.de>
Subject: Re: [REGRESSION] Kernel 5.15 reboots / freezes upon ifup/ifdown
From:   Stefan Dietrich <roots@gmx.de>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Date:   Wed, 24 Nov 2021 08:42:49 +0100
In-Reply-To: <YZ3q4OKhU2EPPttE@kroah.com>
References: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
         <YZ3q4OKhU2EPPttE@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:A37Ub6t0RXsEB/IbD58EqXBmSdPjO67HvbJLpUEVNv42KGP6UBG
 qxOoFcBW5WdEgK1VDPdzFbkZeAyMGUVwI6r7xsqRhlQ0jNLb5sECPbVRs3Qm3aLGU7+Pgh/
 1qkRgnpy4JKs66ZUmZduBVImBzaocYZRFB/RYalYGX/A8A77h6n+tlbp1Of7013bB3nv77q
 IoWGjTrifB0zuP1iHkpag==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Rw6an/91BRw=:OO/9ErP4JJ342UAiN8Gc83
 SKCp2XmxAx7FFB2FFcdKXZ3PwqRmjgcxK2Ks9U2ga7lLO0H3A289jKPNQo1wdyVRs/K7BA0fi
 d64ooyanbKVzG3mOjqeIVB9wSRLDA47tGIR5P+yKhR+SDaGDAREj+4NSYWj7y7jzFstEDSiwh
 JOZNzFbCBULCOuJqSg9bBGTBOxlU2dtsofb1GnGJdMyEZt15CE9DuwlvHCqwOpFlfA3/xLaV+
 9PfxADmoscAJQcj/C7IMiwT4JcmGV+dC+eYFmUKdGDFGgcbo3FbvWKqvILnxJ/up/Z6p2niHI
 bGP/El0dbFnElQWea1FN0w9TZIXoDgt+g++Yh1Ym9iuEabND3s3RkNQsBVXAbgoMa7WCNZ4Z+
 xz3Q4d/pC1YnsYKLvegt/PiZ32J02Y07j2WhUAmeGQ7SBafOVCoult0FMcf4u+Kc3Uyjamp53
 LiZn9o/vPyn1T4x8RfWioLZ8musD0/lUGutrBBrpVzC8ypRRcsoJrQg8EKskK6I7EIz1+O+Cx
 kbv68sMWgoCWxIlQzkcgdYfMFj9AvOT5DktgIFtOwbhWLemoKUIi10nLi3IICP6/GwoPN+vII
 wBOjvcgkhrT+oE9AD4IYFG06vCRuzeMbuJz/RyMz5+bZ126EtvdNXuBNNArUP63tp2Zaqc7FF
 vDMf/YRS//BECfXfpciXfR2stC/PVBgLCvoOG9Mp03k0Ml0xWpYcx8isG4DQbNyjVbXzdbgbY
 qbzGkmLIThX8boeyrQ0gEZxtyl4MfJiOCKG9ajv/NfKWtIx7gybUHtXWmLeYDYp4mpsSh89vp
 s2UwPkHTejPy73JeCGHxhJk9Zi5Y87w3rx32VAjTsEq9cOh2GU4xk1WlLaPsGeXSBWtZUPEsN
 C86AWWqRllJ9bFaDmmj1ICY/k71inmVJNoSa5xyxQOv00rmrCNixraBk3ZoIliLUa35151l7N
 0NRavZy9Nl6dVpZeF8ZOvxPLpOqdp4G3JrW9aTkZ4zfxXqxEzq8sMw9PdkomfK6yZOr6Oi3TS
 p3kObYGMtthtqnBTUwKMrmQilIP1JYTfBJktz8oCTzSg3YkK/WFFCAslQgwyP38Suq9wQmXd4
 9lXqF4THVdSZjg=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I have never done kernel bisect before so I need to do some reading
first. I will report back a.s.a.p.


Stefan


On Wed, 2021-11-24 at 08:33 +0100, Greg KH wrote:
> On Wed, Nov 24, 2021 at 08:28:39AM +0100, Stefan Dietrich wrote:
> > Summary: When attempting to rise or shut down a NIC manually or via
> > network-manager under 5.15, the machine reboots or freezes.
> >
> > Occurs with: 5.15.4-051504-generic and earlier 5.15 mainline (
> > https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.4/) as well as
> > liquorix flavours.
> > Does not occur with: 5.14 and 5.13 (both with various flavours)
>
> Can you use 'git bisect' between 5.14 and 5.15 to find the problem
> commit?
>
> thanks,
>
> greg k-h

