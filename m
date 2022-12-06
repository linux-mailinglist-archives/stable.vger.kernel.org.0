Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EC4643FCA
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiLFJZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiLFJYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:24:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6011FFB9;
        Tue,  6 Dec 2022 01:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670318609; x=1701854609;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oPcLXIVOc+GFeFSkqSIyhWQJfGtxDDGC65jp3SUfUnA=;
  b=UeTBsujFM2gUc2fa8xAvJEKZFBLXsArOFWi7X89x8gQSGBWFpsL79KEA
   DzDZNIULkwnxSB2K4FNReRqbP9fyEJ8HpjBH12OBtzSoxMQVyYaLZSSY0
   dfjIa1w1/vshE+G80mj+806swe1WcTskqPn+sDYRgYPBtU9hNimZA8VkU
   Ibvizso3V/JUb9K6ualMV/THKaUZqPuIjF5sOyW6rnMJpHlwqXBF7U+dK
   SBgnw4V75rdKdAqWOPm2pANjsr+1zDAHH9EQayKJn/0fDx93Kh4ImjJuK
   /5sFbwcq3wzefdCcf9fJNzbXE3wh1kwgVpRdqozjENSXUX5CO97BxooXG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="300001067"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="300001067"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 01:23:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="714733236"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="714733236"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.38.78])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 01:23:19 -0800
Message-ID: <77fff5aa-ddd2-6bc7-f0b4-46b93e87338b@intel.com>
Date:   Tue, 6 Dec 2022 11:23:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH 4.9 00/62] 4.9.335-rc1 review
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190758.073114639@linuxfoundation.org>
 <80305ea1-4d52-b1d3-e078-3c1084d96cc7@nvidia.com>
 <2bb37989-7c22-ae06-6568-8419ce57e44b@gmail.com>
 <e00f6e66-fd51-5b55-6cd1-ec9abe038022@gmail.com>
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <e00f6e66-fd51-5b55-6cd1-ec9abe038022@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/12/22 02:11, Florian Fainelli wrote:
> On 12/5/22 14:48, Florian Fainelli wrote:
>> On 12/5/22 14:28, Jon Hunter wrote:
>>> Hi Greg,
>>>
>>> On 05/12/2022 19:08, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 4.9.335 release.
>>>> There are 62 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
>>>> or in the git tree and branch at:
>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>> -------------
>>>> Pseudo-Shortlog of commits:
>>>>
>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>      Linux 4.9.335-rc1
>>>>
>>>> Adrian Hunter <adrian.hunter@intel.com>
>>>>      mmc: sdhci: Fix voltage switch delay
>>>
>>>
>>> I am seeing a boot regression on a couple boards and bisect is pointing to the above commit.
>>
>> Same thing here, getting a hard lock for our devices with the SDHCI controller enabled, sometimes we are lucky to see the following:
>>
>> [    4.790367] mmc0: SDHCI controller on 84b0000.sdhci [84b0000.sdhci] using ADMA 64-bit
>> [   25.802351] INFO: rcu_sched detected stalls on CPUs/tasks:
>> [   25.807871]  1-...: (1 GPs behind) idle=561/140000000000000/0 softirq=728/728 fqs=5252
>> [   25.815892]  (detected by 0, t=21017 jiffies, g=61, c=60, q=55)
>> [   25.821834] Task dump for CPU 1:
>> [   25.825069] kworker/1:1     R  running task        0   509      2 0x00000002
>> [   25.832164] Workqueue: events_freezable mmc_rescan
>> [   25.836974] Backtrace:
>> [   25.839440] [<ce32fea4>] (0xce32fea4) from [<ce32fed4>] (0xce32fed4)
>> [   25.845803] Backtrace aborted due to bad frame pointer <cd2f0a54>
>>
>> Also confirmed that reverting that change ("mmc: sdhci: Fix voltage switch delay") allows devices to boot properly.
>>
>> Had not a chance to test the change when submitted for mainline despite being copied, sorry about that.
>>
>> Since that specific commit is also included in the other stable trees (5.4, 5.10, 5.15 and 6.0) I will let you know whether the same issue is present in those trees shortly thereafter.
> 
> This only appears to impact 4.9, Adrian is there a missing functional dependency for "mmc: sdhci: Fix voltage switch delay" to work correctly on the 4.9 kernel?

The thing that leaps to mind is that "mmc: sdhci: Fix voltage switch delay" returns out of sdhci_set_ios() without releasing the spinlock which was removed in later kernels.  I expect below would help, but a revert might allow a more considered response - it is a holiday here today.


diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index cfd665f0d6db..f3e2aba53ffa 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1684,7 +1684,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	    host->timing == ios->timing &&
 	    host->version >= SDHCI_SPEC_300 &&
 	    !sdhci_presetable_values_change(host, ios))
-		return;
+		goto out;
 
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
@@ -1773,7 +1773,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->ops->set_clock(host, host->clock);
 	} else
 		sdhci_writeb(host, ctrl, SDHCI_HOST_CONTROL);
-
+out:
 	/*
 	 * Some (ENE) controllers go apeshit on some ios operation,
 	 * signalling timeout and CRC errors even on CMD0. Resetting

