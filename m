Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2E758C31C
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 08:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiHHGC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 02:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbiHHGCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 02:02:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25C6D53
        for <stable@vger.kernel.org>; Sun,  7 Aug 2022 23:02:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F834611CC
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 06:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BB4C433C1;
        Mon,  8 Aug 2022 06:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659938573;
        bh=VmyVtXO1l90uLM/jimvBqRuotNER1x4nzfTCHLBvfAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8QtWs5xmSCTcZjiE/sDStlG1MSAJc0Jb2++hwXi06GR2PVxrnUZjdX3qaanZiZS1
         bA2C+Ji3D0BGvMSKcp61t0GoW7fWFXNvSv5cTm32n7Wr3DSUHo4IDCij9Hp8CaPClT
         kXt1FJ24P8395nYeHs9rnLmt8GsG3pkisgkjEcHI=
Date:   Mon, 8 Aug 2022 08:02:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        lkp <lkp@intel.com>
Subject: Re: Fwd: warning: stable kernel rule is not satisfied
Message-ID: <YvCnCgvNiKVVR+ux@kroah.com>
References: <2364552d-9b18-875a-484a-d54ee8b9b9ee@intel.com>
 <baf4e189-2302-ea9c-e905-4ebc33c1e937@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baf4e189-2302-ea9c-e905-4ebc33c1e937@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 10:51:08AM +0800, kernel test robot wrote:
> Hi Greg, Sasha,
> 
> Sorry to bother you, this is kernel test robot, we have sent some
> reports related to the stable kernel rule, do you want to receive such
> report? or any suggestion for us to improve it, or disable it?

Yes, can you respond with the same subject line as the original email,
to make it obvious what this is referring to?  Much like your other
emails for when a submission breaks the build.

thanks,

greg k-h
