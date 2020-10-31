Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02142A1528
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 11:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgJaK1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 06:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgJaK1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 06:27:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAC6C0613D5;
        Sat, 31 Oct 2020 03:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CqFzFNPPPP+ktKGHhXOQeGBYQqisZzJcB4N3q49VwVk=; b=finovtMJqE27potrRVBMaWX0D
        Gz4KnojpmwAYlcZUv2G7ZXX2qGnGR1Fy+CYmYTwJBFHJjLruN+Z6K5Wx+0D/hUiwviOQd7/6UgqAA
        IH2KciI9MFHve1hNVpMSWwv6kFQpvUfrdpkn8Lwv98qvz+5cwe9djms4MyS3BIhxftkMCf4XNSC2q
        Y11EvdLii2vq/KDKQaQj6bGcnBbamnFVyG5Iz35H+Ml/+Dl4jzVcjyb7XEJb+envbkH72vx/Zxv5L
        iy+oB/NouYRBFJxeko1QnoJ+rC+PwVFN5X9nSlb50DLh7C7iOjTj7/oafn112whYuaAZsPyOhhsLs
        4GoRsvM3w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53272)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kYo6I-00074P-QJ; Sat, 31 Oct 2020 10:27:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kYo6H-00087U-Ss; Sat, 31 Oct 2020 10:27:09 +0000
Date:   Sat, 31 Oct 2020 10:27:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     daniel.vetter@ffwll.ch, gregkh@linuxfoundation.org,
        yepeilin.cs@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201031102709.GH1551@shell.armlinux.org.uk>
References: <20201030181822.570402-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030181822.570402-1-lee.jones@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 06:18:22PM +0000, Lee Jones wrote:
> Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for

Your commit ID does not exist in mainline kernels, which makes this
confusing. The commit ID you should be using is 6735b4632def.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
