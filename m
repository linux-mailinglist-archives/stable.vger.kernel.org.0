Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7FF34EC98
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 17:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhC3Pe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 11:34:56 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38232 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbhC3Peo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 11:34:44 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 808D392009C; Tue, 30 Mar 2021 17:34:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 79C6592009B;
        Tue, 30 Mar 2021 17:34:43 +0200 (CEST)
Date:   Tue, 30 Mar 2021 17:34:43 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     YunQiang Su <yunqiang.su@cipunited.com>
cc:     linux-mips@vger.kernel.org, jiaxun.yang@flygoat.com,
        f4bug@amsat.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v9] MIPS: force use FR=0 for FPXX binaries
In-Reply-To: <20210322015902.18451-1-yunqiang.su@cipunited.com>
Message-ID: <alpine.DEB.2.21.2103300312250.18977@angie.orcam.me.uk>
References: <20210322015902.18451-1-yunqiang.su@cipunited.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021, YunQiang Su wrote:

> Currently, FR=1 mode is used for all FPXX binary if O32_FP64 supported is enabled,
> it makes some wrong behivour of the binaries.
> Since FPXX binary can work with both FR=1 and FR=0, we force it to use FR=0.

 Even if it is given a go-ahead from the semantic point of view, your 
change still suffers from style issues.  I find the change description 
inaccurate or unclear in some places (I can help with that, but not before 
code itself has been accepted), and the change has overlong lines both in 
the body (the limit is 80 columns) and the description (the limit is 75 
columns).  It's not clear to me why `scripts/checkpatch.pl' only complains 
about one place, but you need to fix them all.

 If you haven't so far, please familiarise yourself with the documents 
describing patch submission: Documentation/process/coding-style.rst and
Documentation/process/submitting-patches.rst available in the kernel tree.
They document the line length limits given above and all the other aspects 
of code preparation for submission.

  Maciej
