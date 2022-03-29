Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F012D4EAC1C
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 13:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbiC2LV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 07:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiC2LV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 07:21:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD075DA3E;
        Tue, 29 Mar 2022 04:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B19CB816A6;
        Tue, 29 Mar 2022 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C9AC2BBE4;
        Tue, 29 Mar 2022 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648552810;
        bh=Rr6aenliHjbw+hrV9jmcgT+R44dJusOEZT/eAAlE8Us=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mkjoVAXFwGqTb6wIE6IgH2NTIp9vo8say1ZmpUO6Jxvf+Uafw3AbKCO9MH1kWFz/3
         32YaAxrNL19Tyk+y+59CPM+Id3aMa7oiSdYFfP2MT9R5ydgWotFTe2NYz3rvgQij9x
         X84CEyJE87NwqgxPx+wCSIylpFHEmzPv3c5Vi2Rg=
Date:   Tue, 29 Mar 2022 13:20:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kant Fan <kant@allwinnertech.com>
Cc:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        javi.merino@kernel.org, edubezval@gmail.com, orjan.eide@arm.com,
        amitk@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        allwinner-opensource-support@allwinnertech.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] thermal: devfreq_cooling: use local ops instead of
 global ops
Message-ID: <YkLrZ9OkJz2R8tU6@kroah.com>
References: <20220325094436.101419-1-kant@allwinnertech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325094436.101419-1-kant@allwinnertech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 25, 2022 at 05:44:36PM +0800, Kant Fan wrote:
> commit 7b62935828266658714f81d4e9176edad808dc70 upstream.

I do not see this commit in Linus's tree :(

confused,

greg k-h
