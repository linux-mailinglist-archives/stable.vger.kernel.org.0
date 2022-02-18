Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8953A4BB73B
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 11:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiBRKt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 05:49:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiBRKtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 05:49:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB231EC51
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 02:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DF6BB825B2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 10:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6156AC340E9;
        Fri, 18 Feb 2022 10:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645181346;
        bh=+pQNJ5eH5bkjFwJzb1f8Yh89YQNI/JZ1EzD6QACP2ec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S5f6g3ph/E+1CxqQrwbbzxHuBiPbCmrDqDtFP6ppyJ04HidUUh9Gura1iSbCZu725
         jFf+Mlfz4lwxfh8qtzAjAwiCWcgQFjWN4cGEzRSsw/lbCMoY2j4N2SVRIUvdVtX3bR
         cBJGDyDfaqthdFhdtT+IYo5dIsLc3lDV6BLqMSME=
Date:   Fri, 18 Feb 2022 11:49:03 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] mmc: block: fix read single on recovery logic
Message-ID: <Yg95n1mEJoIm4ahp@kroah.com>
References: <16451252511822@kroah.com>
 <abf69d264c7845bab8433ccae7ed0e0f@hyperstone.com>
 <Yg92AW1onRd47G9z@kroah.com>
 <03b3664476424756867d9dd76f984002@hyperstone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03b3664476424756867d9dd76f984002@hyperstone.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 10:36:47AM +0000, Christian Löhle wrote:
> This is the backport for 4.19, it applied for more recent branches and
> is not applicable to 4.14.

Thanks, now queued up.

greg k-h
