Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAE1178192
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732254AbgCCSDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:03:40 -0500
Received: from mail.klausen.dk ([174.138.9.187]:34792 "EHLO mail.klausen.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387656AbgCCSDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:03:40 -0500
Subject: Re: [PATCH v2] platform/x86: asus-wmi: Support laptops where the
 first battery is named BATT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=klausen.dk; s=dkim;
        t=1583258618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8WfyNAp2nRvD8qMrVeP1u5mbnaHpffX7Fwcte0Deqmw=;
        b=K13YGVaI2OnkhyMHP/5Tdn2LagILJv/fiRmMcTXIHHpI/FsQXFgZ9aiwIk1ma39r3ruMeK
        1uIh0pQtYhnnRx1GaVSe+qLxxVBLFj1T7e02ioqgQ2CUvs3xB0htPhvi8j0EwNnLwO8X2p
        bFKZfsSBo/efS3rsmRD+ESotiXCQ2fE=
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
References: <20200223181832.17131-1-kristian@klausen.dk>
 <20200224011017.C5207208C4@mail.kernel.org>
 <e700ebdc-3dce-c151-3ea5-f7ab1e4cb07f@klausen.dk>
 <CAHp75VcAZZ-d1BQON0ciLoCGt5=1qh4s1jLGhDdApicT+7BEGg@mail.gmail.com>
 <af54a82e-0b9f-1e88-8741-bd4a3658d8e7@klausen.dk>
 <CAHp75VfGkn_oGCNyP=RWo9fHvh8YzEy6e7cDCczJefsq2HMRFw@mail.gmail.com>
 <CAHp75VeG0CgORmpsH8q72MAXhgQs29QAXs1w4B4FxReQ01S7dA@mail.gmail.com>
From:   Kristian Klausen <kristian@klausen.dk>
Message-ID: <4eeb33dc-0838-2feb-74d4-522fe470256b@klausen.dk>
Date:   Tue, 3 Mar 2020 19:03:36 +0100
MIME-Version: 1.0
In-Reply-To: <CAHp75VeG0CgORmpsH8q72MAXhgQs29QAXs1w4B4FxReQ01S7dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03.03.2020 15.46, Andy Shevchenko wrote:
> On Tue, Feb 25, 2020 at 11:55 AM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>> On Tue, Feb 25, 2020 at 11:51 AM Kristian Klausen <kristian@klausen.dk> wrote:
> ...
>
>>> Sorry about that, my response does not make any sense.
>>> The change isn't upstream yet, and should be applied upstream first and
>>> the 5.4 and 5.6 tree tree if possible.
>> The usual pattern is to add Fixes tag and Cc: stable@.
>>
>>> Was I wrong CC'ing stable@vger.kernel.org? (suggested by git send-email
>>> due to "Cc: stable@vger.kernel.org")
> Kristian, to be clear, I'm waiting for v3 with appropriate tag and Cc
> list applied.

Oh, I forgot. I just sent a V3 with "Fixes".


