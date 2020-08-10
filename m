Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3482411C4
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJUfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:35:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53338 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgHJUfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:35:36 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597091735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNzwJsZq0mgDyRAhYCynTgpgOJY9cZb7szfD0lOx3Qw=;
        b=ObiszCEsfhVCEK6T/Y8aKJELf8CV03FEs8wcx22E/gGETJ4zWqkaVfwUERABbgNh8F0Y1N
        2hZvUG4gCSS4w0lrR2KEQ6++Hns+wjv6PszrgcmEkfNqA7K65fcEFyfw3ZYcKao4HcoQ3J
        0RAaxRvhOBRwyg01q9mPk7f9tKLyHU0nWyvVmxSLhHtS2ofWAgQApzvqyD9GX2MCwe4e6A
        iQuqyY1NsoGBdnE8PsqUiVk0592dp+TNAIIbZnbW9K+52C5LPRHguqtQhUNwvtjb/DTBBE
        0aVfPEfrZQ0dPvZTsQJmtBOrStWw2RWKkVXhWuiyZYrjtgHnLnwSzBYFUpQaFQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597091735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNzwJsZq0mgDyRAhYCynTgpgOJY9cZb7szfD0lOx3Qw=;
        b=C1soCkNqNhkB7Udr3QsyMNtcaTgWv3XX4g6C5XQy+u0XGDLWVHkmI2N+1zvGjeBcOZ+vZh
        /0dheUx6y2S+KSCQ==
To:     Frank van der Linden <fllinden@amazon.com>, stable@vger.kernel.org
Subject: Re: [PATCH 5.4] genirq/affinity: Make affinity setting if activated opt-in
In-Reply-To: <20200810202740.GA22367@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
References: <20200810202503.22317-1-fllinden@amazon.com> <20200810202740.GA22367@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
Date:   Mon, 10 Aug 2020 22:33:10 +0200
Message-ID: <87mu32xmux.fsf@nanos>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Frank van der Linden <fllinden@amazon.com> writes:
> On Mon, Aug 10, 2020 at 08:25:03PM +0000, Frank van der Linden wrote:
>> Implement the necessary core logic and make the two irqchip implementations
>> for which this is required opt-in. In hindsight this would have been the
>> right thing to do, but ...
>
> I backported this one since it had a minor conflict, so while the main
> one was Cc-ed to stable@, it didn't get picked up.
>
> Ran it through all our regression tests and the reproducer case, and it's
> fine.

LGTM
