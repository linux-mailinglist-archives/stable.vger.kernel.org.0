Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4975269F49B
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjBVMcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbjBVMcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:32:41 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024163B0CE;
        Wed, 22 Feb 2023 04:32:35 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 23BA01EC063A;
        Wed, 22 Feb 2023 13:32:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677069154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xlmpkjgwQoUi0lrUhbXBq+an05Z+QBYhopZRL4lwg/o=;
        b=Jto/XUVA00NcXdq+3KYnTdEuIq+ZfLSa7FvgBj8xhMAh2+jJI8Q5ZjRxIG38dYrCvRZr3y
        ZE+RlctgJ4Noe2M1SJ4F6QqrezH+iEgEOY7j5U7QRmuSoB3AxNM9r8RR4Jie7ntrG8g2Ns
        6wBI2bGqPADhDl12jANa8oqMmHhbwiM=
Date:   Wed, 22 Feb 2023 13:32:33 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     KP Singh <kpsingh@kernel.org>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/YLYbr5CV2Vtxph@zn.tnic>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <20230222030728.v4ldlndtnx6gqd6x@desk>
 <CACYkzJ4efHx2oZUW82m3DGw7ssLq37EFOV57X=kT5fm=6Q7WbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACYkzJ4efHx2oZUW82m3DGw7ssLq37EFOV57X=kT5fm=6Q7WbQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 09:49:57PM -0800, KP Singh wrote:
> That is a bit more complicated as, for now, the user is not really
> exposed to STIBP explicitly yet.

Remember that we're exposing the normal user to a gazillion switches
already. And not every user has done a PhD in hw vulns like we were
forced to in the last, at least 5, years.

So whatever you do, you should try to make it work automatic - if
possible - and DTRT - i.e., sane defaults.

Every new functionality added to that madness needs a proper
justification.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
