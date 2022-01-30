Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D9E4A365E
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 13:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354800AbiA3Mud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 07:50:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60782 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347113AbiA3Mud (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 07:50:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D38ADB8285B;
        Sun, 30 Jan 2022 12:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BE7C340E4;
        Sun, 30 Jan 2022 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643547030;
        bh=iyo+mlHxHiMCbs0SnF8JOaLkc59upPWg3JbFGcSEqpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yE85WGOJQqUx9mVNtXLXPMTV/8Y4YzBUzS9c7wxTJfFwrZeegbSrNMm+4LlmXAAc/
         g0kxwwK9OfPRsrbE+lefYqYvfs2oBm1YaMQZu1eXSm+CmdRol2cqE6VD0GfCO8Kzb+
         bqxLexM8FpZ51CvS4mK/rPK8v56QMsRzXhBwdTKk=
Date:   Sun, 30 Jan 2022 13:50:27 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] [Modified for 5.16 and 5.15] powerpc/32s: Fix
 kasan_init_region() for KASAN
Message-ID: <YfaJk9dUMmiQOJJT@kroah.com>
References: <247bff242993dd6c8975a4f1248d822a448701ac.1643476812.git.christophe.leroy@csgroup.eu>
 <383707b74eac769f971ea72ea3db39aaf08e5111.1643476880.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <383707b74eac769f971ea72ea3db39aaf08e5111.1643476880.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 05:26:10PM +0000, Christophe Leroy wrote:
> This is a backport for 5.16 and 5.15.
> 
> To apply, it also requires commit 37eb7ca91b69 ("powerpc/32s: Allocate
> one 256k IBAT instead of two consecutives 128k IBATs")

Thanks for these, now queued up.

greg k-h
