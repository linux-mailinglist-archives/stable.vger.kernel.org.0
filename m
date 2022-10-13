Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9C35FD454
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 07:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJMFy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 01:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJMFy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 01:54:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99A111C274;
        Wed, 12 Oct 2022 22:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 972EFB81C23;
        Thu, 13 Oct 2022 05:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16830C433C1;
        Thu, 13 Oct 2022 05:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665640463;
        bh=QAO54DZz+VWkoUxgrAlLsddpVvHW6nR+uyTGLgPGfVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rIkwlk8GryVzVbXCXV6iTEHHiC15ub0C/4rE2OlJF9ePJxeC87yiGfFFHuwvfFvXh
         cC35A8AcdBy5hijsR5PiThqYeFQBxOTpIbMWk45JScchrRHKsSCRI5Bb5sa6mpUZ0G
         +c7baipORdPufhXMc+dFJ/PY3LS0BJ4Z31TJw+zs=
Date:   Thu, 13 Oct 2022 07:55:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        GUO Zihua <guozihua@huawei.com>, philipp.g.hortmann@gmail.com,
        dan.carpenter@oracle.com, dave@stgolabs.net,
        yangyingliang@huawei.com, yogi.kernel@gmail.com,
        f3sch.git@outlook.com, linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.4 07/27] staging: rtl8192e: Fix return type for
 implementation of ndo_start_xmit
Message-ID: <Y0eoOwU1cT7N9ywF@kroah.com>
References: <20221013002501.1895204-1-sashal@kernel.org>
 <20221013002501.1895204-7-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013002501.1895204-7-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 12, 2022 at 08:24:39PM -0400, Sasha Levin wrote:
> From: GUO Zihua <guozihua@huawei.com>
> 
> [ Upstream commit 513d9a61156d79dd0979c4ad400c8587f52cbb9d ]
> 
> CFI (Control Flow Integrity) is a safety feature allowing the system to
> detect and react should a potential control flow hijacking occurs. In
> particular, the Forward-Edge CFI protects indirect function calls by
> ensuring the prototype of function that is actually called matches the
> definition of the function hook.
> 
> Since Linux now supports CFI, it will be a good idea to fix mismatched
> return type for implementation of hooks. Otherwise this would get
> cought out by CFI and cause a panic.

Not needed in any stable branch, please drop from all.

thanks,

greg k-h
