Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E1265A99C
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 11:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjAAKi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 05:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAAKi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 05:38:57 -0500
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF5FD6B
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 02:38:55 -0800 (PST)
Date:   Sun, 01 Jan 2023 10:38:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.kalamlacki.eu;
        s=protonmail2; t=1672569532; x=1672828732;
        bh=wN1NEj1q2KEbxTuuEO3pJlcVM+fkNNn5EESbZQQeC0o=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=tGpI6sfvjad7deZHFva8Jxo1HT6xhdTUHeAOsOZwjdtuGAJUDrn1TFSzlyoOOQU5Z
         S3Vpo+/0EVAbQdy4V3OTGqUCFaEnyALcCIQqcnahErQiUmvXjy5prtF983Kbqxoys+
         zCdnTzhzSsLASgcc8dtVUAnyY68/IYi4Z03py6PXPiKvalqADs6ZCjeQrAN2ispuem
         4qkPuBp/L2ioqw0lF/miCk/O3i0rx7KwmP8oCu0odSTitOCwbDX5uVQmh4OArJhESy
         OWSk1rHJNsABrhrjvlM1B6TstBNgyXiPL13IDPdLQCCWYIrHeFL+ix/U1nP/1vHP6k
         FzR9Bip9R9VEA==
To:     Greg KH <gregkh@linuxfoundation.org>
From:   =?utf-8?Q?=C5=81ukasz_Kalam=C5=82acki?= <lukasz@pm.kalamlacki.eu>
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <4c7bdbc1-0337-9cf2-8957-94a5f702a49c@pm.kalamlacki.eu>
In-Reply-To: <Y7FefVRwIQZWUosS@kroah.com>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu> <20230101065337.GA20539@1wt.eu> <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu> <Y7FIo0Eup6TKswTA@kroah.com> <187e8f10-2b73-3a18-d9ad-48b2d84bd6b9@pm.kalamlacki.eu> <20230101100518.GA21587@1wt.eu> <36e196c7-849f-bcda-4dbc-da9c0c492bbd@pm.kalamlacki.eu> <Y7FefVRwIQZWUosS@kroah.com>
Feedback-ID: 42407704:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1.01.2023 11:20, Greg KH wrote:
> On Sun, Jan 01, 2023 at 10:12:12AM +0000, =C5=81ukasz Kalam=C5=82acki wro=
te:
>> Allright, my kernel config is available here:
>> https://kalamlacki.eu/KERNELS/kconfig-6.1
>>
>> Compilation on 11th gen i5 core cpu using command:
>>
>> make -j 9 bindeb-pkg
> As we have both stated, we are not the people to be discussing this
> with as the kernel source is not the problem at all, so there's nothing
> we can do here, sorry.
>
> Have a good new year!
>
> greg k-h

I am aware Greg that this is not kernel release issue and rather gcc but
it occurs during kernel compilation and many people can have this issue
too and that is why I am discussing about it here.

Willy: Debian stable has gcc in version 10.2.1 as states my buildinfo
from compilation of kernel 6.1.1 as it can be checked here:
https://kalamlacki.eu/KERNELS/BUSTER/linux-upstream_6.1.1-1_amd64.buildinfo=
.


Best,

=C5=81ukasz



