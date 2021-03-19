Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA653416C1
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 08:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhCSHgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 03:36:22 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:52186 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbhCSHfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 03:35:53 -0400
Date:   Fri, 19 Mar 2021 07:35:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1616139347;
        bh=VA+is5LeWi9h2GKvlIGi2doPXuZf10NEWefk9OB/HFM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ufu/RXYcP7riTV0gKgyjGu8TUtxS0LkvHAuJj1BNMD98fBv49lrMO5DgqdkKdM4qD
         cK/QkHs16KKQKQNqAYMtTFoduqkEKv9yKZ9o4QGWqi3dpeNgKP1/O3IWkZf/bk9d9C
         HrLXhE/o/SroqE5KR2u40BP9Qlz1EJk1fGdhgJls=
To:     Sasha Levin <sashal@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
From:   Thomas Backlund <tmb@tmb.nu>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: stable request
Message-ID: <a39ebdf9-c7c3-990f-3d9d-81f138e55d94@tmb.nu>
In-Reply-To: <YFNPiHAvEwDpGLrv@sashalap>
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu> <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com> <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu> <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu> <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com> <YFNPiHAvEwDpGLrv@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 18-03-2021 kl. 15:03, skrev Sasha Levin:
>
> On Tue, Mar 16, 2021 at 01:35:40PM +0100, Ard Biesheuvel wrote:
>> On Tue, 16 Mar 2021 at 13:28, Thomas Backlund <tmb@tmb.nu> wrote:
>>>
>>>
>>> Den 16.3.2021 kl. 14:15, skrev Thomas Backlund:
>>>>
>>>> Den 16.3.2021 kl. 12:17, skrev Ard Biesheuvel:
>>>>> On Tue, 16 Mar 2021 at 10:21, Thomas Backlund <tmb@tmb.nu> wrote:
>>>>>> Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
>>>>>>> Please consider backporting commit
>>>>>>>
>>>>>>> 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
>>>>>>> crypto: x86/aes-ni-xts - use direct calls to and 4-way stride


>
> Queued up for 5.10 and 5.11.
>

I dont see:
86ad60a65f29 ("crypto: x86/aes-ni-xts - use direct calls to and 4-way
stride")

in 5.11 queue.

--
Thomas

