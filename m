Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC9E58FDAB
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 15:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiHKNre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 09:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235134AbiHKNra (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 09:47:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A62B89CDE
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E459614EE
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9340AC433D6;
        Thu, 11 Aug 2022 13:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660225648;
        bh=EmiaOtWdEF6f58NM8ZuB+UV6Tpz4AWv093YsiVrUD04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8GOs5ZGwwwdDS58ZClOo/HlRGCeayhQil1a43/DX6yX5Pgfod3Rib8gMcHS6qa3k
         IuX5540F04arfo/9kKxyfJ4A9qkz6Wyy/9LU9TtPblk94YCLSgBcerTSWBpyD1KJXb
         vc0Q0IbGR9IZkrH1fNXNazdeSoxpsbwr8B1a8sfo=
Date:   Thu, 11 Aug 2022 15:47:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fix microphone on some Lenovo laptops
Message-ID: <YvUIbesjKGUsDqdu@kroah.com>
References: <MN0PR12MB6101E6F7B146642A3E424D76E2649@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101E6F7B146642A3E424D76E2649@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 01:35:30AM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Some Lenovo laptops need to be added to an ACP6x quirk list for the DMIC on them to work.
> Can you please backport this commit to 5.18.y and 5.19.y?
> 
> be0aa8d4b0fc ("ASoC: amd: yc: Update DMI table entries")

Now queued up, thanks.

greg k-h
