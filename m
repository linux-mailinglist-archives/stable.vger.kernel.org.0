Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47873F2B1A
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 13:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239086AbhHTLYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 07:24:36 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51172 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237509AbhHTLYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 07:24:35 -0400
Received: from zn.tnic (p200300ec2f107b00e7e9cb6e773cca66.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:7b00:e7e9:cb6e:773c:ca66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 858051EC0531;
        Fri, 20 Aug 2021 13:23:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1629458632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2mcU7b/Mo2+LoFnyaUn6inWnkrw/BsDqWaLY12vZxfk=;
        b=dp+HFCu/8Hu4vnyrcGRLbhSTIofYyXLtA2DR2J2wL8g65ndA5pGWsBHoAzEFTwDGWSYHvM
        gCKBV6UR8UeO1b8qDEdSMO0ynrLXeW+AF4fnnwh9HGHVRmeYl1yRq94gbZqVgba6tvhrsL
        vxFuyFcbQH6j6qKqcq37pHIQtG6FajM=
Date:   Fri, 20 Aug 2021 13:24:31 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
        Fabio Aiuto <fabioaiuto83@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Message-ID: <YR+Q7zOPuzK2W/8T@zn.tnic>
References: <20210820073429.19457-1-joro@8bytes.org>
 <YR91KKJ1Bq/KNBnY@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YR91KKJ1Bq/KNBnY@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 11:26:00AM +0200, Borislav Petkov wrote:
> Lemme go test it on whatever I can - if others wanna run this, it would
> be very much appreciated!

FWIW, it boots fine here on my machines - not that it means a whole lot.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
