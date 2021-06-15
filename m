Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC3F3A77A9
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 09:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhFOHK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 03:10:59 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:48788 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbhFOHK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 03:10:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623740934; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=EtAuY/3kFrqRfZW6M+zem1Jnb8BC7p5CDItF2TePigc=; b=V9BsN6n77iVMi4b5XAM/LT7ycTBqdZ5Czf37Hh/oNNYgFg0S2bPqiiZFo8UkaxNB9DlCJGFk
 dUkmQdpoik0jrjst/RxIyOQY9GOD5/K15qJ2i6UvqTz7B8fb45G/htA6TBcbVx6ePrHDdZAu
 3ZuwVQuiTdYXEphJ8TJGyO3xX+c=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60c851c8ed59bf69cc96fb60 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 07:07:52
 GMT
Sender: jackp=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A8692C433F1; Tue, 15 Jun 2021 07:07:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 19AFAC433F1;
        Tue, 15 Jun 2021 07:07:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 19AFAC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jackp@codeaurora.org
Date:   Tue, 15 Jun 2021 00:07:47 -0700
From:   Jack Pham <jackp@codeaurora.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-usb@vger.kernel.org,
        Peter Chen <peter.chen@kernel.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: Re: [PATCH 5.10 000/130] 5.10.44-rc2 review
Message-ID: <20210615070747.GB31646@jackp-linux.qualcomm.com>
References: <20210614161424.091266895@linuxfoundation.org>
 <CA+G9fYsfvtr7NNcb0bvEZpYYotdY7Uf+wMY22iLhr0weZ8Om3g@mail.gmail.com>
 <YMhDPjbfTFpUtTs3@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMhDPjbfTFpUtTs3@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jun 15, 2021 at 08:05:50AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 15, 2021 at 09:41:26AM +0530, Naresh Kamboju wrote:
> > On Mon, 14 Jun 2021 at 21:45, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.10.44 release.
> > > There are 130 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > The following kernel crash reported on stable rc 5.10.44-rc2 arm64 db845c board.
> > 
> > [    5.127966] dwc3-qcom a6f8800.usb: failed to get usb-ddr path: -517

Looks like -EPROBE_DEFER happened here due to a not-yet-probed
dependency (interconnect driver).  This leads to dwc3_qcom_probe()
unwinding and calling of_platform_depopulate() which triggers the
"child" dwc3's driver remove callback dwc3_remove()...

> > [    5.145567] Unable to handle kernel NULL pointer dereference at
> > virtual address 0000000000000002
> > [    5.154451] Mem abort info:
> > [    5.157296]   ESR = 0x96000004
> > [    5.160401]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [    5.165771]   SET = 0, FnV = 0
> > [    5.168873]   EA = 0, S1PTW = 0
> > [    5.172064] Data abort info:
> > [    5.174980]   ISV = 0, ISS = 0x00000004
> > [    5.178860]   CM = 0, WnR = 0
> > [    5.181872] [0000000000000002] user address but active_mm is swapper
> > [    5.188293] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> > [    5.193922] Modules linked in:
> > [    5.197022] CPU: 4 PID: 57 Comm: kworker/4:3 Not tainted 5.10.44-rc2 #1
> > [    5.203697] Hardware name: Thundercomm Dragonboard 845c (DT)
> > [    5.204022] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX,
> > TX]: gear=[3, 3], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
> > [    5.209434] Workqueue: events deferred_probe_work_func
> > [    5.221786] ufshcd-qcom 1d84000.ufshc:
> > ufshcd_find_max_sup_active_icc_level: Regulator capability was not
> > set, actvIccLevel=0
> > [    5.226541] pstate: 60c00005 (nZCv daif +PAN +UAO -TCO BTYPE=--)
> > [    5.226551] pc : inode_permission+0x2c/0x178
> > [    5.226559] lr : lookup_one_len_common+0xac/0x100
> > 
> > ref:
> > https://lkft.validation.linaro.org/scheduler/job/2899138#L2873
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > There is a crash like this reported and discussed on the mailing thread.
> > https://lore.kernel.org/linux-usb/20210608105656.10795-1-peter.chen@kernel.org/
> 
> Is this crash just on shutdown?  That's what that commit was fixing, but
> it is resolving an error that should not be in the 5.10.y tree.

Peter reported and fixed it based on reproducing the crash from shutting
down but in my manual testing I found that it could be triggered any
time dwc3_remove() is called, though I surmised it would be a rare
occurence.  In this particular case however Naresh is reporting it is
triggered even during bootup since dwc3-qcom would add its
dwc3 child, but because it encounters a probe deferral it has to
subsequently trigger the dwc3 driver remove callback right after it was
just probed.

So I think it would be good if Peter's follow-up change
(2a042767814b in your usb-next branch) can please go into stable as well
as it should help not only for the shutdown/reboot case.  Otherwise,
my change "usb: dwc3: debugfs: Add and remove endpoint dirs
dynamically" could be simply be dropped until they can go in together.

Thanks,
Jack
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
