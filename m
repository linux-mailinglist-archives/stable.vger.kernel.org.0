Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0403F1ADEBD
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 15:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgDQNud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 09:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730709AbgDQNuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 09:50:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B09FE2087E;
        Fri, 17 Apr 2020 13:50:30 +0000 (UTC)
Date:   Fri, 17 Apr 2020 09:50:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Sasha Levin <sashal@kernel.org>,
        rcu@vger.kernel.org, lkft-triage@lists.linaro.org,
        Anders Roxell <anders.roxell@linaro.org>, zanussi@kernel.org,
        svens@linux.ibm.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: WARNING: events/ipi.h:36 suspicious rcu_dereference_check()
 usage!
Message-ID: <20200417095028.25a64f58@gandalf.local.home>
In-Reply-To: <20200417071543.GA7316@leoy-ThinkPad-X240s>
References: <CA+G9fYtYRc_mKPDN-Gryw7fhjPNGBUP=KemTXaXR6UBU94M3hw@mail.gmail.com>
        <CAA93ih2To3YN=L7VSa_RzVRV5OH9DTffd0zdKWB2M4CfE0Gp1Q@mail.gmail.com>
        <20200417071543.GA7316@leoy-ThinkPad-X240s>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 17 Apr 2020 15:15:43 +0800
Leo Yan <leo.yan@linaro.org> wrote:

> Good analysis, Masami :)

Agreed. Nice work Masami!

> 
> Seems to me, Arm64 should study Arm platform to change using
> trace_ipi_raise_rcuidle() to work around the restriction so can allow the
> event to work in idle context?

Also agree. Looks to need the rcuidle() variant.

-- Steve
