Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7AEE6DBF
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 09:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbfJ1ICY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 04:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730328AbfJ1ICY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 04:02:24 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47DB120862;
        Mon, 28 Oct 2019 08:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572249743;
        bh=KuLjpqvbGMtLUlNc5kaoR6YIjcyREiGv1q4fu5cS1Ak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G0s2Mz00gd0TJaorDXv098tL6oibTl1MVsC5aqs1AmlXJ2/v5v2aMW92DdobIt2vH
         8iwPoE63nv6SkXiWQf+ARi4Nzym8RMF5TM26GsvGCmxLalkZNuQbWULECL/kcPCAYK
         cBhUL+esadSCp39Vvt1uiALdImM8eQOKF6Il7wfQ=
Date:   Mon, 28 Oct 2019 04:02:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH] KVM: vmx, svm: always run with EFER.NXE=1 when shadow
 paging is active
Message-ID: <20191028080220.GH1560@sasha-vm>
References: <20191027152323.24326-1-pbonzini@redhat.com>
 <20191028065919.AB8C3208C0@mail.kernel.org>
 <b08a0103-312e-5441-9ffe-33c9df0a9d57@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b08a0103-312e-5441-9ffe-33c9df0a9d57@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 08:56:26AM +0100, Paolo Bonzini wrote:
>On 28/10/19 07:59, Sasha Levin wrote:
>>
>> This commit has been processed because it contains a -stable tag.
>> The stable tag indicates that it's relevant for the following trees: all
>>
>> The bot has tested the following trees: v5.3.7, v4.19.80, v4.14.150, v4.9.197, v4.4.197.
>>
>> v5.3.7: Build OK!
>> v4.19.80: Failed to apply! Possible dependencies:
>>     Unable to calculate
>>
>> v4.14.150: Failed to apply! Possible dependencies:
>>     Unable to calculate
>>
>> v4.9.197: Failed to apply! Possible dependencies:
>>     Unable to calculate
>>
>> v4.4.197: Failed to apply! Possible dependencies:
>>     Unable to calculate
>>
>>
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>> How should we proceed with this patch?
>
>It should apply just fine to all branches, just to arch/x86/kvm/vmx.c
>instead of arch/x86/kvm/vmx/vmx.c.

I wonder if we should be carrying symlinks in the stable branches to
make this smoother...

-- 
Thanks,
Sasha
