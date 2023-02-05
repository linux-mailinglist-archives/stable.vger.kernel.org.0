Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25B668B03E
	for <lists+stable@lfdr.de>; Sun,  5 Feb 2023 15:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjBEORN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 09:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBEORN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 09:17:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FA17EF0;
        Sun,  5 Feb 2023 06:17:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FE38B8083A;
        Sun,  5 Feb 2023 14:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78B9C433EF;
        Sun,  5 Feb 2023 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675606629;
        bh=M0+y7XWD/m0EVxjYT3JybIANfeo5w8h14kAjh4ctWQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lPJnp59FgPLTFCfThv4JCMOovnM68JhEEhvzXhtMs9K+pTOfEfCC8AjSzqqNahYvx
         BO9UQHnK27Se6jP8q8wJ+8KfEEslUmzZjQRliaAAx6REP4HtkUUYZF0SWoJZOurKWK
         2eesgp3zRgOwEBIDwYzTCpPp3ahCAWC7IpJpqV4MSULca3RfSDRAw0C9BjL0/OJIQP
         bJe0hm7FP+M84/iKCaiqLiBF4jAKxOfFMLcWJtV2cGzENihBxK+Mk/yVNEJrniaVSt
         kFSE6/9XLx0DgZ9uA1TYJk5VFDgnLAmZEzDLMMd2Y0B75N9tV1f2SKttS8JOUphmgu
         PZYMDsiXSMq+g==
Date:   Sun, 5 Feb 2023 09:17:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stylon.wang@amd.com, sunpeng.li@amd.com, Xinhui.Pan@amd.com,
        Rodrigo.Siqueira@amd.com, roman.li@amd.com,
        amd-gfx@lists.freedesktop.org, Jerry.Zuo@amd.com,
        aurabindo.pillai@amd.com, dri-devel@lists.freedesktop.org,
        alexander.deucher@amd.com, Dave Airlie <airlied@redhat.com>,
        christian.koenig@amd.com
Subject: Re: [PATCH AUTOSEL 5.15 12/12] amdgpu: fix build on non-DCN
 platforms.
Message-ID: <Y9+6Y/4SDJ2//I+n@sashalap>
References: <20230131150030.1250104-1-sashal@kernel.org>
 <20230131150030.1250104-12-sashal@kernel.org>
 <CADnq5_M=WvEf6N9my2cjX1=aQdweKfrshyU+Q8Ohuo5=DBtf+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CADnq5_M=WvEf6N9my2cjX1=aQdweKfrshyU+Q8Ohuo5=DBtf+w@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 31, 2023 at 03:29:04PM -0500, Alex Deucher wrote:
>On Tue, Jan 31, 2023 at 10:01 AM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Dave Airlie <airlied@redhat.com>
>>
>> [ Upstream commit f439a959dcfb6b39d6fd4b85ca1110a1d1de1587 ]
>>
>> This fixes the build here locally on my 32-bit arm build.
>>
>> Signed-off-by: Dave Airlie <airlied@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This patch is only applicable to kernel 6.1 and newer.

Ack, I'll drop it on older kernels, thanks!

-- 
Thanks,
Sasha
