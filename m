Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F290D9F900
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 05:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfH1D6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 23:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfH1D6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 23:58:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 465DF20679;
        Wed, 28 Aug 2019 03:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566964727;
        bh=m6h+Bl3vJyFNkRo8EsoTNu6M/5eP2UUcfGWd/62JK+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xm798tLHE3siV/HWJ4c/1D1k7BxnGhZK0ArJZMeW+faT9KFLkOowMYobxb2HHlZmx
         oh5ScM5lh1pwFxK8GSY6KEz3CFPWiywAYvEGVnJoiNuTBZdhfam6eOXcvJOx9zABOs
         YRHMOnQ9tL1F2U7IWtZ+jMUYJg4QGGNOQhXM7plI=
Date:   Tue, 27 Aug 2019 23:58:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     thomas.lendacky@amd.com, akpm@linux-foundation.org,
        andrew.cooper3@citrix.com, bp@suse.de, corbet@lwn.net,
        hpa@zytor.com, jgross@suse.com, jpoimboe@redhat.com,
        keescook@chromium.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, mingo@redhat.com,
        natechancellor@gmail.com, pavel@ucw.cz, pbonzini@redhat.com,
        rjw@rjwysocki.net, stable@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org, yu.c.chen@intel.com
Subject: Re: FAILED: patch "[PATCH] x86/CPU/AMD: Clear RDRAND CPUID bit on
 AMD family 15h/16h" failed to apply to 4.9-stable tree
Message-ID: <20190828035846.GY5281@sasha-vm>
References: <1566809975147242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1566809975147242@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 10:59:35AM +0200, gregkh@linuxfoundation.org wrote:
>The patch below does not apply to the 4.9-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up and queued for 4.9 and 4.4.

--
Thanks,
Sasha
