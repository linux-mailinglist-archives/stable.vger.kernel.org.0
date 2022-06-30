Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B58561901
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiF3LVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiF3LVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:21:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DF74F1BF;
        Thu, 30 Jun 2022 04:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30478B827F9;
        Thu, 30 Jun 2022 11:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89561C34115;
        Thu, 30 Jun 2022 11:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656588092;
        bh=gA1lI01iH3Z3Ghmf8BzSGGEyuci98s//osdN4lv3MRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GxC9iVvdnBosxDbMFOqh8Ezd1ormwnPB/dxNNeKz6Q67bo3Ta//B1/3OdL4AFkMXS
         dHSUp/3LsEV6wW4c6Yqm1pWhX2UMZNvJgxUMZ6A3fIz4mliZrmeX4IrqktLunMO8ox
         53AVe2FRrnzLHPItaYWhMH/Tsih60ttEytfV/ukY=
Date:   Thu, 30 Jun 2022 13:21:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 v4 0/5] xfs stable patches for 5.10.y (backports
 from v5.15.y)
Message-ID: <Yr2HMshqLoVlS7PX@kroah.com>
References: <20220627065140.2798412-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627065140.2798412-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 09:51:35AM +0300, Amir Goldstein wrote:
> [resend with PATCH 5.10 prefix]
> 
> Hi Greg,
> 
> We started to experiment with the "xfs stable maintainers" concept that
> Darrick has proposed.
> 
> My focus is on 5.10.y backports,
> Leah's focus is on 5.15.y backports and
> Chandan may pick up the 5.4.y backports.
> 
> This stable update is the first collaborated series for 5.10.y/5.15.y.
> 
> It started with a 5.15.y patch series from Leah [1] of patches that
> specifically fix bugs prior to 5.10, to whom I already had tested
> 5.10 backport patches for.
> 
> Leah will be sending the ACKed 5.15.y series [2].
> This 5.10.y series is a subset of the 5.15.y series that was
> ACKed by xfs developers for 5.10.y.
> 
> All the patches in the 5.15.y series were backported to 5.10.
> The ones that are not included in this 5.10.y update were more subtle
> to backport, so the backports need more time for review and I will send
> them in one of the following stable updates.
> 
> I would like to thank Darrick for reviewing the backport candidates.
> I would like to thank Luis for his ongoing support of the kdevops [3]
> test environment and Samsung for contributing the hardware to drive it.

Now queued up, thanks.

greg k-h
