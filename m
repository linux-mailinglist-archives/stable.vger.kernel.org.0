Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272BFC9D4F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 13:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbfJCLbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 07:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbfJCLbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 07:31:24 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54E1120830;
        Thu,  3 Oct 2019 11:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570102283;
        bh=YKjNmuHeXmnuedV7jKsUNTCIS/ll4OIqJlQfa+0xfKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uPAKCvVsw09x1TeICwf7/OhQD6ysEnvXf0UWY3n6j0+yMEa2+pME/XRc0qefNbJ43
         B39LEb5zZzGH6JLHssvdNg0E1Z9qZeSz62354peQ7FhLc4rUn4WXQtIow/4+95NJ+k
         rA77hjVIwGIK1YUQjnX0+iAOvu+tNgVo4PY6DBeQ=
Date:   Thu, 3 Oct 2019 07:31:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [char-misc for v4.5-rc2 2/2] mei: avoid FW version request on
 Ibex Peak and earlier
Message-ID: <20191003113122.GT17454@sasha-vm>
References: <20191001235958.19979-2-tomas.winkler@intel.com>
 <20191002224947.A525221783@mail.kernel.org>
 <73c1bac7-613e-6e89-646f-6e39ddfe58af@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73c1bac7-613e-6e89-646f-6e39ddfe58af@molgen.mpg.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 09:05:48AM +0200, Paul Menzel wrote:
>Dear Sasha,
>
>
>On 03.10.19 00:49, Sasha Levin wrote:
>
>>This commit has been processed because it contains a -stable tag.
>>The stable tag indicates that it's relevant for the following trees: 4.18+
>
>I’ll still need to test it.
>
>>The bot has tested the following trees: v5.3.1, v5.2.17, v4.19.75.
>>
>>v5.3.1: Build OK!
>>v5.2.17: Build OK!
>>v4.19.75: Failed to apply! Possible dependencies:
>>     ce0925e8c2f8 ("mei: dma ring buffers allocation")
>>
>>
>>NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>>How should we proceed with this patch?
>>
>>--
>>Thanks,
>>Sasha
>
>Could you please add a space after the two minuses: `-- `? That would 
>make it a valid signature separator, and mail clients can strip it.

I thought there was a space there :( Now added... Thanks!

--
Thanks,
Sasha
