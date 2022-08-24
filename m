Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC359F648
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 11:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiHXJdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 05:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiHXJdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 05:33:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C719084EEA;
        Wed, 24 Aug 2022 02:33:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E773617D5;
        Wed, 24 Aug 2022 09:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A73C433C1;
        Wed, 24 Aug 2022 09:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661333613;
        bh=oDsBptLyTbQ0b8yyoD3YJCOCXhTdpE0KriPkbbmED7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BLDem1g9ZQW2o8age1qttuU7dwPBhcnNVrx5pL4EyLZrrMN2OeyUEgLSG7fAvyrRL
         SOZHL0lBLxwTvL8BIMvgWdrPN2JQVgmEon9iFPB9M0SEMtFgl2SYD0MbGRqkd7Nq2d
         If0Vcvx6tGDSbCOV0uEYr37A7huhPJuwCuCtB7e8PWnssYlyctEZwpAv5qEAbp8a4p
         ieyISYadKqKBqkmcoVhPVph/lWGOnTP1lgTRzfvT9qPEzNRskC1qUbuLrQTFBnhxyX
         a++dRWzfUA2Ic6kjDleDOcRGIo6DRx5Oqd+5YS9LkYahKQ86YwE/XphdiUyExEjQTW
         o0HMFvnH5y6jA==
Date:   Wed, 24 Aug 2022 15:03:29 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, srinivas.kandagatla@linaro.org,
        stable-commits@vger.kernel.org
Subject: Re: Patch "soundwire: qcom: Check device status before reading
 devid" has been added to the 5.15-stable tree
Message-ID: <YwXwaSflH+XCxxWP@matsya>
References: <16604006172842@kroah.com>
 <YwT537rlrckb0/VV@matsya>
 <YwXHtBc2Du+a+rY3@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwXHtBc2Du+a+rY3@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24-08-22, 08:39, Greg KH wrote:
> On Tue, Aug 23, 2022 at 09:31:35PM +0530, Vinod Koul wrote:
> > On 13-08-22, 16:23, gregkh@linuxfoundation.org wrote:
> > > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >     soundwire: qcom: Check device status before reading devid
> > > 
> > > to the 5.15-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > The filename of the patch is:
> > >      soundwire-qcom-check-device-status-before-reading-devid.patch
> > > and it can be found in the queue-5.15 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > 
> > This is causing regression in rc1 so can this be dropped from stable
> > please
> 
> This is already in the following released kernels:
> 	5.15.61 5.18.18 5.19.2
> so when you get this resolved in Linus's tree, be sure to also add a cc:
> stable to the patch so it will get picked up properly.

Thanks will do!

-- 
~Vinod
