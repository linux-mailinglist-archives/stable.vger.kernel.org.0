Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A21846EC9F
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 17:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbhLIQKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 11:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240855AbhLIQKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 11:10:41 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F3CC061746;
        Thu,  9 Dec 2021 08:07:08 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AC65D1EC056B;
        Thu,  9 Dec 2021 17:07:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639066026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZJdrNN0YKWxPWRP2Cax3HsJtXIfrv5v4NHYZQ0BkSk4=;
        b=aMCYZoN1n1jwqd+RQVUFPl8urFDIWWPRVxS9Vn1WzSGkTxWPb/dNRX+wi0YvB3FCXQOFkE
        Z4G6dnI9U0s4aHEAT4HSreBfxHTiQin48lPxa4XXuHsFOC+l55Myhahz6T+OM+M7RD/f0J
        UU2+w58zpNXV115vQag73MFtL8YJ+ic=
Date:   Thu, 9 Dec 2021 17:07:08 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     John Dorminy <jdorminy@redhat.com>
Cc:     tip-bot2@linutronix.de, anjaneya.chagam@intel.com,
        dan.j.williams@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbIprPqjTkgvP0i0@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <CAMeeMh_Huv-XAx4WHRDvTNoZb3J76y0jft05u18uGAfVCrj96w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMeeMh_Huv-XAx4WHRDvTNoZb3J76y0jft05u18uGAfVCrj96w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 10:49:06AM -0500, John Dorminy wrote:
> Confirmed that that patch makes mem= work again:

Thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
