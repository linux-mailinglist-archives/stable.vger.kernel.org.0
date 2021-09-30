Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D581041D604
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 11:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349227AbhI3JK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 05:10:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48796 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348400AbhI3JK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 05:10:28 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632992925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z2oPtc9b4BmqlFJay6jWW7uTcsrX5/QQB2wxEI5hkt0=;
        b=k9uQjQgbf5JdrOhAhuW3cweMBNGjoPqPkGI7wsuVU3sAV61Zy0SkpVQ+VEMBaKbWzhMrzO
        Ng8+l4ExKe0y2/CPNar2xVcAXQYJgqcdJceP8/wp5lmJm5tTWxlo8Or+3dyLRAo0ZUFs1m
        KR+hCYaODEfysXCD3swVGQgKV7nOqUVjyaAChVE/fdZwzgMtMEaykPYp81kMCAwYg6zTwv
        5ojMhB1Nmg5Y7q1rCLr39KETYcGutbganEsG2UmbERjd1NX1g916D6dvKQeqXA1fzbjXgS
        1cgR9gydiLTDj4LvO9HMH5+UDi8JyYUtAokL3Epd/fkZRTSmehX/3fpbZr4INQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632992925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z2oPtc9b4BmqlFJay6jWW7uTcsrX5/QQB2wxEI5hkt0=;
        b=2cksT07ARFxHJvt2Sqpw5ea5gNlBrqCJLo0ITtkYaZV8hsP6DbSGt3xE5GjCkmYZZhMTDV
        5hbV/Zm0jLso83AA==
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     x86@kernel.org, jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, kai.heng.feng@canonical.com, bhelgaas@google.com,
        linux-pci@vger.kernel.org, rudolph@fb.com, xapienz@fb.com,
        bmilton@fb.com, paulmck@kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
In-Reply-To: <20210929160550.GA773748@bhelgaas>
References: <20210929160550.GA773748@bhelgaas>
Date:   Thu, 30 Sep 2021 11:08:44 +0200
Message-ID: <87mtnu77mr.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29 2021 at 11:05, Bjorn Helgaas wrote:
> On Wed, Sep 29, 2021 at 06:11:07AM -0700, Jakub Kicinski wrote:
>> On Thu, 16 Sep 2021 19:46:48 -0700 Jakub Kicinski wrote:
>> > My Lenovo T490s with i7-8665U had been marking TSC as unstable
>> > since v5.13, resulting in very sluggish desktop experience...
>> 
>> Where do we stand? Waiting for tglx to refactor PC10 detection and use
>> that, or just review delay?
>
> From my point of view, this is an x86 issue, not a PCI one, so I'll
> defer to the x86 folks.

Yes, it is. I'm still trying to make sense of this enumeration
muck. Adding these silly PCI ids to the quirks section is a whack a mole
game which does not make sense.

Lemme find a few spare cycles to whip up a patch.

Thanks,

        tglx
