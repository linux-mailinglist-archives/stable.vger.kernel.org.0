Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935ED4EDF36
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbiCaQ7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbiCaQ7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:59:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359B72325C0;
        Thu, 31 Mar 2022 09:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0177B82190;
        Thu, 31 Mar 2022 16:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57387C3410F;
        Thu, 31 Mar 2022 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648745869;
        bh=E04uSCB1BXE8v4n1dsEjGmXWunGzTs+OdMoZdRot078=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A77Y0rrJBysWC3OLfZNdY5ss9jc4izJGVFgK+SFGKosuhyv7Tluf3M1CGMummHUgC
         iTF/pIpOgJOuvivZd8KV7TOVoIb7aAb5nqSayiV2rpswzrKzq6o1qszGPXUkMHaZHv
         64NvC2SqHoQNoHDYi4D6WskhexywWME4iYZKs55NbFsU++4BjgjxCoexkziA84IpBL
         89Nzb0Qq4AcFEdPlAodDXTeZ/UwGddA516SlRICfisyszCTQu7betoNVsCVTZvhlqQ
         hP/Q6E2kw1CTW84HBWmy7AGosAt0esiDQXyYt7GYqcBlJizLd2g4k99xSY4HqANoCI
         Pi2uIHJi75IUg==
Date:   Thu, 31 Mar 2022 12:57:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?iso-8859-1?Q?P=E9ter?= Ujfalusi 
        <peter.ujfalusi@linux.intel.com>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.17 58/66] ASoC: Intel: Revert "ASoC: Intel:
 sof_es8336: add quirk for Huawei D15 2021"
Message-ID: <YkXdjJcvCTkI/yzA@sashalap>
References: <20220330114646.1669334-1-sashal@kernel.org>
 <20220330114646.1669334-58-sashal@kernel.org>
 <YkRGb9uDhWV9GQfn@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkRGb9uDhWV9GQfn@sirena.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 01:00:47PM +0100, Mark Brown wrote:
>On Wed, Mar 30, 2022 at 07:46:37AM -0400, Sasha Levin wrote:
>> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>>
>> [ Upstream commit 1b5283483a782f6560999d8d5965b1874d104812 ]
>>
>> This reverts commit ce6a70bfce21bb4edb7c0f29ecfb0522fa34ab71.
>>
>> The next patch will add run-time detection of the required SSP and
>> this hard-coded quirk is not needed.
>
>This is reverting a commit which was bacported earlier in this series?

Yeah, it makes it easier for us to track and make sure we won't pick up
the quirk commit again.

-- 
Thanks,
Sasha
