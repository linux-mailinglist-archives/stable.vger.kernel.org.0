Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7FD1748E
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfEHJGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:06:43 -0400
Received: from mail.skyhub.de ([5.9.137.197]:41786 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfEHJGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 05:06:42 -0400
Received: from zn.tnic (p2E584D41.dip0.t-ipconnect.de [46.88.77.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 779A01EC0A9C;
        Wed,  8 May 2019 11:06:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1557306401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=F6au2xiowFFEoX8qqczga5C08P8EsTyJL1hDoPHKRLU=;
        b=gtag/QyTLpaXebQdNOSc2BxfbBdPsOotaUxQnYYlZqYKxx/hGyCqFVD+1hLrWBMJGRJxEZ
        7jYLvNVsWkAglyoG6bfT8M0QtF4bmPPjww95fIWt28VVP4uNTqIMG0XuThFYjETPXFOt8P
        7Vv7sRm8/Ga9Dlt/7Jfry6pnXZkz+1o=
Date:   Wed, 8 May 2019 11:04:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        hpa@zytor.com, kirill.shutemov@linux.intel.com,
        keescook@chromium.org
Subject: Re: [PATCH v4] x86/mm/KASLR: Fix the size of vmemmap section
Message-ID: <20190508090424.GA19015@zn.tnic>
References: <20190508080417.15074-1-bhe@redhat.com>
 <20190508082418.GC24922@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190508082418.GC24922@MiWiFi-R3L-srv>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 04:24:18PM +0800, Baoquan He wrote:
> I think this's worth noticing stable tree:
> 
> Cc: stable@vger.kernel.org

Fixes: ?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
