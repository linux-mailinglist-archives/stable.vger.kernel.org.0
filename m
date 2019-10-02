Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24BB7C44BB
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 02:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbfJBAEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 20:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729423AbfJBAEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 20:04:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57FB021920;
        Wed,  2 Oct 2019 00:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569974687;
        bh=LFqlugi476YN/XdJ0OWG4/l0Q4QhhNuB0mawB6AaS9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hO8YDocMfq+8jJfU8ERkDBDlXvKlfSW21v5p0jbiDFiwd7kPK2+OtEaWrRK7CcMNO
         mKR93UFpDHj5gMbAUaBtlemz75IU01NgqmY65HyLGTUvy6FR/5GXaifDlhCRndUeyE
         mWq5nT0LvX2Q3tjnk0xM1JKctMDkiDuhx87ZGCoI=
Date:   Tue, 1 Oct 2019 20:04:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     vincent.whitchurch@axis.com, pmladek@suse.com,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] printk: Do not lose last line in kmsg
 buffer dump" failed to apply to 4.9-stable tree
Message-ID: <20191002000446.GH17454@sasha-vm>
References: <1569949451853@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1569949451853@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 07:04:11PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've grabbed 5aa068ea4082b ("printk: remove games with previous record
flags") to resolve this.

--
Thanks,
Sasha
