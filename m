Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709D048EA03
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 13:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiANMjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 07:39:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40516 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiANMjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 07:39:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C08EB825EE
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 12:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9069C36AE5;
        Fri, 14 Jan 2022 12:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642163958;
        bh=VG/SAy0ieIHzhbajqVNYz1cTM73Cy+uDcT2R5qzNb7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f4inpeZTRG5EP8l+SkHbnoaWk0eZX2WOPCyq0tItfLTfUEZ/n75rebGZuS8GVaOgZ
         2zAU7ITynmj1C3tuYlsO14bgfFVo6B6xDju48TUGDgNdCbGeVLTmhyLEwG/SndAI5x
         VGNHzoB8T4omDbSSdU95cnMGcat80bqv26nfK5GI=
Date:   Fri, 14 Jan 2022 13:39:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [BACKPORT v4.14] bpf: fix truncated jump targets on heavy
 expansions
Message-ID: <YeFu8yoYAWEu3DbY@kroah.com>
References: <CAF2Aj3g6Z_vVEUDcESkJMqTZ_Ljr7GQXFCFdLmFEq9yQHo7YPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF2Aj3g6Z_vVEUDcESkJMqTZ_Ljr7GQXFCFdLmFEq9yQHo7YPQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 11:21:41AM +0000, Lee Jones wrote:
> Could we please have this in linux-4.14.y as it fixes a CVE.
> 
> https://lore.kernel.org/all/20180516234411.18122-1-daniel@iogearbox.net/
> 
> 050fad7c4534c ("bpf: fix truncated jump targets on heavy expansions")

It does not apply cleanly, so we would need a backported version in
order to be able to do this.

Can you please provide one?

thanks,

greg k-h
