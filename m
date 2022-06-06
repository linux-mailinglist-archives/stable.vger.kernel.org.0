Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCAD53E0D4
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 08:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiFFFvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 01:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiFFFvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 01:51:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF362E680
        for <stable@vger.kernel.org>; Sun,  5 Jun 2022 22:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4803260F78
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FC8C385A9;
        Mon,  6 Jun 2022 05:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654494664;
        bh=dQ2wpFawvY0V6RX0baAh1vKYBzvtoHavBo6qb+g84io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KcJi7d0QTA5LAIvVkCIS6ImGWG7Ll7qFf779TNs1X6ZGECT1Yfg252TPQlGdZQScc
         eKPrP7yVbLF+UeQfb373fni9ZDnvkwMRvdCCLchZ9l0n6YDenpx5zdN7lvhrJy7Kme
         q5mWp5rWb+VzkAyH6PGHj6VmkBFo9Na3Ar3PKbWw=
Date:   Mon, 6 Jun 2022 07:51:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fenil Jain <fkjainco@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re:
Message-ID: <Yp2Vxd7MU4sgcbWy@kroah.com>
References: <CAHokDBk-0qSmx5JqAOohocWb5QRq2XmXkiU=fcZ4yvsoev589w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHokDBk-0qSmx5JqAOohocWb5QRq2XmXkiU=fcZ4yvsoev589w@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 11:03:24AM +0530, Fenil Jain wrote:
> On Fri, Jun 03, 2022 at 07:43:01PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.18.2 release.
> > There are 67 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> > Anything received after that time might be too late.
> 
> Hey Greg,
> 
> Ran tests and boot tested on my system, no regression found
> 
> Tested-by: Fenil Jain<fkjainco@gmail.com>

Thanks for the testing, but something went wrong with your email client
and it lost the Subject: line, making this impossible to be picked up by
our tools.

Also, please include an extra ' ' before the '<' character in your
tested-by line.

thanks,

greg k-h
