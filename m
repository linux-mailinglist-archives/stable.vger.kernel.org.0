Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502DC53524E
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 18:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiEZQuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 12:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348274AbiEZQuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 12:50:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E5349C99;
        Thu, 26 May 2022 09:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88A3561CEC;
        Thu, 26 May 2022 16:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61948C385A9;
        Thu, 26 May 2022 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653583805;
        bh=HxEkgjO2EAAyeO56xVtO8CtSiCh6jF5FCDTEIEOocXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=phGHcKF/et7RPbxWmSyaD6M7QvM6Hdrc2MQcQZC/nRH3w0KLJYV8hJyRV1hPazjOf
         T7mici+6LLdT0yMxhtNYhUsXrKN+0eUeOqTg4+JW1WCeHLnbe7XFyuMKmOQ2MT4Ng+
         mJGf3P4CRRtTSQq1z2OOtxIqecbrO5wsRfZkSzw4=
Date:   Thu, 26 May 2022 18:49:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch for stable
Message-ID: <Yo+vidb+a9Ctqyih@kroah.com>
References: <Yo+t8QAgVTi2E6B4@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo+t8QAgVTi2E6B4@yury-laptop>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 26, 2022 at 09:42:25AM -0700, Yury Norov wrote:
> Hi Greg,
> 
> Can you please consider taking the patch "KVM: x86: hyper-v: fix type
> of valid_bank_mask" into stable?
> 
> Commit ea8c66fe8d8f4f93df941e52120a3512d7bf5128 upstream.

For what kernel tree(s) should thie be backported?

thanks,

greg k-h
