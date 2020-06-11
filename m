Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34EE1F6B50
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgFKPoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:44:08 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58152 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbgFKPoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 11:44:05 -0400
Received: from zn.tnic (p200300ec2f0bef00e16d68ab941b81be.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:ef00:e16d:68ab:941b:81be])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C59E21EC0361;
        Thu, 11 Jun 2020 17:44:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1591890242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zRjk4RBi0GnPGLmQJy0T5cJNf2UJsuqZOmkE4U6Bra8=;
        b=VHjBHUTIxc+sw+NlJyhB6Vf0IOkw3ufXM2VUrGTBfB9q5S4ZDEkEa+xjsfPNe8F7dGQxkl
        sWdQEGqxCHcq084KbL68NnAsvG8+AC0gy6LC92sM8Ur/06YQ1OYcLnJw1B8JIEGGatn1Jg
        kXwRQjq8BDmeovBGncC0tgOamddFtuM=
Date:   Thu, 11 Jun 2020 17:43:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Anthony Steinhauser <asteinhauser@google.com>
Cc:     linux-tip-commits@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tip: x86/urgent] x86/speculation: Avoid force-disabling IBPB
 based on STIBP and enhanced IBRS.
Message-ID: <20200611154356.GE30352@zn.tnic>
References: <159169282952.17951.3529693809120577424.tip-bot2@tip-bot2>
 <20200611140951.GD30352@zn.tnic>
 <CAN_oZf16odNhpY6_LqkVY2wpy90jKM9-vgKo4LE8OJ-QTDCKiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAN_oZf16odNhpY6_LqkVY2wpy90jKM9-vgKo4LE8OJ-QTDCKiw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 07:35:18AM -0700, Anthony Steinhauser wrote:
> Yes, I think it's fine.

Ok thanks, I'll do a proper patch next week when -rc1 is done and those
have gone in.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
