Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3DA16F74
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 05:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfEHD3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 23:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfEHD3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 23:29:12 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06CC821479;
        Wed,  8 May 2019 03:29:10 +0000 (UTC)
Date:   Tue, 7 May 2019 23:29:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Andreas Ziegler <andreas.ziegler@fau.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] tracing: probeevent: Fix to make the type of
 $comm string
Message-ID: <20190507232909.645695d3@oasis.local.home>
In-Reply-To: <20190508122403.73cce014a6f7d66e0835e2be@kernel.org>
References: <155723736241.9149.14582064184468574539.stgit@devnote2>
        <20190507174758.1D5FA205C9@mail.kernel.org>
        <20190508122403.73cce014a6f7d66e0835e2be@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 May 2019 12:24:03 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > How should we proceed with this patch?
> >   
> 
> Thanks for the report! I missed the Fixes tag. I realized that the comm type
> check was done in other place in older kernel. This bug was introduced by
> commit 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code").

I've applied this to my queue. Should I change the Fixes to the above commit?

-- Steve
