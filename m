Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00694B0697
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 07:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbiBJGvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 01:51:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbiBJGvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 01:51:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AF310A8;
        Wed,  9 Feb 2022 22:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B986B823D6;
        Thu, 10 Feb 2022 06:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A05C004E1;
        Thu, 10 Feb 2022 06:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644475861;
        bh=NF5vEArqU6PoLBzuHWME77pDLNnZmgMubj3ipXB1Ugw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mn6ZZ4D0+DS9UVw8tI+547ZjxwpwdWNllSCaYBjRHhmwLpzv8MB9XOoOPD1GwJQhz
         REoQsKRszN1l1abuPdYb9cD+sMOSC2gEfHdN6jZa6vMkp3za2R8iNWQj01CuGFDrC1
         LcBK4hWCPRaUsfQdOisc95l9652125xwbG2vL5Ns=
Date:   Thu, 10 Feb 2022 07:50:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     qizhong cheng <qizhong.cheng@mediatek.com>
Cc:     Ryder Lee <ryder.lee@mediatek.com>,
        Jianjun Wang <jianjun.wang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        chuanjia.liu@mediatek.com
Subject: Re: [PATCH v2] PCI: mediatek: Clear interrupt status before
 dispatching handler
Message-ID: <YgS10ZUCzgjRs6LQ@kroah.com>
References: <20220210012125.6420-1-qizhong.cheng@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210012125.6420-1-qizhong.cheng@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 09:21:25AM +0800, qizhong cheng wrote:
> We found a failure when used iperf tool for wifi performance testing,
> there are some MSIs received while clearing the interrupt status,
> these MSIs cannot be serviced.
> 
> The interrupt status can be cleared even the MSI status still remaining,
> as an edge-triggered interrupts, its interrupt status should be cleared
> before dispatching to the handler of device.
> 
> Signed-off-by: qizhong cheng <qizhong.cheng@mediatek.com>
> ---
> v2:
>  - Update the subject line.
>  - Improve the commit log and code comments.
> 
>  drivers/pci/controller/pcie-mediatek.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
