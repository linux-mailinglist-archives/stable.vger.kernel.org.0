Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0547A15F7AB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgBNU0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:26:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56203 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgBNU0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 15:26:36 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2hXk-0006Sl-6d; Fri, 14 Feb 2020 21:26:32 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id ADC2F101304; Fri, 14 Feb 2020 21:26:31 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Borislav Petkov <bp@alien8.de>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, X86 ML <x86@kernel.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mce/amd: Fix kobject lifetime
In-Reply-To: <20200214201143.GQ13395@zn.tnic>
References: <20200214082801.13836-1-bp@alien8.de> <20200214083230.GA13395@zn.tnic> <20200214151727.GA3959278@kroah.com> <20200214201143.GQ13395@zn.tnic>
Date:   Fri, 14 Feb 2020 21:26:31 +0100
Message-ID: <87a75kud8o.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> On Fri, Feb 14, 2020 at 07:17:27AM -0800, Greg KH wrote:
>> Does not bother me at all, it's fine to see stuff come by that will end
>> up in future trees, it's not noise at all.  So no need to suppress
>> stable@vger if you don't want to.
>
> Ok, but what about your formletter which you send to people explaining
> this is not how you should send a patch to stable?
>
> Like this, for example:
>
> https://lkml.kernel.org/r/20200116100925.GA157179@kroah.com

This once Cc'ed stable but lacked a Cc: stable tag in the changelog.

Thanks,

        tglx
