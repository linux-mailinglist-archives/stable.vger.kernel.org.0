Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE23155137A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240318AbiFTIzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240338AbiFTIzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:55:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBC4AE41
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 01:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A14FE61367
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943E3C3411B;
        Mon, 20 Jun 2022 08:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655715306;
        bh=Dlx46ibDOjW0ve1IpwJyEmnqQ3sB8sQEricE+hL20YU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OV2eQeJT5UK6XBKXnHWW9LhWRYUVkquFy96kUHgLED1buvAZSDKuNLLIdS89pdDBr
         fvQZ2uw/89O8HfdCzeGryHVxjVt4f0pP8PZNM0SM66uxy/W5VqU/rz2DdQZwNpYeJI
         kY4j/ibE9gNw+1LpakFT22Lf4m73L04r51M972+w=
Date:   Mon, 20 Jun 2022 10:55:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ernesto Vigano' <lanciadelsole@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        o.rempel@pengutronix.de
Subject: Re: Fwd: question on driver for phy dp83td510e
Message-ID: <YrA150NSJzFszEpB@kroah.com>
References: <CAM3i8OEGrux+ku7hL20oGO10f=CDLkpcg3wH6hRbheEdacWnfw@mail.gmail.com>
 <CAM3i8OF1mC21wzwfsvhQTK7PPa0myCwftyhA9U1r7HR_0Q3fLQ@mail.gmail.com>
 <CAM3i8OFjvOkLGELkrKEo3B7x0hP=uPrYaPL05=0WXygvYJNZCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM3i8OFjvOkLGELkrKEo3B7x0hP=uPrYaPL05=0WXygvYJNZCQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 10:45:59AM +0200, Ernesto Vigano' wrote:
> I see that some weeks ago a driver for phy dp83td510e from TI
> (https://www.ti.com/product/DP83TD510E).
> I see that it's really different from the Linux driver supplied by TI
> on its official repo
> https://git.ti.com/gitweb?p=ti-analog-linux-kernel/dmurphy-analog.git;a=commit;h=fefa908e4e3262455a0cec08f3bb7161d7792d02
> As an example, TI writes some undocumented register for version 1.0 of the PHY.
> 
> Should I forget about the TI driver?
> Or is there something that should be integrated in
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/dp83td510.c

Why not ask on the proper mailing list and also ask the TI developers
about why they are not submitting their changes upstream to us?

This has nothing to do with the stable or regressions list, sorry.

good luck!

greg k-h
