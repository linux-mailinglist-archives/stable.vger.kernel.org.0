Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153D957EF4D
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbiGWNwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiGWNwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:52:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0391A399
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 06:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1594B8091F
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 13:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F81EC341C0;
        Sat, 23 Jul 2022 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658584359;
        bh=MlPGyII2soxZUO9LKb+ACKKQEru1J337q6CZzkqNLpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WzkNF2dw0RdH+IDWOCPe1+WS0cc+GpKpGsvQ0F8v4UwTC/bYwY+VmMTnf0uXygiw0
         dzspLy/Xtr2qtf+1YNpxqippSaHNwWO3b2t25vuZAHC7NYr3GMgXjpL2TrcmdqM59z
         5UNTn3FOtYZ5t5gFZsO2JH8jMoca6zmdsrFh0pZw=
Date:   Sat, 23 Jul 2022 15:52:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com
Subject: Re: [PATCH 3/3] ASoC: SOF: Intel: disable IMR boot when resuming
 from ACPI S4 and S5 states
Message-ID: <Ytv9JKlEOXctrFee@kroah.com>
References: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
 <20220711155719.104952-4-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711155719.104952-4-pierre-louis.bossart@linux.intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 10:57:19AM -0500, Pierre-Louis Bossart wrote:
> commit 58ecb11eab44dd5d64e35664ac4d62fecb6328f4 upstream.

Again, not a valid commit :(

Where did these come from?

confused,

greg k-h
