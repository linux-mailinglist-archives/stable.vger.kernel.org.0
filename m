Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3013A255841
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 12:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgH1KDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 06:03:37 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.68]:32656 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729045AbgH1KDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 06:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1598609011; i=@ts.fujitsu.com;
        bh=i87hszAIHouezrUX4nSwQs0jo2K5Dqe3/ZD9piaM/20=;
        h=Subject:From:To:References:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=n0TjUYlchdv3nS7rueihD+0Gou+vMlCoRi55Lbs3RXTXf4Dovrr8UCm4J3AL9IEp+
         hPMNn0NA+z3ml98dLQSOqwonLTqbD+kSnSDtpf4Xj/p6kIPGkjKLHafgiQtYocCMOJ
         UlqcC2SYiSf23x73e7cZwmD5y5EEDFpTTuLwiFVtUdC0ZwlwpgY663zMa9etnFJXyT
         K4xKmWMlBaGr+HPDTsYFZo5upo55+JdDrecgMVJDtRR6cxW1+oBllHCVSOMsisIAfs
         ztk05FBPmldFDQib5M3gNdtNkCe/UmGksk6Ak15+NUS7eKsYzBd7CNWN1aganGkIpV
         RNkOqcbG2dC2w==
Received: from [100.112.197.40] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-west-1.aws.symcld.net id 75/C1-16187-376D84F5; Fri, 28 Aug 2020 10:03:31 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRWlGSWpSXmKPExsViZ8MRqlt8zSP
  e4PgleYvu6zvYLJYf/8dksf7IBkaLBRsfMVq0Ln3L5MDq8fHpLRaP9/uusnl83iQXwBzFmpmX
  lF+RwJrR/qWVtWCjUMXxD99ZGxh38nUxcnEICUxmlPh8/wwrhNPPKLHr6Dz2LkZODmGBMIkX3
  z8ygdhsAgYSKybdZwEpEhHYwyjxbUIfVMc6RolVM2+BdfAKOErMedwCVMXBwSKgKrHmkxyIKS
  oQLvFshT9EhaDEyZlPWEBsTgEniQ2/V7CB2MwCZhLzNj9khrDFJW49mc8EYctLbH87h3kCI98
  sJO2zkLTMQtIyC0nLAkaWVYwWSUWZ6RkluYmZObqGBga6hoZGuoaWFrqGFmZ6iVW6SXqppbrl
  qcUluoZ6ieXFesWVuck5KXp5qSWbGIEhnlJwbNcOxrevP+gdYpTkYFIS5bU86REvxJeUn1KZk
  VicEV9UmpNafIhRhoNDSYJ30WWgnGBRanpqRVpmDjDeYNISHDxKIrzlV4DSvMUFibnFmekQqV
  OMuhwvri5exCzEkpeflyolzmsKUiQAUpRRmgc3Ahb7lxhlpYR5GRkYGIR4ClKLcjNLUOVfMYp
  zMCoJ8z4DuYQnM68EbtMroCOYgI6YG+YKckRJIkJKqoEpXz3h+ZOrM+5yG7Xu2Xhv7vb/b8VV
  L2b8bGdr7egO3xGaPkOb6WZCbunpU9535I91KmoFXzduzW1wfl5z/1Tgr237p0Q/cjHM8NWSv
  31n83yd7KN3/nSU1uvq/2MSn7tpfbSqtdOkG3pLhcQmv+Z6unXzsbMz7XYq75b0enk99sz/B2
  UXOKLD1n2foqjY9Ox++fujZfe+CMXLrH0R8USf96Oco7Xm15gvq1YuYXqQcOjg/t3f4mxmsZg
  q7404v8A2SvjDvcaSbyeX/Vt+Peb6FLNY3S1pH49bh+X3Tt+UIziTael/88bVc0NSV+99sUCs
  SP3N0YfvzFyLQ275rfa0blTWOup2oP6EX7qNxIdjEkosxRmJhlrMRcWJAOyF6oF4AwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-3.tower-287.messagelabs.com!1598609010!549738!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 10085 invoked from network); 28 Aug 2020 10:03:31 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-3.tower-287.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 28 Aug 2020 10:03:31 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 07SA3UsK026689;
        Fri, 28 Aug 2020 11:03:30 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 2718E202FF;
        Fri, 28 Aug 2020 12:03:30 +0200 (CEST)
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to
 tcmu_flush_dcache_range
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
 <159114947916.26776.943125808891892721.b4-ty@oracle.com>
 <79f7119f-fda7-64cc-b617-d49a23f2e628@ts.fujitsu.com>
Message-ID: <28862cd1-e7f2-d161-1bab-4d2ff73cf6a1@ts.fujitsu.com>
Date:   Fri, 28 Aug 2020 12:03:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <79f7119f-fda7-64cc-b617-d49a23f2e628@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
I'm adding stable@vger.kernel.org

Once again, this time really adding stable.

On 2020-06-03 04:31, Martin K. Petersen wrote:
> On Thu, 28 May 2020 21:31:08 +0200, Bodo Stroesser wrote:
>
>> 1) If remaining ring space before the end of the ring is
>>      smaller then the next cmd to write, tcmu writes a padding
>>      entry which fills the remaining space at the end of the
>>      ring.
>>      Then tcmu calls tcmu_flush_dcache_range() with the size
>>      of struct tcmu_cmd_entry as data length to flush.
>>      If the space filled by the padding was smaller then
>>      tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
>>      an address range reaching behind the end of the vmalloc'ed
>>      ring.
>>      tcmu_flush_dcache_range() in a loop calls
>>         flush_dcache_page(virt_to_page(start));
>>      for every page being part of the range. On x86 the line is
>>      optimized out by the compiler, as flush_dcache_page() is
>>      empty on x86.
>>      But I assume the above can cause trouble on other
>>      architectures that really have a flush_dcache_page().
>>      For paddings only the header part of an entry is relevant
>>      Due to alignment rules the header always fits in the
>>      remaining space, if padding is needed.
>>      So tcmu_flush_dcache_range() can safely be called with
>>      sizeof(entry->hdr) as the length here.
>>
>> [...]
>
> Applied to 5.8/scsi-queue, thanks!
>
> [1/1] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
>         https://git.kernel.org/mkp/scsi/c/8c4e0f212398
>

The full commit of this patch is:
      8c4e0f212398cdd1eb4310a5981d06a723cdd24f

This patch is the first of four patches that are necessary to run tcmu
on ARM without crash. For details please see
      https://bugzilla.kernel.org/show_bug.cgi?id=208045
Upsteam commits of patches 2,3, and 4 are:
    2: 3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"
    3: 3145550a7f8b "scsi: target: tcmu: Fix crash in 
tcmu_flush_dcache_range on ARM"
    4: 5a0c256d96f0 "scsi: target: tcmu: Fix crash on ARM during cmd 
completion"

Since patches 3 and 4 already were accepted for 5.8, 5.4, and 4.19, and
I sent a request to add patch 2 about 1 hour ago, please consider adding
this patch to 5.4 and 4.19, because without it tcmu on ARM will still
crash.

Thank you,
Bodo

