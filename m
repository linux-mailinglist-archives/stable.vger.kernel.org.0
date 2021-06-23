Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0143B1D84
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 17:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhFWPVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:21:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38132 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWPVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 11:21:43 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624461564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H97TK7SWBoqFkcltGv9HA4eTuwxZ8WtcMRjEv46Z/QI=;
        b=WWIGTsqdX4nJknan46d2I92K2vChVacs1sKGwy88dzxZzzHE12mSADjlltacRv3kvUG3WJ
        Ul0dI46zHA02aWNJY/2H+rbGsF0ai94c7eyLNFFL6SfRIcTzxrSj0MlrQz7chFC01cshtu
        QXzdXOOJ9/lyeuAdn5x7ZtdgYCY10Ez0k8pfh7RioiZaBkZik+hgxlyKqC01SzSbl4c+pu
        ITUEqK4nocQ0xV+ii9rXA150wOR26EWBXGx+KyhRPzRldDRSgxJuOfViJFdWg/06dIizlX
        whto7vOuHstbCto/lVDHmA+4QBZxDxmWgFkrPX+Q4B/DYxMZ93XYZmVzsHJvmw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624461564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H97TK7SWBoqFkcltGv9HA4eTuwxZ8WtcMRjEv46Z/QI=;
        b=uSh+KfNrqnUO+QbPbehqbApcH/bU9TRCRcd8TljKx+vAb5fIzy/Mu4v8uVJS2EZjJZ5LUA
        UlZr4CHpUrC+DQCw==
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Reset state for all signal restore failures" failed to apply to 4.4-stable tree
In-Reply-To: <YNNNiU7fFy/AFlxV@kroah.com>
References: <162427273275124@kroah.com> <YNDQHgGztJAWO2H+@zn.tnic> <YNG4q++kHwWtVupg@kroah.com> <878s31ekg8.ffs@nanos.tec.linutronix.de> <YNNNiU7fFy/AFlxV@kroah.com>
Date:   Wed, 23 Jun 2021 17:19:24 +0200
Message-ID: <87im24d2wz.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23 2021 at 17:04, Greg KH wrote:
> On Tue, Jun 22, 2021 at 10:03:03PM +0200, Thomas Gleixner wrote:
> I get the following build error:
> arch/x86/kernel/fpu/signal.c: In function =E2=80=98__fpu__restore_sig=E2=
=80=99:
> arch/x86/kernel/fpu/signal.c:285:17: error: =E2=80=98ret=E2=80=99 undecla=
red (first use in this function); did you mean =E2=80=98net=E2=80=99?
>   285 |                 ret =3D -EACCES;
>       |                 ^~~
>       |                 net
> arch/x86/kernel/fpu/signal.c:285:17: note: each undeclared identifier is =
reported only once for each function it appears in
> arch/x86/kernel/fpu/signal.c:374:1: warning: control reaches end of non-v=
oid function [-Wreturn-type]
>   374 | }
>       | ^
>
> I'll fix it up, it's an "obvious" change :)

Duh. /me blushes
