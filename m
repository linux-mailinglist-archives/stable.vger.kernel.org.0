Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B5A69E8FA
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 21:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBUUXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 15:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBUUXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 15:23:46 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4CFEFA2;
        Tue, 21 Feb 2023 12:23:45 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 420881EC0674;
        Tue, 21 Feb 2023 21:23:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677011024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mwTlKRXdLRqYXlVMvi0G247liHlUiP0Y1/NNpH6qfZw=;
        b=byYirHvTzqzPT2/7NYZQrJy3640P4+VnqFKw2OD2hd6K5fkqZsIhrFc058oN/OKhgDND0M
        bhDRqATtCtZbFJoHFh60V59PQKiC8TvA7vesW8o1/kvaa5wIBcctg4ZPqJtR7xXy/32Od7
        aL98pyuYvSRMykAOPdjcs0c03gZ/xgg=
Date:   Tue, 21 Feb 2023 21:23:38 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, jpoimboe@kernel.org,
        tglx@linutronix.de, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com, corbet@lwn.net,
        linyujun809@huawei.com, jmattson@google.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/UoSh7yazR75J8P@zn.tnic>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <Y/UbqiHQ2/aczPzg@kroah.com>
 <CACYkzJ7pLhJ+NfUq36PaMxadkgv-cPtO60TW=g_Nh7vU1vEWqA@mail.gmail.com>
 <Y/Uf2lnU/VcsFs1O@kroah.com>
 <Y/UiJmv7j12hOe0k@zn.tnic>
 <Y/Uk/CnJq+F2idie@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/Uk/CnJq+F2idie@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 09:09:32PM +0100, Greg KH wrote:
> I still send them, and so does 0-day, IF you send the emails
> incorrectly.  So far, that's not been the case for this series at all
> (hint, there needs to be a cc: stable in the signed-off-by area of the
> patch, that's all.)

Aha, you send it when there's no Cc: stable in the SOB area but stable
is still CCed.

Bah, forget what I said.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
