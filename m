Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B22C98CA
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 09:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfJCHFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 03:05:52 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:35669 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727331AbfJCHFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 03:05:52 -0400
Received: from [192.168.0.8] (ip5f5bf2c1.dynamic.kabel-deutschland.de [95.91.242.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2A9622022568A;
        Thu,  3 Oct 2019 09:05:49 +0200 (CEST)
Subject: Re: [char-misc for v4.5-rc2 2/2] mei: avoid FW version request on
 Ibex Peak and earlier
To:     Sasha Levin <sashal@kernel.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20191001235958.19979-2-tomas.winkler@intel.com>
 <20191002224947.A525221783@mail.kernel.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <73c1bac7-613e-6e89-646f-6e39ddfe58af@molgen.mpg.de>
Date:   Thu, 3 Oct 2019 09:05:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002224947.A525221783@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sasha,


On 03.10.19 00:49, Sasha Levin wrote:

> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 4.18+

I’ll still need to test it.

> The bot has tested the following trees: v5.3.1, v5.2.17, v4.19.75.
> 
> v5.3.1: Build OK!
> v5.2.17: Build OK!
> v4.19.75: Failed to apply! Possible dependencies:
>      ce0925e8c2f8 ("mei: dma ring buffers allocation")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> --
> Thanks,
> Sasha

Could you please add a space after the two minuses: `-- `? That would 
make it a valid signature separator, and mail clients can strip it.


Kind regards,

Paul
