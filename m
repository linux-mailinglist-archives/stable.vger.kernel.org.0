Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBC04EBCB6
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiC3I3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiC3I3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:29:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03A2F1;
        Wed, 30 Mar 2022 01:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A7FD60C2B;
        Wed, 30 Mar 2022 08:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CCEC340EC;
        Wed, 30 Mar 2022 08:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648628853;
        bh=wwFS/WdQTn9EsDc0Gv7Xpw3ubX3dAPmXu+JHWIjR2qo=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=CqGoGKVMgl6RPYZWpFNWiI15qWrqMhM4hmb+CPjPmx0PjCQOih417bY3aHtx/kNZ3
         YGZEpVLfU9p8ceyrU6DwueWbCPTA1yK6ktWlec0XlKw7uFaAkjDnwevQ5AlH4ogel0
         L0zHZwoFR06Orfim5GxyyLprpPn4OA2Gd2JwZfDXA5d0sXoIRUkIAyR/Bs3r9N6bFB
         iiHecjZJLy59Z0nulOnlqKPkJ3l4MRRBSFSMvc+TuglI8OYqtLaah/niWssBOTMF/b
         UuMq9QB14dc3Jwx29q9pQ3SEOKMAb8LPBDTJDLB93saDLdyAoTSaRg7UOsTP3AxaDZ
         tpXC3c0D3Mstg==
Date:   Wed, 30 Mar 2022 10:27:28 +0200 (CEST)
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
Subject: RE:(2) (2) Request for reverting the commit for Samsung HID driver
In-Reply-To: <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
Message-ID: <nycvar.YFH.7.76.2203301025010.24795@cbobk.fhfr.pm>
References: <YkQRXqlzVjBLbvp2@kroah.com> <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm> <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3> <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
 <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p3> <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

> As I said, AP manufacturers don't consider validation of patches. They 
> just import linux patches into their Board Support Packages without 
> consideration.

We as a Linux kernel community have no insight into the process/setup you 
have with your AP vendors though.

> So, I can remove the condition that you made once I add Bluetooh 
> accessories to Samsung driver in Linux Mainline?

Of course; the code then needs to be adjusted in a way that the USB 
codepath and Bluetooth codepath handle the transport driver intrinsics 
properly.
Which wasn't the case before Greg's commit -- a specially crafted device 
could be bound by hid-samsung with non-HID transport, crashing the kernel 
once it tried to perform USB operations on it.

Thanks,

-- 
Jiri Kosina
SUSE Labs

