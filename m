Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02D6E864F
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 02:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjDTAVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 20:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDTAVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 20:21:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B09173D;
        Wed, 19 Apr 2023 17:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JotGrjKh5QxtPJB2PfGPr7wf5j/a4ArSZ7abIyxUYOA=; b=ixck3ZLr8wUxl8Ry1MWNh5tvBi
        9pwodgZldN4NWPTQq3XtPrUl+LIE6lfnkwN2sKKUkGdLSyFtqHahkUyxOVNv4iQuOad2mnygjAQMH
        kyYAAtXjGOp51BC4q0K4i7pk382qPNYeR6Lh8IcbaHVilM/Hn5a5HDLb6yTX8npXNQKY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppI3C-00AjnE-TL; Thu, 20 Apr 2023 02:21:26 +0200
Date:   Thu, 20 Apr 2023 02:21:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] leds: trigger: netdev: recheck
 NETDEV_LED_MODE_LINKUP on dev rename
Message-ID: <24510f29-3a2e-4694-a179-92b064738a3a@lunn.ch>
References: <20230419210743.3594-1-ansuelsmth@gmail.com>
 <20230419210743.3594-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419210743.3594-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 11:07:39PM +0200, Christian Marangi wrote:
> Dev can be renamed also while up for supported device. We currently
> wrongly clear the NETDEV_LED_MODE_LINKUP flag on NETDEV_CHANGENAME
> event.
> 
> Fix this by rechecking if the carrier is ok on NETDEV_CHANGENAME and
> correctly set the NETDEV_LED_MODE_LINKUP bit.
> 
> Fixes: 5f820ed52371 ("leds: trigger: netdev: fix handling on interface rename")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v5.5+

Since this is a fix, it should be posted on its own. It should then
get merged faster and backported to stable.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
