Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25B84EBCF3
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbiC3IvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbiC3IvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:51:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299A43FBE6;
        Wed, 30 Mar 2022 01:49:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EAA0B81AD4;
        Wed, 30 Mar 2022 08:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F5FC340EC;
        Wed, 30 Mar 2022 08:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648630158;
        bh=tYxY4ek5gEwbZ055CQYAvviVWec4+oMRK9jhmrHxt6Y=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=gKZu+4lFz5bsehy1ZfmVEhDVUoWHIYnlFlsf6JZbt41q7m+f0HUIysnw5QaTZbEL1
         hYTbplJFhS11JZ950ptawqSjmdKZGxlQFEXUhjzSsHlcm+GJalh5mARUvo0xnULvGN
         RT5863Wi/1TFt2FjJ6O0gF9goACV6uBc+MjB3RXYRyR0d3/y+MOPNsjEDPquXbninx
         jcWDQknmeSNOXqfPz1XlOWgnh43B2LEhm0lknISRqgWlv2ndm+Bi1Ow2jT9rwz81/X
         dqTSFLLWDZ7cLcfsvTaPKUvug/r+OywUgWnFes6zX6eRoeFW032RFp8wKjsNuU1UV4
         Z5VfE1+Bavy+A==
Date:   Wed, 30 Mar 2022 10:49:12 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     =?EUC-KR?B?wbbB2L/P?= <junwan.cho@samsung.com>
cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "michael.zaidman@gmail.com" <michael.zaidman@gmail.com>,
        "erazor_de@users.sourceforge.net" <erazor_de@users.sourceforge.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?EUC-KR?B?sejAz8ij?= <ih0923.kim@samsung.com>,
        =?EUC-KR?B?udrDtcij?= <chun.ho.park@samsung.com>,
        =?EUC-KR?B?uejAsb3E?= <yunsik.bae@samsung.com>,
        =?EUC-KR?B?sK2068jx?= <daihee7.kang@samsung.com>,
        =?EUC-KR?B?wMyxpMij?= <gaudium.lee@samsung.com>,
        =?EUC-KR?B?t/nDtb/s?= <chunwoo.ryu@samsung.com>,
        =?EUC-KR?B?s6q1zrz2?= <doosu.na@samsung.com>,
        =?EUC-KR?B?sei89sf2?= <suhyun_.kim@samsung.com>
Subject: RE:(2) (2) (2) Request for reverting the commit for Samsung HID
 driver
In-Reply-To: <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
Message-ID: <nycvar.YFH.7.76.2203301047560.24795@cbobk.fhfr.pm>
References: <YkQVq1RvWTp1xxJO@kroah.com> <YkQRXqlzVjBLbvp2@kroah.com> <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm> <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3> <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
 <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3> <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p1> <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Mar 2022, 조준완 wrote:

> Sorry that I'm not familier with policy of Linux.
> That means I cannot add the code to support Bluetoth accessories in Linux Main line?

You of course can (and I'd be actually very happy to take any in-house 
patches you have in order for the hid-samsung driver to support much 
bigger group of devices), but together with that, the hid-samsung driver 
needs to be adjusted so that it treats the BT-specific and USB-speicific 
codepaths properly.

-- 
Jiri Kosina
SUSE Labs

