Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0904C5931BC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiHOP0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiHOPZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:25:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8411261F
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14CB4B80EC2
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 15:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE7CC433C1;
        Mon, 15 Aug 2022 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660577137;
        bh=weWprjDfR/99CZVKnb9W4fEp74AvnF9hKLKig//Dw2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FzJewXlKPM1z6bcp2bFmYsjG4faGygZKhw2znQMMzR9SodrzF+UVVfU6uTneB98yP
         EEhphuvttJ1fDnUuiZg17+qyiyX4GuwC5YqkUPhn+d8a7ZDN29uUE7ZSjBfnEc/P2M
         JTIEvTQIe7c4SSymdCTP826l/RXKJ4qEkRJu10PY=
Date:   Mon, 15 Aug 2022 17:25:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tony Battersby <tonyb@cybernetics.com>
Cc:     dgilbert@interlog.com, martin.petersen@oracle.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: sg: Allow waiting for commands to complete on
 removed device
Message-ID: <Yvplbua2ezEgrLo2@kroah.com>
References: <166039721378118@kroah.com>
 <f6d97c65-08c7-28f8-7d63-dd4ed9fb6423@cybernetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6d97c65-08c7-28f8-7d63-dd4ed9fb6423@cybernetics.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 11:03:34AM -0400, Tony Battersby wrote:
> This backport applies to 4.19, 4.14, and 4.9.  The only difference from the
> upstream commit is "goto free_old_hdr" instead of just return retval in
> sg_read().

Thanks, now queued up.

greg k-h
