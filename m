Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFC33143C3
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 00:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhBHX2j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 8 Feb 2021 18:28:39 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:49512 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231424AbhBHX2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 18:28:34 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.69.177;
Received: from localhost (unverified [78.156.69.177]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 23816764-1500050 
        for multiple; Mon, 08 Feb 2021 23:27:38 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <fe6040b5-72a0-9882-439e-ea7fc0b3935d@redhat.com>
References: <fe6040b5-72a0-9882-439e-ea7fc0b3935d@redhat.com>
Subject: Re: [Intel-gfx] [5.10.y regression] i915 clear-residuals mitigation is causing gfx issues
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org
Date:   Mon, 08 Feb 2021 23:27:38 +0000
Message-ID: <161282685855.9448.10484374241892252440@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Hans de Goede (2021-02-08 20:38:58)
> Hi All,
> 
> We (Fedora) have been receiving reports from multiple users about gfx issues / glitches
> stating with 5.10.9. All reporters are users of Ivy Bridge / Haswell iGPUs and all
> reporters report that adding i915.mitigations=off to the cmdline fixes things, see:

I tried to reproduce this on the w/e on hsw-gt1, to no avail; and piglit
did not report any differences with and without mitigations. I have yet
to test other platforms. So I don't yet have an alternative. Though note
that v5.11 and v5.12 will behave similarly, so we need to urgently find
a fix for Linus's tree anyway.
-Chris
