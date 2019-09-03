Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F25FA75B7
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 22:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfICUxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 16:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfICUxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 16:53:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C31AB208E4;
        Tue,  3 Sep 2019 20:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567544003;
        bh=gl4XZsfQTl+WA1TKhVbcpNWGOPpnveEWKEgSGNHjzbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0/4CJDs8tT8J6PK8rh7GquhzuOWwVDtLRasU0WljTi1J0+vP68D8pCw2RIxSVP5Q1
         ovnEFig15GcoUiPy3FfmQLFreF1ldeh7vX19dwEsOinMY9/kCZnGmmj7WuEFUotqz9
         TVAspO6rSccYBRIdMvIJNgO0h1/YZZPyk5+ChG3w=
Date:   Tue, 3 Sep 2019 16:53:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     luciano.coelho@intel.com, johannes.berg@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iwlwifi: pcie: handle switching killer Qu
 B0 NICs to C0" failed to apply to 5.2-stable tree
Message-ID: <20190903205321.GP5281@sasha-vm>
References: <15675370949856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15675370949856@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 08:58:14PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.2-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

There are quite a few dependencies here - it looks like a few other
stable tagged commits didn't make it to 5.2 and this one depends on
them. I've fixed it up by taking:

d151b0a2efa12 ("iwlwifi: add new cards for 22000 and fix struct name")
a976bfb44bdbc ("iwlwifi: add new cards for 22000 and change wrong structs")
ffcb60a54f245 ("iwlwifi: add new cards for 9000 and 20000 series")
658521fc1bf14 ("iwlwifi: change 0x02F0 fw from qu to quz")
a7d544d631200 ("iwlwifi: pcie: add support for qu c-step devices")
17e40e6979aaf ("iwlwifi: pcie: don't switch FW to qnj when ax201 is detected")
b9500577d3615 ("iwlwifi: pcie: handle switching killer Qu B0 NICs to C0")

--
Thanks,
Sasha
