Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4741B5FE932
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 09:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJNHH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 03:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJNHH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 03:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E144617E0D;
        Fri, 14 Oct 2022 00:07:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70C9861A18;
        Fri, 14 Oct 2022 07:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D97C433D6;
        Fri, 14 Oct 2022 07:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665731245;
        bh=tS8+wz9VN89VY29u3OM3Xpc9y7suImdD9+Qd3cFDWAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YLutjAXZJOEOju+L1hYtfv4hoXB4QU9/wZdaGVvPi2YYbJLRjjaTC5RXlh1MAtWAp
         hjfkItzCDlDnDbFsV4uVk2a/nEbs/yfW+I1KLqgbCmQhT9HaAXq89QhoCrteFNRWUg
         XgdR4iZ8DRAZoNcwLaSr97t125ZgY/tS/Nrluq0c=
Date:   Fri, 14 Oct 2022 09:08:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] Documentation: process: update the list of current LTS
Message-ID: <Y0kK2g+CUxbqPJ8d@kroah.com>
References: <20221013183414.667316-1-ndesaulniers@google.com>
 <130adb69-ff37-51fd-26a2-674ab78ff044@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <130adb69-ff37-51fd-26a2-674ab78ff044@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 09:24:11AM +0700, Bagas Sanjaya wrote:
> On 10/14/22 01:34, Nick Desaulniers wrote:
> > 3.16 was EOL in 2020.
> > 4.4 was EOL in 2022.
> > 
> > 5.10 is new in 2020.
> > 5.15 is new in 2021.
> > 
> > We'll see if 6.1 becomes LTS in 2022.
> > 
> 
> I think the table should be keep updated whenever new LTS is announced
> and oldest LTS become EOL, to be on par with kernel.org homepage.

Yeah, I didn't even realize this was in the kernel tree, I've just been
keeping kernel.org up to date.

thanks,

greg k-h
