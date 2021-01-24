Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40C1301C01
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbhAXNME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:12:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbhAXNMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 08:12:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B634522ADC;
        Sun, 24 Jan 2021 13:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611493883;
        bh=eQ88PvupuioCNW7tkGGhAMMpSfJ8kHhHjNZWNJQTuKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AlFpSiGSBozQ1MSnPObM9Ji5GyJORj9/cG24SRXZQddU5koRJpijMM2GVd2W6rHdr
         DogO261pf3bQq0RkFLVv3K7Nxvh2X89x5w0mVlg8KSCQ3TG4F4kTq81fQC7AWS2Gnc
         VjVq5FuP3AVjQC0BT13xl2JonigKb4CKXu9lJ4jHFDzT+ky91muj093De5cZ8VuYgk
         mVLR/uRFFeWf6cIXYKEAXVzT6ksxHrvLo8L2VmSSaGn8KToz2trRIgtlka2RckkXtW
         9sLEYdvWUjFhJX2L1uXNddorp0drsQpZh3y74X0eIFlhhWl1XWccHXiB8FiUZd7g2s
         6zKbaUAhve/4A==
Date:   Sun, 24 Jan 2021 08:11:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH AUTOSEL 5.10 26/45] x86/xen: Fix xen_hvm_smp_init() when
 vector callback not available
Message-ID: <20210124131121.GG4035784@sasha-vm>
References: <20210120012602.769683-1-sashal@kernel.org>
 <20210120012602.769683-26-sashal@kernel.org>
 <86c0baa1-f8c5-2580-6ee9-efc7043c2bf5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <86c0baa1-f8c5-2580-6ee9-efc7043c2bf5@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 08:35:04PM -0500, Boris Ostrovsky wrote:
>
>On 1/19/21 8:25 PM, Sasha Levin wrote:
>> From: David Woodhouse <dwmw@amazon.co.uk>
>>
>> [ Upstream commit 3d7746bea92530e8695258a3cf3ddec7a135edd6 ]
>
>
>Sasha, you will also want https://lore.kernel.org/lkml/20210115191123.27572-1-rdunlap@infradead.org/, it is sitting in Xen staging tree.

I'll grab it too, thanks!

-- 
Thanks,
Sasha
