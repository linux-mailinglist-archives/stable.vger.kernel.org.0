Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93ACD4EBD60
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 11:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244650AbiC3JPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 05:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244663AbiC3JPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 05:15:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEA9E0FB;
        Wed, 30 Mar 2022 02:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C2E60FA2;
        Wed, 30 Mar 2022 09:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F68C340EE;
        Wed, 30 Mar 2022 09:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648631615;
        bh=WZ/5tA04tWecySUUsqngXFKJ0VVRl25jFDemLRCrZBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yt8H1pYNDYr/76RsZiBw4ORD/5+DXnAIWXKe7mW75DHPkPnXcBguuMgWfVLVYyuFt
         m5i7LCXQOp9Q0Q+gfC8N06VVfGmL6ofJWNXsZzYCUCp3qKy2/ctsd1oh6Az73IeQVX
         o6s/dUHv3vNTuDyeBrCPTlpUWT2FNrsxykv/6vEc=
Date:   Wed, 30 Mar 2022 11:13:32 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     =?utf-8?B?7KGw7KSA7JmE?= <junwan.cho@samsung.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "michael.zaidman@gmail.com" <michael.zaidman@gmail.com>,
        "erazor_de@users.sourceforge.net" <erazor_de@users.sourceforge.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?6rmA7J287Zi4?= <ih0923.kim@samsung.com>,
        =?utf-8?B?67CV7LKc7Zi4?= <chun.ho.park@samsung.com>,
        =?utf-8?B?67Cw7Jyk7Iud?= <yunsik.bae@samsung.com>,
        =?utf-8?B?6rCV64yA7Z2s?= <daihee7.kang@samsung.com>,
        =?utf-8?B?7J206rSR7Zi4?= <gaudium.lee@samsung.com>,
        =?utf-8?B?66WY7LKc7Jqw?= <chunwoo.ryu@samsung.com>,
        =?utf-8?B?64KY65GQ7IiY?= <doosu.na@samsung.com>,
        =?utf-8?B?6rmA7IiY7ZiE?= <suhyun_.kim@samsung.com>
Subject: Re: (3) (2) (2) Request for reverting the commit for Samsung HID
 driver
Message-ID: <YkQfPEKX0pd+tkz3@kroah.com>
References: <nycvar.YFH.7.76.2203301047560.24795@cbobk.fhfr.pm>
 <YkQVq1RvWTp1xxJO@kroah.com>
 <YkQRXqlzVjBLbvp2@kroah.com>
 <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
 <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
 <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
 <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
 <20220330084401epcms1p1fe9efa50452a84f7bbb22a4de82b5a0a@epcms1p1>
 <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p4>
 <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220330090150epcms1p42e28758b515942ecdee680cdef3ef0b9@epcms1p4>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 06:01:50PM +0900, 조준완 wrote:
>  
> Thank you for good advice.
> 
> I'll check security problem when I add in-house patch.
> I have no idea about how the commit improves security level.

Then please do not remove it.

> Was there any security problem?

Yes there was, it is now fixed.

thanks,

greg k-h
