Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61251E2F42
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbgEZTqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389798AbgEZTqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 15:46:33 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A9AC03E96D;
        Tue, 26 May 2020 12:46:32 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f9100c45766fca55d94fe.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:9100:c457:66fc:a55d:94fe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2E2FC1EC0300;
        Tue, 26 May 2020 21:46:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590522391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UwvATQ6Di/6WhS3s7DR0p6YEsaemqMGEuZEXjR9YHqY=;
        b=B1BB2ASrXS7lkgOCqmceLfGIj7A6UX84rUjvPGTBq+TqA+asHph26yRdF97LOjIO8mlvF+
        bbys0sk/9zitA+DMuhKC3Yx+u40czSS56uabln/dxffytiuJqkqusv9Lov4wsVFPumgCW8
        PjEXorTr+ILNIP7ysTrqhyQHlbhdkdQ=
Date:   Tue, 26 May 2020 21:46:25 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jue Wang <juew@google.com>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        x86 <x86@kernel.org>
Subject: Re: [tip: ras/core] x86/{mce,mm}: Change so poison pages are either
 unmapped or marked uncacheable
Message-ID: <20200526194624.GG28228@zn.tnic>
References: <159040440370.17951.17560303737298768113.tip-bot2@tip-bot2>
 <20200525204010.GB25598@zn.tnic>
 <3908561D78D1C84285E8C5FCA982C28F7F64615F@ORSMSX115.amr.corp.intel.com>
 <CAPcxDJ5arJojbY4pzOvYh=waSPd3X_JJb1_PSuzd+jQ0qbvFsA@mail.gmail.com>
 <CAPcxDJ54EgX-SaDV=Lm+a2-43O68LhomyYfYdCDz38HGJCkh7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcxDJ54EgX-SaDV=Lm+a2-43O68LhomyYfYdCDz38HGJCkh7g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 11:44:18AM -0700, Jue Wang wrote:
> On Tue, May 26, 2020 at 11:03 AM Jue Wang <juew@google.com> wrote:
> 
> > I tried to test this but my guest image build setup was not able to build
> > from kernel/git/bp/bp.git tip-ras-core branch. It appeared there was some
> > bindeb-pkg issue.
> >
> The bindeb-pkg issue is resolved and I tested the following branch in KVM
> guest and the injected MCE is recovered.
> https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=tip-ras-core

Thanks to both of you!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
