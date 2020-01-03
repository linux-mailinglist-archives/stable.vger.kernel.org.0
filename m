Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87AE912F43E
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 06:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgACF3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 00:29:02 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:43155 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725928AbgACF3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 00:29:02 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578029341; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=QGQ3D1GyNhd0LAoBVLxbTbXL6/9pOn4Pwzlj2/BukcY=;
 b=oxebzTLgZP9G6nl8Dx2hE0b3ch/Lh5ga69ChYyRMvNIPEl17ALMdC5cvWgFwqGhuO8F2sFTV
 VrW23NQxQW2sc0lx64efwnXq8lhslIKN8C7IuM3sOCjVWkBk9Q7rlu9R1BOveozZllvqBE1P
 7/ZExnRqa5+lTZmYvV+0TAecRHY=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e0ed11b.7fbab6fd77a0-smtp-out-n01;
 Fri, 03 Jan 2020 05:28:59 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C551EC447A5; Fri,  3 Jan 2020 05:28:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7B4A2C433CB;
        Fri,  3 Jan 2020 05:28:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 03 Jan 2020 13:28:58 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        andy.teng@mediatek.com, jejb@linux.ibm.com,
        chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        asutoshd@codeaurora.org, avri.altman@wdc.com,
        linux-mediatek@lists.infradead.org, peter.wang@mediatek.com,
        linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org,
        alim.akhtar@samsung.com, beanhuo@micron.com,
        pedrom.sousa@synopsys.com, bvanassche@acm.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        ron.hsu@mediatek.com, cc.chou@mediatek.com
Subject: Re: [PATCH v1 1/2] scsi: ufs: set device as default active power mode
 during initialization only
In-Reply-To: <4888afd46a9065b7f298a5de039426c9@codeaurora.org>
References: <1577693546-7598-1-git-send-email-stanley.chu@mediatek.com>
 <1577693546-7598-2-git-send-email-stanley.chu@mediatek.com>
 <fd129b859c013852bd80f60a36425757@codeaurora.org>
 <1577754469.13164.5.camel@mtkswgap22>
 <836772092daffd8283a97d633e59fc34@codeaurora.org>
 <1577766179.13164.24.camel@mtkswgap22>
 <1577778290.13164.45.camel@mtkswgap22>
 <44393ed9ff3ba9878bae838307e7eec0@codeaurora.org>
 <1577947124.13164.75.camel@mtkswgap22>
 <4888afd46a9065b7f298a5de039426c9@codeaurora.org>
Message-ID: <e13011fd858cf3ec0258c4b7ac914973@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-01-03 09:51, Can Guo wrote:
> On 2020-01-02 14:38, Stanley Chu wrote:
>> Hi Can,
>> 
>> On Tue, 2019-12-31 at 16:35 +0800, Can Guo wrote:
>> 
>>> Hi Stanley,
>>> 
>>> I missed this mail before I hit send. In current code, as per my
>>> understanding,
>>> UFS device's power state should be Active after ufshcd_link_startup()
>>> returns.
>>> If I am wrong, please feel free to correct me.
>>> 
>> 
>> Yes, this assumption of ufshcd_probe_hba() is true so I will drop this
>> patch.
>> Thanks for remind.
>> 
>>> Due to you are almost trying to revert commit 7caf489b99a42a, I am 
>>> just
>>> wondering
>>> if you encounter failure/error caused by it.
>> 
>> Yes, we actually have some doubts from the commit message of "scsi: 
>> ufs:
>> issue link startup 2 times if device isn't active"
>> 
>> If we configured system suspend as device=PowerDown/Link=LinkDown 
>> mode,
>> during resume, the 1st link startup will be successful, and after that
>> device could be accessed normally so it shall be already in Active 
>> power
>> mode. We did not find devices which need twice linkup for normal work.
>> 
>> And because the 1st linkup is OK, the forced 2nd linkup by commit 
>> "scsi:
>> ufs: issue link startup 2 times if device isn't active" leads to link
>> lost and finally the 3rd linkup is made again by retry mechanism in
>> ufshcd_link_startup() and be successful. So a linkup performance issue
>> is introduced here: We actually need one-time linkup only but finally
>> got 3 linkup operations.
>> 
>> According to the UFS spec, all reset types (including POR and Host
>> UniPro Warm Reset which both may happen in above configurations) other
>> than LU reset, UFS device power mode shall return to Sleep mode or
>> Active mode depending on bInitPowerMode, by default, it's Active mode.
>> 
>> So we are curious that why enforcing twice linkup is necessary here?
>> Could you kindly help us clarify this?
>> 
>> If anything wrong in above description, please feel free to correct 
>> me.
>> 
> 
> Hi Stanley,
> 
> Above description is correct. The reason why the UFS device becomes
> Active after the 1st link startup in your experiment is due to you
> set spm_lvl to 5, during system suspend, UFS device is powered down.
> When resume kicks start, the UFS device is power cycled once.
> 
> Moreover, if you set rpm_lvl to 5, during runtime suspend, if bkops is
> enabled, the UFS device will not be powered off, meaning when runtime
> resume kicks start, the UFS device is not power cycled, in this case,
> we need 3 times of link startup.
> 
> Does above explain?
> 
> Thanks,
> 
> Can Guo.
> 

Hi Stanley,

Sorry, typo before. I meant if set rpm_lvl/spm_lvl to 5, during suspend,
if is_lu_power_on_wp is set, the UFS device will not be fully powered 
off
(only VCC is down), meaning when resume kicks start, the UFS device is 
not
power cycled, in this case, we need 3 times of link startup.

Regards,

Can Guo.

>>> 
>>> Happy new year to you too!
>>> 
>>> Thanks,
>>> 
>>> Can Guo
>> 
>> Thanks,
>> 
>> Stanley
>> 
>>> 
>>> _______________________________________________
>>> Linux-mediatek mailing list
>>> Linux-mediatek@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-mediatek
