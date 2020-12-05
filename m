Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4782CFAFB
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 11:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgLEKW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 05:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbgLEKVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Dec 2020 05:21:30 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B266C061A51;
        Sat,  5 Dec 2020 02:20:50 -0800 (PST)
Received: from zn.tnic (p200300ec2f21ef0015054ed9185c317a.dip0.t-ipconnect.de [IPv6:2003:ec:2f21:ef00:1505:4ed9:185c:317a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5F48F1EC0494;
        Sat,  5 Dec 2020 11:17:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1607163423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oo0/lXNnhSYJq1ZkrccRKwqxO+zFM/8uFysGplWZKrg=;
        b=oiwQuNmRpbjkJI3R6n/YzgyYTXRw9SaBxba2OuSFKelLDBpZY+fl0nTkC5evthrkogJtRz
        5LJnckym0kvVa8hWyWRIXXERSI1xJ7ef9R9bYBuQ37ZU4ow815FY7SG38IIgECOpGsuWC5
        6fL/dKv3H3rybDzNW/BCSSwtwwkysEM=
Date:   Sat, 5 Dec 2020 11:17:04 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        tip-bot2 for Masami Hiramatsu <tip-bot2@linutronix.de>,
        linux-tip-commits@vger.kernel.org,
        syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com,
        Borislav Petkov <bp@suse.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        stable@vger.kernel.org, x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/uprobes: Do not use prefixes.nbytes when
 looping over prefixes.bytes
Message-ID: <20201205101704.GB26409@zn.tnic>
References: <160697103739.3146288.7437620795200799020.stgit@devnote2>
 <160709424307.3364.5849503551045240938.tip-bot2@tip-bot2>
 <20201205091256.14161a2e1606c527131efc06@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201205091256.14161a2e1606c527131efc06@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 05, 2020 at 09:12:56AM +0900, Masami Hiramatsu wrote:
> This may break tools/objtool build. Please keep "inat.h".

How? Please elaborate.

Build tests are fine here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
