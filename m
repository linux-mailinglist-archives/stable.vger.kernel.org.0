Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1710F24079A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHJOaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgHJOaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 10:30:08 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02864C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 07:30:07 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r21so7395131ota.10
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 07:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=9IkGUnEoTJPiYHEveySKL8n3Wre12wGP5WvtP18Nvow=;
        b=RaKrUlH5jAHeNs2AG4VGbmKgIQgCecfwNKLml2/KermQGe0xQfwRFDkQyRP2PJEx0x
         UPVfrfPj723s4IyzmW642OnJDhlJ+qdWpwIrVVQC9JM53CfGYkGSm5o1th2ZSLYfTKcg
         qOcfUiav5P7j1QeIThlKEvyruvgptMOwEzjJZGrMJ4kmQL6SMLlV3mtDYg2ikgbxjtQ9
         akPOgjVzudt3CNfuh9axDQTTvqLFcmh1nG6iPjJiwAjVoE6J4g4kct18UAZ0q+p65C82
         hYtGY43SgdeYRgR8f3iQYTPTwfr7Hi85dSBSfNIbGhMdQ6qIGqWL3xVJkEmK/2xYefuX
         oMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=9IkGUnEoTJPiYHEveySKL8n3Wre12wGP5WvtP18Nvow=;
        b=AN40VBFAB8KcfqVgfIf7+x3DKXCqMjq9i5q8VtPDpsVZIdx+VC5zcQq0RkdaB9JZCu
         iF7YZ+tkhukS8J96Uy+1lrQclOIqvcGEMWXIvcvA7c4w5cfA1ImJ8Jfqanoi/mSOPNL4
         pqisHEtCnPkgj0y/g7xYU9wfz1tJmlzvJLCrj06U6/zWp0vHjzT5cLbBC1A35yR7DnV7
         tvzPEsff2ly8sAL2vaa5O031M1Lj5STsgGYC/aO7b3rFez3LRykTESMAaAvwZpIb37Jd
         NBJawtxThLTDb7RDOVnW6ihQPQx2wcqBMfb2XU/rYYgvIDwmuWJOKMaXUULdwJ0Oac6X
         JH6g==
X-Gm-Message-State: AOAM533N2BT7lNbbFWB5svWRCo65q861rfpMxljKi3NRU31TbRuwpCds
        uot1/P86YrY4zVt5UohzBvoQ2lGppxCHaItouwc=
X-Google-Smtp-Source: ABdhPJxPWHDFlw3wxVGyofjS6IUudxCoo+cKDOa3/MT+5aOeEHLP4M/z59Al+wBBJZxN0LZDYtOyyd21rONE7H7B7to=
X-Received: by 2002:a9d:5e9a:: with SMTP id f26mr947252otl.109.1597069807274;
 Mon, 10 Aug 2020 07:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
 <20200810100125.GA2405194@kroah.com> <20200810100149.GB2405194@kroah.com>
 <CA+icZUWzsHect3v_31-PE_qRfXk7hbORY8JpSkjQmoEFqMykiQ@mail.gmail.com> <20200810140551.GH2975990@sasha-vm>
In-Reply-To: <20200810140551.GH2975990@sasha-vm>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 10 Aug 2020 16:29:55 +0200
Message-ID: <CA+icZUU18HcsT8E4umxgHPWDwdR4YbaX29=Lk4-7AvW2=4c=hw@mail.gmail.com>
Subject: Re: Base for <linux-stable-rc.git#queue/5.8>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 4:05 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Mon, Aug 10, 2020 at 12:11:40PM +0200, Sedat Dilek wrote:
> >On Mon, Aug 10, 2020 at 12:01 PM Greg Kroah-Hartman
> ><gregkh@linuxfoundation.org> wrote:
> >>
> >> On Mon, Aug 10, 2020 at 12:01:25PM +0200, Greg Kroah-Hartman wrote:
> >> > On Mon, Aug 10, 2020 at 11:52:30AM +0200, Sedat Dilek wrote:
> >> > > [ Hope I have the correct CC for linux-stable ML ]
> >> > >
> >> > > Hi Greg and Sasha,
> >> > >
> >> > > The base for <linux-stable-rc.git#queue/5.8> is Linux v5.7.14 where it
> >> > > should be Linux v5.8.
> >> >
> >> > What exactly do you mean by "#queue/5.8"?
> >> >
> >> > Is that a branch name?  Ah, never seen those before, maybe they are
> >> > something that Sasha creates?
> >>
> >> But yes, you are right, it seems to mirror queue/5.7 at the moment,
> >> which isn't correct.
> >>
> >> thanks,
> >
> >[ CC correct stable ML ]
> >
> >Exactly.
> >
> >With <linux-stable-rc.git#queue/5.8> I mean [1].
>
> Ah, thanks for pointing it out! I've fixed the script and pushed out a
> correct queue-5.8 branch.
>

Thanks Sasha.

Would you mind to take the random/random32 patches from Linus mainline
for queue/5.8 (see Linux v5.7.14)?

- Sedat -
