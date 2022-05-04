Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A4051A0D2
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 15:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350669AbiEDN0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 09:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350655AbiEDN0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 09:26:16 -0400
Received: from mout.web.de (mout.web.de [217.72.192.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3198F10F4
        for <stable@vger.kernel.org>; Wed,  4 May 2022 06:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1651670506;
        bh=nIxU8gLzFYKvJF9uI9kY+lt0KyTjpL9S/tKCGC/2f5k=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=kLrKibK8uQj+45A3r2pOBbmI/csGu0kGZl1leAa0Zv9Mu2lFpbhJRCZH5OxVeRpy0
         xx2muFCTAeUCw2t2QVxVumoxTo78pabLW/lUG0y5QD3U4qK8l8lC2DsF1rtGvZq0hK
         E9tCPb5r6n3erfghGoD2wsVMtd9MVw6jT8UT4gPg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from uruz.dynato.kyma ([79.245.218.86]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N14pE-1nwiTg2q4o-012ajB; Wed, 04
 May 2022 15:21:46 +0200
Received: from [127.0.0.1]
        by uruz.dynato.kyma with esmtp (Exim 4.95)
        (envelope-from <jvpeetz@web.de>)
        id 1nmEws-0002Ot-0D;
        Wed, 04 May 2022 15:21:46 +0200
Message-ID: <f731aff4-a20a-26b3-473f-723b65e760ce@web.de>
Date:   Wed, 4 May 2022 15:21:45 +0200
MIME-Version: 1.0
Subject: Re: Linux 5.17.5
Content-Language: en-US
To:     JoergRoedel <joro@8bytes.org>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        vasant.hegde@amd.com, WillDeacon <will@kernel.org>,
        stable@vger.kernel.org
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de> <Ym+oOjFrkdju5H6X@8bytes.org>
 <4bfd2811-69ec-e4ec-2957-7054a075aa50@web.de> <YnI2QYZ1GqmORC10@8bytes.org>
From:   =?UTF-8?Q?J=c3=b6rg-Volker_Peetz?= <jvpeetz@web.de>
In-Reply-To: <YnI2QYZ1GqmORC10@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pEPGtn0wwj+jTE06nlejLSuO+MtLJiiqoxtRTeWoOWNbmgum7bf
 tFLEKu+5QPzVWlpy7nt8ohYWv7uOWqNqz9obA7bN1tsNWcwEsbuyy0YXsbyipdhl/a4p4Mw
 teIzdNXzfb3+J9mKeq/NlZUwViqxZAwBTRHSZiBSm/xq8paMXhPoyWBBHCx6W4aOfIKxXO8
 BOH8HhNhFcECIgb4QTiNA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sSb7FzQiMTc=:FbWCCpl4nYa8z6f+Ow4YV5
 G+xhoJiLMuxCzIPleb+AEnCcTCNVMcs9VzfTVBw5FJ8P2+t3/IfyS4D/4Dra96hmG0yo/Uw1U
 VhiK4/2Ac1BqbFX0OIX8IyEicVq0DH+8E+UStvaZ4XiDQaEfdtMmm3ynWwwJVkgKATTpZmFC6
 D/IhIbWWnojYQ5wdPEDUYJGhLuTXAaDgu2ABr+GfDfpMnYRbn3LYy1hs4Rb7MTXyO+FtKui2g
 Ur3HXf0z5P1PASogrgTybMfARzsvOop11e+UA0we91/sx/+Iu+3NrjEbsNkXk9+hnRQFHUsQz
 5ettViSeIqjPpYZrtC3bRc/02NhOfyFVWieOsRHYD17ei1EcwyCeDQTzMq58lZeIdPyR0UkfC
 2TwovyPaztcniN/V9lj6wJ/DZ399nNNa2vy/sQMiCAD34LrFRGUnxb3gEOnNT7rbTd99dt4bT
 3W7IHfjuMbPAFhMTWQk6H73fu9XlpycQgGQ6UBQhzl8AVksUybZP31+h1O8B77mDIZbVQpScn
 Ki/7baYPq0RzrXU8Kpkrx2qHxg8eZSy7i6FGx92F9YWW+2qBz6Spr5Donhx2Tl3YMUyRJzkLf
 fnuVeRC2vnjMxi4kd6veK5jclHE+Ph3ADQU4y+/kevU9le6hopl7bMw6WXMZi48AOObYGnkEc
 bDCzLE10Dhkdzq5urc56kHl3/18XWrD7ekRWadyiuVMkP7hlm2AfVC35v9OsUQeIMk60VVur8
 Jwenk2mMgj8yB3EeYs/rwrpI12VJnDRsJz8PnI9DAst4D3znBMi7LGQ33X4ZqliyS37r4qILe
 abKBNa8Eq3g6/ojetL/JXC6eesHyKUJFJhj/hIF5FE3W7HhJCDrUuphyG/u8Km4lT07D387iU
 5+iUGHUe13O1lTV9YlUPrLm78YG83hLliJ5HGZ6PoYGNzP/yrFaXRTguIqMKl8F0u98HwyvIM
 s9FK0qlwl8sYd6gW30BGwI3NAx0ZrthT5Ecf1HLKHGMMSKtIi6/FmqAT+eeZ92Rktg/IFQoDG
 ztL/JocLUt8QYPeiIpIfsLk1ZTTVJxvcOEYBDilj6gV4Gce9+LEOaav8G/g29q8MAz5z4gl6O
 ABL60l/HV1XHYA=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joerg,

now with the really patched kernel 5.17.5 the warning doesn't show up anym=
ore. I
did two cold starts and one reboot.

There are only two warnings regarding the CPU:

[    2.659141] amdgpu 0000:30:00.0: amdgpu: PSP runtime database doesn't e=
xist
[    3.538925] amdgpu: SRAT table not found

Sorry for the confusion and many thanks for your help.
Regards,
J=C3=B6rg.

[Sorry for re-sending. But somehow the other addressees got lost.]

JoergRoedel wrote on 04/05/2022 10:16:> Hi J=C3=B6rg,
 >
 > On Tue, May 03, 2022 at 12:17:40AM +0200, J=C3=B6rg-Volker Peetz wrote:
 >> May  2 21:50:27 xxx kernel: WARNING: CPU: 0 PID: 1 at
 >> drivers/iommu/amd/init.c:851 amd_iommu_enable_interrupts+0x312/0x3f0
 >
 > Are you sure you tested the right kernel? My patch removes that warning=
,
 > so it can't trigger anymore. It also adds a new warning, but in
 > different file and line.
 >
 >> In 'kern.log' I also found this:
 >>
 >> May  2 21:53:27 xxx kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR*=
 ring gfx
 >> timeout, signaled seq=3D16, emitted seq=3D17
 >
 > GPU errors, hard to say what triggered this. Can you please send me you=
r
 > exact MB and CPU model? There is a chance this is firmware-related.
 >
 > Besides that I learned that on some systems this warning only triggers
 > on resume. So increasing the timeout seems to be the only viable fix.
 > Can you please try the attached diff? It also prints the time it took t=
o
 > enable the GA log.
 >
 > Regards,
 >
 > 	Joerg
