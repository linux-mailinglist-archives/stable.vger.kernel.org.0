Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5116F1703A
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 06:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfEHE5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 00:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfEHE5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 00:57:39 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 032A42053B;
        Wed,  8 May 2019 04:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557291459;
        bh=zc8ET2TlkNTxfwKt24Q51994S2V4ItrjPRhAJkNmZiQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NiW6sio4OdTuLOj3M1f6+jhfGZ22s3WTTqKsXOZAKCCulte+Bz8KILCV27BX5IHkd
         ktiBaWbBtEyZNBDN62d30NahZ5q0BGCvqC7udh4nHKnAcYbgCRgy3ys64nUGGJ9Ipt
         BTY5oQdc4yNsxh7vfDi9bDRKtpMa3iLMVJjUsYKI=
Date:   Wed, 8 May 2019 13:57:36 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Andreas Ziegler <andreas.ziegler@fau.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] tracing: probeevent: Fix to make the type of
 $comm string
Message-Id: <20190508135736.8b8495e0406acb48e4980758@kernel.org>
In-Reply-To: <20190507232909.645695d3@oasis.local.home>
References: <155723736241.9149.14582064184468574539.stgit@devnote2>
        <20190507174758.1D5FA205C9@mail.kernel.org>
        <20190508122403.73cce014a6f7d66e0835e2be@kernel.org>
        <20190507232909.645695d3@oasis.local.home>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 23:29:09 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 8 May 2019 12:24:03 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > > How should we proceed with this patch?
> > >   
> > 
> > Thanks for the report! I missed the Fixes tag. I realized that the comm type
> > check was done in other place in older kernel. This bug was introduced by
> > commit 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code").
> 
> I've applied this to my queue. Should I change the Fixes to the above commit?

Thanks! Yes, please update the Fixes tag to 533059281ee5, that is the correct commit.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
