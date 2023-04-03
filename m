Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F0F6D459F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjDCNZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbjDCNY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:24:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E589E20C27
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7053EB81A34
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D00C433D2;
        Mon,  3 Apr 2023 13:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680528284;
        bh=1hzvaVwzSuXGNk0MqNY6kcyiti3Y1xL1BnsTakOqccg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pFfHQfR6xM46HXRmAzR7Zh7MlMIFJBn6YhCt3LGfxPoxQMyyssHae6BfJ0zZTXLSk
         aiDPg9CJsG/2ML3k1sR9kc/dSGIW/KFqO0lskybcV6ziOkAhEmbCQVtfgnBwDrThUd
         aADZccPcVnNW9bY+zmK6jQ/gB+VcV3mmRXBrh+7Y=
Date:   Mon, 3 Apr 2023 15:24:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cristian Marussi <cristian.marussi@arm.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH 4.19] firmware: arm_scmi: Fix device node validation for
 mailbox transport
Message-ID: <2023040334-monsieur-garter-9ce6@gregkh>
References: <20230331104955.3800788-1-cristian.marussi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331104955.3800788-1-cristian.marussi@arm.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 11:49:55AM +0100, Cristian Marussi wrote:
> commit 2ab4f4018cb6b8010ca5002c3bdc37783b5d28c2 upstream.
> 
> When mailboxes are used as a transport it is possible to setup the SCMI
> transport layer, depending on the underlying channels configuration, to use
> one or two mailboxes, associated, respectively, to one or two, distinct,
> shared memory areas: any other combination should be treated as invalid.
> 
> Add more strict checking of SCMI mailbox transport device node descriptors.
> 
> Fixes: fbc4d81ad285 ("firmware: arm_scmi: refactor in preparation to support per-protocol channels")
> Cc: <stable@vger.kernel.org> # 4.19
> Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
> Link: https://lore.kernel.org/r/20230307162324.891866-1-cristian.marussi@arm.com
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> [Cristian: backported to v4.19]
> Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
> ---
> Backporting was trivial but required since the patched function
> was moved around in a different file.

Both backports now queued up, thanks.

greg k-h
