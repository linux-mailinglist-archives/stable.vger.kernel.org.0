Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A8891A55
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 01:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfHRXzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 19:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfHRXzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 19:55:50 -0400
Received: from localhost (unknown [107.242.116.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBCE52082A;
        Sun, 18 Aug 2019 23:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566172549;
        bh=ywAHqAElHbDHFhP0WMdGwCVmSeXl9rX+JuP03gaeVjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NsDdd2oFS0/4uRQMDSZI1tFi21aUnUAS8WNbi6e9bK5Vr03JUcF22Kehm08mf0kaH
         gjXVpM5nAwA2wmV9e6ordVlBVeTe9zREqN9WpS7ySrDfy3T8lk0+rQD2jY/mXrzA2A
         rAFVNmz0kosaT4uPsBhdRskYgJugWNtCfbJELSy0=
Date:   Sun, 18 Aug 2019 19:55:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
Cc:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.2.10-rc1-61d06c6.cki (stable)
Message-ID: <20190818235546.GA15418@sasha-vm>
References: <cki.8FD44CAC8D.KLM2TF66J1@redhat.com>
 <20190818184900.GE2791@kroah.com>
 <843a068f-9a67-f3a0-cef6-a51f29616705@applied-asynchrony.com>
 <38430602-3b5e-5217-aeae-13fcd82a9c1f@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38430602-3b5e-5217-aeae-13fcd82a9c1f@applied-asynchrony.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 11:57:05PM +0200, Holger Hoffstätte wrote:
>On 8/18/19 10:38 PM, Holger Hoffstätte wrote:
>>On 8/18/19 8:49 PM, Greg KH wrote:
>>>On Sun, Aug 18, 2019 at 02:31:22PM -0400, CKI Project wrote:
>>>>
>>>>Hello,
>>>>
>>>>We ran automated tests on a recent commit from this kernel tree:
>>>>
>>>>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>>>             Commit: 61d06c60569f - Linux 5.2.10-rc1
>>>>
>>>>The results of these automated tests are provided below.
>>>>
>>>>     Overall result: FAILED (see details below)
>>>>              Merge: OK
>>>>            Compile: OK
>>>>              Tests: FAILED
>>>>
>>>>All kernel binaries, config files, and logs are available for download here:
>>>>
>>>>   https://artifacts.cki-project.org/pipelines/108998
>>>>
>>>>
>>>>
>>>>One or more kernel tests failed:
>>>>
>>>>   aarch64:
>>>>     ❌ Boot test
>>>>     ❌ Boot test
>>>>
>>>>   ppc64le:
>>>>     ❌ Boot test
>>>>     ❌ Boot test
>>>>
>>>>   x86_64:
>>>>     ❌ Boot test
>>>>     ❌ Boot test
>>>>
>>>
>>>Are these all real?
>>>
>>
>>Hi Greg,
>>
>>the current 5.2-queue also fails to boot for me when applied to 5.2.9,
>>so this is not a false positive. I had a handful of the queued patches in my
>>own tree and know which ones work in 5.2.9, but the new ones for -mm look
>>like they could cause problems. I'll try a few things..
>
>The culprit is "exit-make-setting-exit_state-consistent.patch", which was
>successfully added everywhere. This explains why KCI is consistently sad
>everywhere, too. :)
>
>Removing that patch from the queue results in a working kernel (with the
>version updated by me):
>
>$cat /proc/version
>Linux version 5.2.10 (root@ragnarok) (gcc version 9.2.0 (Gentoo 9.2.0 p1)) #1 SMP Sun Aug 18 23:50:50 CEST 2019

Are you seeing the same failure with upstream kernel?

--
Thanks,
Sasha
