Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF6B298A31
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769413AbgJZKPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:15:17 -0400
Received: from valentin-vidic.from.hr ([94.229.67.141]:45739 "EHLO
        valentin-vidic.from.hr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1768367AbgJZJr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 05:47:28 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 05:47:27 EDT
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 42CF54120; Mon, 26 Oct 2020 10:39:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=valentin-vidic.from.hr; s=2020; t=1603705171;
        bh=znD6lkVbNfaZ0zHkzgIp3Fv73O/9JQfUXlbCJcyIaGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jB2ueFf2TKMpESFXED2YuWdxOoV69/E6BpmF/FpXjM7LKuA1529+add4yyXJjslAD
         kK64hSpDvrpBmxKVsuBLS8RRl0Pw1JmGLhZruobAm4ShyfW4n9w/3V6R0ywDgY1I1P
         hQp5rPvtFvLx9q60kZlqZALfwBkh2VbuXRdxaTdNblfPge8rbogVBIf9PthD2Pw/PV
         6a8dSx3RbVMBj/uUtxSWaMsXRoB25mf61GUv6yzZiPArKCkxBl6/se4jK/urD+dJRH
         SDEBPbDmc515m587rQWCBJKMgd9QG4zjgJH4OtevoSkb3fYYoopYA0cMj1IyCzoPh0
         kr9YkGb/t9ucwdBTd1jsWtaThsPtamrxCbI0VT0+7tlNZHGMm7NtB6LFZum6Ge7VQG
         PqJCfCJsP75zrNmZtoSsf7HMHsUD46T1y+1OJXXlZG3RG07twp7+cMjeBmgIwrmTT0
         XGsW26bf96obtUVFXpHevy+XYDaz85qGNCfXb3aOMq2BxFJ1oIHujckbRT0oHeDT/i
         xqv2Vh5fYHJT6LHoklquEcrGHFcNpZ1DWnLplB25Wq4zBU0zE4oIbTE7QxLoFU4SAj
         hex1o2jA532z2cmlFg+jbQWOQD69pk5W+7f/CvHY0a0QYnlXG2rL2e5Az0IZ8LeUjQ
         RPXVxpfa+AkHQKV78m3//ZZA=
Date:   Mon, 26 Oct 2020 10:39:31 +0100
From:   Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: Patch "net: korina: fix kfree of rx/tx descriptor array" has
 been added to the 4.4-stable tree
Message-ID: <20201026093931.GE29903@valentin-vidic.from.hr>
References: <20201026055650.4235D2222C@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026055650.4235D2222C@mail.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 01:56:49AM -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     net: korina: fix kfree of rx/tx descriptor array
> 
> to the 4.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      net-korina-fix-kfree-of-rx-tx-descriptor-array.patch
> and it can be found in the queue-4.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

A followup patch is probably required with this one:

commit 3bd57b90554b4bb82dce638e0668ef9dc95d3e96
net: korina: cast KSEG0 address to pointer in kfree

Fixes gcc warning:

passing argument 1 of 'kfree' makes pointer from integer without a cast

Fixes: 3af5f0f ("net: korina: fix kfree of rx/tx descriptor array")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Link: https://lore.kernel.org/r/20201018184255.28989-1-vvidic@valentin-vidic.from.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

-- 
Valentin
