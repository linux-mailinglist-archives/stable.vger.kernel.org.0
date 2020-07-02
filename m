Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3471B212BB8
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgGBR5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 13:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgGBR5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 13:57:00 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8E920737;
        Thu,  2 Jul 2020 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593712620;
        bh=gPpRcC4CdQ88jJY9dj57H/apFCeRb675Ti/VODDaRXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jd0uS7qtE7nqBf05fXlE7p8yjBMKrtDsu54ogESdTpy867Hj0ugYZcgp18M5jrdaC
         gtUbF37JYKpwla7JZ7bA2C/ZmjPfnhKD+PGN1gEZeEm+ry8ur0/xVFUfXewexLkr4V
         eo7Ra2qJkYxdgKz7TPOngistTXE/+uz2sTLm8i74=
Date:   Thu, 2 Jul 2020 13:56:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        lists@colorremedies.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: fix swap cache node allocation mask"
 failed to apply to 5.7-stable tree
Message-ID: <20200702175659.GD2722994@sasha-vm>
References: <1593429751245129@kroah.com>
 <alpine.LSU.2.11.2006291132520.3798@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2006291132520.3798@eggly.anvils>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 11:35:03AM -0700, Hugh Dickins wrote:
>On Mon, 29 Jun 2020, gregkh@linuxfoundation.org wrote:
>
>>
>> The patch below does not apply to the 5.7-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>------------------ Please use the below for both v5.7 and v5.4

Thanks for the backports Hugh, all are now queued up.

-- 
Thanks,
Sasha
