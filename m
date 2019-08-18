Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2FF9199A
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 22:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHRU46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 16:56:58 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:54148 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfHRU46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 16:56:58 -0400
Received: from tux.wizards.de (pD9EBF359.dip0.t-ipconnect.de [217.235.243.89])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 86F7441634F5;
        Sun, 18 Aug 2019 22:56:56 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 40F63F015AA;
        Sun, 18 Aug 2019 22:38:07 +0200 (CEST)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e2=2e10?=
 =?UTF-8?Q?-rc1-61d06c6=2ecki_=28stable=29?=
To:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
References: <cki.8FD44CAC8D.KLM2TF66J1@redhat.com>
 <20190818184900.GE2791@kroah.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <843a068f-9a67-f3a0-cef6-a51f29616705@applied-asynchrony.com>
Date:   Sun, 18 Aug 2019 22:38:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190818184900.GE2791@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/19 8:49 PM, Greg KH wrote:
> On Sun, Aug 18, 2019 at 02:31:22PM -0400, CKI Project wrote:
>>
>> Hello,
>>
>> We ran automated tests on a recent commit from this kernel tree:
>>
>>         Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>              Commit: 61d06c60569f - Linux 5.2.10-rc1
>>
>> The results of these automated tests are provided below.
>>
>>      Overall result: FAILED (see details below)
>>               Merge: OK
>>             Compile: OK
>>               Tests: FAILED
>>
>> All kernel binaries, config files, and logs are available for download here:
>>
>>    https://artifacts.cki-project.org/pipelines/108998
>>
>>
>>
>> One or more kernel tests failed:
>>
>>    aarch64:
>>      ❌ Boot test
>>      ❌ Boot test
>>
>>    ppc64le:
>>      ❌ Boot test
>>      ❌ Boot test
>>
>>    x86_64:
>>      ❌ Boot test
>>      ❌ Boot test
>>
> 
> Are these all real?
> 

Hi Greg,

the current 5.2-queue also fails to boot for me when applied to 5.2.9,
so this is not a false positive. I had a handful of the queued patches in my
own tree and know which ones work in 5.2.9, but the new ones for -mm look
like they could cause problems. I'll try a few things..

-h
