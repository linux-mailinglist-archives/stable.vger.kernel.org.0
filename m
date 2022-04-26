Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61E050F1AF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 09:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343615AbiDZHGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 03:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343611AbiDZHGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 03:06:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B1F6D383
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 00:03:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0265E6153D
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 07:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E27C385A0;
        Tue, 26 Apr 2022 07:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650956609;
        bh=x09BCREdHcsWbdFa5JuRkdJZ+PKdJyUL11GDclgEqE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0MbauDRZJfuLy3izlTO7IJDhOwPu6ZTUAgiiTa+ol7tUvY3Tg/vYLKbRwIe9A/5S9
         G5c1ROREZdJxGCPmYA9b3xvrPkOhQv4UcdyfHP3eUE/lQc25CCop9X19Cxl6xGcZi9
         YMvlgAPLXhnICuDh28uoPA54UDsUX9S9oy9KAfBg=
Date:   Tue, 26 Apr 2022 09:03:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.14 1/8] ax25: add refcount in ax25_dev to avoid UAF bugs
Message-ID: <YmeZPsJsw9e1tK3G@kroah.com>
References: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 21, 2022 at 01:37:32PM +0300, Ovidiu Panait wrote:
> From: Duoming Zhou <duoming@zju.edu.cn>
> 
> commit d01ffb9eee4af165d83b08dd73ebdf9fe94a519b upstream.

This, and the 4.19 series are now queued up, thanks!

greg k-h
