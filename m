Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD162342019
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 15:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhCSOsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 10:48:16 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:37892 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbhCSOsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 10:48:03 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 510F892009C; Fri, 19 Mar 2021 15:48:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 49FB392009B;
        Fri, 19 Mar 2021 15:48:02 +0100 (CET)
Date:   Fri, 19 Mar 2021 15:48:02 +0100 (CET)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     YunQiang Su <wzssyqa@gmail.com>
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 RESEND] MIPS: force use FR=0 or FRE for FPXX
 binaries
In-Reply-To: <CAKcpw6X88Z7ZjDfXgeDcBHpf1bzPWZc3KqEGgxfc7T30--wNWQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2103191532140.21463@angie.orcam.me.uk>
References: <20210312104859.16337-1-yunqiang.su@cipunited.com> <20210315145850.GA12494@alpha.franken.de> <CAKcpw6X88Z7ZjDfXgeDcBHpf1bzPWZc3KqEGgxfc7T30--wNWQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Mar 2021, YunQiang Su wrote:

> > what about just rebuilding them ? They are broken, so why should we fix
> > broken user binaries with kernel hacks ?
> >
> 
> In fact without O32_FP64_SUPPORT option is enabled, the FP=0 mode is
> always used for FPXX.

 As I noted in the discussion the choice of the FR mode for FPXX binaries 
is neutral performance-wise for R2 through R5, so as I previously stated 
it would be fine with me to use FR=0 rather than FR=1 for FPXX binaries 
with these architecture levels.

> In fact it doesn't change the behaviour of kernel.

 That is not true for R6.  The use of the FRE mode with R6 does regress 
support for FPXX binaries performance-wise, which makes it unacceptable.  
And O32_FP64_SUPPORT is unconditionally selected for R6, so FR=0 (or FRE) 
is currently not used for FPXX with R6.

  Maciej

