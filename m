Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDB15AA7F5
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 08:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiIBGR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 02:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbiIBGRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 02:17:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2ABBB01A;
        Thu,  1 Sep 2022 23:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3AE1B829E3;
        Fri,  2 Sep 2022 06:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52217C433C1;
        Fri,  2 Sep 2022 06:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662099433;
        bh=rgkjdautOHlyL6ZuVf9bQSHTyMy6he9tgKeEU9sZSuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xyOCci5LMHFOSt03MU9EMMfBBgoubyJMQWc1CZ5OFLhx5EEle8Eo28F+vdI+0TDQ3
         Ny05+FEF+j1ibQ3+MVdow0KrabgPBRqoIZnWssZ61dY4tbTJS5Ri/KXyfTkYZtmC8X
         fCiXGdLfKkrP8ZbfHydLk+nUB07F6ca4pgYS65Jc=
Date:   Fri, 2 Sep 2022 08:17:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 v3 0/5] xfs stable patches for 5.10.y (from v5.18+)
Message-ID: <YxGf5gGWItX7tp4M@kroah.com>
References: <20220901133356.2473299-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901133356.2473299-1-amir73il@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 01, 2022 at 04:33:51PM +0300, Amir Goldstein wrote:
> Hi Greg,
> 
> This 5.10.y backport series contains fixes from v5.18 and v5.19-rc1.
> 
> The patches in this series have already been applied to 5.15.y in Leah's
> latest update [1], so this 5.10.y is is mostly catching up with 5.15.y.

Now queued up, thanks.

greg k-h
