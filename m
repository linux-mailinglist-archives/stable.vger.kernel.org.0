Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005F9FA026
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKMBa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:30:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfKMBa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:30:28 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54BEC222CE;
        Wed, 13 Nov 2019 01:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573608627;
        bh=6A6kbeJRQUdIpb0UL6yB/6+57iQ0+YlQbszsDcrCses=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2A1K3QFkYVoGRcdTRXGTlXPSxTvFRpSPVMIcMOnFA4px5/tGc9/VcsosvJT+fKc9l
         Fga1T2tp8F/sNYoB2DZQqa1KEiGtno2kNHiEIFYff/Nn00oYfbJHHB+ILVHj9T6rvj
         f1y6A5cs7KQNR249udiCUb+1ViRfYsubgHZqQH1M=
Date:   Tue, 12 Nov 2019 20:30:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jeffrin Jose <jeffrin@rajagiritech.edu.in>
Cc:     akpm@linux-foundation.org, oleg@redhat.com, christian@brauner.io,
        tj@kernel.org, peterz@infradead.org, prsood@codeaurora.org,
        avagin@gmail.com, aarcange@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: PROBLEM: objtool: __x64_sys_exit_group()+0x14: unreachable
 instruction
Message-ID: <20191113013026.GO8496@sasha-vm>
References: <20191112223300.GA17891@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191112223300.GA17891@debian>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 04:03:00AM +0530, Jeffrin Jose wrote:
>hello all,
>
>i found a warning during kernel build (5.3.11-rc1+).
>-----------------x----------x-----------------
>kernel/exit.o: warning: objtool: __x64_sys_exit_group()+0x14: unreachable instruction
>-------------------x---------------x-----------

Could you bisect it please? I'm not seeing the warning here, and
kernel/exit.c wasn't touched during the life of the 5.3 stable tree.

-- 
Thanks,
Sasha
