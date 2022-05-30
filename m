Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0BE538597
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242221AbiE3P5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242624AbiE3P4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:56:52 -0400
Received: from mx0b-001ae601.pphosted.com (mx0a-001ae601.pphosted.com [67.231.149.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2B3612B0;
        Mon, 30 May 2022 08:43:19 -0700 (PDT)
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UCWckK031719;
        Mon, 30 May 2022 10:42:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=11pjfbwnqjvFmqlfNXE5HUVDU57yELpFdGSoDPUvib0=;
 b=EaW6SU162fEQ3FQZQS8yM52QevUSykbIP7szsvIQrEb/gSmowud+PoSL3ncvInveHswo
 zqoyxta/V876bobfonBUffqiM92yxSrSgbSAVK+x5zgwWmrQ+ehAVswLe9vFI/USQAv7
 AJFek2WDrQIAQOsYpCpklQ7cJl/YVbATj+FzzdvuydibWNAbLpICwbYLGEAcnyDgkPCC
 L9iRCmtLp1Dk1pB1n8ABXbkhpgm6Od4dYbWX7vRi+1FGzYFjqTVgRT+Nh03xCqr/qsOk
 Y1AL8AJF47tD+eX31FVcD68vBv8CArCnZRFlqxvVMrWq33Xg0MB47KqNE1BBmdjKZ4uo 8w== 
Received: from ediex02.ad.cirrus.com ([84.19.233.68])
        by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 3gbh51hvjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 May 2022 10:42:43 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 30 May
 2022 16:42:40 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Mon, 30 May 2022 16:42:40 +0100
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id A46BF11D1;
        Mon, 30 May 2022 15:42:40 +0000 (UTC)
Date:   Mon, 30 May 2022 15:42:40 +0000
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     Mark Brown <broonie@kernel.org>
CC:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <steven.eckhoff.opensource@gmail.com>,
        <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.com>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH AUTOSEL 5.18 089/159] ASoC: tscs454: Add endianness flag
 in snd_soc_component_driver
Message-ID: <20220530154240.GW38351@ediswmail.ad.cirrus.com>
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-89-sashal@kernel.org>
 <YpTSkjYKAZLcOykC@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YpTSkjYKAZLcOykC@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-GUID: 4OiTsCAEN3KNyoBVMCYlj_vrrrXL9qyJ
X-Proofpoint-ORIG-GUID: 4OiTsCAEN3KNyoBVMCYlj_vrrrXL9qyJ
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 30, 2022 at 04:20:02PM +0200, Mark Brown wrote:
> On Mon, May 30, 2022 at 09:23:14AM -0400, Sasha Levin wrote:
> > From: Charles Keepax <ckeepax@opensource.cirrus.com>
> > 
> > [ Upstream commit ff69ec96b87dccb3a29edef8cec5d4fefbbc2055 ]
> > 
> > The endianness flag is used on the CODEC side to specify an
> > ambivalence to endian, typically because it is lost over the hardware
> > link. This device receives audio over an I2S DAI and as such should
> > have endianness applied.
> > 
> > A fixup is also required to use the width directly rather than relying
> > on the format in hw_params, now both little and big endian would be
> > supported. It is worth noting this changes the behaviour of S24_LE to
> > use a word length of 24 rather than 32. This would appear to be a
> > correction since the fact S24_LE is stored as 32 bits should not be
> > presented over the bus.
> 
> This series of commits doesn't feel like a good idea for stable,
> it will probably be safe but it's effectively new feature stuff
> so out of scope and there's some possibility we might uncover
> some bug which might've been being masked.

Strongly agree here, no need to back port these to stable.

Thanks,
Charles
