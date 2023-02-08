Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDB068E601
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 03:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjBHCXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 21:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHCXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 21:23:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCED31EFEE
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 18:23:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2376B81B9A
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 02:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25014C433D2;
        Wed,  8 Feb 2023 02:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675823022;
        bh=tDuNSmvcoa2NZz5oWGmu5Uqj5RiQFIIs8txbHsJmagk=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=Adey18ub3DPqg2IYeNIK96LXZaI22Mj3Bu34JnqHRQO98Dx18TKLK9kzDvTRA+1Q/
         70QjzzSFM+eEZpekQU69dArQ94ft0r8yNSANIuCLDeG7HWB8UKZ+NWaH/2AAoigoqO
         FZAJtuPL2vD5Anv2QxLRFb6wjf4p/U3JL43Jh44H2GdwIekQlcMLsLi+YWB/uX+Kbt
         NehkZq7Hwlj2gmrny4zZpH7vu5eAUM9Jsbnt9KwahcXVEsB3MxNS/DFuQic+5klmv+
         QVTZ07wFXYBnsWj52zASdaktbe+GCySMPr4aQRcT6KQNGLnFCnkYgNpfTxY+9lAmNF
         NyZsut1nwhK0g==
Message-ID: <98459a1b-eb42-afe3-9795-70c45292add9@kernel.org>
Date:   Tue, 7 Feb 2023 19:23:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 5.4 v2 2/2] ipv4: Fix incorrect route flushing when source
 address is deleted
Content-Language: en-US
From:   David Ahern <dsahern@kernel.org>
To:     Shaoying Xu <shaoyi@amazon.com>, gregkh@linuxfoundation.org
Cc:     idosch@nvidia.com, kuba@kernel.org, patches@lists.linux.dev,
        sashal@kernel.org, stable@vger.kernel.org
References: <Y+IckeUtbE/UfOz/@kroah.com>
 <20230207182820.4959-1-shaoyi@amazon.com>
 <20230207182820.4959-2-shaoyi@amazon.com>
 <9d90e05b-c9cb-03d2-645a-b50b1cae694d@kernel.org>
In-Reply-To: <9d90e05b-c9cb-03d2-645a-b50b1cae694d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/23 7:22 PM, David Ahern wrote:
> On 2/7/23 11:28 AM, Shaoying Xu wrote:
>> From: Ido Schimmel <idosch@nvidia.com>
>>
>> [ Upstream commit f96a3d74554df537b6db5c99c27c80e7afadc8d1 ]
>>
> 
> That commit, does not have this change:
> 

nevermind. I was looking at the other commit with that Fixes tag.


You did drop the selftests associated with the commit.

