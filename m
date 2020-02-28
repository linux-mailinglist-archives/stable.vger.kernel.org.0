Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD89173ECC
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 18:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgB1Rrx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 28 Feb 2020 12:47:53 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37750 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Rrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 12:47:53 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j7jjh-0003xG-Gx; Fri, 28 Feb 2020 18:47:41 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id E66F2100EA1; Fri, 28 Feb 2020 18:47:40 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware\, Inc." <pv-drivers@vmware.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/ioperm: add new paravirt function update_io_bitmap
In-Reply-To: <4715c1af-5854-9f2c-2145-fba43e82d350@suse.com>
References: <20200218154712.25490-1-jgross@suse.com> <4715c1af-5854-9f2c-2145-fba43e82d350@suse.com>
Date:   Fri, 28 Feb 2020 18:47:40 +0100
Message-ID: <87wo86fvsz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jürgen Groß <jgross@suse.com> writes:

> Friendly ping...

Ooops. I pick it up first thing tomorrow morning
