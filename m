Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADCB4BB5B9
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiBRJf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 04:35:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbiBRJfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:35:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4B7175C5F
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:35:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1260BB82586
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 09:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207A6C340E9;
        Fri, 18 Feb 2022 09:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645176931;
        bh=IgmoOsENaBbWI8GTX9Ksi2S0DLz8/vRrhC5Jel47wOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Auenp4WJoWyxJK4QffuCf+I6WfFnytcQRn/Kl6ZgYwwIIvxiAiE55f50PVM/iYZ02
         5leLoCZ8H0QtAiQVyIKa5xGW3aribV/DPOnUO/TCcMBCX3g+uqkyVsF3d6vrMER6aC
         KNQOo51Hl6Tqf3vAoadWJb7OxJpnq5Sk63QjaDTk=
Date:   Fri, 18 Feb 2022 10:35:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     ebiederm@xmission.com, bsingharora@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] taskstats: Cleanup the use of
 task->exit_code" failed to apply to 5.4-stable tree
Message-ID: <Yg9oYBgZ/mfeB/ci@kroah.com>
References: <164302987619021@kroah.com>
 <Yg6qBtvmY3t75jF9@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg6qBtvmY3t75jF9@debian>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 08:03:18PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 24, 2022 at 02:11:16PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to all branches till 4.9-stable.

Now queued up, thanks.

greg k-h
