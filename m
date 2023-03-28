Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C1B6CC8B7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 19:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjC1RCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 13:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjC1RCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 13:02:12 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C459ECF;
        Tue, 28 Mar 2023 10:02:11 -0700 (PDT)
Date:   Tue, 28 Mar 2023 19:02:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1680022929;
        bh=WlyrVyWWgyyjbRTXsDBXNHSjIHTp5NR+F+mBA92jthI=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=fXlHkcfe8bkRLKyJKkgjN6Weg8NbpHAw2aHGS62p5nOTgZiVlD3ksPb8sNvxTKMnW
         2iNhEast4YhFm9AXk6X32B7ePInky+xmLHwCgxkJthODO8cO63ddarvzWEa6ib3iaA
         R4qQOxDqdOD5DjIxHDYxD6h/cS3p2cIExv/K+057k7Tdr7rSVoyvxq2pTGqdwnXzd9
         nlVk47ZIiP2IHZeRZmNEZJ9mq6s0w+d3C0S4vAWFryKgloL0yGNhMGr+Ue1dFeycjK
         whHE/YWsa+wjarxqjDQ4nhfqkXyZ+Z7PCnVajnpx7edYmYl5NbJPicCpKVkg488icC
         x0dHj8t0QzYGA==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Message-ID: <20230328170209.GA5469@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230328142619.643313678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.9-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
