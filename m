Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA076A59FE
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 14:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjB1NaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 08:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjB1NaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 08:30:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776661A652
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 05:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E90561090
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 13:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D982C433EF;
        Tue, 28 Feb 2023 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677591021;
        bh=qogcG24Q1ji9zZf+DCRvXhp1Ekgome6bv6MzqRLPC/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrTCk9Ra4WOyIKPhgXovzIOWN/LAP7lkf83goC/VG0IEhsov98rV6o9a35mLKWBG/
         s+C0XQsRC8DEG7ZsqJiUwqAdiEpYAFMDnuZ/6gFRXMheiwUal5Xllg0zPMMdyVAHCT
         shtzzG8XZcZVYGngkSUwIki7hItmi7SdP/yDSs6Q=
Date:   Tue, 28 Feb 2023 14:30:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Richard Fitzgerald <rf@opensource.cirrus.com>
Cc:     stable@vger.kernel.org, Takashi Iwai <tiwai@suse.com>,
        Martin Wolf <info@martinwolf.pub>,
        - <patches@opensource.cirrus.com>
Subject: Re: stable/6.2: backport commit 943f4e64ee17 ("ALSA: hda: cs35l41:
 Correct error condition handling")
Message-ID: <Y/4B6toVezE7U7H1@kroah.com>
References: <c530b196-c668-8437-4792-951a82ea7c42@opensource.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c530b196-c668-8437-4792-951a82ea7c42@opensource.cirrus.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 12:46:57PM +0000, Richard Fitzgerald wrote:
> commit 943f4e64ee177cf44d7f2c235281fcda7c32bb28 upstream
> 
> Please backport to 6.2.
> 
> This fixes an API break between the cs_dsp driver and the cs35l41 HDA
> driver that broke the cs35l41 driver.
> 
> The original chain of patches that made the cs_dsp change missed out the
> corresponding change to the HDA code. These changes went into the first
> 6.2 release.
> 
> Reported-by: Martin Wolf <info@martinwolf.pub>
> 

Now queued up, thanks.

greg k-h
