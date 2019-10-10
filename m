Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26778D3462
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 01:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfJJXcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 19:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbfJJXcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 19:32:55 -0400
Received: from localhost (unknown [131.107.174.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D9B20B7C;
        Thu, 10 Oct 2019 23:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570750374;
        bh=KRCPJlJhWjHuztpYIBRMiPsZRR2NVPVkumUYRq8JVHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AywgrSp6EqiAXSIoqsvT5tF9H83nvlRDj4Tgxb7U6c8o2P7KLBH//KgvnQOVwVQQ5
         dQo6/ZAxguheD8qN4spE0QxENwCz21Gq+umSoGM6R41JfoQ2RcCLji5dBVxt1fk5qE
         nfvzJMbrBy7iNegnxuWOLlR3hnE44hUzBWD7EVlg=
Date:   Thu, 10 Oct 2019 19:32:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "niveditas98 ." <nivedita@alum.mit.edu>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 5.3 111/148] x86/purgatory: Disable the stackleak GCC
 plugin for the purgatory
Message-ID: <20191010233254.GA2635@sasha-vm>
References: <20191010083609.660878383@linuxfoundation.org>
 <20191010083617.862786246@linuxfoundation.org>
 <BYAPR04MB62468F03E52BCE23B5CD1C91AA940@BYAPR04MB6246.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <BYAPR04MB62468F03E52BCE23B5CD1C91AA940@BYAPR04MB6246.namprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 04:22:20PM +0000, niveditas98 . wrote:
>Is it applied to 5.2 as well? Only saw mails for 4.19 and 5.3.

5.2 is EOL.

-- 
Thanks,
Sasha
