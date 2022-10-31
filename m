Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167A161311E
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJaHUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaHUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:20:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B899960D2;
        Mon, 31 Oct 2022 00:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AFD760FF6;
        Mon, 31 Oct 2022 07:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DCFC433D7;
        Mon, 31 Oct 2022 07:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667200829;
        bh=q2ZZrR41br3YLdUjckUtgehBbp1gJwMfQ6cZHdjaA5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LJTJYRpvLtyRUS7eaTIZgyDrTStauIOp23alYwk1/rQEj0RUFmLC6MemyhGjkfmPW
         xr9ciAnpTF7ieet97h9Mig/eG9PyDLACfgNFmQ0GpK7XYfk4OlQqUH8R22untGYteU
         QyhMGvRfoWxWsZZJCY50tycWrJ90bKTUDfRZzyDc=
Date:   Mon, 31 Oct 2022 08:21:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 0/3] xfs stable candidate patches for 5.4.y
Message-ID: <Y193dVbkKw6oeRDr@kroah.com>
References: <20221031045354.183020-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031045354.183020-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 31, 2022 at 10:23:51AM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains patches which fix XFS bugs
> introduced by patches which were recently backported from v5.7. The
> patchset has been acked by Darrick.

All now queued up, thanks.

greg k-h
