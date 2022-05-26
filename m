Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FFA534ED3
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 14:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343703AbiEZMI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 08:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245176AbiEZMI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 08:08:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58B7D4128;
        Thu, 26 May 2022 05:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C16CCE2258;
        Thu, 26 May 2022 12:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C01C34113;
        Thu, 26 May 2022 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653566903;
        bh=XCHEUSYWm6B+Yf3fjIWxFr2km5Exc5uFeJATjGUlQeo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cSATMU9W9EhCfj4hRbQNb+SDr42LOjAhMgR+fdb4iUAGNP0qxJM3EPJXldgcZJmHv
         ekXu+13/B7OQorUcAIq4KVpHSaxC247PQiLMpjBDfJmtqC9iUbFKxJVDifFH/ean2G
         kX1mTrFt0cUnkFPq4XTk1NUBtDtPpAPILHJuVtYc=
Date:   Thu, 26 May 2022 14:08:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     dmastykin@astralinux.ru,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        stable <stable@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: goodix: Commit for 5.4 stable inclusion
Message-ID: <Yo9ts52Ktv5Hv89B@kroah.com>
References: <CAOMZO5CsGxwos0_SwSEACZxSUVwPeT7GiwzT8W+sV=o=b=i-Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CsGxwos0_SwSEACZxSUVwPeT7GiwzT8W+sV=o=b=i-Mw@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 03:53:30PM -0300, Fabio Estevam wrote:
> Hi,
> 
> I would like to kindly request the inclusion of commit 24ef83f6e31d
> ("Input: goodix - fix spurious key release events") to the 5.4 stable
> tree.
> 
> It fixes the spurious touches reported on an imx6dl board with Goodix
> GT911 running kernel 5.4.

Now queued up, thanks.

greg k-h
