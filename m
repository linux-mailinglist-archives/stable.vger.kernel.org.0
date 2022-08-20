Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6499C59B261
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiHUHAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiHUHAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D868126130;
        Sun, 21 Aug 2022 00:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53DB6B80064;
        Sun, 21 Aug 2022 07:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDA1C433C1;
        Sun, 21 Aug 2022 07:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065205;
        bh=qPYfPLGXHsrtRmVcp3PnfW8A/fEJyGDrpaLdg2fwFY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zGPr6j13E6X1NGeAv2W42f0rZsiJ6YQE657fl4jTygB0y54d1SCkgeYyNzpG6U32g
         JJ7ak3dpZdsVBbDoayfnErZ1lZdGb1y4O+DmIQExdqOsFT7yhsLlXOI5leOn06rOmW
         zQUu3ZGgg95Td6ICaLr8F5kdChi48RkQ8+ezGQAY=
Date:   Sat, 20 Aug 2022 20:05:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rob Herring <robh@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 146/545] dt-bindings: Update QCOM USB subsystem
 maintainer information
Message-ID: <YwEieJHsTVV6RInb@kroah.com>
References: <20220819153829.135562864@linuxfoundation.org>
 <20220819153835.859060503@linuxfoundation.org>
 <CAL_JsqKY_Bq_-hd6xS-XSA9KZdDLUyj8PevD-_HniPyg9JqjRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKY_Bq_-hd6xS-XSA9KZdDLUyj8PevD-_HniPyg9JqjRA@mail.gmail.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 11:09:04AM -0500, Rob Herring wrote:
> On Fri, Aug 19, 2022 at 10:52 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Wesley Cheng <quic_wcheng@quicinc.com>
> >
> > [ Upstream commit e059da384ffdc93778e69a5f212c2ac7357ec09a ]
> >
> > Update devicetree binding files with the proper maintainer, and updated
> > contact email.
> 
> I don't think this needs to go to stable.

good point, now dropped.

