Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8716DDCE4
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjDKN4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjDKN4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B763930CA
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55D0F626F4
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69466C433A0;
        Tue, 11 Apr 2023 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681221371;
        bh=Ou8mzuO5ZTISaXWS+FbZhp1VQoT6gvQbrlfqeX5i40w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qrLiYSex4jZYqfO6q9F5WzcxaYWF41G5jhMHEAw6ASfDRsQE6PacBjb31d0a1lXju
         aqpeixcmH3X29ZidDpP1uKul/9pc/XLDcC8/2stGWu9M/s4DnHT/r7gRNLbGTszaYQ
         q4DLUVuF0ESl75lE7ZHC6F36WHGMw7cda8Z4d5Vc=
Date:   Tue, 11 Apr 2023 15:56:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mahapatra, Rajib" <Rajib.Mahapatra@amd.com>,
        "Huang, Tim" <Tim.Huang@amd.com>
Subject: Re: Fix GPU reset on DCN 3.1.4
Message-ID: <2023041102-composer-ligament-8ecb@gregkh>
References: <MN0PR12MB6101408843E065F3442271A7E2929@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101408843E065F3442271A7E2929@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 03:08:56PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Rajib recently found that GPU reset is failing on DCN 3.1.4 with 6.1.y.
> It's because of some missing commits in 6.1.y that skip the appropriate functions to match the GPU's graphics architecture.  Backporting these and GPU reset works again.
> Can you please bring these back to 6.1.y and 6.2.y?
> 
> 2a7798ea7390 ("drm/amdgpu: for S0ix, skip SDMA 5.x+ suspend/resume")
> e11c775030c5 ("drm/amdgpu: skip psp suspend for IMU enabled ASICs mode2 reset")

All now queued up, thanks.

greg k-h
