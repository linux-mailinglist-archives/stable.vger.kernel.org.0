Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C2316BDE4
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 10:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgBYJvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 04:51:55 -0500
Received: from mail.klausen.dk ([174.138.9.187]:49972 "EHLO mail.klausen.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729178AbgBYJvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 04:51:55 -0500
Subject: Re: [PATCH v2] platform/x86: asus-wmi: Support laptops where the
 first battery is named BATT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=klausen.dk; s=dkim;
        t=1582624312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cayDO/spxhnm0XTSfjb5VkL79VovgljmFLAhBNwnvBY=;
        b=IfTxTlgfITmIqZynGBEFT0XHg8r3YczQ5bwVetW5Jch554lwAk08+T0vAnCFhTec+n0tjh
        XbEe8UvWDI44MPvg5b3sgCKk9sI0qYTWTNns7hqIy0G54aIG1cxAcU5bjW/z5v2QugEh1o
        vs7sd8rVZyaLMNiT9DNfc2g/tVuPtLI=
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
References: <20200223181832.17131-1-kristian@klausen.dk>
 <20200224011017.C5207208C4@mail.kernel.org>
 <e700ebdc-3dce-c151-3ea5-f7ab1e4cb07f@klausen.dk>
 <CAHp75VcAZZ-d1BQON0ciLoCGt5=1qh4s1jLGhDdApicT+7BEGg@mail.gmail.com>
From:   Kristian Klausen <kristian@klausen.dk>
Message-ID: <af54a82e-0b9f-1e88-8741-bd4a3658d8e7@klausen.dk>
Date:   Tue, 25 Feb 2020 10:51:50 +0100
MIME-Version: 1.0
In-Reply-To: <CAHp75VcAZZ-d1BQON0ciLoCGt5=1qh4s1jLGhDdApicT+7BEGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.02.2020 10.30, Andy Shevchenko wrote:
> On Mon, Feb 24, 2020 at 3:15 AM Kristian Klausen <kristian@klausen.dk> wrote:
>> On 24.02.2020 02.10, Sasha Levin wrote:
>>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>>
>>> How should we proceed with this patch?
>> The patch should only be applied to the v5.4 and v5.5 trees.
> I'm not sure I got this right. Do we have already this change in upstream?
> I don't see it there. So, why there is no mention of the v5.6 and
> current upstream in above list?

Sorry about that, my response does not make any sense.
The change isn't upstream yet, and should be applied upstream first and 
the 5.4 and 5.6 tree tree if possible.
Was I wrong CC'ing stable@vger.kernel.org? (suggested by git send-email 
due to "Cc: stable@vger.kernel.org")


