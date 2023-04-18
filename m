Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1106E5DDD
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 11:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjDRJtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 05:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjDRJtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 05:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198783AA0;
        Tue, 18 Apr 2023 02:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B753625AC;
        Tue, 18 Apr 2023 09:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838CCC433EF;
        Tue, 18 Apr 2023 09:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681811347;
        bh=R6gTUTBkShh42cGKqGMnGkOwkNaSzHp0QU1JPlAhj+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RVHsY3ARdIAMUakelyycn8+Dqaej+Rc2ke3UU7CT8gYgMe7fk8SB4P1Q7W2b3MFWm
         rIJSSGIXY8NwAZYmMiGdAkLwLP0hmyPfBukPf3zZ2EfATOJCBPV9HM9Eo2W5HMP5AB
         hA7ZMSaRnuWf8Sxaez+nbvVVTbWYedrZiktYPUtg=
Date:   Tue, 18 Apr 2023 11:49:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/17] xfs stable candidate patches for 5.4.y (from
 v5.11 & v5.12)
Message-ID: <2023041853-plow-shiny-22f3@gregkh>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 09:56:07AM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains XFS fixes from v5.11 & v5.12. The
> patchset has been acked by Darrick.
> 
> As a side note, where applicable, patches have been cherry picked from
> 5.10.y rather than from v5.11/v5.12.

all now queued up, thanks.

greg k-h
