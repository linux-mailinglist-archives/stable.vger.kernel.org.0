Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4CD583A6A
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 10:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiG1IfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 04:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiG1IfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 04:35:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEAF6314;
        Thu, 28 Jul 2022 01:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E1EB82304;
        Thu, 28 Jul 2022 08:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF047C433B5;
        Thu, 28 Jul 2022 08:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658997308;
        bh=K8YQMrKoUYhUC1VKHP9tpQP4rPcZmTUjYsgeLL0atBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Le2xzw+2132kAijLaUyGGQT/+OI6TCbLDJJXe4hRW+JCURXbYUf8GgbHcKzg4s7mg
         XGKtiK9u20N7bpJMOhrQD01VNFdsMfnJ6fw/Kvu69DIj2bkODUgkXSRKpr7coUiCpf
         j9ZEcnbZJKUS8NOATYfqefhuyFxgbaD5dCYzPaVw=
Date:   Thu, 28 Jul 2022 10:35:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     linux-serial@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit in CS7
 mode
Message-ID: <YuJKObb/XQJ4woBK@kroah.com>
References: <20220714185858.615373-1-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220714185858.615373-1-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 01:58:58PM -0500, Shenwei Wang wrote:
> The LPUART hardware doesn't zero out the parity bit on the received
> characters. This behavior won't impact the use cases of CS8 because
> the parity bit is the 9th bit which is not currently used by software.
> But the parity bit for CS7 must be zeroed out by software in order to
> get the correct raw data.
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
> changes in v2
> - remove the "inline" keyword from the function of lpuart_tty_insert_flip_string;
> 
> changes in v1
> - fix the code indent and whitespace issue;

Please work with your email admins to fix up your systems as it is
showing this is an invalid signature when validating it:
	✗ BADSIG: DKIM/nxp.com

Soon I will just reject patches like this as you don't want people to
impersonate your domain, right?

thanks,

greg k-h
