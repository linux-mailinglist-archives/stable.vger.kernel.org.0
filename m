Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052F7584CFC
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 09:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiG2Hw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 03:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiG2Hw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 03:52:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C25E7E016;
        Fri, 29 Jul 2022 00:52:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 136ECB826FE;
        Fri, 29 Jul 2022 07:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685EEC433D6;
        Fri, 29 Jul 2022 07:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659081172;
        bh=OYdvV1YvlA/eN4XOJblBaobdFexkVmkDwauRhOeGPlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n8duhNOi5jT8T0Yyk11vj2ck80+7yMAUrjAuEnCEawa3e738bgm8tNWh1JElV1wtc
         e1zmW/TnfLSmUW86TW2o+OfA58EDdeamGD1yhA8uXGNQp0u6Uow4o3ZEHvi7BE0JXG
         cvVRbA0UxTxLSTiJUEy5GGMR/GS1YoYTDb6QR2uk=
Date:   Fri, 29 Jul 2022 09:52:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit
 in CS7 mode
Message-ID: <YuOR0nA5EYnNQOYh@kroah.com>
References: <20220714185858.615373-1-shenwei.wang@nxp.com>
 <YuJKObb/XQJ4woBK@kroah.com>
 <AM9PR04MB8274C49685CC127AE48FB3DD89969@AM9PR04MB8274.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM9PR04MB8274C49685CC127AE48FB3DD89969@AM9PR04MB8274.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Jul 28, 2022 at 06:15:09PM +0000, Shenwei Wang wrote:
> Hi Greg,
> 
> I tried to send an email again to check this DKIM badsig issue, but everything looked fine here. Can you please let me know how you validated the signature? The following is my DKIM validating info:

I use b4, and here's what I used and you should be able to duplicate it
yourself:

$ b4 am -t https://lore.kernel.org/r/20220714185858.615373-1-shenwei.wang@nxp.com
Grabbing thread from lore.kernel.org/all/20220714185858.615373-1-shenwei.wang%40nxp.com/t.mbox.gz
Analyzing 5 messages in the thread
Checking attestation on all messages, may take a moment...
---
  ✗ [PATCH v2 1/1] serial: fsl_lpuart: zero out parity bit in CS7 mode
  ---
  ✗ BADSIG: DKIM/nxp.com
---
Total patches: 1
---
 Link: https://lore.kernel.org/r/20220714185858.615373-1-shenwei.wang@nxp.com
 Base: not specified
       git am ./v2_20220714_shenwei_wang_serial_fsl_lpuart_zero_out_parity_bit_in_cs7_mode.mbx

thanks,

greg k-h
