Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6383F51785
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbfFXPon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbfFXPon (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 11:44:43 -0400
Received: from localhost (mobile-166-177-251-191.mycingular.net [166.177.251.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F512054F;
        Mon, 24 Jun 2019 15:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561391082;
        bh=7Jt7rUpCp3dXBK8HQ+SmNDCCUj1JSeZ3i8KBPoRDdwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kX253NfTTtyouxOS1RZK2ORnfaf0USw4oBL5rt3Za3DEUC+ByPjKeXv/Jbfr/bPE1
         nVRmlumHIELavHZHLA7oi/1Fo2SiZPDMENCa4l1fR6UrVZr0Vk83GMTqHSLX6yAziL
         1gvwwwJgNqOFBcAba7OI37PsO8wdWRwlZ9z+Vuj4=
Date:   Mon, 24 Jun 2019 23:41:45 +0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/121] 5.1.15-stable review
Message-ID: <20190624154145.GA30572@kroah.com>
References: <20190624092320.652599624@linuxfoundation.org>
 <a37d3054-c0a4-da0f-8316-051f0ce293ca@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a37d3054-c0a4-da0f-8316-051f0ce293ca@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 05:48:34AM -0700, Guenter Roeck wrote:
> On 6/24/19 2:55 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.15 release.
> > There are 121 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Early feedback:
> 
> Building nds32:allmodconfig ... failed
> --------------
> Error log:
> arch/nds32/math-emu/fpuemu.c: In function 'fpu_emu':
> arch/nds32/math-emu/fpuemu.c:308:48: error: 'FPCSR_mskALLE_NO_UDFE' undeclared (first use in this function); did you mean 'FPCSR_mskALLE_NO_UDF_IEXE'?
>   if (((fpu_reg->fpcsr << 5) & fpu_reg->fpcsr & FPCSR_mskALLE_NO_UDFE) ||
>                                                 ^~~~~~~~~~~~~~~~~~~~~
>                                                 FPCSR_mskALLE_NO_UDF_IEXE
> arch/nds32/math-emu/fpuemu.c:308:48: note: each undeclared identifier is reported only once for each function it appears in
> arch/nds32/math-emu/fpuemu.c:309:52: error: 'struct fpu_struct' has no member named 'UDF_trap'; did you mean 'UDF_IEX_trap'?
>       ((fpu_reg->fpcsr & FPCSR_mskUDF) && (fpu_reg->UDF_trap)))
>                                                     ^~~~~~~~
>                                                     UDF_IEX_trap

Now dropped nds32 patch that caused this, and pushed out an -rc2
release.

thanks

greg k-h
