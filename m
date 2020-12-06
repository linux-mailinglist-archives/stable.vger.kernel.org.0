Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C892D0063
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 05:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgLFEJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 23:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgLFEJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Dec 2020 23:09:25 -0500
Date:   Sun, 6 Dec 2020 12:53:25 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607226809;
        bh=oNdexUdzXEELZFB/asVGYCG3iBfFGGOsLg4yKLqOUVE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=SpL4mxdyV/CYPWANhRJt+EBWH21CKMozVXoeFiqHlfs8S1wKYyQFgfRp7sm0uLW8V
         5WBvSXofY7npPVpuPpw/RW6dS4xJmbf13SBUzIJlqO7O3zUuGfIAADOuVMpuZBvtuI
         uyQ64FFiDmP1pEFctqo5YhIzVqCvB0HmNBIZ1Y4K6NPIQrhdk2NTt34RM2ZXKkjP7M
         J+vH7IVtl3mCGpntPxY6MpeRZf8pTkKrVegE3aVp9tfo6tuZnUZ5oF+HzTBcZxuYGp
         /lYz66ljnIIXDCw9JSocLi/U6waYNw/ZgJhPRpFRK76Zy5lpHH0WsUkjwB0fUm5UwN
         +kBKRpOxOkWdg==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org,
        tip-bot2 for Masami Hiramatsu <tip-bot2@linutronix.de>,
        linux-tip-commits@vger.kernel.org,
        syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com,
        Borislav Petkov <bp@suse.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        stable@vger.kernel.org, x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/uprobes: Do not use prefixes.nbytes when
 looping over prefixes.bytes
Message-Id: <20201206125325.d676906774c2329742746005@kernel.org>
In-Reply-To: <20201205101704.GB26409@zn.tnic>
References: <160697103739.3146288.7437620795200799020.stgit@devnote2>
        <160709424307.3364.5849503551045240938.tip-bot2@tip-bot2>
        <20201205091256.14161a2e1606c527131efc06@kernel.org>
        <20201205101704.GB26409@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 5 Dec 2020 11:17:04 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Dec 05, 2020 at 09:12:56AM +0900, Masami Hiramatsu wrote:
> > This may break tools/objtool build. Please keep "inat.h".
> 
> How? Please elaborate.
> 
> Build tests are fine here.

Oops, sorry, it was for perf build.

Please refer commit 00a263902ac3 ("perf intel-pt: Use shared x86 insn decoder").

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
