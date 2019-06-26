Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2735661A
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 12:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfFZKCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 06:02:09 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37555 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfFZKCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 06:02:09 -0400
Received: by mail-lj1-f194.google.com with SMTP id 131so1554349ljf.4
        for <stable@vger.kernel.org>; Wed, 26 Jun 2019 03:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o9i5XTj85xE5+uIU9F3Z+SVC9PlglUijXjyIQPf23zk=;
        b=AOWKbfIevn1+Y1epZyLKPeDc4DyvGR1J4/7dM2nyViF2dwyIesmoSJbatm71aYMqe9
         1Y6J0zkUW8AhH6RkGYyvUNKUW6MQsUyWR27s/xHhDmZlE/14YTCZFrc00rO+lSSnF14z
         0feiBzOBLtKBspnnRURvLcWusqhOiDrfxQ911YAVD2kiwehf2b1uOUugOECyssOWwWuO
         h1YNJtiyBcbQvmd256YdYR3py5vc6QdfOnsXaj12ePSBeKVzQT/fErMpPwLTiMKYzKM2
         EP39z07t0v96F56mMhvjkpv0gPrI0f7v+L1EyntrAzPPYWTaqw3DJdrazMNIrN8YzD04
         CfDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o9i5XTj85xE5+uIU9F3Z+SVC9PlglUijXjyIQPf23zk=;
        b=aziaFcZ2EzhtN8vxIPy7CBPKpXOs2i2oFkmGhNBh2Ye8zkSC3HO10HOzVzM55WdpRR
         xFtgfp49pR/4FJt9R0HJ/Nf7WVCVkLG13w26mCIOuO1a/7DupkUYxda1dPUrjf/POtSD
         HaSeXznWcvdC1fYnx49V//u3zvYWhTjKetB8HKrzYiVlRxS/RDFSLj9ndqX1Z9REUTG+
         yhNSdPFz2OeZJdM20SRNKW75rRLbN8oKJ6lSW7xAtTvmS8qZaSpzNr+6cXQqGC5lB45U
         DYGDckRTLG2J1wSUCooHxi6baqyfgMVhPDsN+wpVl69xnfsvu1xy0yo9XYGJWbQyy+pM
         FkkQ==
X-Gm-Message-State: APjAAAVJ48x/yi9BfzAc2bVbHdGyJLNTl1T27DKiXr5fd/LEwGQBfCoH
        1TesIwKJZfC+HX4qkPjO0d79xfjkJoVtilNh1y8=
X-Google-Smtp-Source: APXvYqxM2bUqESFgOvGmfYwAkrF+H/+s7aHnlHrdC/dWUpH0w1SqW7Tku1MHVqj4MMc7TZE3OeSBtLH2fQU+gzh2ZBs=
X-Received: by 2002:a2e:3e01:: with SMTP id l1mr2379455lja.208.1561543327500;
 Wed, 26 Jun 2019 03:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190625141725.26220-1-jinpuwang@gmail.com> <20190625195038.GB7898@sasha-vm>
In-Reply-To: <20190625195038.GB7898@sasha-vm>
From:   Jinpu Wang <jinpuwang@gmail.com>
Date:   Wed, 26 Jun 2019 12:01:56 +0200
Message-ID: <CAD9gYJK7jDxVqezPtaQJaqF0rjrMKcigb9AEU90MaT-dj+Yjag@mail.gmail.com>
Subject: Re: [stable-4.14 0/2] block layer fixes for silent data corruption
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "v3.14+, only the raid10 part" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> =E4=BA=8E2019=E5=B9=B46=E6=9C=8825=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=889:50=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Jun 25, 2019 at 04:17:23PM +0200, Jack Wang wrote:
> >A silent data corruption was introduced in v4.10-rc1 with commit
> >72ecad22d9f198aafee64218512e02ffa7818671 and was fixed in v4.18-rc7
> >with commit 17d51b10d7773e4618bcac64648f30f12d4078fb. It affects
> >users of O_DIRECT, in our case a KVM virtual machine with drives
> >which use qemu's "cache=3Dnone" option.
> >
> >The other 2 commits has been accepted in 4.14, but 2 are missing,
> >ref: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1796542
> >
> >Please consider to include them in next release.
>
> I've ended up cherry picking these two into the 4.14 tree.

Thanks Sasha!
>
> --
> Thanks,
> Sasha
Jack
