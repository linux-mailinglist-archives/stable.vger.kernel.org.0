Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B0E1CFE76
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 21:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgELTiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 15:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgELTiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 15:38:13 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B39B20731;
        Tue, 12 May 2020 19:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589312292;
        bh=YtJ9NOV1BLiJ9/JmIl/bQxeEUSpa9JJgLlMjrMIIH64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDOKDC74LNBMvmsB5037lwCHtJMWnmNG9Yn4d0B/MMqTDYj/G0VYuzwf/YFsdanA4
         ZsPvvtKJATGzSDqOZ5ZcoGYH3hLpj62lyP5Nn+RjOZEvOxmChBrqcZ8uqZ2Dy8G8Gt
         sgLjkdTw5I4N+ljki32YmYk11XdWIyERfso/Mt0g=
Date:   Tue, 12 May 2020 15:38:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     Li Wang <liwan@redhat.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        skt-results-master@redhat.com, Ondrej Moris <omoris@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: =?utf-8?Q?=E2=9D=8C_FAIL=3A_Waiting_fo?= =?utf-8?Q?r?= review:
 Test report for kernel 5.6.12-c4bbda2.cki (stable)
Message-ID: <20200512193810.GT13035@sasha-vm>
References: <cki.9933286682.FRYDQE9CQT@redhat.com>
 <CAEemH2cAxJy1GtmhjH8S2F_96E19FkUo-gUEnoTL=YG6taJ1qQ@mail.gmail.com>
 <fb1cfaac-bdb9-4daf-4ddf-acb97bd33338@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb1cfaac-bdb9-4daf-4ddf-acb97bd33338@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 12:40:53PM -0400, Rachel Sibley wrote:
>Thanks Li, cc'ing stable ML so they're aware.
>
>On 5/12/20 6:24 AM, Li Wang wrote:
>>
>>
>>On Tue, May 12, 2020 at 4:48 PM CKI Project <cki-project@redhat.com <mailto:cki-project@redhat.com>> wrote:
>>
>>
>>    ┌───────────────────────────────────────────────────────────────┐
>>    │ REVIEW REQUIRED FOR FAILED TEST                               │
>>    ├───────────────────────────────────────────────────────────────┤
>>    │ This failed kernel test has been held for review by kernel    │
>>    │ test maintainers and the CKI team. Please investigate using   │
>>    │ the pipeline link below this box.                             │
>>    │                                                               │
>>    │ If the test failure is related to a non-kernel bug, no action │
>>    │ is needed. If a kernel bug is found, please reply all with    │
>>    │ your assessment and we will release the report.               │
>>    │ For more details: https://docs.engineering.redhat.com/x/eG5qB │
>>    └───────────────────────────────────────────────────────────────┘
>>
>>    Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pipeline/pipelines/563063
>>
>>    Check out if the issue is autotriaged in the dashboard:
>>    https://datawarehouse-webservice-ark.cloud.paas.psi.redhat.com/pipeline/563063
>>
>>    Hello,
>>
>>    We ran automated tests on a recent commit from this kernel tree:
>>
>>            Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>                 Commit: c4bbda210077 - Linux 5.6.12
>>
>>    The results of these automated tests are provided below.
>>
>>         Overall result: FAILED (see details below)
>>                  Merge: OK
>>                Compile: OK
>>                  Tests: FAILED
>>
>>    All kernel binaries, config files, and logs are available for download here:
>>
>>    https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/05/11/563063
>>
>>    One or more kernel tests failed:
>>
>>         aarch64:
>>          ❌ LTP
>>
>>
>>fanotify09Bug 1832099 - fanotify: fix merging marks masks with FAN_ONDIR
>>
>>fanotify15 failure is also a kernel bug in fedora.
>>which has been fix in mainline: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f367a62a7cad
>>$ git describe --contains f367a62a7cad
>>v5.7-rc1~72^2~10

I've queued up these two patches:

	f367a62a7cad ("fanotify: merge duplicate events on parent and child")
	dfc2d2594e4a ("fsnotify: replace inode pointer with an object id")

for 5.6 and 5.4, thanks!

-- 
Thanks,
Sasha
