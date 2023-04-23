Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04FA6EBFAF
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 15:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDWNLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 09:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDWNLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 09:11:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B361700
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 06:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01CA060D30
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 13:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFED1C433D2;
        Sun, 23 Apr 2023 13:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682255511;
        bh=eGaOijBn2k5slMaHGxvhnwDCICnTeSZkXx69k+HB/PE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eoVEvmF4+i6u4HDBCoCkqecy6rwtGT57eecfWf4Lw1QoOqWUtOuFtIVFNDkbJBTeu
         +AKtXWCjQQ41f3wOuXPc3prgUaH+lHD3LJSEeTSEmuJpO2/ZlnHejkTgyNA6b1KRtb
         jnVFpTGuaj3Y+TFi7RJgU46eoBShr6xu2xi6go/w=
Date:   Sun, 23 Apr 2023 15:11:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     stable@vger.kernel.org, conor@kernel.org,
        Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH 5.15 2/3] soc: sifive: l2_cache: fix missing free_irq()
 in error path in sifive_l2_init()
Message-ID: <2023042330-tartness-geology-a090@gregkh>
References: <20230421-scam-karma-3de5bf7904b3@wendy>
 <20230421-dole-ignition-10fe81114811@wendy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421-dole-ignition-10fe81114811@wendy>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 21, 2023 at 02:58:17PM +0100, Conor Dooley wrote:
> From: Yang Yingliang <yangyingliang@huawei.com>
> 
> commit 73e770f085023da327dc9ffeb6cd96b0bb22d97e upstream.

No, sorry, wrong git id :(

Please fix up and resend the series.

thanks,

greg k-h
