Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BC561ED85
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 09:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiKGIxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 03:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiKGIxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 03:53:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B65615832;
        Mon,  7 Nov 2022 00:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE77460F5D;
        Mon,  7 Nov 2022 08:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871ACC433D6;
        Mon,  7 Nov 2022 08:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667811184;
        bh=boFTHOOGOQoYKpcPxdvX4sVSrAV0GDqJVAzkrNm4grw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TmNKXs/uxpk4NvYrJOgztWX21gyv/MjbL2dVnXVmjdv+PP4efWmhaWy8Sev/40L7n
         4TIjYPkgYQXRoKFIT6VimIzFfWC1lJ9LnsCGsNCksOSlZPjAHAoazKli5DsUl7bRY6
         KYtuA62czy/3tsykvxH/eemzX0V7UMPMih1OAEUs=
Date:   Mon, 7 Nov 2022 09:52:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 0/6] xfs stable candidate patches for 5.4.y (from
 v5.8)
Message-ID: <Y2jHaDK5F53pQ+aM@kroah.com>
References: <20221107040327.132719-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107040327.132719-1-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 09:33:21AM +0530, Chandan Babu R wrote:
> Hi Greg,
> 
> This 5.4.y backport series contains XFS fixes from v5.8. The patchset
> has been acked by Darrick.

Now queued up, thanks.

greg k-h
