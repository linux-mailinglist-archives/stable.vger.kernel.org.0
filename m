Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDAF4EBCC5
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244369AbiC3Iee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242851AbiC3Iee (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:34:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735EC67D2C;
        Wed, 30 Mar 2022 01:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C57EB81B83;
        Wed, 30 Mar 2022 08:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB15C340EC;
        Wed, 30 Mar 2022 08:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648629166;
        bh=jOFfbijCi7qGNrraB8HP8pKNvvxk2svcfBfj4lluvjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AirYvz4zLuiuQbV+YA3sCVlaWkfG1lvincmZKKW0rkm8GmOX0aqcxSfAOHJs7HvSi
         bAg2h7TP0ZC38rY7Wdn8TRUBTdjTuIzJCj5caejEUH7MqR44HNk+01SYK5WhU1e7jZ
         vIDnNoQ0y7zxEQyOvFFk5XWyhvZ37MGmlWq0s7jc=
Date:   Wed, 30 Mar 2022 10:32:43 +0200
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
Subject: Re: (2) (2) Request for reverting the commit for Samsung HID driver
Message-ID: <YkQVq1RvWTp1xxJO@kroah.com>
References: <YkQRXqlzVjBLbvp2@kroah.com>
 <nycvar.YFH.7.76.2203300948500.24795@cbobk.fhfr.pm>
 <20220330070159epcms1p31c351bc7eb90d99e0bbecd2c2f6092d1@epcms1p3>
 <20220330080937epcms1p51e6c98c5eb5f8108c9cfe35efa450daa@epcms1p5>
 <CGME20220330062122epcms1p30a2c2e3e1d3b108d729a00034bf86587@epcms1p3>
 <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220330082308epcms1p3f9bb275272b3e32abd4202fa1b893623@epcms1p3>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 05:23:08PM +0900, 조준완 wrote:
> 
> 
> As I said, AP manufacturers don't consider validation of patches.

That is not our issue, but yours.

> They just import linux patches into their Board Support Packages without consideration.

That is good for our changes, but not for yours.

> So, I can remove the condition that you made once I add Bluetooh accessories to Samsung driver in Linux Mainline?

No, not at all unless you wish to have a broken system?

Again, you have the budget and resources to handle the maintenance and
support of your out-of-tree changes.  That is your responsibility to
your customers as per your contracts with them.

As written, the in-kernel code is correct and now fixed.  If you have
modified the driver to do something else, it is your responsibility to
ensure that it remains working as there is nothing that we can do about
that for obvious reasons.

And again, if you remove those lines, you have a known insecure system,
which I doubt you want for your devices.

Please discuss this with your management as they understand the risks
and responsibilities that you have undertaken by having out-of-tree
code.  That is not our responsibility, but yours.

thanks,

greg k-h
