Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3479C57EF4C
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbiGWNwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiGWNwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:52:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614951A399
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 06:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF170611F6
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 13:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E98C341C0;
        Sat, 23 Jul 2022 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658584335;
        bh=8lE2Hsh+GeZMZMpbiKghZWLAXlzYCk/Z8FpKhNJ24RM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ITB1Aw+zaJqCyCs//EDT31pPP+N2gFTK94PFVbK/m+TOeQ0qqr5W4XjfCa1k4NxIe
         cpYJ2YqWH6mvkyDBSzw1FK/K/0DT41EgByyU4WYh9NPzF5R+v9L2r5w1qNhgbQi7SK
         2nA+Z8E/7y4y2BLOa9uO2NbVOfXZA9BgFPytV55I=
Date:   Sat, 23 Jul 2022 15:52:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com
Subject: Re: [PATCH 2/3] ASoC: SOF: pm: add definitions for S4 and S5 states
Message-ID: <Ytv9DDZv0szCmBlF@kroah.com>
References: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
 <20220711155719.104952-3-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711155719.104952-3-pierre-louis.bossart@linux.intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 10:57:18AM -0500, Pierre-Louis Bossart wrote:
> commit 7a5974e035a6d496797547e4b469bc88938343c2 upstream.

This is not a commit in Linus's tree :(
